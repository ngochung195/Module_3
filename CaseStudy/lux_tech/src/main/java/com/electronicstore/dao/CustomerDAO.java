package com.electronicstore.dao;

import com.electronicstore.model.Customer;
import com.electronicstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public List<Customer> findAll() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT id, name, phone, email, address FROM customers ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                customers.add(extractCustomerFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách khách hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }

    public Customer findById(int id) {
        String sql = "SELECT id, name, phone, email, address FROM customers WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCustomerFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi truy vấn khách hàng theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tìm kiếm khách hàng theo từ khóa (tên, SĐT hoặc email).
     */
    public List<Customer> search(String keyword) {
        List<Customer> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT id, name, phone, email, address FROM customers WHERE 1=1 "
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        if (hasKeyword) {
            sql.append("AND (name LIKE ? OR phone LIKE ? OR email LIKE ?) ");
        }
        sql.append("ORDER BY id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (hasKeyword) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(extractCustomerFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm kiếm khách hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }

    public boolean save(Customer customer) {
        String sql = "INSERT INTO customers (name, phone, email, address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getAddress());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        customer.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi thêm khách hàng mới: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lưu Customer sử dụng Connection bên ngoài (dùng cho transaction đăng ký).
     */
    public boolean saveWithConnection(Connection conn, Customer customer) throws SQLException {
        String sql = "INSERT INTO customers (name, phone, email, address) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getPhone());
            if (customer.getEmail() != null) {
                ps.setString(3, customer.getEmail());
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            if (customer.getAddress() != null) {
                ps.setString(4, customer.getAddress());
            } else {
                ps.setNull(4, java.sql.Types.VARCHAR);
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        customer.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    public boolean update(Customer customer) {
        String sql = "UPDATE customers SET name = ?, phone = ?, email = ?, address = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getPhone());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getAddress());
            ps.setInt(5, customer.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật khách hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật Customer sử dụng Connection bên ngoài (dùng cho transaction checkout).
     */
    public boolean updateWithConnection(Connection conn, Customer customer) throws SQLException {
        String sql = "UPDATE customers SET name = ?, phone = ?, email = ?, address = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getPhone());
            if (customer.getEmail() != null) {
                ps.setString(3, customer.getEmail());
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            if (customer.getAddress() != null) {
                ps.setString(4, customer.getAddress());
            } else {
                ps.setNull(4, java.sql.Types.VARCHAR);
            }
            ps.setInt(5, customer.getId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM customers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi xóa khách hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra khách hàng có đơn hàng liên kết không (để ngăn xóa).
     */
    public boolean isCustomerInOrders(int customerId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi kiểm tra khách hàng trong đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setId(rs.getInt("id"));
        customer.setName(rs.getString("name"));
        customer.setPhone(rs.getString("phone"));
        customer.setEmail(rs.getString("email"));
        customer.setAddress(rs.getString("address"));
        return customer;
    }
}
