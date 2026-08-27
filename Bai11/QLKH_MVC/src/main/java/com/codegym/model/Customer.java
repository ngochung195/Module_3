package com.codegym.model;

/**
 * Model class đại diện cho một Khách hàng (Customer) trong hệ thống.
 *
 * <p>Lớp này chứa các thông tin cơ bản của khách hàng bao gồm:
 * mã định danh (id), tên (name), địa chỉ email (email) và địa chỉ (address).
 *
 * <p>Nhiệm vụ:
 * <ul>
 *   <li>Lưu trữ dữ liệu khách hàng theo mô hình POJO.</li>
 *   <li>Cung cấp các phương thức getter/setter để truy xuất và cập nhật thuộc tính.</li>
 * </ul>
 */
public class Customer {

    /** Mã định danh duy nhất của khách hàng. */
    private Long id;

    /** Tên đầy đủ của khách hàng. */
    private String name;

    /** Địa chỉ email của khách hàng. */
    private String email;

    /** Địa chỉ thường trú/liên hệ của khách hàng. */
    private String address;

    // ----------------------------------------------------------------
    // Constructors
    // ----------------------------------------------------------------

    /** Khởi tạo đối tượng Customer rỗng (no-arg constructor). */
    public Customer() {
    }

    /**
     * Khởi tạo đối tượng Customer với đầy đủ thông tin.
     *
     * @param id      mã định danh khách hàng
     * @param name    tên khách hàng
     * @param email   địa chỉ email
     * @param address địa chỉ liên hệ
     */
    public Customer(Long id, String name, String email, String address) {
    }

    // ----------------------------------------------------------------
    // Getters & Setters
    // ----------------------------------------------------------------

    /**
     * Trả về mã định danh của khách hàng.
     *
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Gán mã định danh cho khách hàng.
     *
     * @param id mã định danh mới
     */
    public void setId(Long id) {
    }

    /**
     * Trả về tên của khách hàng.
     *
     * @return name
     */
    public String getName() {
        return name;
    }

    /**
     * Gán tên cho khách hàng.
     *
     * @param name tên mới
     */
    public void setName(String name) {
    }

    /**
     * Trả về địa chỉ email của khách hàng.
     *
     * @return email
     */
    public String getEmail() {
        return email;
    }

    /**
     * Gán địa chỉ email cho khách hàng.
     *
     * @param email email mới
     */
    public void setEmail(String email) {
    }

    /**
     * Trả về địa chỉ của khách hàng.
     *
     * @return address
     */
    public String getAddress() {
        return address;
    }

    /**
     * Gán địa chỉ cho khách hàng.
     *
     * @param address địa chỉ mới
     */
    public void setAddress(String address) {
    }
}
