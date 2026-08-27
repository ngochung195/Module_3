package com.codegym.service;

import com.codegym.model.Product;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Implementation của ProductService sử dụng HashMap tĩnh để giả lập cơ sở dữ liệu.
 * Dữ liệu được khởi tạo sẵn với một số sản phẩm mẫu để tiện kiểm thử.
 */
public class ProductServiceImpl implements ProductService {

    // Map tĩnh giả lập database: key = id, value = Product
    private static final Map<Integer, Product> productDB = new LinkedHashMap<>();

    // Bộ đếm ID tự động tăng
    private static int idCounter = 1;

    // ==================== Khởi tạo dữ liệu mẫu ====================
    static {
        save_internal(new Product(0, "Laptop Dell XPS 15", 32990000, "Laptop cao cấp màn hình OLED 15.6 inch", "Dell"));
        save_internal(new Product(0, "iPhone 15 Pro Max", 34990000, "Smartphone Apple chip A17 Pro, camera 48MP", "Apple"));
        save_internal(new Product(0, "Samsung Galaxy S24 Ultra", 31990000, "Smartphone Android hàng đầu, bút S-Pen tích hợp", "Samsung"));
        save_internal(new Product(0, "MacBook Air M3", 29990000, "Laptop siêu mỏng nhẹ, chip Apple M3", "Apple"));
        save_internal(new Product(0, "Sony WH-1000XM5", 8490000, "Tai nghe chống ồn hàng đầu thế giới", "Sony"));
        save_internal(new Product(0, "iPad Pro M4 11 inch", 23990000, "Máy tính bảng chuyên nghiệp, màn hình Ultra Retina XDR", "Apple"));
        save_internal(new Product(0, "Logitech MX Master 3S", 2490000, "Chuột không dây cao cấp cho dân văn phòng", "Logitech"));
    }

    // Phương thức nội bộ để thêm sản phẩm với ID tự động
    private static void save_internal(Product product) {
        product.setId(idCounter++);
        productDB.put(product.getId(), product);
    }

    // ==================== Triển khai interface ====================

    @Override
    public List<Product> findAll() {
        return new ArrayList<>(productDB.values());
    }

    @Override
    public Product findById(int id) {
        return productDB.get(id);
    }

    @Override
    public void save(Product product) {
        product.setId(idCounter++);
        productDB.put(product.getId(), product);
    }

    @Override
    public void update(Product product) {
        if (productDB.containsKey(product.getId())) {
            productDB.put(product.getId(), product);
        }
    }

    @Override
    public void delete(int id) {
        productDB.remove(id);
    }

    @Override
    public List<Product> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        String lowerKeyword = keyword.toLowerCase().trim();
        return productDB.values().stream()
                .filter(p -> p.getName().toLowerCase().contains(lowerKeyword)
                        || p.getManufacturer().toLowerCase().contains(lowerKeyword)
                        || p.getDescription().toLowerCase().contains(lowerKeyword))
                .collect(Collectors.toList());
    }
}
