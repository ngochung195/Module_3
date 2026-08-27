package com.codegym.service;

import com.codegym.model.Product;
import java.util.List;

/**
 * Interface định nghĩa các thao tác CRUD cho sản phẩm.
 * Theo nguyên tắc Dependency Inversion (DIP), controller phụ thuộc vào
 * interface này thay vì implementation cụ thể.
 */
public interface ProductService {

    /**
     * Lấy toàn bộ danh sách sản phẩm.
     * @return List chứa tất cả sản phẩm
     */
    List<Product> findAll();

    /**
     * Tìm sản phẩm theo ID.
     * @param id ID của sản phẩm cần tìm
     * @return Sản phẩm tương ứng hoặc null nếu không tìm thấy
     */
    Product findById(int id);

    /**
     * Thêm mới một sản phẩm.
     * @param product Sản phẩm cần thêm (id tự động sinh)
     */
    void save(Product product);

    /**
     * Cập nhật thông tin sản phẩm.
     * @param product Sản phẩm chứa thông tin đã cập nhật
     */
    void update(Product product);

    /**
     * Xóa sản phẩm theo ID.
     * @param id ID của sản phẩm cần xóa
     */
    void delete(int id);

    /**
     * Tìm kiếm sản phẩm theo tên (tìm kiếm gần đúng, không phân biệt hoa/thường).
     * @param keyword Từ khóa tìm kiếm
     * @return List sản phẩm khớp với từ khóa
     */
    List<Product> search(String keyword);
}
