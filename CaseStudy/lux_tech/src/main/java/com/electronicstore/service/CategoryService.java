package com.electronicstore.service;

import com.electronicstore.dao.CategoryDAO;
import com.electronicstore.model.Category;
import com.electronicstore.util.ValidationUtil;

import java.util.List;

public class CategoryService {
    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    public CategoryService(CategoryDAO categoryDAO) {
        this.categoryDAO = categoryDAO;
    }

    public List<Category> findAll() {
        return categoryDAO.findAll();
    }

    public Category findById(int id) {
        return categoryDAO.findById(id);
    }

    /**
     * Thêm danh mục mới với validation
     * @param category Đối tượng danh mục
     * @return Thông báo lỗi nếu thất bại, null nếu thành công
     */
    public String save(Category category) {
        if (category == null || ValidationUtil.isEmpty(category.getName())) {
            return "Tên danh mục không được để trống.";
        }

        String name = category.getName().trim();
        Category existing = categoryDAO.findByName(name);
        if (existing != null) {
            return "Tên danh mục '" + name + "' đã tồn tại trong hệ thống.";
        }

        category.setName(name);
        boolean success = categoryDAO.save(category);
        return success ? null : "Lỗi hệ thống! Không thể thêm danh mục mới.";
    }

    /**
     * Cập nhật danh mục với validation
     * @param category Đối tượng danh mục
     * @return Thông báo lỗi nếu thất bại, null nếu thành công
     */
    public String update(Category category) {
        if (category == null || category.getId() <= 0) {
            return "Thông tin danh mục không hợp lệ.";
        }
        if (ValidationUtil.isEmpty(category.getName())) {
            return "Tên danh mục không được để trống.";
        }

        String name = category.getName().trim();
        if (categoryDAO.existsByName(name, category.getId())) {
            return "Tên danh mục '" + name + "' đã bị trùng với một danh mục khác.";
        }

        category.setName(name);
        boolean success = categoryDAO.update(category);
        return success ? null : "Lỗi hệ thống! Không thể cập nhật danh mục.";
    }

    /**
     * Xóa danh mục với ràng buộc dữ liệu
     * @param id ID danh mục
     * @return Thông báo lỗi nếu thất bại, null nếu thành công
     */
    public String delete(int id) {
        Category existing = categoryDAO.findById(id);
        if (existing == null) {
            return "Danh mục cần xóa không tồn tại.";
        }

        // Ràng buộc: Không được xóa nếu đang có sản phẩm tham chiếu
        if (categoryDAO.hasProducts(id)) {
            return "Không thể xóa danh mục '" + existing.getName() + "' vì đang có sản phẩm thuộc danh mục này.";
        }

        boolean success = categoryDAO.delete(id);
        return success ? null : "Lỗi hệ thống! Không thể xóa danh mục.";
    }
}
