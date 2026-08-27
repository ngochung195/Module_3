package com.codegym.controller;

import com.codegym.model.Product;
import com.codegym.service.ProductService;
import com.codegym.service.ProductServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller chính xử lý toàn bộ các yêu cầu liên quan đến Sản phẩm.
 * Ánh xạ URL: /products
 * Điều hướng dựa trên tham số "action" trong request.
 *
 * Các action được hỗ trợ:
 *   - (none)   : Hiển thị danh sách sản phẩm (GET)
 *   - create   : Hiển thị form tạo mới / Xử lý tạo mới (GET/POST)
 *   - edit     : Hiển thị form chỉnh sửa / Xử lý cập nhật (GET/POST)
 *   - delete   : Hiển thị trang xác nhận xóa / Xử lý xóa (GET/POST)
 *   - view     : Xem chi tiết sản phẩm (GET)
 *   - search   : Tìm kiếm sản phẩm (GET)
 */
@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private ProductService productService;

    @Override
    public void init() throws ServletException {
        productService = new ProductServiceImpl();
    }

    // ==================== GET ====================

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                showDeleteConfirm(request, response);
                break;
            case "view":
                showProductDetail(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    // ==================== POST ====================

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    // ==================== Các phương thức xử lý ====================

    /**
     * Hiển thị danh sách tất cả sản phẩm.
     */
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productService.findAll();
        request.setAttribute("products", products);
        request.setAttribute("totalCount", products.size());
        dispatch(request, response, "/product/list.jsp");
    }

    /**
     * Hiển thị form tạo sản phẩm mới.
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        dispatch(request, response, "/product/create.jsp");
    }

    /**
     * Xử lý tạo sản phẩm mới từ form POST.
     */
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Product product = extractProductFromRequest(request, 0);
            productService.save(product);
            response.sendRedirect(request.getContextPath() + "/products?action=list&success=created");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Giá sản phẩm không hợp lệ. Vui lòng nhập số.");
            dispatch(request, response, "/product/create.jsp");
        }
    }

    /**
     * Hiển thị form chỉnh sửa sản phẩm theo ID.
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseId(request.getParameter("id"));
        Product product = productService.findById(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/products?error=notfound");
            return;
        }
        request.setAttribute("product", product);
        dispatch(request, response, "/product/edit.jsp");
    }

    /**
     * Xử lý cập nhật sản phẩm từ form POST.
     */
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = parseId(request.getParameter("id"));
            Product product = extractProductFromRequest(request, id);
            productService.update(product);
            response.sendRedirect(request.getContextPath() + "/products?action=list&success=updated");
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ.");
            showEditForm(request, response);
        }
    }

    /**
     * Hiển thị trang xác nhận xóa sản phẩm.
     */
    private void showDeleteConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseId(request.getParameter("id"));
        Product product = productService.findById(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/products?error=notfound");
            return;
        }
        request.setAttribute("product", product);
        dispatch(request, response, "/product/delete.jsp");
    }

    /**
     * Xử lý xóa sản phẩm từ form POST xác nhận.
     */
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseId(request.getParameter("id"));
        productService.delete(id);
        response.sendRedirect(request.getContextPath() + "/products?action=list&success=deleted");
    }

    /**
     * Hiển thị chi tiết một sản phẩm.
     */
    private void showProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = parseId(request.getParameter("id"));
        Product product = productService.findById(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/products?error=notfound");
            return;
        }
        request.setAttribute("product", product);
        dispatch(request, response, "/product/view.jsp");
    }

    /**
     * Tìm kiếm sản phẩm theo từ khóa.
     */
    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Product> results = productService.search(keyword);
        request.setAttribute("products", results);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalCount", results.size());
        dispatch(request, response, "/product/search.jsp");
    }

    // ==================== Tiện ích ====================

    /**
     * Trích xuất thông tin sản phẩm từ request parameters.
     */
    private Product extractProductFromRequest(HttpServletRequest request, int id) {
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        String manufacturer = request.getParameter("manufacturer");
        return new Product(id, name, price, description, manufacturer);
    }

    /**
     * Parse ID từ chuỗi, trả về 0 nếu không hợp lệ.
     */
    private int parseId(String idStr) {
        if (idStr == null || idStr.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    /**
     * Forward request đến JSP view.
     */
    private void dispatch(HttpServletRequest request, HttpServletResponse response, String viewPath)
            throws ServletException, IOException {
        request.getRequestDispatcher(viewPath).forward(request, response);
    }
}
