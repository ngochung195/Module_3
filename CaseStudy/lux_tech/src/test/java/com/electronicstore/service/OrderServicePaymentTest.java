package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.OrderDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.model.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class OrderServicePaymentTest {

    private OrderService orderService;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;

    @BeforeEach
    void setUp() {
        orderService = new OrderService();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
    }

    @Test
    @DisplayName("Đặt hàng với phương thức COD: Đơn hàng phải lưu paymentMethod = 'COD' và status = 'PENDING'")
    void testCheckoutCOD() throws Exception {
        // Lấy sản phẩm thực tế trong DB có sẵn hàng
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 2) {
                product = p;
                break;
            }
        }
        assertNotNull(product, "Phải có ít nhất 1 sản phẩm có tồn kho để test checkout");

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Customer customerInput = new Customer();
        customerInput.setName("Nguyen Test COD");
        customerInput.setPhone("0912345678");
        customerInput.setEmail("cod@example.com");
        customerInput.setAddress("123 Duong Test COD, Ha Noi");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Mặc định");

        Order createdOrder = orderService.processCheckout(user, customerInput, cart, "COD");

        assertNotNull(createdOrder);
        assertTrue(createdOrder.getId() > 0);
        assertEquals("COD", createdOrder.getPaymentMethod(), "Phương thức thanh toán phải là COD");
        assertEquals("PENDING", createdOrder.getStatus(), "Trạng thái đơn hàng phải là PENDING");

        // Đọc lại từ DB qua OrderDAO để đảm bảo DB lưu đúng
        Order dbOrder = orderDAO.findById(createdOrder.getId());
        assertNotNull(dbOrder);
        assertEquals("COD", dbOrder.getPaymentMethod(), "Cột payment_method trong MySQL phải là COD");
        assertEquals("PENDING", dbOrder.getStatus());
    }

    @Test
    @DisplayName("Đặt hàng với phương thức VNPAY: Đơn hàng phải lưu paymentMethod = 'VNPAY' và status = 'PENDING'")
    void testCheckoutVNPay() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 2) {
                product = p;
                break;
            }
        }
        assertNotNull(product, "Phải có sản phẩm có tồn kho để test");

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Customer customerInput = new Customer();
        customerInput.setName("Nguyen Test VNPay");
        customerInput.setPhone("0987654321");
        customerInput.setEmail("vnpay@example.com");
        customerInput.setAddress("456 Duong VNPay Sandbox, TP HCM");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Mặc định");

        Order createdOrder = orderService.processCheckout(user, customerInput, cart, "VNPAY");

        assertNotNull(createdOrder);
        assertTrue(createdOrder.getId() > 0);
        assertEquals("VNPAY", createdOrder.getPaymentMethod(), "Phương thức thanh toán phải là VNPAY");
        assertEquals("PENDING", createdOrder.getStatus());

        // Đọc lại từ DB
        Order dbOrder = orderDAO.findById(createdOrder.getId());
        assertNotNull(dbOrder);
        assertEquals("VNPAY", dbOrder.getPaymentMethod(), "Cột payment_method trong MySQL phải là VNPAY");
        assertEquals("PENDING", dbOrder.getStatus());

        // Kiểm tra xử lý cập nhật thanh toán thành công (markOrderAsPaid)
        boolean paidSuccess = orderService.markOrderAsPaid(createdOrder.getId());
        assertTrue(paidSuccess, "markOrderAsPaid phải thành công");

        Order updatedOrder = orderDAO.findById(createdOrder.getId());
        assertEquals("PAID", updatedOrder.getStatus(), "Sau khi thanh toán thành công, status phải là PAID");
        assertEquals("PAID", updatedOrder.getPaymentStatus(), "payment_status phải là PAID");

        // Kiểm tra Idempotency: Gọi lại markOrderAsPaid lần 2 không gây lỗi
        boolean idempotentCall = orderService.markOrderAsPaid(createdOrder.getId());
        assertTrue(idempotentCall, "Gọi markOrderAsPaid lần 2 phải trả về true mà không bị lỗi duplicate");
    }
}
