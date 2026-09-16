package com.electronicstore.dao;

import com.electronicstore.model.Product;
import com.electronicstore.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private final ProductColorDAO productColorDAO = new ProductColorDAO();

    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.price, p.quantity, p.category_id, p.image, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "ORDER BY p.id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(extractProductFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy danh sách sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public Product findById(int id) {
        String sql = "SELECT p.id, p.name, p.price, p.quantity, p.category_id, p.image, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = extractProductFromResultSet(rs);
                    if (product != null) {
                        product.setColors(productColorDAO.findByProductId(product.getId()));
                    }
                    return product;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi truy vấn sản phẩm theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> search(String keyword, Integer categoryId) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.id, p.name, p.price, p.quantity, p.category_id, p.image, c.name AS category_name " +
            "FROM products p JOIN categories c ON p.category_id = c.id WHERE 1=1 "
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasCategory = categoryId != null && categoryId > 0;

        if (hasKeyword) {
            sql.append("AND p.name LIKE ? ");
        }
        if (hasCategory) {
            sql.append("AND p.category_id = ? ");
        }
        sql.append("ORDER BY p.id ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (hasKeyword) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            if (hasCategory) {
                ps.setInt(paramIndex++, categoryId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(extractProductFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tìm kiếm sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public boolean save(Product product) {
        String sql = "INSERT INTO products (name, price, quantity, category_id, image) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, product.getName());
                ps.setBigDecimal(2, product.getPrice());
                ps.setInt(3, product.getQuantity());
                ps.setInt(4, product.getCategoryId());
                ps.setString(5, product.getImage());

                int affectedRows = ps.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            product.setId(generatedKeys.getInt(1));
                        }
                    }
                } else {
                    conn.rollback();
                    return false;
                }
            }

            // Lưu danh sách màu sắc nếu có
            if (product.getColors() != null && !product.getColors().isEmpty()) {
                productColorDAO.saveColors(conn, product.getId(), product.getColors());
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Lỗi rollback khi thêm sản phẩm: " + ex.getMessage());
                }
            }
            System.err.println("Lỗi thêm sản phẩm mới: " + e.getMessage());
            e.printStackTrace();
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
        return false;
    }

    public boolean update(Product product) {
        String sql = "UPDATE products SET name = ?, price = ?, quantity = ?, category_id = ?, image = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, product.getName());
                ps.setBigDecimal(2, product.getPrice());
                ps.setInt(3, product.getQuantity());
                ps.setInt(4, product.getCategoryId());
                ps.setString(5, product.getImage());
                ps.setInt(6, product.getId());

                int affectedRows = ps.executeUpdate();
                if (affectedRows <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Cập nhật lại danh sách màu sắc
            if (product.getColors() != null) {
                productColorDAO.saveColors(conn, product.getId(), product.getColors());
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Lỗi rollback khi cập nhật sản phẩm: " + ex.getMessage());
                }
            }
            System.err.println("Lỗi cập nhật sản phẩm: " + e.getMessage());
            e.printStackTrace();
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
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi xóa sản phẩm: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isProductInOrders(int productId) {
        String sql = "SELECT COUNT(*) FROM order_details WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi kiểm tra sản phẩm trong đơn hàng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tìm sản phẩm theo ID sử dụng Connection của transaction (hỗ trợ đọc trực tiếp trong transaction).
     */
    public Product findById(Connection conn, int id) throws SQLException {
        String sql = "SELECT p.id, p.name, p.price, p.quantity, p.category_id, p.image, c.name AS category_name " +
                     "FROM products p JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractProductFromResultSet(rs);
                }
            }
        }
        return null;
    }

    /**
     * Trừ tồn kho sản phẩm an toàn trong transaction.
     * Kiểm tra điều kiện quantity >= ? để đảm bảo không bị âm kho.
     * @return true nếu trừ kho thành công, false nếu không đủ tồn kho hoặc không tìm thấy sản phẩm.
     */
    public boolean decreaseStock(Connection conn, int productId, int quantity) throws SQLException {
        String sql = "UPDATE products SET quantity = quantity - ? WHERE id = ? AND quantity >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Hoàn trả tồn kho sản phẩm trong transaction (khi hủy đơn hàng).
     */
    public boolean increaseStock(Connection conn, int productId, int quantity) throws SQLException {
        String sql = "UPDATE products SET quantity = quantity + ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Lấy toàn bộ sản phẩm kèm danh sách màu sắc phục vụ nạp ngữ cảnh cho AI Chatbot.
     */
    public List<Product> findAllWithColors() {
        List<Product> products = findAll();
        for (Product product : products) {
            try {
                product.setColors(productColorDAO.findByProductId(product.getId()));
            } catch (Exception e) {
                // Ignore if color loading fails
            }
        }
        return products;
    }

    private Product extractProductFromResultSet(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setQuantity(rs.getInt("quantity"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setImage(rs.getString("image"));
        product.setCategoryName(rs.getString("category_name"));
        return product;
    }
}
