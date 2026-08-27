package com.codegym.service;

import com.codegym.model.Customer;

import java.util.List;

/**
 * Interface định nghĩa các hành vi (contract) của tầng dịch vụ
 * quản lý Khách hàng (Customer Service Layer).
 *
 * <p>Nhiệm vụ:
 * <ul>
 *   <li>Khai báo các phương thức CRUD cơ bản cho đối tượng {@link Customer}.</li>
 *   <li>Tách biệt logic nghiệp vụ khỏi tầng Controller và tầng dữ liệu.</li>
 *   <li>Cho phép nhiều cách triển khai khác nhau (in-memory, database, v.v.).</li>
 * </ul>
 */
public interface CustomerService {

    /**
     * Trả về danh sách tất cả khách hàng hiện có trong hệ thống.
     *
     * @return danh sách {@link Customer}
     */
    List<Customer> findAll();

    /**
     * Tìm kiếm khách hàng theo mã định danh (id).
     *
     * @param id mã định danh cần tìm
     * @return đối tượng {@link Customer} tương ứng, hoặc {@code null} nếu không tìm thấy
     */
    Customer findById(Long id);

    /**
     * Lưu mới một khách hàng vào hệ thống.
     *
     * @param customer đối tượng {@link Customer} cần lưu
     */
    void save(Customer customer);

    /**
     * Cập nhật thông tin của khách hàng đã tồn tại.
     *
     * @param customer đối tượng {@link Customer} chứa dữ liệu cập nhật
     */
    void update(Customer customer);

    /**
     * Xoá khách hàng khỏi hệ thống theo mã định danh.
     *
     * @param id mã định danh của khách hàng cần xoá
     */
    void delete(Long id);
}
