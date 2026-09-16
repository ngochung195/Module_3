package com.electronicstore.controller;

import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.service.CustomerService;
import com.electronicstore.service.OrderService;
import com.electronicstore.util.PageResult;
import com.electronicstore.util.PaginationHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * OrderServlet – Quản lý đơn hàng Back-Office dành cho ADMIN & STAFF.
 * 
 * GET  /orders                      → Danh sách tất cả đơn hàng (tìm kiếm theo tên khách hàng & lọc trạng thái)
 * GET  /orders?action=detail&id=    → Chi tiết đơn hàng
 * POST /orders?action=updateStatus  → Cập nhật trạng thái đơn hàng (CONFIRMED, COMPLETED, CANCELLED)
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/orders", "/orders/*"})
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderService orderService;
    private CustomerService customerService;
    private com.electronicstore.service.ProductService productService;

    @Override
    public void init() throws ServletException {
        this.orderService = new OrderService();
        this.customerService = new CustomerService();
        this.productService = new com.electronicstore.service.ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "detail":
                showOrderDetail(request, response);
                break;
            case "list":
            default:
                showOrderList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equalsIgnoreCase(action)) {
            handleUpdateStatus(request, response);
        } else if ("create".equalsIgnoreCase(action)) {
            handleCreateOrder(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    /**
     * Hiển thị danh sách đơn hàng cho Admin & Staff.
     */
    private void showOrderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String source = request.getParameter("source");

        int page = PaginationHelper.parsePage(request.getParameter("page"));
        int pageSize = 10;
        List<Order> allOrders = orderService.search(keyword, status, source);
        PageResult<Order> pageResult = PaginationHelper.paginate(allOrders, page, pageSize);

        StringBuilder paginationUrl = new StringBuilder(request.getContextPath() + "/orders?action=list");
        if (keyword != null && !keyword.trim().isEmpty()) {
            paginationUrl.append("&keyword=").append(URLEncoder.encode(keyword.trim(), StandardCharsets.UTF_8));
        }
        if (status != null && !status.trim().isEmpty()) {
            paginationUrl.append("&status=").append(URLEncoder.encode(status.trim(), StandardCharsets.UTF_8));
        }
        if (source != null && !source.trim().isEmpty()) {
            paginationUrl.append("&source=").append(URLEncoder.encode(source.trim(), StandardCharsets.UTF_8));
        }

        request.setAttribute("orders", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("source", source);
        request.setAttribute("paginationUrl", paginationUrl.toString());

        HttpSession session = request.getSession(false);
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

        request.setAttribute("activePage", "orders");
        request.getRequestDispatcher("/WEB-INF/views/order/list.jsp").forward(request, response);
    }

    /**
     * Xem chi tiết đơn hàng Back-Office.
     */
    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr.trim());
            Order order = orderService.findByIdWithDetails(orderId);
            if (order == null) {
                request.getSession().setAttribute("flashError", "Không tìm thấy đơn hàng ID " + orderId);
                response.sendRedirect(request.getContextPath() + "/orders");
                return;
            }

            Customer customer = customerService.findById(order.getCustomerId());
            request.setAttribute("order", order);
            request.setAttribute("customer", customer);
            request.setAttribute("activePage", "orders");

            HttpSession session = request.getSession(false);
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

            request.getRequestDispatcher("/WEB-INF/views/order/detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    /**
     * Cập nhật trạng thái đơn hàng (ADMIN/STAFF).
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String newStatus = request.getParameter("newStatus");
        HttpSession session = request.getSession();

        if (idStr == null || newStatus == null || newStatus.trim().isEmpty()) {
            session.setAttribute("flashError", "Dữ liệu cập nhật trạng thái không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(idStr.trim());
            newStatus = newStatus.trim().toUpperCase();

            String error;
            // Nếu chuyển trạng thái sang CANCELLED: Gọi hủy đơn kèm hoàn trả tồn kho tự động
            if ("CANCELLED".equalsIgnoreCase(newStatus)) {
                error = orderService.cancelOrderWithStockRestore(orderId, 0, true);
                if (error == null) {
                    session.setAttribute("flashSuccess", 
                            "Đã hủy đơn hàng #ORD-" + orderId + " và tự động hoàn trả số lượng sản phẩm về kho thành công.");
                } else {
                    session.setAttribute("flashError", error);
                }
            } else {
                error = orderService.updateStatus(orderId, newStatus);
                if (error == null) {
                    session.setAttribute("flashSuccess", 
                            "Cập nhật trạng thái đơn hàng #ORD-" + orderId + " thành " + newStatus + " thành công.");
                } else {
                    session.setAttribute("flashError", error);
                }
            }

            response.sendRedirect(request.getContextPath() + "/orders?action=detail&id=" + orderId);

        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Mã đơn hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/orders");
        }
    }

    /**
     * Hiển thị giao diện tạo đơn hàng tại quầy (STAFF/ADMIN).
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("customers", customerService.findAll());
        request.setAttribute("products", productService.findAll());
        request.setAttribute("activePage", "orders");

        HttpSession session = request.getSession(false);
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

        request.getRequestDispatcher("/WEB-INF/views/order/form.jsp").forward(request, response);
    }

    /**
     * Xử lý tạo đơn hàng tại quầy (STAFF/ADMIN).
     */
    private void handleCreateOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        String customerIdStr = request.getParameter("customerId");
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String paymentMethod = request.getParameter("paymentMethod");

        try {
            int customerId = Integer.parseInt(customerIdStr);
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            Order created = orderService.createStaffOrder(customerId, productId, quantity, paymentMethod);
            session.setAttribute("flashSuccess", "Tạo đơn hàng tại quầy thành công (#ORD-" + created.getId() + ")!");
            response.sendRedirect(request.getContextPath() + "/orders?action=detail&id=" + created.getId());
        } catch (Exception e) {
            session.setAttribute("flashError", "Lỗi tạo đơn hàng: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/orders?action=create");
        }
    }
}
