package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.model.Customer;
import com.electronicstore.util.ValidationUtil;

import java.util.List;

public class CustomerService {
    private final CustomerDAO customerDAO;

    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }

    public CustomerService(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    public List<Customer> findAll() {
        return customerDAO.findAll();
    }

    public Customer findById(int id) {
        return customerDAO.findById(id);
    }

    public List<Customer> search(String keyword) {
        return customerDAO.search(keyword);
    }

    /**
     * Thêm khách hàng mới – trả về null nếu thành công, chuỗi lỗi nếu thất bại.
     */
    public String save(Customer customer) {
        String validationError = validateCustomer(customer);
        if (validationError != null) {
            return validationError;
        }

        boolean success = customerDAO.save(customer);
        return success ? null : "Lỗi hệ thống! Không thể thêm khách hàng mới.";
    }

    /**
     * Cập nhật khách hàng – trả về null nếu thành công, chuỗi lỗi nếu thất bại.
     */
    public String update(Customer customer) {
        if (customerDAO.findById(customer.getId()) == null) {
            return "Khách hàng không tồn tại.";
        }

        String validationError = validateCustomer(customer);
        if (validationError != null) {
            return validationError;
        }

        boolean success = customerDAO.update(customer);
        return success ? null : "Lỗi hệ thống! Không thể cập nhật thông tin khách hàng.";
    }

    /**
     * Xóa khách hàng – trả về null nếu thành công, chuỗi lỗi nếu thất bại.
     */
    public String delete(int id) {
        Customer customer = customerDAO.findById(id);
        if (customer == null) {
            return "Khách hàng không tồn tại.";
        }

        if (customerDAO.isCustomerInOrders(id)) {
            return "Không thể xóa khách hàng '" + customer.getName() + "' vì đã có đơn hàng liên kết.";
        }

        boolean success = customerDAO.delete(id);
        return success ? null : "Lỗi hệ thống! Không thể xóa khách hàng.";
    }

    /**
     * Kiểm tra dữ liệu khách hàng: tên, SĐT, email (nếu có).
     */
    private String validateCustomer(Customer customer) {
        if (customer == null) {
            return "Dữ liệu khách hàng không hợp lệ.";
        }

        // Tên bắt buộc, tối thiểu 2 ký tự
        if (ValidationUtil.isEmpty(customer.getName())) {
            return "Tên khách hàng không được để trống.";
        }
        if (customer.getName().trim().length() < 2) {
            return "Tên khách hàng phải có ít nhất 2 ký tự.";
        }

        // SĐT bắt buộc, phải đúng định dạng VN
        if (ValidationUtil.isEmpty(customer.getPhone())) {
            return "Số điện thoại không được để trống.";
        }
        if (!ValidationUtil.isValidPhone(customer.getPhone())) {
            return "Số điện thoại không đúng định dạng (VD: 0912345678).";
        }

        // Email không bắt buộc, nhưng nếu có phải đúng định dạng
        if (!ValidationUtil.isEmpty(customer.getEmail()) && !ValidationUtil.isValidEmail(customer.getEmail())) {
            return "Địa chỉ email không đúng định dạng.";
        }

        return null; // Hợp lệ
    }
}
