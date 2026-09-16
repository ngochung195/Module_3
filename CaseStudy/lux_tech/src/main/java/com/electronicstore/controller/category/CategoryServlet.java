package com.electronicstore.controller.category;

import com.electronicstore.model.Category;
import com.electronicstore.service.CategoryService;
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

@WebServlet(name = "CategoryServlet", urlPatterns = {"/categories"})
public class CategoryServlet extends HttpServlet {
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        this.categoryService = new CategoryService();
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
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String role = (String) session.getAttribute("role");
        return "ADMIN".equalsIgnoreCase(role);
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
            createCategory(request, response);
        } else if ("edit".equals(action)) {
            updateCategory(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Nhận flash message từ Session
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
        List<Category> allCategories = categoryService.findAll();
        PageResult<Category> pageResult = PaginationHelper.paginate(allCategories, page, pageSize);

        request.setAttribute("categories", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("paginationUrl", request.getContextPath() + "/categories");
        request.getRequestDispatcher("/WEB-INF/views/category/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Thêm Danh Mục Mới");
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/views/category/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = categoryService.findById(id);
            if (category == null) {
                request.getSession().setAttribute("errorMessage", "Danh mục không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/categories");
                return;
            }
            request.setAttribute("category", category);
            request.setAttribute("pageTitle", "Chỉnh Sửa Danh Mục");
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/views/category/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID danh mục không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    private void createCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        Category category = new Category(name);

        String errorMsg = categoryService.save(category);
        if (errorMsg != null) {
            request.setAttribute("errorMessage", errorMsg);
            request.setAttribute("category", category);
            request.setAttribute("pageTitle", "Thêm Danh Mục Mới");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/WEB-INF/views/category/form.jsp").forward(request, response);
        } else {
            // POST / Redirect / GET
            request.getSession().setAttribute("successMessage", "Thêm danh mục '" + name.trim() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            Category category = new Category(id, name);

            String errorMsg = categoryService.update(category);
            if (errorMsg != null) {
                request.setAttribute("errorMessage", errorMsg);
                request.setAttribute("category", category);
                request.setAttribute("pageTitle", "Chỉnh Sửa Danh Mục");
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/WEB-INF/views/category/form.jsp").forward(request, response);
            } else {
                // POST / Redirect / GET
                request.getSession().setAttribute("successMessage", "Cập nhật danh mục thành công!");
                response.sendRedirect(request.getContextPath() + "/categories");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID danh mục không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String errorMsg = categoryService.delete(id);
            if (errorMsg != null) {
                request.getSession().setAttribute("errorMessage", errorMsg);
            } else {
                request.getSession().setAttribute("successMessage", "Xóa danh mục thành công!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID danh mục không hợp lệ.");
        }
        response.sendRedirect(request.getContextPath() + "/categories");
    }
}
