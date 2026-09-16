package com.electronicstore.controller.shop;

import com.electronicstore.model.Category;
import com.electronicstore.model.Product;
import com.electronicstore.service.CategoryService;
import com.electronicstore.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * ShopServlet – Controller cho Customer Online Shop.
 * Xử lý các trang công khai (không yêu cầu đăng nhập):
 *   GET /shop                  → Shop home page
 *   GET /shop?action=products  → Product listing (search + filter)
 *   GET /shop?action=detail&id=1 → Product detail page
 *
 * Tái sử dụng ProductService và CategoryService hiện có.
 * Không viết SQL trực tiếp trong Controller.
 */
@WebServlet(name = "ShopServlet", urlPatterns = {"/shop", "/shop/*"})
public class ShopServlet extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "home";
        }

        switch (action) {
            case "products":
                showProducts(request, response);
                break;
            case "detail":
                showProductDetail(request, response);
                break;
            default:
                showHome(request, response);
        }
    }

    /**
     * Trang chủ Shop – hiển thị sản phẩm nổi bật + danh mục.
     */
    private void showHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tất cả sản phẩm (hiển thị nổi bật – lấy tối đa 6 sản phẩm)
        List<Product> allProducts = productService.findAll();
        List<Product> featuredProducts = allProducts.size() > 6
                ? allProducts.subList(0, 6)
                : allProducts;

        List<Category> categories = categoryService.findAll();

        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("categories", categories);
        request.setAttribute("activePage", "shop-home");
        request.getRequestDispatcher("/WEB-INF/views/shop/home.jsp").forward(request, response);
    }

    /**
     * Trang danh sách sản phẩm – có search và filter category.
     */
    private void showProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String categoryIdParam = request.getParameter("categoryId");

        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam.trim());
                if (categoryId <= 0) categoryId = null;
            } catch (NumberFormatException e) {
                categoryId = null;
            }
        }

        // Tái sử dụng ProductService.search() hiện có
        List<Product> products = productService.search(keyword, categoryId);
        List<Category> categories = categoryService.findAll();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("activePage", "shop-products");
        request.getRequestDispatcher("/WEB-INF/views/shop/products.jsp").forward(request, response);
    }

    /**
     * Trang chi tiết sản phẩm.
     */
    private void showProductDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop?action=products");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop?action=products");
            return;
        }

        // Tái sử dụng ProductService.findById() – lấy thông tin từ DB
        Product product = productService.findById(productId);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/shop?action=products");
            return;
        }

        request.setAttribute("product", product);
        request.setAttribute("activePage", "shop-products");
        request.getRequestDispatcher("/WEB-INF/views/shop/product-detail.jsp").forward(request, response);
    }
}
