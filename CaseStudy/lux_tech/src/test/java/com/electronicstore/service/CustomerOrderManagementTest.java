package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.OrderDAO;
import com.electronicstore.dao.ProductDAO;
import com.electronicstore.model.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit & Integration Test cho Phase 11: Customer Order Management:
 * - My Orders (Danh sách đơn hàng của khách hàng)
 * - Order Detail (Chi tiết đơn hàng)
 * - Order Ownership (Bảo mật quyền sở hữu đơn hàng)
 * - Cancel Order (Hủy đơn hàng PENDING)
 * - Restore Stock (Tự động hoàn trả tồn kho sản phẩm khi hủy đơn)
 * - Transaction (Tính nguyên tử trong DB transaction)
 */
public class CustomerOrderManagementTest {

    private OrderService orderService;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private CustomerDAO customerDAO;

    @BeforeEach
    void setUp() {
        orderService = new OrderService();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        customerDAO = new CustomerDAO();
    }

    @Test
    @DisplayName("Phase 11 - My Orders: Lấy danh sách đơn hàng theo customer_id")
    void testFindByCustomerId() throws Exception {
        // Tạo hoặc lấy sản phẩm
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 5) {
                product = p;
                break;
            }
        }
        assertNotNull(product, "Cần có ít nhất 1 sản phẩm có tồn kho");

        int testCustomerId = 1;
        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(testCustomerId);

        Customer customerInput = new Customer();
        customerInput.setId(testCustomerId);
        customerInput.setName("Test Customer Phase 11");
        customerInput.setPhone("0912345678");
        customerInput.setEmail("phase11@test.com");
        customerInput.setAddress("123 Test Street");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Màu xám");

        Order order = orderService.processCheckout(user, customerInput, cart, "COD");
        assertNotNull(order);
        assertTrue(order.getId() > 0);

        // Kiểm tra findByCustomerId
        List<Order> customerOrders = orderService.findByCustomerId(testCustomerId);
        assertNotNull(customerOrders);
        assertTrue(customerOrders.size() > 0);
        boolean foundCreatedOrder = customerOrders.stream().anyMatch(o -> o.getId() == order.getId());
        assertTrue(foundCreatedOrder, "Đơn hàng vừa tạo phải có trong danh sách My Orders của customer");
    }

    @Test
    @DisplayName("Phase 11 - Order Detail & Order Ownership: Chỉ chủ sở hữu mới xem được chi tiết đơn hàng")
    void testOrderOwnershipAndDetail() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 5) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        int ownerCustomerId = 1;
        int attackerCustomerId = 999999; // ID người khác

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(ownerCustomerId);

        Customer customerInput = new Customer();
        customerInput.setId(ownerCustomerId);
        customerInput.setName("Owner Customer");
        customerInput.setPhone("0901234567");
        customerInput.setEmail("owner@test.com");
        customerInput.setAddress("Owner Address");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Tiêu chuẩn");

        Order order = orderService.processCheckout(user, customerInput, cart, "COD");
        assertNotNull(order);

        // 1. Chủ sở hữu truy cập -> Thành công, có đủ chi tiết OrderDetails
        Order detailOwner = orderService.findByIdWithDetailsForCustomer(order.getId(), ownerCustomerId);
        assertNotNull(detailOwner, "Chủ sở hữu phải xem được chi tiết đơn hàng");
        assertNotNull(detailOwner.getOrderDetails());
        assertFalse(detailOwner.getOrderDetails().isEmpty(), "Chi tiết đơn hàng phải có danh sách sản phẩm");

        // 2. Khách hàng khác truy cập -> Bị từ chối (trả về null - 403)
        Order detailAttacker = orderService.findByIdWithDetailsForCustomer(order.getId(), attackerCustomerId);
        assertNull(detailAttacker, "Customer khác không được phép xem đơn hàng này (Order Ownership bảo vệ)");
    }

    @Test
    @DisplayName("Phase 11 - Cancel Order & Restore Stock: Hủy đơn PENDING, hoàn trả đúng tồn kho trong Transaction")
    void testCancelOrderAndRestoreStock() throws Exception {
        List<Product> products = productDAO.findAll();
        Product targetProduct = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                targetProduct = p;
                break;
            }
        }
        assertNotNull(targetProduct);

        int productId = targetProduct.getId();
        int initialStock = productDAO.findById(productId).getQuantity();
        int orderQty = 2;

        int customerId = 1;
        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(customerId);

        Customer customerInput = new Customer();
        customerInput.setId(customerId);
        customerInput.setName("Customer Cancel Test");
        customerInput.setPhone("0908888888");
        customerInput.setEmail("cancel@test.com");
        customerInput.setAddress("Cancel Test Address");

        Cart cart = new Cart();
        cart.addItem(targetProduct, orderQty, "Tiêu chuẩn");

        // Tạo đơn hàng -> Stock phải giảm đúng orderQty
        Order order = orderService.processCheckout(user, customerInput, cart, "COD");
        assertNotNull(order);

        int stockAfterOrder = productDAO.findById(productId).getQuantity();
        assertEquals(initialStock - orderQty, stockAfterOrder, "Sau khi đặt, tồn kho phải giảm trừ đúng số lượng đặt");

        // Tiến hành hủy đơn hàng (Cancel Order)
        String cancelError = orderService.cancelOrderWithStockRestore(order.getId(), customerId, false);
        assertNull(cancelError, "Hủy đơn hàng PENDING của chính mình phải thành công (trả về null)");

        // 1. Kiểm tra trạng thái đơn hàng trong DB -> Phải là CANCELLED
        Order cancelledOrder = orderDAO.findById(order.getId());
        assertNotNull(cancelledOrder);
        assertEquals("CANCELLED", cancelledOrder.getStatus(), "Trạng thái đơn hàng phải chuyển sang CANCELLED");

        // 2. Kiểm tra tồn kho sản phẩm trong DB -> Phải được hoàn trả (Restore Stock)
        int stockAfterCancel = productDAO.findById(productId).getQuantity();
        assertEquals(initialStock, stockAfterCancel, "Tồn kho phải được tự động hoàn trả nguyên vẹn về giá trị ban đầu");
    }

    @Test
    @DisplayName("Phase 11 - Cancel Order Ownership Security: Customer khác không thể hủy đơn của người khác")
    void testCannotCancelOtherCustomerOrder() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = products.stream().filter(p -> p.getQuantity() > 5).findFirst().orElse(null);
        assertNotNull(product);

        int ownerCustomerId = 1;
        int hackerCustomerId = 88888;

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(ownerCustomerId);

        Customer customer = new Customer();
        customer.setId(ownerCustomerId);
        customer.setName("Owner Customer");
        customer.setPhone("0901112222");
        customer.setEmail("owner2@test.com");
        customer.setAddress("Owner Address 2");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Tiêu chuẩn");

        Order order = orderService.processCheckout(user, customer, cart, "COD");
        assertNotNull(order);

        // Hacker cố gắng hủy đơn của owner
        String error = orderService.cancelOrderWithStockRestore(order.getId(), hackerCustomerId, false);
        assertNotNull(error);
        assertTrue(error.contains("không có quyền"), "Hệ thống phải chặn không cho khách hàng khác hủy đơn");

        // Đơn hàng vẫn giữ nguyên trạng thái PENDING
        Order dbOrder = orderDAO.findById(order.getId());
        assertEquals("PENDING", dbOrder.getStatus());
    }

    @Test
    @DisplayName("Phase 11 - Cancel Order Rule: Không thể hủy đơn hàng đã CONFIRMED hoặc COMPLETED")
    void testCannotCancelConfirmedOrder() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = products.stream().filter(p -> p.getQuantity() > 5).findFirst().orElse(null);
        assertNotNull(product);

        int customerId = 1;
        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(customerId);

        Customer customer = new Customer();
        customer.setId(customerId);
        customer.setName("Confirm Test Customer");
        customer.setPhone("0903334444");
        customer.setEmail("confirm@test.com");
        customer.setAddress("Confirm Address");

        Cart cart = new Cart();
        cart.addItem(product, 1, "Tiêu chuẩn");

        Order order = orderService.processCheckout(user, customer, cart, "COD");
        assertNotNull(order);

        // Cửa hàng xác nhận đơn hàng (CONFIRMED)
        orderDAO.updateStatus(order.getId(), "CONFIRMED");

        // Khách hàng cố hủy đơn đã CONFIRMED
        String error = orderService.cancelOrderWithStockRestore(order.getId(), customerId, false);
        assertNotNull(error);
        assertTrue(error.contains("PENDING"), "Chỉ được phép hủy đơn hàng khi đang PENDING");

        // Đơn hàng vẫn giữ nguyên trạng thái CONFIRMED
        Order dbOrder = orderDAO.findById(order.getId());
        assertEquals("CONFIRMED", dbOrder.getStatus());
    }
}
