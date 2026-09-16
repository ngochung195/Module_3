package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.model.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Ownership Security Test Suite (Phase 14).
 * Kiểm tra tính cô lập và bảo mật quyền sở hữu dữ liệu giữa các Customer:
 * - Khách hàng không thể xem đơn hàng của khách hàng khác
 * - Khách hàng không thể hủy đơn hàng của khách hàng khác
 * - Quản trị viên (Admin/Staff) có quyền can thiệp hợp lệ
 */
public class OwnershipSecurityTest {

    private OrderService orderService;
    private ProductDAO productDAO;
    private CustomerDAO customerDAO;

    @BeforeEach
    void setUp() {
        orderService = new OrderService();
        productDAO = new ProductDAO();
        customerDAO = new CustomerDAO();
    }

    @Test
    @DisplayName("Ownership - Customer A không thể xem đơn hàng của Customer B")
    void testCustomerCannotViewAnotherCustomerOrder() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        int customerAId = 1;
        int customerBId = 2;

        User userB = new User();
        userB.setId(2);
        userB.setRole("CUSTOMER");
        userB.setCustomerId(customerBId);

        Customer customerB = new Customer();
        customerB.setId(customerBId);
        customerB.setName("Customer B Test");
        customerB.setPhone("0987654321");
        customerB.setAddress("456 Customer B Street");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Default");

        // Tạo đơn hàng cho Customer B
        Order orderB = orderService.processCheckout(userB, customerB, cart, "COD");
        assertNotNull(orderB);
        assertEquals(customerBId, orderB.getCustomerId());

        // 1. Customer B xem đơn của chính mình -> Hợp lệ
        Order viewByB = orderService.findByIdWithDetailsForCustomer(orderB.getId(), customerBId);
        assertNotNull(viewByB, "Customer B phải xem được đơn hàng của chính mình");

        // 2. Customer A cố tình xem đơn của Customer B -> Bị chặn (Trả về null)
        Order viewByA = orderService.findByIdWithDetailsForCustomer(orderB.getId(), customerAId);
        assertNull(viewByA, "Customer A không được phép xem chi tiết đơn hàng của Customer B");
    }

    @Test
    @DisplayName("Ownership - Customer A không thể hủy đơn hàng của Customer B")
    void testCustomerCannotCancelAnotherCustomerOrder() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        int customerAId = 1;
        int customerBId = 2;

        User userB = new User();
        userB.setId(2);
        userB.setRole("CUSTOMER");
        userB.setCustomerId(customerBId);

        Customer customerB = new Customer();
        customerB.setId(customerBId);
        customerB.setName("Customer B For Cancel");
        customerB.setPhone("0987112233");
        customerB.setAddress("789 Cancel Isolation St");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Default");

        Order orderB = orderService.processCheckout(userB, customerB, cart, "COD");
        assertNotNull(orderB);

        // Customer A cố tình gửi request hủy đơn của Customer B (isAdminOrStaff = false)
        String cancelByAError = orderService.cancelOrderWithStockRestore(orderB.getId(), customerAId, false);
        assertNotNull(cancelByAError, "Hành vi hủy đơn trái phép phải bị từ chối");
        assertTrue(cancelByAError.contains("quyền thao tác"), "Phải báo lỗi vi phạm quyền sở hữu");

        // Đơn hàng của Customer B vẫn phải ở trạng thái PENDING, không bị hủy
        Order checkOrderB = orderService.findByIdWithDetails(orderB.getId());
        assertEquals("PENDING", checkOrderB.getStatus(), "Trạng thái đơn hàng không được thay đổi");

        // Customer B hủy đơn của chính mình -> Thành công
        String cancelByBError = orderService.cancelOrderWithStockRestore(orderB.getId(), customerBId, false);
        assertNull(cancelByBError, "Customer B hủy đơn của chính mình phải thành công");
    }
}
