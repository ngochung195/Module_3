package com.electronicstore.service;

import com.electronicstore.dao.CustomerDAO;
import com.electronicstore.dao.UserDAO;
import com.electronicstore.model.Customer;
import com.electronicstore.model.User;
import com.electronicstore.util.PasswordUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit & Integration Test cho Phase 12: Customer Profile + Register
 * - Customer registration
 * - User + Customer creation in Transaction
 * - Profile retrieval
 * - Update profile
 * - Password handling (BCrypt verification & update)
 */
public class CustomerProfileAndRegisterTest {

    private UserService userService;
    private CustomerService customerService;
    private UserDAO userDAO;
    private CustomerDAO customerDAO;

    @BeforeEach
    void setUp() {
        this.userService = new UserService();
        this.customerService = new CustomerService();
        this.userDAO = new UserDAO();
        this.customerDAO = new CustomerDAO();
    }

    @Test
    @DisplayName("Phase 12 - Register & Transaction: Tạo đồng thời Customer + User trong 1 Transaction, hash mật khẩu BCrypt")
    void testCustomerRegistrationAndCreation() {
        long ts = System.currentTimeMillis();
        String username = "cust_" + ts;
        String password = "Password@123";
        String name = "Customer Test " + ts;
        String phone = String.format("098%07d", Math.abs(ts % 10000000));
        String email = "cust" + ts + "@example.com";
        String address = "123 Đường Test, Quận 1, TP.HCM";

        // 1. Thực hiện đăng ký
        String error = userService.registerCustomer(name, phone, email, address, username, password);
        assertNull(error, "Đăng ký tài khoản customer phải thành công, không có lỗi");

        // 2. Kiểm tra User được tạo
        User createdUser = userDAO.findByUsername(username);
        assertNotNull(createdUser, "User phải tồn tại trong CSDL");
        assertEquals("CUSTOMER", createdUser.getRole(), "Role phải là CUSTOMER");
        assertTrue(createdUser.getCustomerId() > 0, "User phải được liên kết với customer_id");
        assertTrue(PasswordUtil.checkPassword(password, createdUser.getPassword()), "Mật khẩu phải được hash BCrypt hợp lệ");

        // 3. Kiểm tra Customer được tạo
        Customer createdCustomer = customerDAO.findById(createdUser.getCustomerId());
        assertNotNull(createdCustomer, "Customer phải tồn tại trong CSDL");
        assertEquals(name, createdCustomer.getName());
        assertEquals(phone, createdCustomer.getPhone());
        assertEquals(email, createdCustomer.getEmail());
        assertEquals(address, createdCustomer.getAddress());

        // 4. Kiểm tra chống trùng tên đăng nhập
        String duplicateError = userService.registerCustomer("Khác", "0912345678", "other@email.com", "Địa chỉ", username, "123456");
        assertNotNull(duplicateError, "Không được phép đăng ký trùng username");
        assertTrue(duplicateError.contains("đã tồn tại"));

        // Dọn dẹp
        userDAO.delete(createdUser.getId());
        customerDAO.delete(createdCustomer.getId());
    }

    @Test
    @DisplayName("Phase 12 - Update Profile: Cập nhật thông tin hồ sơ cá nhân của khách hàng")
    void testUpdateCustomerProfile() {
        long ts = System.currentTimeMillis();
        String username = "upd_" + ts;
        String phone = String.format("097%07d", Math.abs(ts % 10000000));

        userService.registerCustomer("Ban Dau", phone, "bandau@test.com", "Dia Chi Cu", username, "123456");
        User user = userDAO.findByUsername(username);
        assertNotNull(user);

        Customer customer = customerDAO.findById(user.getCustomerId());
        assertNotNull(customer);

        // Cập nhật thông tin mới
        String updatedName = "Nguyen Van Cap Nhat";
        String updatedPhone = String.format("096%07d", Math.abs(ts % 10000000));
        String updatedEmail = "capnhat" + ts + "@test.com";
        String updatedAddress = "456 Đường Mới, Hà Nội";

        customer.setName(updatedName);
        customer.setPhone(updatedPhone);
        customer.setEmail(updatedEmail);
        customer.setAddress(updatedAddress);

        String updateError = customerService.update(customer);
        assertNull(updateError, "Cập nhật hồ sơ phải thành công");

        // Kiểm tra lại từ DB
        Customer dbCustomer = customerDAO.findById(customer.getId());
        assertEquals(updatedName, dbCustomer.getName());
        assertEquals(updatedPhone, dbCustomer.getPhone());
        assertEquals(updatedEmail, dbCustomer.getEmail());
        assertEquals(updatedAddress, dbCustomer.getAddress());

        // Dọn dẹp
        userDAO.delete(user.getId());
        customerDAO.delete(customer.getId());
    }

    @Test
    @DisplayName("Phase 12 - Password Handling: Đổi mật khẩu an toàn, xác thực mật khẩu cũ và đăng nhập lại bằng mật khẩu mới")
    void testPasswordHandlingAndChange() {
        long ts = System.currentTimeMillis();
        String username = "pwd_" + ts;
        String oldPassword = "OldPassword123";
        String newPassword = "NewPassword456";

        userService.registerCustomer("Test Pwd", String.format("095%07d", Math.abs(ts % 10000000)), "pwd@test.com", "Dia Chi", username, oldPassword);
        User user = userDAO.findByUsername(username);
        assertNotNull(user);

        // 1. Thử đổi mật khẩu với mật khẩu hiện tại sai -> Bị từ chối
        String wrongCurrentErr = userService.changePassword(user.getId(), "WrongOldPass", newPassword, newPassword);
        assertNotNull(wrongCurrentErr);
        assertTrue(wrongCurrentErr.contains("không chính xác"));

        // 2. Thử đổi mật khẩu mới không khớp xác nhận -> Bị từ chối
        String mismatchErr = userService.changePassword(user.getId(), oldPassword, newPassword, "DifferentPassword");
        assertNotNull(mismatchErr);
        assertTrue(mismatchErr.contains("không trùng khớp"));

        // 3. Thử đổi mật khẩu mới trùng mật khẩu cũ -> Bị từ chối
        String samePassErr = userService.changePassword(user.getId(), oldPassword, oldPassword, oldPassword);
        assertNotNull(samePassErr);
        assertTrue(samePassErr.contains("không được trùng"));

        // 4. Đổi mật khẩu hợp lệ -> Thành công
        String success = userService.changePassword(user.getId(), oldPassword, newPassword, newPassword);
        assertNull(success, "Đổi mật khẩu hợp lệ phải thành công");

        // 5. Thử đăng nhập lại bằng mật khẩu cũ -> Thất bại
        User failedLogin = userService.login(username, oldPassword);
        assertNull(failedLogin, "Không thể đăng nhập bằng mật khẩu cũ");

        // 6. Đăng nhập lại bằng mật khẩu mới -> Thành công
        User successLogin = userService.login(username, newPassword);
        assertNotNull(successLogin, "Đăng nhập thành công với mật khẩu mới");
        assertEquals(user.getId(), successLogin.getId());

        // Dọn dẹp
        userDAO.delete(user.getId());
        customerDAO.delete(user.getCustomerId());
    }
}
