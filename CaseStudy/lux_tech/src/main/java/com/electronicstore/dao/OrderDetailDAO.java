package com.electronicstore.dao;

import com.electronicstore.model.OrderDetail;
import com.electronicstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO {

    /**
     * Lấy danh sách OrderDetail theo orderId.
     * JOIN với products để lấy tên sản phẩm.
     */
    public List<OrderDetail> findByOrderId(int orderId) {
        List<OrderDetail> details = new ArrayList<>();
        String sql = "SELECT od.id, od.order_id, od.product_id, p.name AS product_name, " +
                     "od.quantity, od.price " +
                     "FROM order_details od JOIN products p ON od.product_id = p.id " +
                     "WHERE od.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    details.add(extractDetailFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy chi tiết đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return details;
    }

    /**
     * Lưu OrderDetail sử dụng Connection bên ngoài (dùng cho transaction checkout).
     */
    public boolean save(Connection conn, OrderDetail detail) throws SQLException {
        String sql = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, detail.getOrderId());
            ps.setInt(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setBigDecimal(4, detail.getPrice());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        detail.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    private OrderDetail extractDetailFromResultSet(ResultSet rs) throws SQLException {
        OrderDetail detail = new OrderDetail();
        detail.setId(rs.getInt("id"));
        detail.setOrderId(rs.getInt("order_id"));
        detail.setProductId(rs.getInt("product_id"));
        detail.setProductName(rs.getString("product_name"));
        detail.setQuantity(rs.getInt("quantity"));
        detail.setPrice(rs.getBigDecimal("price"));
        return detail;
    }
}
