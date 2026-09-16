package com.electronicstore.service;

import com.electronicstore.dao.CategoryDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.model.Category;
import com.electronicstore.model.Product;
import com.electronicstore.util.ValidationUtil;

import java.math.BigDecimal;
import java.util.List;

public class ProductService {
    private final ProductDAO productDAO;
    private final CategoryDAO categoryDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
    }

    public ProductService(ProductDAO productDAO, CategoryDAO categoryDAO) {
        this.productDAO = productDAO;
        this.categoryDAO = categoryDAO;
    }

    public List<Product> findAll() {
        return productDAO.findAll();
    }

    public List<Product> findAllWithColors() {
        return productDAO.findAllWithColors();
    }

    public Product findById(int id) {
        return productDAO.findById(id);
    }

    public List<Product> search(String keyword, Integer categoryId) {
        return productDAO.search(keyword, categoryId);
    }

    public String save(Product product) {
        String validationError = validateProduct(product);
        if (validationError != null) {
            return validationError;
        }

        boolean success = productDAO.save(product);
        return success ? null : "Lỗi hệ thống! Không thể thêm sản phẩm mới.";
    }

    public String update(Product product) {
        if (productDAO.findById(product.getId()) == null) {
            return "Sản phẩm không tồn tại.";
        }

        String validationError = validateProduct(product);
        if (validationError != null) {
            return validationError;
        }

        boolean success = productDAO.update(product);
        return success ? null : "Lỗi hệ thống! Không thể cập nhật thông tin sản phẩm.";
    }

    public String delete(int id) {
        Product product = productDAO.findById(id);
        if (product == null) {
            return "Sản phẩm không tồn tại.";
        }

        if (productDAO.isProductInOrders(id)) {
            return "Không thể xóa sản phẩm '" + product.getName() + "' vì đã tồn tại trong lịch sử đơn hàng.";
        }

        boolean success = productDAO.delete(id);
        return success ? null : "Lỗi hệ thống! Không thể xóa sản phẩm.";
    }

    private String validateProduct(Product product) {
        if (product == null) {
            return "Dữ liệu sản phẩm không hợp lệ.";
        }

        if (ValidationUtil.isEmpty(product.getName())) {
            return "Tên sản phẩm không được để trống.";
        }
        if (product.getName().trim().length() < 2) {
            return "Tên sản phẩm phải có ít nhất 2 ký tự.";
        }

        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá bán sản phẩm phải lớn hơn 0.";
        }

        if (product.getQuantity() < 0) {
            return "Số lượng tồn kho không được âm.";
        }

        if (product.getCategoryId() <= 0) {
            return "Vui lòng chọn danh mục hợp lệ.";
        }

        Category category = categoryDAO.findById(product.getCategoryId());
        if (category == null) {
            return "Danh mục được chọn không tồn tại trong hệ thống.";
        }

        return null;
    }
}
