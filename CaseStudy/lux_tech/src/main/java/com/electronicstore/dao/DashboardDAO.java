package com.electronicstore.dao;

import com.electronicstore.model.Product;
import com.electronicstore.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm tổng số sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countCustomers() {
        String sql = "SELECT COUNT(*) FROM customers";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm tổng số khách hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm tổng số đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lượng đơn hàng đang ở trạng thái PENDING (chờ xác nhận từ Online).
     */
    public int countPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm số đơn hàng chờ xử lý: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lượng đơn hàng có nguồn từ Website (ONLINE).
     */
    public int countOnlineOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE source = 'ONLINE' OR source IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm đơn hàng Online: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm số lượng đơn hàng do nhân viên tạo tại quầy (STAFF).
     */
    public int countStaffOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE source = 'STAFF'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi đếm đơn hàng tại quầy: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tính tổng doanh thu từ kênh Online (đơn hàng CONFIRMED, COMPLETED hoặc PAID).
     */
    public BigDecimal calculateOnlineRevenue() {
        String sql = "SELECT COALESCE(SUM(od.quantity * od.price), 0.00) " +
                     "FROM order_details od " +
                     "JOIN orders o ON od.order_id = o.id " +
                     "WHERE o.status IN ('CONFIRMED', 'COMPLETED', 'PAID') " +
                     "AND (o.source = 'ONLINE' OR o.source IS NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tính doanh thu Online: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal calculateTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(od.quantity * od.price), 0.00) " +
                     "FROM order_details od " +
                     "JOIN orders o ON od.order_id = o.id " +
                     "WHERE o.status IN ('CONFIRMED', 'COMPLETED', 'PAID')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tính tổng doanh thu: " + e.getMessage());
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<Product> findBestSellingProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.price, p.quantity, p.category_id, c.name AS category_name, " +
                     "COALESCE(SUM(od.quantity), 0) AS total_sold " +
                     "FROM order_details od " +
                     "JOIN orders o ON od.order_id = o.id " +
                     "JOIN products p ON od.product_id = p.id " +
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE o.status IN ('CONFIRMED', 'COMPLETED', 'PAID') " +
                     "GROUP BY p.id, p.name, p.price, p.quantity, p.category_id, c.name " +
                     "ORDER BY total_sold DESC " +
                     "LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getBigDecimal("price"));
                    p.setQuantity(rs.getInt("quantity"));
                    p.setCategoryId(rs.getInt("category_id"));
                    p.setCategoryName(rs.getString("category_name"));
                    p.setTotalSold(rs.getInt("total_sold"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi truy vấn sản phẩm bán chạy: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}
