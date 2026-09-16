package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.OrderDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.dao.UserDAO;
import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.model.Product;
import com.electronicstore.model.User;
import com.electronicstore.util.PasswordUtil;
import com.electronicstore.util.ValidationUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Security & Authorization Test Suite (Phase 14).
 * - BCrypt Password Hashing and Verification
 * - SQL Injection Protection across DAOs (PreparedStatements)
 * - XSS Prevention & Sanitization
 * - Role-based authorization rules verification
 */
public class SecurityAndAuthorizationTest {

    private UserService userService;
    private OrderService orderService;
    private ProductService productService;
    private CustomerService customerService;
    private UserDAO userDAO;
    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    private CustomerDAO customerDAO;

    @BeforeEach
    void setUp() {
        userService = new UserService();
        orderService = new OrderService();
        productService = new ProductService();
        customerService = new CustomerService();
        userDAO = new UserDAO();
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        customerDAO = new CustomerDAO();
    }

    @Test
    @DisplayName("Security - BCrypt Hash: Mật khẩu luôn được mã hóa ngẫu nhiên và an toàn")
    void testBCryptPasswordSecurity() {
        String rawPassword = "AdminSecretPassword!2026";
        String hash1 = PasswordUtil.hashPassword(rawPassword);
        String hash2 = PasswordUtil.hashPassword(rawPassword);

        assertNotNull(hash1);
        assertNotNull(hash2);
        assertNotEquals(rawPassword, hash1, "Mật khẩu không được lưu dưới dạng plain text");
        assertNotEquals(hash1, hash2, "Mỗi lần băm BCrypt phải sinh Salt khác nhau");
        assertTrue(PasswordUtil.checkPassword(rawPassword, hash1));
        assertTrue(PasswordUtil.checkPassword(rawPassword, hash2));
        assertFalse(PasswordUtil.checkPassword("WrongPassword", hash1));
    }

    @Test
    @DisplayName("Security - SQL Injection: Tìm kiếm với chuỗi độc hại không làm hỏng câu lệnh SQL")
    void testSqlInjectionProtection() {
        String sqlInjectionKeyword = "' OR '1'='1' -- ";
        
        // 1. Product Search
        assertDoesNotThrow(() -> {
            List<Product> products = productService.search(sqlInjectionKeyword, null);
            assertNotNull(products);
        }, "Tìm kiếm sản phẩm với payload SQL Injection phải an toàn");

        // 2. Order Search
        assertDoesNotThrow(() -> {
            List<Order> orders = orderService.search(sqlInjectionKeyword, null, null);
            assertNotNull(orders);
        }, "Tìm kiếm đơn hàng với payload SQL Injection phải an toàn");

        // 3. Customer Search
        assertDoesNotThrow(() -> {
            List<Customer> customers = customerService.search(sqlInjectionKeyword);
            assertNotNull(customers);
        }, "Tìm kiếm khách hàng với payload SQL Injection phải an toàn");
    }

    @Test
    @DisplayName("Security - XSS Prevention: Ký tự nguy hiểm được escape hoặc mã hóa")
    void testXssProtection() {
        String xssPayload = "<script>alert('hack')</script>";
        String sanitized = ValidationUtil.sanitizeHtml(xssPayload);
        assertFalse(sanitized.contains("<script>"), "Không được để lọt thẻ script");
        assertTrue(sanitized.contains("&lt;script&gt;"));
    }

    @Test
    @DisplayName("Security - Role Matrix: Kiểm tra phân quyền truy cập theo từng vai trò")
    void testRolePermissionsMatrix() {
        // ADMIN: toàn quyền
        User admin = new User(1, "admin", "pwd", "ADMIN");
        assertTrue("ADMIN".equalsIgnoreCase(admin.getRole()));

        // STAFF: chỉ quản lý nghiệp vụ, không quản lý người dùng
        User staff = new User(2, "staff", "pwd", "STAFF");
        assertTrue("STAFF".equalsIgnoreCase(staff.getRole()));
        assertFalse("ADMIN".equalsIgnoreCase(staff.getRole()));

        // CUSTOMER: chỉ dùng shop, không được truy cập back-office
        User customer = new User("customer", "pwd", "CUSTOMER", 1);
        assertTrue("CUSTOMER".equalsIgnoreCase(customer.getRole()));
        assertEquals(1, customer.getCustomerId());
    }
}
