package com.electronicstore.dao;

import com.electronicstore.model.Order;
import com.electronicstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public OrderDAO() {
        initTableSchema();
    }

    /**
     * Tự động kiểm tra và thêm cột source vào bảng orders nếu chưa tồn tại (Phase 13).
     */
    private void initTableSchema() {
        String checkSql = "SELECT source FROM orders LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(checkSql);
        } catch (SQLException e) {
            // Cột source chưa có -> Thêm cột với giá trị mặc định 'ONLINE'
            String alterSql = "ALTER TABLE orders ADD COLUMN source VARCHAR(20) NOT NULL DEFAULT 'ONLINE'";
            try (Connection conn = DBConnection.getConnection();
                 Statement stmt = conn.createStatement()) {
                stmt.execute(alterSql);
            } catch (SQLException ex) {
                // Đã tồn tại hoặc lỗi khác
            }
        }
    }

    /**
     * Lấy tất cả đơn hàng (ADMIN/STAFF).
     */
    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.id, o.customer_id, c.name AS customer_name, " +
                     "o.order_date, o.total, o.status, o.payment_method, o.payment_status, o.source " +
                     "FROM orders o JOIN customers c ON o.customer_id = c.id " +
                     "ORDER BY o.id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Tìm đơn hàng theo ID.
     */
    public Order findById(int id) {
        String sql = "SELECT o.id, o.customer_id, c.name AS customer_name, " +
                     "o.order_date, o.total, o.status, o.payment_method, o.payment_status, o.source " +
                     "FROM orders o JOIN customers c ON o.customer_id = c.id " +
                     "WHERE o.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractOrderFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi truy vấn đơn hàng theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy tất cả đơn hàng của một customer cụ thể.
     */
    public List<Order> findByCustomerId(int customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.id, o.customer_id, c.name AS customer_name, " +
                     "o.order_date, o.total, o.status, o.payment_method, o.payment_status, o.source " +
                     "FROM orders o JOIN customers c ON o.customer_id = c.id " +
                     "WHERE o.customer_id = ? " +
                     "ORDER BY o.id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy đơn hàng theo customer_id: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Lưu Order mới sử dụng Connection bên ngoài (dùng cho transaction checkout và staff create order).
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean save(Connection conn, Order order) throws SQLException {
        String sql = "INSERT INTO orders (customer_id, order_date, total, status, payment_method, payment_status, source) VALUES (?, NOW(), ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getCustomerId());
            ps.setBigDecimal(2, order.getTotal());
            ps.setString(3, order.getStatus() != null ? order.getStatus() : "PENDING");
            ps.setString(4, order.getPaymentMethod() != null ? order.getPaymentMethod() : "COD");
            ps.setString(5, order.getPaymentStatus() != null ? order.getPaymentStatus() : "UNPAID");
            ps.setString(6, order.getSource() != null ? order.getSource() : "ONLINE");

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    /**
     * Cập nhật trạng thái đơn hàng (dùng cho ADMIN/STAFF quản lý và Customer cancel).
     */
    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật trạng thái đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật trạng thái thanh toán thành công (dùng cho VNPay callback / IPN / Return).
     */
    public boolean updatePaymentSuccess(int orderId, String newStatus, String paymentStatus) {
        String sql = "UPDATE orders SET status = ?, payment_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, paymentStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật trạng thái thanh toán: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật trạng thái đơn hàng sử dụng Connection bên ngoài (dùng cho transaction cancel + restore stock).
     */
    public boolean updateStatus(Connection conn, int orderId, String newStatus) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Tìm kiếm đơn hàng theo keyword (tên khách hàng) và/hoặc status.
     */
    public List<Order> search(String keyword, String status) {
        return search(keyword, status, null);
    }

    /**
     * Tìm kiếm đơn hàng theo keyword, status và source (ONLINE / STAFF).
     */
    public List<Order> search(String keyword, String status, String source) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT o.id, o.customer_id, c.name AS customer_name, " +
            "o.order_date, o.total, o.status, o.payment_method, o.payment_status, o.source " +
            "FROM orders o JOIN customers c ON o.customer_id = c.id WHERE 1=1 "
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = status != null && !status.trim().isEmpty();
        boolean hasSource = source != null && !source.trim().isEmpty() && !"ALL".equalsIgnoreCase(source.trim());

        if (hasKeyword) {
            sql.append("AND c.name LIKE ? ");
        }
        if (hasStatus) {
            sql.append("AND o.status = ? ");
        }
        if (hasSource) {
            sql.append("AND o.source = ? ");
        }
        sql.append("ORDER BY o.id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (hasKeyword) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            if (hasStatus) {
                ps.setString(paramIndex++, status.trim().toUpperCase());
            }
            if (hasSource) {
                ps.setString(paramIndex++, source.trim().toUpperCase());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm kiếm đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setCustomerId(rs.getInt("customer_id"));
        order.setCustomerName(rs.getString("customer_name"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotal(rs.getBigDecimal("total"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        try {
            String src = rs.getString("source");
            order.setSource((src != null && !src.trim().isEmpty()) ? src : "ONLINE");
        } catch (SQLException e) {
            order.setSource("ONLINE");
        }
        return order;
    }
}
