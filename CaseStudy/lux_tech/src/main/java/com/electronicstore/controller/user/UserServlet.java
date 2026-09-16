package com.electronicstore.controller.user;

import com.electronicstore.model.User;
import com.electronicstore.service.UserService;
import com.electronicstore.util.PageResult;
import com.electronicstore.util.PaginationHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserServlet", urlPatterns = {"/users"})
public class UserServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
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
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createUser(request, response);
        } else if ("edit".equals(action)) {
            updateUser(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

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
        List<User> allUsers = userService.findAll();
        PageResult<User> pageResult = PaginationHelper.paginate(allUsers, page, pageSize);

        request.setAttribute("users", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("paginationUrl", request.getContextPath() + "/users");
        request.getRequestDispatcher("/WEB-INF/views/user/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Thêm Người Dùng Mới");
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/views/user/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User userTarget = userService.findById(id);
            if (userTarget == null) {
                request.getSession().setAttribute("errorMessage", "Người dùng không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/users");
                return;
            }
            request.setAttribute("userTarget", userTarget);
            request.setAttribute("pageTitle", "Chỉnh Sửa Người Dùng");
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/views/user/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        String errorMsg = userService.save(username, password, role);

        if (errorMsg != null) {
            request.setAttribute("errorMessage", errorMsg);
            User userTarget = new User(username, "", role);
            request.setAttribute("userTarget", userTarget);
            request.setAttribute("pageTitle", "Thêm Người Dùng Mới");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/WEB-INF/views/user/form.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("successMessage", "Thêm người dùng '" + username.trim() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            String errorMsg = userService.update(id, username, password, role);

            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                User userTarget = new User(id, username, "", role);
                request.setAttribute("userTarget", userTarget);
                request.setAttribute("pageTitle", "Chỉnh Sửa Người Dùng");
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/WEB-INF/views/user/form.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("successMessage", "Cập nhật thông tin người dùng thành công!");
                response.sendRedirect(request.getContextPath() + "/users");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            int currentUserId = (currentUser != null) ? currentUser.getId() : -1;

            String errorMsg = userService.delete(id, currentUserId);

            if (errorMsg != null) {
                session.setAttribute("errorMessage", errorMsg);
            } else {
                session.setAttribute("successMessage", "Xóa người dùng thành công!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/users");
    }
}
