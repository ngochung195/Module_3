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
 * Order Transaction & Stock Test Suite (Phase 14).
 * - Kiểm tra tính toàn vẹn của Transaction khi xử lý đơn hàng
 * - Kiểm tra trừ kho & hoàn trả tồn kho nguyên tử
 * - Kiểm tra từ chối khi vượt quá số lượng tồn kho hoặc số lượng không hợp lệ
 */
public class OrderTransactionAndStockTest {

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
    @DisplayName("Stock & Transaction - Đặt hàng thành công thì tồn kho bị trừ chính xác")
    void testStockDeductionOnSuccessfulCheckout() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        int initialStock = productDAO.findById(product.getId()).getQuantity();
        int buyQty = 3;

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Customer customerInput = new Customer();
        customerInput.setName("Test Stock Customer");
        customerInput.setPhone("0981122334");
        customerInput.setAddress("123 Test Stock Address");

        Cart cart = new Cart();
        cart.addItem(product, buyQty, "Default");

        Order order = orderService.processCheckout(user, customerInput, cart, "COD");
        assertNotNull(order);
        assertTrue(order.getId() > 0);

        int stockAfterCheckout = productDAO.findById(product.getId()).getQuantity();
        assertEquals(initialStock - buyQty, stockAfterCheckout, "Tồn kho phải bị trừ đúng số lượng đã mua");
    }

    @Test
    @DisplayName("Stock & Transaction - Hủy đơn hàng tự động hoàn trả tồn kho về trạng thái ban đầu")
    void testStockRestorationOnOrderCancel() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        int initialStock = productDAO.findById(product.getId()).getQuantity();
        int buyQty = 2;

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Customer customerInput = new Customer();
        customerInput.setName("Test Cancel Customer");
        customerInput.setPhone("0982233445");
        customerInput.setAddress("456 Cancel Street");

        Cart cart = new Cart();
        cart.addItem(product, buyQty, "Default");

        Order order = orderService.processCheckout(user, customerInput, cart, "COD");
        assertEquals(initialStock - buyQty, productDAO.findById(product.getId()).getQuantity());

        // Thực hiện hủy đơn hàng (Admin/Staff)
        String cancelError = orderService.cancelOrderWithStockRestore(order.getId(), 0, true);
        assertNull(cancelError, "Hủy đơn hàng phải thành công");

        int stockAfterCancel = productDAO.findById(product.getId()).getQuantity();
        assertEquals(initialStock, stockAfterCancel, "Tồn kho phải được phục hồi đúng số lượng ban đầu");
    }

    @Test
    @DisplayName("Stock & Transaction - Từ chối đặt hàng khi số lượng mua vượt quá số lượng trong kho")
    void testRejectOrderWhenInsufficientStock() {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 0) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        int currentStock = productDAO.findById(product.getId()).getQuantity();
        int excessiveQty = currentStock + 50;

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Customer customerInput = new Customer();
        customerInput.setName("Test Insufficient Stock");
        customerInput.setPhone("0983344556");
        customerInput.setAddress("789 Out of Stock Road");

        Cart cart = new Cart();
        CartItem excessiveItem = new CartItem(
            product.getId(),
            product.getName(),
            product.getPrice(),
            excessiveQty,
            "Default",
            "",
            currentStock
        );
        cart.getItems().add(excessiveItem);

        // Transaction phải ném Exception và Rollback
        assertThrows(Exception.class, () -> {
            orderService.processCheckout(user, customerInput, cart, "COD");
        }, "Hệ thống phải từ chối khi mua số lượng lớn hơn tồn kho");

        // Tồn kho không bị thay đổi
        int stockAfterAttempt = productDAO.findById(product.getId()).getQuantity();
        assertEquals(currentStock, stockAfterAttempt, "Tồn kho không được thay đổi khi giao dịch thất bại");
    }

    @Test
    @DisplayName("Stock & Transaction - Từ chối tạo đơn tại quầy khi số lượng không hợp lệ (<= 0)")
    void testRejectStaffOrderInvalidQuantity() {
        List<Product> products = productDAO.findAll();
        assertFalse(products.isEmpty());
        Product product = products.get(0);

        List<Customer> customers = customerDAO.findAll();
        assertFalse(customers.isEmpty());
        Customer customer = customers.get(0);

        assertThrows(IllegalArgumentException.class, () -> {
            orderService.createStaffOrder(customer.getId(), product.getId(), 0, "COD");
        }, "Số lượng <= 0 phải bị từ chối");

        assertThrows(IllegalArgumentException.class, () -> {
            orderService.createStaffOrder(customer.getId(), product.getId(), -5, "COD");
        }, "Số lượng âm phải bị từ chối");
    }
}
