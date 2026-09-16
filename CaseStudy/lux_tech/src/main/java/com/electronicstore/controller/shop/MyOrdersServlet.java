package com.electronicstore.controller.shop;

import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.model.User;
import com.electronicstore.service.CustomerService;
import com.electronicstore.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * MyOrdersServlet – Quản lý đơn hàng cá nhân của Khách hàng (Phase 11).
 * 
 * GET  /my-orders                  → Danh sách đơn hàng của khách hàng (kèm bộ lọc trạng thái)
 * GET  /my-orders?action=detail&id= → Xem chi tiết đơn hàng (kiểm tra chặt chẽ Order Ownership)
 * POST /my-orders?action=cancel    → Hủy đơn hàng PENDING & hoàn trả tồn kho sản phẩm (Transaction)
 */
@WebServlet(name = "MyOrdersServlet", urlPatterns = {"/my-orders", "/my-orders/*"})
public class MyOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderService orderService;
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
        this.customerService = new CustomerService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showOrderDetail(request, response, currentUser);
                break;
            case "list":
            default:
                showOrderList(request, response, currentUser, session);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("cancel".equalsIgnoreCase(action)) {
            handleCancelOrder(request, response, currentUser, session);
        } else {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    /**
     * Hiển thị danh sách đơn hàng của khách hàng kèm bộ lọc trạng thái.
     */
    private void showOrderList(HttpServletRequest request, HttpServletResponse response,
                               User currentUser, HttpSession session)
            throws ServletException, IOException {
        int customerId = currentUser.getCustomerId();
        List<Order> allOrders = (customerId > 0) ? orderService.findByCustomerId(customerId) : new ArrayList<>();

        // Thống kê số lượng đơn theo từng trạng thái
        int countAll = allOrders.size();
        int countPending = 0;
        int countConfirmed = 0;
        int countCompleted = 0;
        int countCancelled = 0;

        for (Order o : allOrders) {
            String s = (o.getStatus() != null) ? o.getStatus().toUpperCase() : "";
            switch (s) {
                case "PENDING": countPending++; break;
                case "CONFIRMED": countConfirmed++; break;
                case "COMPLETED": countCompleted++; break;
                case "CANCELLED": countCancelled++; break;
            }
        }

        // Lọc theo trạng thái tab được chọn
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "ALL";
        } else {
            statusFilter = statusFilter.trim().toUpperCase();
        }

        List<Order> displayOrders = new ArrayList<>();
        if ("ALL".equals(statusFilter)) {
            displayOrders = allOrders;
        } else {
            for (Order o : allOrders) {
                if (statusFilter.equalsIgnoreCase(o.getStatus())) {
                    displayOrders.add(o);
                }
            }
        }

        // Chuyển Flash Messages từ Session sang Request
        if (session != null) {
            if (session.getAttribute("flashSuccess") != null) {
                request.setAttribute("flashSuccess", session.getAttribute("flashSuccess"));
                session.removeAttribute("flashSuccess");
            }
            if (session.getAttribute("flashError") != null) {
                request.setAttribute("flashError", session.getAttribute("flashError"));
                session.removeAttribute("flashError");
            }
        }

        request.setAttribute("orders", displayOrders);
        request.setAttribute("selectedStatus", statusFilter);
        request.setAttribute("countAll", countAll);
        request.setAttribute("countPending", countPending);
        request.setAttribute("countConfirmed", countConfirmed);
        request.setAttribute("countCompleted", countCompleted);
        request.setAttribute("countCancelled", countCancelled);
        request.setAttribute("activePage", "my-orders");

        request.getRequestDispatcher("/WEB-INF/views/shop/my-orders.jsp").forward(request, response);
    }

    /**
     * Hiển thị chi tiết đơn hàng (Kiểm tra nghiêm ngặt quyền sở hữu Order Ownership).
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr.trim());
            int customerId = currentUser.getCustomerId();

            // Gọi phương thức findByIdWithDetailsForCustomer: Chỉ trả về đơn hàng nếu order.customerId == customerId
            Order order;
            if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                order = orderService.findByIdWithDetails(orderId);
            } else {
                order = orderService.findByIdWithDetailsForCustomer(orderId, customerId);
            }

            // Nếu không tìm thấy hoặc bị từ chối quyền sở hữu
            if (order == null) {
                request.getSession().setAttribute("flashError", 
                        "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập đơn hàng này.");
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            Customer customer = customerService.findById(order.getCustomerId());
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("activePage", "my-orders");

            request.getRequestDispatcher("/WEB-INF/views/shop/my-order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }

    /**
     * Hủy đơn hàng và hoàn trả tồn kho sản phẩm trong Transaction.
     */
    private void handleCancelOrder(HttpServletRequest request, HttpServletResponse response,
                                  User currentUser, HttpSession session)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr.trim());
            boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());

            String error = orderService.cancelOrderWithStockRestore(orderId, currentUser.getCustomerId(), isAdmin);
            if (error == null) {
                session.setAttribute("flashSuccess", 
                        "Hủy đơn hàng #ORD-" + orderId + " thành công! Số lượng sản phẩm đã được tự động hoàn trả về kho hàng.");
            } else {
                session.setAttribute("flashError", error);
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Mã đơn hàng không hợp lệ.");
        }

        response.sendRedirect(request.getContextPath() + "/my-orders");
    }
}
