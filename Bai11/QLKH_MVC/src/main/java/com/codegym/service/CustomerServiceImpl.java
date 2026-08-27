package com.codegym.service;

import com.codegym.model.Customer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Lớp triển khai (implementation) của interface {@link CustomerService}.
 *
 * <p>Sử dụng một {@link Map} tĩnh ({@code static}) làm kho lưu trữ dữ liệu
 * giả lập trong bộ nhớ (in-memory), thay thế cho cơ sở dữ liệu thực tế
 * trong giai đoạn phát triển và kiểm thử.
 *
 * <p>Nhiệm vụ:
 * <ul>
 *   <li>Cài đặt đầy đủ các thao tác CRUD: tìm tất cả, tìm theo id,
 *       lưu mới, cập nhật, xoá.</li>
 *   <li>Tự sinh id tăng dần cho mỗi khách hàng mới.</li>
 *   <li>Đóng vai trò là lớp trung gian giữa Controller và dữ liệu,
 *       đảm bảo tách biệt trách nhiệm theo mô hình MVC.</li>
 * </ul>
 */
public class CustomerServiceImpl implements CustomerService {

    /**
     * Kho lưu trữ dữ liệu khách hàng dưới dạng Map tĩnh (in-memory).
     * Key   : id của khách hàng.
     * Value : đối tượng {@link com.codegym.model.Customer}.
     */
    private static final Map<Long, com.codegym.model.Customer> customers = new HashMap<>();

    /** Biến tĩnh dùng để tự sinh id tăng dần cho mỗi khách hàng mới. */
    private static long nextId = 1L;

    // ----------------------------------------------------------------
    // Triển khai các phương thức của CustomerService
    // ----------------------------------------------------------------

    /**
     * {@inheritDoc}
     *
     * <p>Trả về danh sách tất cả khách hàng đang được lưu trong Map tĩnh.
     *
     * @return danh sách {@link com.codegym.model.Customer}
     */
    @Override
    public List<com.codegym.model.Customer> findAll() {
        return null; // TODO: implement
    }

    /**
     * {@inheritDoc}
     *
     * <p>Tra cứu khách hàng trong Map tĩnh theo khoá là {@code id}.
     *
     * @param id mã định danh cần tìm
     * @return đối tượng Customer hoặc {@code null}
     */
    @Override
    public com.codegym.model.Customer findById(Long id) {
        return null; // TODO: implement
    }

    /**
     * {@inheritDoc}
     *
     * <p>Gán id tự động cho khách hàng mới và thêm vào Map tĩnh.
     *
     * @param customer đối tượng {@link com.codegym.model.Customer} cần lưu
     */
    @Override
    public void save(com.codegym.model.Customer customer) {
        // TODO: implement
    }

    /**
     * {@inheritDoc}
     *
     * <p>Cập nhật thông tin khách hàng đã tồn tại trong Map tĩnh.
     *
     * @param customer đối tượng chứa dữ liệu cập nhật
     */
    @Override
    public void update(com.codegym.model.Customer customer) {
        // TODO: implement
    }

    /**
     * {@inheritDoc}
     *
     * <p>Xoá khách hàng khỏi Map tĩnh theo {@code id}.
     *
     * @param id mã định danh cần xoá
     */
    @Override
    public void delete(Long id) {
        // TODO: implement
    }
}
