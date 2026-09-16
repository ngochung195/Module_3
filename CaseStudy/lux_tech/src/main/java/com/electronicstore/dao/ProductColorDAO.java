package com.electronicstore.dao;

import com.electronicstore.model.ProductColor;
import com.electronicstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductColorDAO – Quản lý dữ liệu màu sắc sản phẩm trong bảng product_colors.
 */
public class ProductColorDAO {

    public ProductColorDAO() {
        initTable();
    }

    /**
     * Tự động khởi tạo bảng product_colors nếu chưa tồn tại trong CSDL.
     */
    private void initTable() {
        String sql = "CREATE TABLE IF NOT EXISTS product_colors (" +
                "id INT AUTO_INCREMENT PRIMARY KEY, " +
                "product_id INT NOT NULL, " +
                "name VARCHAR(100) NOT NULL, " +
                "hex_code VARCHAR(20) NOT NULL, " +
                "border_hex VARCHAR(20) NULL, " +
                "CONSTRAINT fk_product_colors_products FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            System.err.println("Lỗi khởi tạo bảng product_colors: " + e.getMessage());
        }
    }

    /**
     * Lấy danh sách màu sắc của một sản phẩm theo product_id.
     */
    public List<ProductColor> findByProductId(int productId) {
        List<ProductColor> list = new ArrayList<>();
        String sql = "SELECT id, product_id, name, hex_code, border_hex FROM product_colors WHERE product_id = ? ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductColor c = new ProductColor(
                            rs.getInt("id"),
                            rs.getInt("product_id"),
                            rs.getString("name"),
                            rs.getString("hex_code"),
                            rs.getString("border_hex")
                    );
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách màu của sản phẩm ID " + productId + ": " + e.getMessage());
        }
        return list;
    }

    /**
     * Lưu (đồng bộ) danh sách màu sắc của sản phẩm trong Connection đã có (phục vụ Transaction).
     * Xóa sạch màu cũ của sản phẩm và chèn danh sách màu mới.
     */
    public boolean saveColors(Connection conn, int productId, List<ProductColor> colors) throws SQLException {
        // 1. Xóa toàn bộ màu cũ của sản phẩm này
        String deleteSql = "DELETE FROM product_colors WHERE product_id = ?";
        try (PreparedStatement psDel = conn.prepareStatement(deleteSql)) {
            psDel.setInt(1, productId);
            psDel.executeUpdate();
        }

        // 2. Chèn danh sách màu mới (nếu có)
        if (colors != null && !colors.isEmpty()) {
            String insertSql = "INSERT INTO product_colors (product_id, name, hex_code, border_hex) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                for (ProductColor c : colors) {
                    if (c.getName() != null && !c.getName().trim().isEmpty()) {
                        String hex = (c.getHexCode() != null && !c.getHexCode().trim().isEmpty()) 
                                ? c.getHexCode().trim() : "#000000";
                        String border = c.getBorderHex();
                        // Tự động thêm border nếu màu quá sáng (như trắng hoặc xám rất nhạt)
                        if (border == null && isLightColor(hex)) {
                            border = "#d1d5db";
                        }

                        psIns.setInt(1, productId);
                        psIns.setString(2, c.getName().trim());
                        psIns.setString(3, hex);
                        psIns.setString(4, border);
                        psIns.addBatch();
                    }
                }
                psIns.executeBatch();
            }
        }
        return true;
    }

    /**
     * Lưu danh sách màu quản lý Connection độc lập.
     */
    public boolean saveColors(int productId, List<ProductColor> colors) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            saveColors(conn, productId, colors);
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Lỗi rollback khi lưu màu: " + ex.getMessage());
                }
            }
            System.err.println("Lỗi lưu màu sắc sản phẩm: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Lỗi đóng connection: " + e.getMessage());
                }
            }
        }
    }

    /**
     * Kiểm tra xem màu sắc có phải tone màu sáng không (cần viền border hiển thị).
     */
    private boolean isLightColor(String hex) {
        if (hex == null || !hex.startsWith("#") || hex.length() < 7) {
            return false;
        }
        try {
            int r = Integer.parseInt(hex.substring(1, 3), 16);
            int g = Integer.parseInt(hex.substring(3, 5), 16);
            int b = Integer.parseInt(hex.substring(5, 7), 16);
            // Công thức tính độ sáng cảm nhận
            double brightness = (r * 299 + g * 587 + b * 114) / 1000.0;
            return brightness > 210;
        } catch (Exception e) {
            return false;
        }
    }
}
