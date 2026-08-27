package com.codegym.controller;

import com.codegym.service.CustomerService;
import com.codegym.service.CustomerServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet điều phối (Front Controller) cho các chức năng quản lý Khách hàng.
 *
 * <p>Ánh xạ URL: {@code /customers}
 *
 * <p>Nhiệm vụ:
 * <ul>
 *   <li>Nhận và xử lý các yêu cầu HTTP GET / POST từ trình duyệt.</li>
 *   <li>Phân tích tham số {@code action} trên URL để điều hướng tới
 *       hành động phù hợp: list, view, create, edit, delete.</li>
 *   <li>Gọi tầng Service ({@link CustomerService}) để thực hiện
 *       các thao tác nghiệp vụ trên dữ liệu.</li>
 *   <li>Chuyển tiếp (forward) kết quả tới các trang JSP tương ứng
 *       trong thư mục {@code /customer/}.</li>
 * </ul>
 *
 * <p>Danh sách hành động dự kiến (qua tham số {@code action}):
 * <ul>
 *   <li>{@code list}   – Hiển thị danh sách tất cả khách hàng.</li>
 *   <li>{@code view}   – Xem chi tiết một khách hàng.</li>
 *   <li>{@code create} – Hiển thị form tạo mới và xử lý lưu dữ liệu.</li>
 *   <li>{@code edit}   – Hiển thị form chỉnh sửa và xử lý cập nhật.</li>
 *   <li>{@code delete} – Hiển thị trang xác nhận và xử lý xoá.</li>
 * </ul>
 */
// Servlet mapping được khai báo trong WEB-INF/web.xml (không dùng @WebServlet để tránh xung đột)
public class CustomerServlet extends HttpServlet {

    /** Tầng dịch vụ xử lý nghiệp vụ quản lý khách hàng. */
    private CustomerService customerService;

    /**
     * Khởi tạo Servlet, tạo instance của {@link CustomerServiceImpl}.
     *
     * @throws ServletException nếu quá trình khởi tạo gặp lỗi
     */
    @Override
    public void init() throws ServletException {
        // TODO: khởi tạo customerService
    }

    /**
     * Xử lý các yêu cầu HTTP GET.
     *
     * <p>Dựa vào tham số {@code action}, servlet sẽ điều hướng tới
     * hành động tương ứng (list, view, showCreate, showEdit, showDelete).
     *
     * @param request  đối tượng {@link HttpServletRequest}
     * @param response đối tượng {@link HttpServletResponse}
     * @throws ServletException nếu xảy ra lỗi servlet
     * @throws IOException      nếu xảy ra lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    /**
     * Xử lý các yêu cầu HTTP POST.
     *
     * <p>Dựa vào tham số {@code action}, servlet sẽ điều hướng tới
     * hành động tương ứng (save, update, delete).
     *
     * @param request  đối tượng {@link HttpServletRequest}
     * @param response đối tượng {@link HttpServletResponse}
     * @throws ServletException nếu xảy ra lỗi servlet
     * @throws IOException      nếu xảy ra lỗi I/O
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }
}
