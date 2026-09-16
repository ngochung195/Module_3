package com.electronicstore.filter;

import com.electronicstore.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {
    // Back Office – bảo vệ khỏi CUSTOMER
    "/users/*", "/users",
    "/categories/*", "/categories",
    "/products/*", "/products",
    "/customers/*", "/customers",
    "/orders/*", "/orders",
    "/dashboard/*", "/dashboard",
    // Customer Shop – bảo vệ khỏi ADMIN/STAFF nếu cần
    "/cart", "/cart/*",
    "/checkout", "/checkout/*",
    "/my-orders", "/my-orders/*",
    "/profile", "/profile/*"
})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Nếu chưa đăng nhập, để AuthenticationFilter xử lý
        if (user == null) {
            chain.doFilter(request, response);
            return;
        }

        String role = user.getRole();
        String servletPath = httpRequest.getServletPath();
        String action = httpRequest.getParameter("action");
        if (action == null) {
            action = "";
        }

        boolean isAllowed = true;

        // ============================================================
        // ADMIN – toàn quyền hệ thống
        // ============================================================
        if ("ADMIN".equalsIgnoreCase(role)) {
            isAllowed = true;

        // ============================================================
        // STAFF – nghiệp vụ bán hàng Back Office
        // ============================================================
        } else if ("STAFF".equalsIgnoreCase(role)) {

            // 1. /users: STAFF không có quyền truy cập
            if (servletPath.startsWith("/users")) {
                isAllowed = false;
            }
            // 2. /categories: STAFF chỉ được xem (action rỗng hoặc list)
            else if (servletPath.startsWith("/categories")) {
                if ("create".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)
                        || "delete".equalsIgnoreCase(action)) {
                    isAllowed = false;
                }
            }
            // 3. /products: STAFF chỉ được xem / tìm kiếm
            else if (servletPath.startsWith("/products")) {
                if ("create".equalsIgnoreCase(action) || "edit".equalsIgnoreCase(action)
                        || "delete".equalsIgnoreCase(action)) {
                    isAllowed = false;
                }
            }
            // 4. /customers: STAFF được xem, thêm, sửa nhưng KHÔNG được xóa
            else if (servletPath.startsWith("/customers")) {
                if ("delete".equalsIgnoreCase(action)) {
                    isAllowed = false;
                }
            }
            // STAFF không được truy cập Customer Shop endpoints
            else if (servletPath.startsWith("/cart") || servletPath.startsWith("/checkout")
                    || servletPath.startsWith("/my-orders") || servletPath.startsWith("/profile")) {
                // STAFF không cần dùng shop – redirect về dashboard
                isAllowed = false;
            }

        // ============================================================
        // CUSTOMER – chỉ được dùng Online Shop
        // ============================================================
        } else if ("CUSTOMER".equalsIgnoreCase(role)) {

            // Back Office paths – CUSTOMER không được truy cập
            if (servletPath.startsWith("/dashboard")
                    || servletPath.startsWith("/users")
                    || servletPath.startsWith("/categories")
                    || servletPath.startsWith("/orders")) {
                isAllowed = false;
            }
            // /products và /customers – CUSTOMER chỉ được xem danh sách, không được CRUD
            else if (servletPath.startsWith("/products")) {
                // Chỉ cho xem list (action rỗng hoặc detail qua shop)
                // Nhưng đây là back-office /products – block toàn bộ cho CUSTOMER
                isAllowed = false;
            }
            else if (servletPath.startsWith("/customers")) {
                // Back-office customer management – block
                isAllowed = false;
            }
            // Customer Shop endpoints – CUSTOMER được phép
            else if (servletPath.startsWith("/cart")
                    || servletPath.startsWith("/checkout")
                    || servletPath.startsWith("/my-orders")
                    || servletPath.startsWith("/profile")) {
                isAllowed = true;
            }
            else {
                // Các path khác không xác định
                isAllowed = false;
            }

        } else {
            // Role không xác định → Từ chối
            isAllowed = false;
        }

        if (!isAllowed) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp")
                       .forward(httpRequest, httpResponse);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
