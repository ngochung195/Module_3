package com.electronicstore.controller.shop;

import com.electronicstore.dao.UserDAO;
import com.electronicstore.model.Customer;
import com.electronicstore.model.Order;
import com.electronicstore.model.User;
import com.electronicstore.service.CustomerService;
import com.electronicstore.service.OrderService;
import com.electronicstore.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ProfileServlet – Quản lý thông tin tài khoản và hồ sơ Khách hàng (Phase 12).
 * 
 * GET  /profile               → Xem hồ sơ, thông tin cá nhân và lịch sử tổng quan
 * POST /profile?action=updateProfile  → Cập nhật thông tin cá nhân (họ tên, SĐT, email, địa chỉ)
 * POST /profile?action=changePassword → Đổi mật khẩu an toàn với BCrypt
 */
@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/profile/*"})
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService;
    private CustomerService customerService;
    private OrderService orderService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
        this.customerService = new CustomerService();
        this.orderService = new OrderService();
        this.userDAO = new UserDAO();
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

        // Đồng bộ dữ liệu người dùng mới nhất từ DB
        User user = userService.findById(currentUser.getId());
        if (user != null) {
            currentUser = user;
            session.setAttribute("user", user);
        }

        Customer customer = null;
        if (currentUser.getCustomerId() > 0) {
            customer = customerService.findById(currentUser.getCustomerId());
        }

        // Thống kê lịch sử đơn hàng của khách hàng
        List<Order> orders = (customer != null) ? orderService.findByCustomerId(customer.getId()) : new ArrayList<>();
        int totalOrders = orders.size();
        int completedOrders = 0;
        int pendingOrders = 0;
        BigDecimal totalSpent = BigDecimal.ZERO;

        for (Order o : orders) {
            String status = (o.getStatus() != null) ? o.getStatus().toUpperCase() : "";
            if ("COMPLETED".equals(status)) {
                completedOrders++;
                if (o.getTotal() != null) {
                    totalSpent = totalSpent.add(o.getTotal());
                }
            } else if ("PAID".equals(status)) {
                if (o.getTotal() != null) {
                    totalSpent = totalSpent.add(o.getTotal());
                }
            } else if ("PENDING".equals(status)) {
                pendingOrders++;
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
            if (session.getAttribute("activeTab") != null) {
                request.setAttribute("activeTab", session.getAttribute("activeTab"));
                session.removeAttribute("activeTab");
            }
        }

        request.setAttribute("user", currentUser);
        request.setAttribute("customer", customer);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalSpent", totalSpent);
        request.setAttribute("recentOrders", orders.stream().limit(5).collect(Collectors.toList()));

        request.getRequestDispatcher("/WEB-INF/views/shop/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("changePassword".equalsIgnoreCase(action)) {
            handleChangePassword(request, response, currentUser, session);
        } else {
            handleUpdateProfile(request, response, currentUser, session);
        }
    }

    /**
     * Cập nhật thông tin hồ sơ cá nhân.
     */
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
                                     User currentUser, HttpSession session) throws IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        Customer customer = null;
        if (currentUser.getCustomerId() > 0) {
            customer = customerService.findById(currentUser.getCustomerId());
        }

        if (customer != null) {
            customer.setName(name);
            customer.setPhone(phone);
            customer.setEmail((email != null && !email.trim().isEmpty()) ? email.trim() : null);
            customer.setAddress((address != null && !address.trim().isEmpty()) ? address.trim() : null);

            String error = customerService.update(customer);
            if (error != null) {
                session.setAttribute("flashError", error);
            } else {
                session.setAttribute("flashSuccess", "Cập nhật thông tin hồ sơ thành công!");
            }
        } else {
            // Trường hợp User chưa liên kết customer_id
            Customer newCust = new Customer(name, phone, email, address);
            String error = customerService.save(newCust);
            if (error != null) {
                session.setAttribute("flashError", error);
            } else {
                try {
                    userDAO.updateCustomerId(null, currentUser.getId(), newCust.getId());
                    currentUser.setCustomerId(newCust.getId());
                    session.setAttribute("user", currentUser);
                    session.setAttribute("flashSuccess", "Khởi tạo và lưu thông tin hồ sơ thành công!");
                } catch (Exception e) {
                    session.setAttribute("flashError", "Lỗi liên kết hồ sơ: " + e.getMessage());
                }
            }
        }

        session.setAttribute("activeTab", "profile");
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    /**
     * Đổi mật khẩu tài khoản người dùng.
     */
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
                                      User currentUser, HttpSession session) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String error = userService.changePassword(currentUser.getId(), currentPassword, newPassword, confirmPassword);
        if (error != null) {
            session.setAttribute("flashError", error);
            session.setAttribute("activeTab", "password");
        } else {
            // Cập nhật lại đối tượng user trong session sau khi đổi mật khẩu
            User updatedUser = userService.findById(currentUser.getId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
            }
            session.setAttribute("flashSuccess", "Đổi mật khẩu thành công! Mật khẩu mới đã được cập nhật an toàn.");
            session.setAttribute("activeTab", "password");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
