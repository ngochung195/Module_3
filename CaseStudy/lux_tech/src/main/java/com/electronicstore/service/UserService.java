package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.UserDAO;
import com.electronicstore.model.Customer;
import com.electronicstore.model.User;
import com.electronicstore.util.DBConnection;
import com.electronicstore.util.PasswordUtil;
import com.electronicstore.util.ValidationUtil;

import java.sql.Connection;
import java.sql.SQLException;

public class UserService {
    private final UserDAO userDAO;
    private final CustomerDAO customerDAO;

    public UserService() {
        this.userDAO = new UserDAO();
        this.customerDAO = new CustomerDAO();
    }

    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
        this.customerDAO = new CustomerDAO();
    }

    /**
     * Xác thực người dùng đăng nhập
     * @param username Tên đăng nhập
     * @param password Mật khẩu thô
     * @return User nếu hợp lệ, null nếu sai thông tin
     */
    public User login(String username, String password) {
        if (ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(password)) {
            return null;
        }

        User user = userDAO.findByUsername(username.trim());
        if (user == null) {
            return null;
        }

        // Kiểm tra khớp mật khẩu
        if (PasswordUtil.checkPassword(password.trim(), user.getPassword())) {
            return user;
        }

        return null;
    }

    public User findByUsername(String username) {
        if (ValidationUtil.isEmpty(username)) {
            return null;
        }
        return userDAO.findByUsername(username.trim());
    }

    public User findById(int id) {
        return userDAO.findById(id);
    }

    public User findByCustomerId(int customerId) {
        return userDAO.findByCustomerId(customerId);
    }

    public java.util.List<User> findAll() {
        return userDAO.findAll();
    }

    /**
     * Thêm người dùng mới
     * @param username Tên đăng nhập
     * @param rawPassword Mật khẩu thô
     * @param role Vai trò (ADMIN hoặc STAFF)
     * @return Thông báo lỗi (String) nếu không hợp lệ, null nếu thành công
     */
    public String save(String username, String rawPassword, String role) {
        if (ValidationUtil.isEmpty(username)) {
            return "Tên đăng nhập không được để trống.";
        }
        if (username.trim().length() < 3) {
            return "Tên đăng nhập phải có ít nhất 3 ký tự.";
        }
        if (ValidationUtil.isEmpty(rawPassword)) {
            return "Mật khẩu không được để trống.";
        }
        if (rawPassword.trim().length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự.";
        }
        if (!"ADMIN".equalsIgnoreCase(role) && !"STAFF".equalsIgnoreCase(role) && !"CUSTOMER".equalsIgnoreCase(role)) {
            return "Vai trò không hợp lệ. Phải là ADMIN, STAFF hoặc CUSTOMER.";
        }

        User existingUser = userDAO.findByUsername(username.trim());
        if (existingUser != null) {
            return "Tên đăng nhập '" + username.trim() + "' đã tồn tại.";
        }

        String hashedPassword = PasswordUtil.hashPassword(rawPassword.trim());
        User newUser = new User(username.trim(), hashedPassword, role.toUpperCase());
        boolean success = userDAO.save(newUser);
        return success ? null : "Lỗi hệ thống! Không thể tạo người dùng.";
    }

    /**
     * Cập nhật thông tin người dùng
     * @param id ID người dùng
     * @param username Tên đăng nhập mới
     * @param newPassword Mật khẩu mới (nếu rỗng thì giữ nguyên)
     * @param role Vai trò mới
     * @return Thông báo lỗi (String) nếu không hợp lệ, null nếu thành công
     */
    public String update(int id, String username, String newPassword, String role) {
        User currentUser = userDAO.findById(id);
        if (currentUser == null) {
            return "Người dùng không tồn tại.";
        }

        if (ValidationUtil.isEmpty(username)) {
            return "Tên đăng nhập không được để trống.";
        }
        if (username.trim().length() < 3) {
            return "Tên đăng nhập phải có ít nhất 3 ký tự.";
        }
        if (!"ADMIN".equalsIgnoreCase(role) && !"STAFF".equalsIgnoreCase(role) && !"CUSTOMER".equalsIgnoreCase(role)) {
            return "Vai trò không hợp lệ. Phải là ADMIN, STAFF hoặc CUSTOMER.";
        }

        // Kiểm tra nếu tên đăng nhập thay đổi và bị trùng
        if (!currentUser.getUsername().equalsIgnoreCase(username.trim())) {
            User existingUser = userDAO.findByUsername(username.trim());
            if (existingUser != null) {
                return "Tên đăng nhập '" + username.trim() + "' đã được sử dụng bởi tài khoản khác.";
            }
        }

        // Kiểm tra nếu chuyển vai trò ADMIN sang vai trò khác đối với ADMIN cuối cùng
        if ("ADMIN".equalsIgnoreCase(currentUser.getRole()) && !"ADMIN".equalsIgnoreCase(role)) {
            if (userDAO.countAdminUsers() <= 1) {
                return "Không thể chuyển vai trò ADMIN vì hệ thống phải duy trì ít nhất 1 tài khoản ADMIN.";
            }
        }

        currentUser.setUsername(username.trim());
        currentUser.setRole(role.toUpperCase());

        if (!ValidationUtil.isEmpty(newPassword)) {
            if (newPassword.trim().length() < 6) {
                return "Mật khẩu mới phải có ít nhất 6 ký tự.";
            }
            currentUser.setPassword(PasswordUtil.hashPassword(newPassword.trim()));
        }

        boolean success = userDAO.update(currentUser);
        return success ? null : "Lỗi hệ thống! Không thể cập nhật thông tin người dùng.";
    }

    /**
     * Xóa người dùng kèm theo các quy tắc bảo vệ
     * @param targetUserId ID người dùng cần xóa
     * @param currentUserId ID người dùng đang đăng nhập
     * @return Thông báo lỗi (String) nếu không thể xóa, null nếu thành công
     */
    public String delete(int targetUserId, int currentUserId) {
        if (targetUserId == currentUserId) {
            return "Bạn không thể tự xóa tài khoản đang đăng nhập của chính mình.";
        }

        User targetUser = userDAO.findById(targetUserId);
        if (targetUser == null) {
            return "Người dùng không tồn tại.";
        }

        if ("ADMIN".equalsIgnoreCase(targetUser.getRole())) {
            if (userDAO.countAdminUsers() <= 1) {
                return "Không thể xóa tài khoản ADMIN cuối cùng trong hệ thống.";
            }
        }

        boolean success = userDAO.delete(targetUserId);
        return success ? null : "Lỗi hệ thống! Không thể xóa người dùng.";
    }

    /**
     * Đăng ký tài khoản CUSTOMER mới.
     * Tạo đồng thời một bản ghi Customer và một bản ghi User trong cùng 1 transaction.
     *
     * @return null nếu thành công, chuỗi lỗi nếu thất bại
     */
    public String registerCustomer(String name, String phone, String email,
                                   String address, String username, String rawPassword) {
        // Validate fields
        if (ValidationUtil.isEmpty(name) || name.trim().length() < 2) {
            return "Họ tên phải có ít nhất 2 ký tự.";
        }
        if (ValidationUtil.isEmpty(phone) || !ValidationUtil.isValidPhone(phone.trim())) {
            return "Số điện thoại không đúng định dạng (VD: 0912345678).";
        }
        if (!ValidationUtil.isEmpty(email) && !ValidationUtil.isValidEmail(email.trim())) {
            return "Địa chỉ email không đúng định dạng.";
        }
        if (ValidationUtil.isEmpty(username) || username.trim().length() < 3) {
            return "Tên đăng nhập phải có ít nhất 3 ký tự.";
        }
        if (ValidationUtil.isEmpty(rawPassword) || rawPassword.trim().length() < 6) {
            return "Mật khẩu phải có ít nhất 6 ký tự.";
        }

        // Kiểm tra username đã tồn tại
        if (userDAO.findByUsername(username.trim()) != null) {
            return "Tên đăng nhập '" + username.trim() + "' đã tồn tại. Vui lòng chọn tên khác.";
        }

        // Transaction: tạo Customer + User trong cùng 1 transaction
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Bước 1: Tạo Customer
                Customer customer = new Customer(
                    name.trim(),
                    phone.trim(),
                    ValidationUtil.isEmpty(email) ? null : email.trim(),
                    ValidationUtil.isEmpty(address) ? null : address.trim()
                );
                if (!customerDAO.saveWithConnection(conn, customer)) {
                    conn.rollback();
                    return "Lỗi hệ thống! Không thể tạo thông tin khách hàng.";
                }

                // Bước 2: Tạo User với customer_id vừa tạo
                String hashedPassword = PasswordUtil.hashPassword(rawPassword.trim());
                User user = new User(username.trim(), hashedPassword, "CUSTOMER", customer.getId());
                if (!userDAO.saveCustomerUser(conn, user)) {
                    conn.rollback();
                    return "Lỗi hệ thống! Không thể tạo tài khoản.";
                }

                conn.commit();
                return null; // Thành công

            } catch (SQLException e) {
                conn.rollback();
                System.err.println("Lỗi transaction đăng ký customer: " + e.getMessage());
                e.printStackTrace();
                return "Lỗi hệ thống! Vui lòng thử lại.";
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database khi đăng ký: " + e.getMessage());
            e.printStackTrace();
            return "Lỗi kết nối hệ thống! Vui lòng thử lại.";
        }
    }

    /**
     * Đổi mật khẩu cho người dùng (Phase 12).
     * @param userId ID người dùng
     * @param currentPassword Mật khẩu hiện tại (chưa băm)
     * @param newPassword Mật khẩu mới (chưa băm)
     * @param confirmPassword Mật khẩu xác nhận
     * @return null nếu thành công, chuỗi thông báo lỗi nếu thất bại
     */
    public String changePassword(int userId, String currentPassword, String newPassword, String confirmPassword) {
        if (ValidationUtil.isEmpty(currentPassword)) {
            return "Vui lòng nhập mật khẩu hiện tại.";
        }
        if (ValidationUtil.isEmpty(newPassword) || newPassword.trim().length() < 6) {
            return "Mật khẩu mới phải có ít nhất 6 ký tự.";
        }
        if (!newPassword.equals(confirmPassword)) {
            return "Xác nhận mật khẩu mới không trùng khớp.";
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            return "Tài khoản người dùng không tồn tại.";
        }

        // Kiểm tra mật khẩu hiện tại bằng BCrypt
        if (!PasswordUtil.checkPassword(currentPassword, user.getPassword())) {
            return "Mật khẩu hiện tại không chính xác.";
        }

        // Không cho phép trùng mật khẩu cũ
        if (currentPassword.equals(newPassword)) {
            return "Mật khẩu mới không được trùng với mật khẩu hiện tại.";
        }

        String hashedNewPassword = PasswordUtil.hashPassword(newPassword.trim());
        boolean success = userDAO.updatePassword(userId, hashedNewPassword);
        return success ? null : "Lỗi hệ thống! Không thể cập nhật mật khẩu.";
    }
}
