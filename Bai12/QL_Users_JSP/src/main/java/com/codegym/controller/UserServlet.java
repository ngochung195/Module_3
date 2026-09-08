package com.codegym.controller;

import com.codegym.dao.UserDAO;
import com.codegym.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller UserServlet thực hiện ánh xạ URL "/users"
 * Tiếp nhận và xử lý các yêu cầu HTTP (GET, POST) từ Client, tương tác với
 * UserDAO
 * và điều hướng dữ liệu đến các trang JSP tương ứng.
 * 
 * NGƯỜI HỌC TỰ THỰC HÀNH:
 * - Khởi tạo đối tượng UserDAO.
 * - Triển khai doGet(): Đọc tham số action (create, edit, delete, ...) để gọi
 * phương thức điều hướng thích hợp.
 * - Triển khai doPost(): Đọc tham số action (create, edit, ...) để xử lý gửi dữ
 * liệu Form.
 * - Định nghĩa các hàm phụ trợ: listUser, showNewForm, showEditForm,
 * insertUser, updateUser, deleteUser.
 */
@WebServlet(name = "UserServlet", urlPatterns = "/users")
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "create":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    showDeleteForm(request, response);
                    break;
                case "search":
                    searchByCountry(request, response);
                    break;
                case "sort":
                    sortByName(request, response);
                    break;
                default:
                    listUser(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        try {
            switch (action) {
                case "create":
                    insertUser(request, response);
                    break;
                case "edit":
                    updateUser(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                case "search":
                    searchByCountry(request, response);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<User> listUser = userDAO.selectAllUsers();
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/create.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        User existingUser = userDAO.getUserById(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/edit.jsp");
        request.setAttribute("user", existingUser);
        dispatcher.forward(request, response);
    }

    private void showDeleteForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.selectUser(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/delete.jsp");
        request.setAttribute("user", user);
        dispatcher.forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String country = request.getParameter("country");
        User newUser = new User(name, email, country);
        userDAO.insertUserStore(newUser);

        RequestDispatcher dispatcher = request.getRequestDispatcher("user/create.jsp");
        request.setAttribute("message", "Đã thêm mới User thành công!");
        dispatcher.forward(request, response);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String country = request.getParameter("country");

        User user = new User(id, name, email, country);
        userDAO.updateUser(user);
        response.sendRedirect("users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id);
        response.sendRedirect("users");
    }

    private void searchByCountry(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String country = request.getParameter("country");
        if (country == null) {
            country = "";
        }
        List<User> listUser = userDAO.selectUsersByCountry(country);
        request.setAttribute("listUser", listUser);
        request.setAttribute("searchCountry", country);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/list.jsp");
        dispatcher.forward(request, response);
    }

    private void sortByName(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> listUser = userDAO.selectAllUsersSortedByName();
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("user/list.jsp");
        dispatcher.forward(request, response);
    }
}