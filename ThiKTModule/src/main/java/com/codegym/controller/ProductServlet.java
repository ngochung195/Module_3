package com.codegym.controller;

import com.codegym.model.Category;
import com.codegym.model.Product;
import com.codegym.service.CategoryService;
import com.codegym.service.ICategoryService;
import com.codegym.service.IProductService;
import com.codegym.service.ProductService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/product"})
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IProductService productService;
    private ICategoryService categoryService;

    @Override
    public void init() {
        productService = new ProductService();
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "search":
                searchProducts(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                createProduct(request, response);
                break;
            case "update":
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

    private void listProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Product> products = productService.findAll();
        List<Category> categories = categoryService.findAll();

        String messageParam = request.getParameter("message");
        if ("create_success".equals(messageParam)) {
            request.setAttribute("successMessage", "Thêm mới sản phẩm thành công!");
        } else if ("delete_success".equals(messageParam)) {
            request.setAttribute("successMessage", "Xóa sản phẩm thành công!");
        } else if ("update_success".equals(messageParam)) {
            request.setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
        }

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product/list.jsp");
        dispatcher.forward(request, response);
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        String searchPriceStr = request.getParameter("searchPrice");
        String searchCategoryStr = request.getParameter("searchCategory");

        Double searchPrice = null;
        if (searchPriceStr != null && !searchPriceStr.trim().isEmpty()) {
            try {
                searchPrice = Double.parseDouble(searchPriceStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        Integer searchCategoryId = null;
        if (searchCategoryStr != null && !searchCategoryStr.trim().isEmpty()) {
            try {
                searchCategoryId = Integer.parseInt(searchCategoryStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        List<Product> products = productService.search(searchName, searchPrice, searchCategoryId);
        List<Category> categories = categoryService.findAll();

        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("searchName", searchName);
        request.setAttribute("searchPrice", searchPriceStr);
        request.setAttribute("searchCategory", searchCategoryStr);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product/list.jsp");
        dispatcher.forward(request, response);
    }

    private void createProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String[] colors = request.getParameterValues("color");
        String color = "";
        if (colors != null && colors.length > 0) {
            java.util.List<String> validColors = new java.util.ArrayList<>();
            for (String c : colors) {
                if (c != null && !c.trim().isEmpty() && !validColors.contains(c.trim())) {
                    validColors.add(c.trim());
                }
            }
            color = String.join(", ", validColors);
        } else {
            String singleColor = request.getParameter("color");
            if (singleColor != null) {
                color = singleColor.trim();
            }
        }
        String description = request.getParameter("description");
        String categoryIdStr = request.getParameter("categoryId");

        Map<String, String> errors = new HashMap<>();

        // 1. Validate Tên sản phẩm
        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Tên sản phẩm không được để trống");
        }

        // 2. Validate Giá (không để trống và > 10.000.000 VNĐ)
        double price = 0;
        if (priceStr == null || priceStr.trim().isEmpty()) {
            errors.put("price", "Giá không được để trống");
        } else {
            try {
                price = Double.parseDouble(priceStr.trim());
                if (price <= 10000000) {
                    errors.put("price", "Giá phải lớn hơn 10.000.000 VNĐ");
                }
            } catch (NumberFormatException e) {
                errors.put("price", "Giá phải là định dạng số hợp lệ");
            }
        }

        // 3. Validate Số lượng (không để trống và phải là số nguyên dương)
        int quantity = 0;
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            errors.put("quantity", "Số lượng không được để trống");
        } else {
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                if (quantity <= 0) {
                    errors.put("quantity", "Số lượng phải là số nguyên dương (> 0)");
                }
            } catch (NumberFormatException e) {
                errors.put("quantity", "Số lượng phải là số nguyên hợp lệ");
            }
        }

        // 4. Validate Màu sắc (dropdown list)
        if (color == null || color.trim().isEmpty()) {
            errors.put("color", "Màu sắc phải có giá trị");
        }

        // 5. Validate Danh mục
        int categoryId = 0;
        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            errors.put("categoryId", "Danh mục phải có giá trị");
        } else {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
                if (categoryId <= 0) {
                    errors.put("categoryId", "Vui lòng chọn danh mục hợp lệ");
                }
            } catch (NumberFormatException e) {
                errors.put("categoryId", "Danh mục không hợp lệ");
            }
        }

        // Nếu có lỗi -> Giữ lại dữ liệu và mở lại modal hiển thị lỗi
        if (!errors.isEmpty()) {
            List<Product> products = productService.findAll();
            List<Category> categories = categoryService.findAll();

            Product draftProduct = new Product(name, price, quantity, color, description, categoryId);

            request.setAttribute("products", products);
            request.setAttribute("categories", categories);
            request.setAttribute("errors", errors);
            request.setAttribute("draftProduct", draftProduct);
            request.setAttribute("openCreateModal", true);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/product/list.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Thêm mới thành công
        Product product = new Product(name.trim(), price, quantity, color.trim(), 
                description != null ? description.trim() : "", categoryId);
        boolean isCreated = productService.save(product);

        if (isCreated) {
            response.sendRedirect(request.getContextPath() + "/products?message=create_success");
        } else {
            errors.put("general", "Có lỗi xảy ra khi lưu sản phẩm vào cơ sở dữ liệu!");
            request.setAttribute("errors", errors);
            listProducts(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String[] colors = request.getParameterValues("color");
        String color = "";
        if (colors != null && colors.length > 0) {
            java.util.List<String> validColors = new java.util.ArrayList<>();
            for (String c : colors) {
                if (c != null && !c.trim().isEmpty() && !validColors.contains(c.trim())) {
                    validColors.add(c.trim());
                }
            }
            color = String.join(", ", validColors);
        } else {
            String singleColor = request.getParameter("color");
            if (singleColor != null) {
                color = singleColor.trim();
            }
        }
        String description = request.getParameter("description");
        String categoryIdStr = request.getParameter("categoryId");

        Map<String, String> errors = new HashMap<>();

        int id = 0;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            errors.put("id", "ID không hợp lệ");
        }

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Tên sản phẩm không được để trống");
        }

        double price = 0;
        if (priceStr == null || priceStr.trim().isEmpty()) {
            errors.put("price", "Giá không được để trống");
        } else {
            try {
                price = Double.parseDouble(priceStr.trim());
                if (price <= 10000000) {
                    errors.put("price", "Giá phải lớn hơn 10.000.000 VNĐ");
                }
            } catch (NumberFormatException e) {
                errors.put("price", "Giá phải là định dạng số hợp lệ");
            }
        }

        int quantity = 0;
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            errors.put("quantity", "Số lượng không được để trống");
        } else {
            try {
                quantity = Integer.parseInt(quantityStr.trim());
                if (quantity <= 0) {
                    errors.put("quantity", "Số lượng phải là số nguyên dương (> 0)");
                }
            } catch (NumberFormatException e) {
                errors.put("quantity", "Số lượng phải là số nguyên hợp lệ");
            }
        }

        if (color == null || color.trim().isEmpty()) {
            errors.put("color", "Màu sắc phải có giá trị");
        }

        int categoryId = 0;
        if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
            errors.put("categoryId", "Danh mục phải có giá trị");
        } else {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException e) {
                errors.put("categoryId", "Danh mục không hợp lệ");
            }
        }

        if (errors.isEmpty() && id > 0) {
            Product product = new Product(id, name.trim(), price, quantity, color.trim(), 
                    description != null ? description.trim() : "", categoryId);
            boolean isUpdated = productService.update(product);
            if (isUpdated) {
                response.sendRedirect(request.getContextPath() + "/products?message=update_success");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                productService.delete(id);
                response.sendRedirect(request.getContextPath() + "/products?message=delete_success");
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/products");
    }
}
