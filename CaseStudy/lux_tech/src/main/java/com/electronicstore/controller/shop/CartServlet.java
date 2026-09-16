package com.electronicstore.controller.shop;

import com.electronicstore.model.Cart;
import com.electronicstore.model.CartItem;
import com.electronicstore.model.Product;
import com.electronicstore.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * CartServlet – Quản lý giỏ hàng mua sắm (Shopping Cart).
 * 
 * GET  /cart                  → Xem giỏ hàng
 * GET  /cart?action=remove    → Xóa một mặt hàng
 * GET  /cart?action=clear     → Làm trống giỏ hàng
 * POST /cart (action=add)     → Thêm sản phẩm vào giỏ
 * POST /cart (action=update)  → Cập nhật số lượng
 * POST /cart (action=remove)  → Xóa một mặt hàng
 * POST /cart (action=clear)   → Làm trống giỏ hàng
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "remove":
                handleRemoveItem(request, response);
                break;
            case "clear":
                handleClearCart(request, response);
                break;
            case "view":
            default:
                showCart(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "add":
                handleAddToCart(request, response);
                break;
            case "update":
                handleUpdateQuantity(request, response);
                break;
            case "remove":
                handleRemoveItem(request, response);
                break;
            case "clear":
                handleClearCart(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
        }
    }

    /**
     * Hiển thị trang giỏ hàng.
     */
    private void showCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        request.setAttribute("cart", cart);
        request.setAttribute("activePage", "cart");
        request.getRequestDispatcher("/WEB-INF/views/shop/cart.jsp").forward(request, response);
    }

    /**
     * Thêm sản phẩm vào giỏ hàng.
     */
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        String color = request.getParameter("color");

        int productId;
        int quantity = 1;

        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Mã sản phẩm không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/shop?action=products");
            return;
        }

        if (quantityParam != null && !quantityParam.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam.trim());
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        Product product = productService.findById(productId);
        if (product == null) {
            session.setAttribute("flashError", "Sản phẩm không tồn tại hoặc đã ngừng kinh doanh.");
            response.sendRedirect(request.getContextPath() + "/shop?action=products");
            return;
        }

        if (product.getQuantity() <= 0) {
            session.setAttribute("flashError", "Sản phẩm \"" + product.getName() + "\" hiện đã hết hàng.");
            response.sendRedirect(request.getContextPath() + "/shop?action=detail&id=" + productId);
            return;
        }

        // Thêm vào giỏ hàng
        boolean added = cart.addItem(product, quantity, color);
        if (added) {
            String colorText = (color != null && !color.trim().isEmpty()) ? " (" + color.trim() + ")" : "";
            session.setAttribute("flashSuccess", "Đã thêm " + quantity + "x \"" + product.getName() + colorText + "\" vào giỏ hàng thành công!");
        } else {
            session.setAttribute("flashError", "Không thể thêm sản phẩm vào giỏ hàng. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    /**
     * Cập nhật số lượng của sản phẩm trong giỏ hàng.
     */
    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        String productIdParam = request.getParameter("productId");
        String color = request.getParameter("color");
        String quantityParam = request.getParameter("quantity");
        String deltaParam = request.getParameter("delta");

        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        CartItem item = cart.getItem(productId, color);
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int targetQuantity;
        if (deltaParam != null && !deltaParam.trim().isEmpty()) {
            try {
                int delta = Integer.parseInt(deltaParam.trim());
                targetQuantity = item.getQuantity() + delta;
            } catch (NumberFormatException e) {
                targetQuantity = item.getQuantity();
            }
        } else if (quantityParam != null && !quantityParam.trim().isEmpty()) {
            try {
                targetQuantity = Integer.parseInt(quantityParam.trim());
            } catch (NumberFormatException e) {
                targetQuantity = item.getQuantity();
            }
        } else {
            targetQuantity = item.getQuantity();
        }

        // Kiểm tra tồn kho từ database
        Product currentProduct = productService.findById(productId);
        if (currentProduct != null) {
            item.setMaxStock(currentProduct.getQuantity());
            if (targetQuantity > currentProduct.getQuantity()) {
                targetQuantity = currentProduct.getQuantity();
                session.setAttribute("flashWarning", "Số lượng đã được điều chỉnh về tối đa tồn kho hiện có (" + currentProduct.getQuantity() + ").");
            }
        }

        if (targetQuantity <= 0) {
            cart.removeItem(productId, color);
            session.setAttribute("flashSuccess", "Đã xóa sản phẩm khỏi giỏ hàng.");
        } else {
            cart.updateQuantity(productId, color, targetQuantity);
            session.setAttribute("flashSuccess", "Đã cập nhật số lượng thành công.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    /**
     * Xóa một sản phẩm khỏi giỏ hàng.
     */
    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        String productIdParam = request.getParameter("productId");
        String color = request.getParameter("color");

        try {
            int productId = Integer.parseInt(productIdParam);
            CartItem removed = cart.getItem(productId, color);
            boolean success = cart.removeItem(productId, color);
            if (success) {
                String name = (removed != null) ? removed.getProductName() : "sản phẩm";
                session.setAttribute("flashSuccess", "Đã xóa \"" + name + "\" khỏi giỏ hàng.");
            }
        } catch (Exception e) {
            session.setAttribute("flashError", "Không thể xóa sản phẩm khỏi giỏ.");
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    /**
     * Xóa sạch toàn bộ sản phẩm trong giỏ hàng.
     */
    private void handleClearCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        cart.clear();
        session.setAttribute("flashSuccess", "Đã làm trống toàn bộ giỏ hàng.");
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    /**
     * Lấy giỏ hàng từ session, nếu chưa có thì khởi tạo mới.
     */
    private Cart getOrCreateCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }
}
