package com.electronicstore.controller.shop;

import com.electronicstore.model.Cart;
import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.model.User;
import com.electronicstore.service.CustomerService;
import com.electronicstore.service.OrderService;
import com.electronicstore.service.VnPayService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * CheckoutServlet – Quản lý quy trình đặt hàng và thanh toán trực tuyến (Phase 10).
 * 
 * GET  /checkout                 → Hiển thị trang thanh toán và thông tin khách hàng
 * GET  /checkout?action=success  → Hiển thị màn hình đặt hàng thành công
 * POST /checkout                 → Xử lý đặt hàng: xác thực giỏ hàng, re-check DB, tạo Order, trừ tồn kho
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/checkout/*"})
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderService orderService;
    private CustomerService customerService;
    private VnPayService vnPayService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
        this.customerService = new CustomerService();
        this.vnPayService = new VnPayService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        String action = request.getParameter("action");
        if ("success".equalsIgnoreCase(action)) {
            showOrderSuccess(request, response, currentUser);
            return;
        }

        // Xử lý thanh toán lại cho đơn hàng VNPAY đang PENDING
        if ("retryVNPay".equalsIgnoreCase(action)) {
            handleRetryVNPay(request, response, currentUser);
            return;
        }

        showCheckoutPage(request, response, session, currentUser);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (session == null || currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            session.setAttribute("flashError", "Giỏ hàng của bạn đang trống. Vui lòng chọn sản phẩm trước khi thanh toán.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Nhận dữ liệu giao hàng từ form
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");

        // Chuẩn hóa phương thức thanh toán: chỉ chấp nhận COD hoặc VNPAY
        String selectedMethod = "VNPAY".equalsIgnoreCase(paymentMethod) ? "VNPAY" : "COD";

        Customer customerInput = new Customer();
        customerInput.setName(name != null ? name.trim() : "");
        customerInput.setPhone(phone != null ? phone.trim() : "");
        customerInput.setEmail(email != null ? email.trim() : "");
        customerInput.setAddress(address != null ? address.trim() : "");

        try {
            // Xử lý đặt hàng an toàn trong Database Transaction:
            // - Re-check sản phẩm, giá DB, tồn kho DB
            // - Tạo Order (với paymentMethod tương ứng)
            // - Trừ tồn kho products
            // - Đồng bộ Customer & User
            Order createdOrder = orderService.processCheckout(currentUser, customerInput, cart, selectedMethod);

            // Đặt hàng thành công trong hệ thống:
            // 1. Làm trống giỏ hàng
            cart.clear();
            session.setAttribute("cartCount", 0);

            // 2. Cập nhật thông tin User trong session nếu có gắn customer_id mới
            session.setAttribute("user", currentUser);

            // 3. Lưu ghi chú (nếu có) vào session tạm thời
            if (note != null && !note.trim().isEmpty()) {
                session.setAttribute("lastOrderNote", note.trim());
            }

            // 4. Phân luồng theo Phương Thức Thanh Toán:
            if ("VNPAY".equalsIgnoreCase(selectedMethod)) {
                // Flow VNPAY: Tạo URL VNPay và chuyển hướng sang cổng thanh toán Sandbox
                String paymentUrl = vnPayService.createPaymentUrl(request, createdOrder);
                response.sendRedirect(paymentUrl);
            } else {
                // Flow COD: Chuyển hướng tới trang đặt hàng thành công
                response.sendRedirect(request.getContextPath() + "/checkout?action=success&orderId=" + createdOrder.getId());
            }

        } catch (Exception e) {
            // Có lỗi (hết hàng, dữ liệu không hợp lệ, lỗi DB) -> Giữ lại dữ liệu và báo lỗi
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("customer", customerInput);
            request.setAttribute("orderNote", note);
            request.setAttribute("selectedPaymentMethod", selectedMethod);
            request.getRequestDispatcher("/WEB-INF/views/shop/checkout.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý thanh toán lại cho đơn hàng VNPAY đang ở trạng thái PENDING.
     * Không tạo đơn mới, không trừ tồn kho lần 2.
     */
    private void handleRetryVNPay(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr.trim());
            Order order;
            if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                order = orderService.findByIdWithDetails(orderId);
            } else if (currentUser.getCustomerId() > 0) {
                order = orderService.findByIdWithDetailsForCustomer(orderId, currentUser.getCustomerId());
            } else {
                order = orderService.findByIdWithDetails(orderId);
            }

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }

            // Chỉ cho phép thanh toán lại nếu đơn hàng đang PENDING và chọn VNPAY
            if (!"PENDING".equalsIgnoreCase(order.getStatus()) || !"VNPAY".equalsIgnoreCase(order.getPaymentMethod())) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            String paymentUrl = vnPayService.createPaymentUrl(request, order);
            response.sendRedirect(paymentUrl);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }

    /**
     * Hiển thị trang thanh toán và chuẩn bị thông tin khách hàng.
     */
    private void showCheckoutPage(HttpServletRequest request, HttpServletResponse response,
                                  HttpSession session, User currentUser)
            throws ServletException, IOException {
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            if (session != null) {
                session.setAttribute("flashError", "Giỏ hàng của bạn đang trống. Vui lòng chọn sản phẩm trước khi thanh toán.");
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Tự động nạp thông tin khách hàng nếu đã có liên kết trong DB
        if (currentUser != null && currentUser.getCustomerId() > 0) {
            Customer existingCustomer = customerService.findById(currentUser.getCustomerId());
            if (existingCustomer != null) {
                request.setAttribute("customer", existingCustomer);
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/shop/checkout.jsp").forward(request, response);
    }

    /**
     * Hiển thị trang cảm ơn / xác nhận đặt hàng thành công.
     */
    private void showOrderSuccess(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shop");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr.trim());
            Order order;

            // Kiểm tra phân quyền truy cập đơn hàng
            if (currentUser != null && "ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                order = orderService.findByIdWithDetails(orderId);
            } else if (currentUser != null && currentUser.getCustomerId() > 0) {
                order = orderService.findByIdWithDetailsForCustomer(orderId, currentUser.getCustomerId());
            } else {
                order = orderService.findByIdWithDetails(orderId);
            }

            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }

            Customer orderCustomer = customerService.findById(order.getCustomerId());
            request.setAttribute("order", order);
            request.setAttribute("customer", orderCustomer);

            request.getRequestDispatcher("/WEB-INF/views/shop/order-success.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shop");
        }
    }
}
