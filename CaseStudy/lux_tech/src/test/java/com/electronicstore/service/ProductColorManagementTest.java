package com.electronicstore.service;

import com.electronicstore.dao.ProductColorDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.model.Product;
import com.electronicstore.model.ProductColor;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit & Integration Test kiểm tra chức năng Quản lý Màu Sắc Sản Phẩm:
 * - Thêm sản phẩm kèm danh sách màu sắc tùy chọn
 * - Đọc sản phẩm nạp đầy đủ danh sách màu sắc
 * - Chỉnh sửa / Cập nhật màu sắc sản phẩm
 * - Xóa sản phẩm tự động dọn dẹp các màu sắc liên quan (Cascade)
 */
public class ProductColorManagementTest {

    private ProductDAO productDAO;
    private ProductColorDAO productColorDAO;

    @BeforeEach
    void setUp() {
        productDAO = new ProductDAO();
        productColorDAO = new ProductColorDAO();
    }

    @Test
    @DisplayName("Thêm sản phẩm mới kèm danh sách màu sắc tùy chọn (Tên + Mã Hex)")
    void testCreateProductWithColors() {
        Product product = new Product();
        product.setName("Test Phone Color " + System.currentTimeMillis());
        product.setPrice(new BigDecimal("15000000"));
        product.setQuantity(10);
        product.setCategoryId(1);
        product.setImage("test-phone.png");

        List<ProductColor> colors = new ArrayList<>();
        colors.add(new ProductColor("Xanh Dương Titan", "#2563eb"));
        colors.add(new ProductColor("Titan Sa Mạc", "#cda277"));
        colors.add(new ProductColor("Titan Trắng", "#f4f3ed", "#d1d5db"));
        product.setColors(colors);

        boolean saved = productDAO.save(product);
        assertTrue(saved, "Phải lưu thành công sản phẩm");
        assertTrue(product.getId() > 0, "Sản phẩm phải có ID phát sinh tự động");

        // Đọc lại từ CSDL qua findById
        Product dbProduct = productDAO.findById(product.getId());
        assertNotNull(dbProduct);
        assertEquals(3, dbProduct.getColors().size(), "Phải lưu đủ 3 màu vào CSDL");

        ProductColor c1 = dbProduct.getColors().get(0);
        assertEquals("Xanh Dương Titan", c1.getName());
        assertEquals("#2563eb", c1.getHexCode());

        ProductColor c2 = dbProduct.getColors().get(1);
        assertEquals("Titan Sa Mạc", c2.getName());
        assertEquals("#cda277", c2.getHexCode());

        // Dọn dẹp
        productDAO.delete(product.getId());
    }

    @Test
    @DisplayName("Cập nhật / Chỉnh sửa màu sắc của sản phẩm (Thêm màu mới, Xóa bớt màu cũ)")
    void testUpdateProductColors() {
        // 1. Tạo sản phẩm với 2 màu ban đầu
        Product product = new Product();
        product.setName("Test Laptop Color " + System.currentTimeMillis());
        product.setPrice(new BigDecimal("25000000"));
        product.setQuantity(5);
        product.setCategoryId(2);

        List<ProductColor> initialColors = new ArrayList<>();
        initialColors.add(new ProductColor("Bạc Ánh Kim", "#e2e4e6"));
        initialColors.add(new ProductColor("Xám Không Gian", "#7d7e82"));
        product.setColors(initialColors);

        productDAO.save(product);
        int productId = product.getId();

        // 2. Chỉnh sửa: Đổi thành 3 màu khác
        List<ProductColor> updatedColors = new ArrayList<>();
        updatedColors.add(new ProductColor("Đen Nhám (Mới)", "#181818"));
        updatedColors.add(new ProductColor("Vàng Đồng (Mới)", "#d97706"));
        updatedColors.add(new ProductColor("Xanh Midnight (Mới)", "#1e3a8a"));
        product.setColors(updatedColors);

        boolean updated = productDAO.update(product);
        assertTrue(updated, "Cập nhật sản phẩm phải thành công");

        // 3. Kiểm tra lại từ DB
        Product dbProduct = productDAO.findById(productId);
        assertNotNull(dbProduct);
        assertEquals(3, dbProduct.getColors().size(), "Danh sách màu phải được cập nhật đúng 3 màu mới");
        assertEquals("Đen Nhám (Mới)", dbProduct.getColors().get(0).getName());
        assertEquals("Vàng Đồng (Mới)", dbProduct.getColors().get(1).getName());
        assertEquals("Xanh Midnight (Mới)", dbProduct.getColors().get(2).getName());

        // Dọn dẹp
        productDAO.delete(productId);
    }

    @Test
    @DisplayName("Xóa sản phẩm tự động xóa toàn bộ màu sắc liên quan trong CSDL")
    void testDeleteProductCascadesColors() {
        Product product = new Product();
        product.setName("Test Cascade " + System.currentTimeMillis());
        product.setPrice(new BigDecimal("5000000"));
        product.setQuantity(8);
        product.setCategoryId(3);

        List<ProductColor> colors = new ArrayList<>();
        colors.add(new ProductColor("Màu A", "#111111"));
        colors.add(new ProductColor("Màu B", "#222222"));
        product.setColors(colors);

        productDAO.save(product);
        int productId = product.getId();

        // Đảm bảo trong CSDL có 2 màu
        List<ProductColor> dbColorsBefore = productColorDAO.findByProductId(productId);
        assertEquals(2, dbColorsBefore.size());

        // Xóa sản phẩm
        boolean deleted = productDAO.delete(productId);
        assertTrue(deleted);

        // Kiểm tra bảng product_colors: Không còn màu nào thuộc về productId này
        List<ProductColor> dbColorsAfter = productColorDAO.findByProductId(productId);
        assertTrue(dbColorsAfter.isEmpty(), "Các màu của sản phẩm đã bị xóa phải được dọn dẹp sạch sẽ");
    }

    @Test
    @DisplayName("getAvailableColors(): Ưu tiên màu trong CSDL, nếu rỗng thì fallback về danh sách mặc định")
    void testGetAvailableColorsFallback() {
        // Trường hợp 1: Sản phẩm có màu trong DB -> trả về đúng màu đó
        Product p1 = new Product();
        p1.setName("iPhone 17 Pro Max");
        List<ProductColor> customColors = new ArrayList<>();
        customColors.add(new ProductColor("Hồng Độc Quyền", "#f43f5e"));
        p1.setColors(customColors);

        assertEquals(1, p1.getAvailableColors().size());
        assertEquals("Hồng Độc Quyền", p1.getAvailableColors().get(0).getName());

        // Trường hợp 2: Sản phẩm chưa có màu trong DB -> tự động fallback về danh sách theo tên
        Product p2 = new Product();
        p2.setName("iPhone 17 Pro Max");
        p2.setColors(new ArrayList<>()); // rỗng

        assertFalse(p2.getAvailableColors().isEmpty(), "Phải có danh sách màu mặc định");
        assertEquals("Titan Sa Mạc", p2.getAvailableColors().get(0).getName());
    }
}
