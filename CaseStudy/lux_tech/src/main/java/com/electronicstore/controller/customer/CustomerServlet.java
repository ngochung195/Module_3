package com.electronicstore.controller.customer;

import com.electronicstore.model.Customer;
import com.electronicstore.service.CustomerService;
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

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers"})
public class CustomerServlet extends HttpServlet {
    private CustomerService customerService;

    @Override
    public void init() throws ServletException {
        this.customerService = new CustomerService();
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
                if (!isAdmin(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                showCreateForm(request, response);
                break;
            case "edit":
                if (!isAdmin(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                showEditForm(request, response);
                break;
            case "delete":
                if (!isAdmin(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                deleteCustomer(request, response);
                break;
            case "search":
                searchCustomers(request, response);
                break;
            default:
                listCustomers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createCustomer(request, response);
        } else if ("edit".equals(action)) {
            updateCustomer(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/customers");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String role = (String) session.getAttribute("role");
        return "ADMIN".equalsIgnoreCase(role);
    }

    // ==================== LIST ====================
    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Flash messages
        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }
        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }

        int page = PaginationHelper.parsePage(request.getParameter("page"));
        int pageSize = 10;
        List<Customer> allCustomers = customerService.findAll();
        PageResult<Customer> pageResult = PaginationHelper.paginate(allCustomers, page, pageSize);

        request.setAttribute("customers", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("paginationUrl", request.getContextPath() + "/customers");
        request.getRequestDispatcher("/WEB-INF/views/customer/list.jsp").forward(request, response);
    }

    // ==================== SEARCH ====================
    private void searchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        int page = PaginationHelper.parsePage(request.getParameter("page"));
        int pageSize = 10;
        List<Customer> allCustomers = customerService.search(keyword);
        PageResult<Customer> pageResult = PaginationHelper.paginate(allCustomers, page, pageSize);

        StringBuilder paginationUrl = new StringBuilder(request.getContextPath() + "/customers?action=search");
        if (keyword != null && !keyword.trim().isEmpty()) {
            paginationUrl.append("&keyword=").append(URLEncoder.encode(keyword.trim(), StandardCharsets.UTF_8));
        }

        request.setAttribute("customers", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("keyword", keyword);
        request.setAttribute("paginationUrl", paginationUrl.toString());
        request.getRequestDispatcher("/WEB-INF/views/customer/list.jsp").forward(request, response);
    }

    // ==================== SHOW CREATE FORM ====================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Thêm Khách Hàng Mới");
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/views/customer/form.jsp").forward(request, response);
    }

    // ==================== SHOW EDIT FORM ====================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer customer = customerService.findById(id);
            if (customer == null) {
                request.getSession().setAttribute("errorMessage", "Khách hàng không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/customers");
                return;
            }
            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Chỉnh Sửa Khách Hàng");
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/views/customer/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/customers");
        }
    }

    // ==================== CREATE ====================
    private void createCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");

        Customer customer = new Customer(name, phone, email, address);
        String errorMsg = customerService.save(customer);

        if (errorMsg != null) {
            request.setAttribute("errorMessage", errorMsg);
            request.setAttribute("customer", customer);
            request.setAttribute("pageTitle", "Thêm Khách Hàng Mới");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/WEB-INF/views/customer/form.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("successMessage",
                    "Thêm khách hàng '" + name.trim() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/customers");
        }
    }

    // ==================== UPDATE ====================
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            Customer customer = new Customer(id, name, phone, email, address);
            String errorMsg = customerService.update(customer);

            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                request.setAttribute("customer", customer);
                request.setAttribute("pageTitle", "Chỉnh Sửa Khách Hàng");
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/WEB-INF/views/customer/form.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("successMessage", "Cập nhật khách hàng thành công!");
                response.sendRedirect(request.getContextPath() + "/customers");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID hoặc thông tin nhập vào không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/customers");
        }
    }

    // ==================== DELETE ====================
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String errorMsg = customerService.delete(id);
            if (errorMsg != null) {
                request.getSession().setAttribute("errorMessage", errorMsg);
            } else {
                request.getSession().setAttribute("successMessage", "Xóa khách hàng thành công!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID khách hàng không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/customers");
    }
}
