package com.codegym.dao;

import com.codegym.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO implements IProductDAO {

    private static final String SELECT_ALL_PRODUCTS = 
        "SELECT p.id, p.name, p.price, p.quantity, p.color, p.description, p.category_id, c.name AS category_name " +
        "FROM products p " +
        "JOIN categories c ON p.category_id = c.id " +
        "ORDER BY p.id ASC;";

    private static final String SELECT_PRODUCT_BY_ID = 
        "SELECT p.id, p.name, p.price, p.quantity, p.color, p.description, p.category_id, c.name AS category_name " +
        "FROM products p " +
        "JOIN categories c ON p.category_id = c.id " +
        "WHERE p.id = ?;";

    private static final String INSERT_PRODUCT = 
        "INSERT INTO products (name, price, quantity, color, description, category_id) " +
        "VALUES (?, ?, ?, ?, ?, ?);";

    private static final String UPDATE_PRODUCT = 
        "UPDATE products SET name = ?, price = ?, quantity = ?, color = ?, description = ?, category_id = ? " +
        "WHERE id = ?;";

    private static final String DELETE_PRODUCT = 
        "DELETE FROM products WHERE id = ?;";

    @Override
    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_PRODUCTS)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    @Override
    public Product findById(int id) {
        Product product = null;
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PRODUCT_BY_ID)) {
            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                product = mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    @Override
    public boolean insert(Product product) {
        boolean rowInserted = false;
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_PRODUCT)) {
            preparedStatement.setString(1, product.getName());
            preparedStatement.setDouble(2, product.getPrice());
            preparedStatement.setInt(3, product.getQuantity());
            preparedStatement.setString(4, product.getColor());
            preparedStatement.setString(5, product.getDescription());
            preparedStatement.setInt(6, product.getCategoryId());
            rowInserted = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowInserted;
    }

    @Override
    public boolean update(Product product) {
        boolean rowUpdated = false;
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_PRODUCT)) {
            preparedStatement.setString(1, product.getName());
            preparedStatement.setDouble(2, product.getPrice());
            preparedStatement.setInt(3, product.getQuantity());
            preparedStatement.setString(4, product.getColor());
            preparedStatement.setString(5, product.getDescription());
            preparedStatement.setInt(6, product.getCategoryId());
            preparedStatement.setInt(7, product.getId());
            rowUpdated = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    @Override
    public boolean delete(int id) {
        boolean rowDeleted = false;
        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_PRODUCT)) {
            preparedStatement.setInt(1, id);
            rowDeleted = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowDeleted;
    }

    @Override
    public List<Product> search(String name, Double price, Integer categoryId) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.id, p.name, p.price, p.quantity, p.color, p.description, p.category_id, c.name AS category_name " +
            "FROM products p " +
            "JOIN categories c ON p.category_id = c.id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append("AND p.name LIKE ? ");
            params.add("%" + name.trim() + "%");
        }

        if (price != null && price > 0) {
            // Hỗ trợ tìm kiếm theo giá gần đúng hoặc theo giá trị tương đối
            sql.append("AND (p.price = ? OR CAST(p.price AS CHAR) LIKE ?) ");
            params.add(price);
            params.add("%" + String.valueOf(price.longValue()) + "%");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        sql.append("ORDER BY p.id ASC;");

        try (Connection connection = DBContext.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    preparedStatement.setString(i + 1, (String) param);
                } else if (param instanceof Double) {
                    preparedStatement.setDouble(i + 1, (Double) param);
                } else if (param instanceof Integer) {
                    preparedStatement.setInt(i + 1, (Integer) param);
                }
            }

            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        double price = rs.getDouble("price");
        int quantity = rs.getInt("quantity");
        String color = rs.getString("color");
        String description = rs.getString("description");
        int categoryId = rs.getInt("category_id");
        String categoryName = rs.getString("category_name");
        return new Product(id, name, price, quantity, color, description, categoryId, categoryName);
    }
}
