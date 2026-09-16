package com.electronicstore.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit Test cho ValidationUtil (Phase 14).
 * Kiểm tra các bộ validator: Email, Phone, Username, Password, Hex Color, Bounds, Sanitization.
 */
public class ValidationUtilTest {

    @Test
    @DisplayName("Validation - Email Validator kiểm tra định dạng email chính xác")
    void testEmailValidation() {
        assertTrue(ValidationUtil.isValidEmail("admin@luxtech.com"));
        assertTrue(ValidationUtil.isValidEmail("user.test+1@domain.co.uk"));
        assertTrue(ValidationUtil.isValidEmail("customer_99@gmail.com"));

        assertFalse(ValidationUtil.isValidEmail(null));
        assertFalse(ValidationUtil.isValidEmail(""));
        assertFalse(ValidationUtil.isValidEmail("   "));
        assertFalse(ValidationUtil.isValidEmail("invalid-email"));
        assertFalse(ValidationUtil.isValidEmail("@domain.com"));
        assertFalse(ValidationUtil.isValidEmail("user@.com"));
    }

    @Test
    @DisplayName("Validation - Phone Validator kiểm tra số điện thoại Việt Nam hợp lệ")
    void testPhoneValidation() {
        assertTrue(ValidationUtil.isValidPhone("0901234567"));
        assertTrue(ValidationUtil.isValidPhone("0987654321"));
        assertTrue(ValidationUtil.isValidPhone("0345678901"));
        assertTrue(ValidationUtil.isValidPhone("0771234567"));
        assertTrue(ValidationUtil.isValidPhone("+84901234567"));

        assertFalse(ValidationUtil.isValidPhone(null));
        assertFalse(ValidationUtil.isValidPhone(""));
        assertFalse(ValidationUtil.isValidPhone("0123456789")); // Đầu số 01 không hợp lệ
        assertFalse(ValidationUtil.isValidPhone("090123456"));  // Quá ngắn
        assertFalse(ValidationUtil.isValidPhone("090123456789")); // Quá dài
        assertFalse(ValidationUtil.isValidPhone("090123456a")); // Chứa chữ cái
    }

    @Test
    @DisplayName("Validation - Username & Password Validator kiểm tra độ dài và định dạng")
    void testUsernameAndPasswordValidation() {
        assertTrue(ValidationUtil.isValidUsername("admin"));
        assertTrue(ValidationUtil.isValidUsername("customer_01"));
        assertTrue(ValidationUtil.isValidUsername("staff123"));

        assertFalse(ValidationUtil.isValidUsername(null));
        assertFalse(ValidationUtil.isValidUsername(""));
        assertFalse(ValidationUtil.isValidUsername("ab")); // < 3 chars
        assertFalse(ValidationUtil.isValidUsername("user with spaces"));
        assertFalse(ValidationUtil.isValidUsername("user@special!"));

        assertTrue(ValidationUtil.isValidPassword("123456"));
        assertTrue(ValidationUtil.isValidPassword("StrongPassword!@#"));
        assertFalse(ValidationUtil.isValidPassword(null));
        assertFalse(ValidationUtil.isValidPassword("12345")); // < 6 chars
    }

    @Test
    @DisplayName("Validation - Hex Color Validator kiểm tra mã màu hợp lệ")
    void testHexColorValidation() {
        assertTrue(ValidationUtil.isValidHexColor("#ffffff"));
        assertTrue(ValidationUtil.isValidHexColor("#000000"));
        assertTrue(ValidationUtil.isValidHexColor("#6366f1"));
        assertTrue(ValidationUtil.isValidHexColor("#fff"));
        assertTrue(ValidationUtil.isValidHexColor("#1A2B3C"));

        assertFalse(ValidationUtil.isValidHexColor(null));
        assertFalse(ValidationUtil.isValidHexColor(""));
        assertFalse(ValidationUtil.isValidHexColor("ffffff")); // Thiếu #
        assertFalse(ValidationUtil.isValidHexColor("#gggggg")); // Ký tự không phải hex
        assertFalse(ValidationUtil.isValidHexColor("#12345"));  // Sai độ dài
    }

    @Test
    @DisplayName("Validation - HTML Sanitizer chuyển đổi ký tự đặc biệt chống XSS")
    void testHtmlSanitization() {
        assertNull(ValidationUtil.sanitizeHtml(null));

        String input = "<script>alert('XSS')</script>";
        String sanitized = ValidationUtil.sanitizeHtml(input);
        assertEquals("&lt;script&gt;alert(&#x27;XSS&#x27;)&lt;/script&gt;", sanitized);

        String attributePayload = "\" onclick=\"evil()";
        String sanitizedAttr = ValidationUtil.sanitizeHtml(attributePayload);
        assertEquals("&quot; onclick=&quot;evil()", sanitizedAttr);
    }
}
