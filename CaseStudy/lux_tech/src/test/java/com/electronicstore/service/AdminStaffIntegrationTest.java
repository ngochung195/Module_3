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

/**
 * Integration Test cho Phase 13: Admin/Staff Integration
 * - Online Order appears in Back Office
 * - Manage online orders (Status updates, Cancel with stock restore)
 * - Source ONLINE / STAFF classification & filtering
 * - Staff in-store order creation
 * - Dashboard statistics updates
 */
public class AdminStaffIntegrationTest {

    private OrderService orderService;
    private DashboardService dashboardService;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;
    private CustomerDAO customerDAO;

    @BeforeEach
    void setUp() {
        orderService = new OrderService();
        dashboardService = new DashboardService();
        orderDAO = new OrderDAO();
        productDAO = new ProductDAO();
        customerDAO = new CustomerDAO();
    }

    @Test
    @DisplayName("Phase 13 - Online Order Creation sets source = 'ONLINE' and appears in Back Office")
    void testOnlineOrderAppearsInBackOffice() throws Exception {
        // Find product with sufficient stock
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                product = p;
                break;
            }
        }
        assertNotNull(product, "Phải có ít nhất một sản phẩm còn đủ tồn kho");

        Customer customerInput = new Customer();
        customerInput.setName("Khách Hàng Test Online");
        customerInput.setPhone("0988776655");
        customerInput.setEmail("online.test@example.com");
        customerInput.setAddress("456 Đường Test Online, TP.HCM");

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Cart cart = new Cart();
        cart.addItem(product, 1, "Titan Tự Nhiên");

        Order onlineOrder = orderService.processCheckout(user, customerInput, cart, "COD");
        assertNotNull(onlineOrder, "Đơn hàng online phải được tạo thành công");
        assertEquals("ONLINE", onlineOrder.getSource(), "Đơn hàng online phải có source là ONLINE");
        assertEquals("PENDING", onlineOrder.getStatus(), "Đơn hàng COD online mới tạo phải ở trạng thái PENDING");

        // Verify it appears in back office search
        List<Order> foundOrders = orderService.search("Khách Hàng Test Online", "PENDING", "ONLINE");
        assertFalse(foundOrders.isEmpty(), "Đơn hàng online phải xuất hiện trong tìm kiếm Back Office");
        boolean containsCreatedOrder = foundOrders.stream().anyMatch(o -> o.getId() == onlineOrder.getId());
        assertTrue(containsCreatedOrder, "Đơn hàng online mới tạo phải nằm trong danh sách");
    }

    @Test
    @DisplayName("Phase 13 - Staff in-store order creation sets source = 'STAFF' and deducts stock")
    void testStaffInStoreOrderCreation() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 5) {
                product = p;
                break;
            }
        }
        assertNotNull(product, "Phải có ít nhất một sản phẩm còn hàng");

        List<Customer> customers = customerDAO.findAll();
        assertFalse(customers.isEmpty(), "Phải có ít nhất một khách hàng trong hệ thống");
        Customer customer = customers.get(0);

        int initialStock = productDAO.findById(product.getId()).getQuantity();
        int buyQty = 2;

        Order staffOrder = orderService.createStaffOrder(customer.getId(), product.getId(), buyQty, "COD");
        assertNotNull(staffOrder);
        assertTrue(staffOrder.getId() > 0);
        assertEquals("STAFF", staffOrder.getSource(), "Đơn hàng tại quầy phải có source = 'STAFF'");
        assertEquals("COMPLETED", staffOrder.getStatus());
        assertEquals("PAID", staffOrder.getPaymentStatus());

        // Verify stock deducted
        int afterStock = productDAO.findById(product.getId()).getQuantity();
        assertEquals(initialStock - buyQty, afterStock, "Tồn kho phải được trừ chính xác sau khi Staff tạo đơn");

        // Verify order details
        Order orderWithDetails = orderService.findByIdWithDetails(staffOrder.getId());
        assertNotNull(orderWithDetails);
        assertNotNull(orderWithDetails.getOrderDetails());
        assertEquals(1, orderWithDetails.getOrderDetails().size());
        assertEquals(product.getId(), orderWithDetails.getOrderDetails().get(0).getProductId());
        assertEquals(buyQty, orderWithDetails.getOrderDetails().get(0).getQuantity());
    }

    @Test
    @DisplayName("Phase 13 - Back Office search & filtering by source (ONLINE vs STAFF)")
    void testSearchAndFilterBySource() throws Exception {
        // Query ONLINE orders
        List<Order> onlineOrders = orderService.search(null, null, "ONLINE");
        assertNotNull(onlineOrders);
        for (Order o : onlineOrders) {
            assertTrue(o.getSource() == null || "ONLINE".equalsIgnoreCase(o.getSource()),
                    "Tất cả đơn hàng phải là ONLINE khi lọc theo source ONLINE");
        }

        // Query STAFF orders
        List<Order> staffOrders = orderService.search(null, null, "STAFF");
        assertNotNull(staffOrders);
        for (Order o : staffOrders) {
            assertEquals("STAFF", o.getSource(), "Tất cả đơn hàng phải là STAFF khi lọc theo source STAFF");
        }
    }

    @Test
    @DisplayName("Phase 13 - Dashboard metrics reflect Pending Orders, Online Orders and Online Revenue")
    void testDashboardMetrics() {
        int pendingOrders = dashboardService.getPendingOrders();
        assertTrue(pendingOrders >= 0, "Số lượng đơn hàng PENDING không được âm");

        int onlineOrders = dashboardService.getOnlineOrders();
        assertTrue(onlineOrders >= 0, "Số lượng đơn hàng ONLINE không được âm");

        int staffOrders = dashboardService.getStaffOrders();
        assertTrue(staffOrders >= 0, "Số lượng đơn hàng STAFF không được âm");

        BigDecimal onlineRevenue = dashboardService.getOnlineRevenue();
        assertNotNull(onlineRevenue, "Doanh thu online không được null");
        assertTrue(onlineRevenue.compareTo(BigDecimal.ZERO) >= 0, "Doanh thu online không được âm");

        BigDecimal totalRevenue = dashboardService.getTotalRevenue();
        assertNotNull(totalRevenue, "Tổng doanh thu không được null");
        assertTrue(totalRevenue.compareTo(BigDecimal.ZERO) >= 0, "Tổng doanh thu không được âm");
    }

    @Test
    @DisplayName("Phase 13 - Back Office Order Management: Confirm & Cancel with Stock Restore")
    void testBackOfficeOrderStatusManagement() throws Exception {
        List<Product> products = productDAO.findAll();
        Product product = null;
        for (Product p : products) {
            if (p.getQuantity() > 10) {
                product = p;
                break;
            }
        }
        assertNotNull(product);

        Customer customerInput = new Customer();
        customerInput.setName("Khách Hàng Test Quản Lý Đơn");
        customerInput.setPhone("0977665544");
        customerInput.setAddress("789 Phố Quản Lý, Hà Nội");

        User user = new User();
        user.setId(1);
        user.setRole("CUSTOMER");
        user.setCustomerId(1);

        Cart cart = new Cart();
        cart.addItem(product, 3, "Titan Tự Nhiên");

        int stockBeforeOrder = productDAO.findById(product.getId()).getQuantity();
        Order order = orderService.processCheckout(user, customerInput, cart, "COD");
        int stockAfterOrder = productDAO.findById(product.getId()).getQuantity();
        assertEquals(stockBeforeOrder - 3, stockAfterOrder, "Tồn kho phải trừ 3");

        // 1. Admin confirms order
        String updateErr = orderService.updateStatus(order.getId(), "CONFIRMED");
        assertNull(updateErr, "Admin cập nhật CONFIRMED phải thành công");
        Order confirmedOrder = orderService.findByIdWithDetails(order.getId());
        assertEquals("CONFIRMED", confirmedOrder.getStatus());

        // 2. Admin cancels order -> stock restored
        String cancelErr = orderService.cancelOrderWithStockRestore(order.getId(), 0, true);
        assertNull(cancelErr, "Admin hủy đơn kèm hoàn kho phải thành công");

        Order cancelledOrder = orderService.findByIdWithDetails(order.getId());
        assertEquals("CANCELLED", cancelledOrder.getStatus());

        int stockAfterCancel = productDAO.findById(product.getId()).getQuantity();
        assertEquals(stockBeforeOrder, stockAfterCancel, "Tồn kho phải được phục hồi nguyên vẹn khi hủy đơn");
    }
}
