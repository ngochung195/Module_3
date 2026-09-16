<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký Tài Khoản - LuxTech Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        * { font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #0F172A 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1rem;
            position: relative;
            overflow-x: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            top: 20%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(255, 107, 0, 0.15) 0%, rgba(0, 0, 0, 0) 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .register-card {
            width: 100%;
            max-width: 560px;
            background: #FFFFFF;
            border-radius: 24px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.4);
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        .register-header {
            padding: 2.5rem 2rem 1.5rem;
            text-align: center;
            background: #FFFFFF;
            border-bottom: 1px solid #F1F5F9;
        }
        .register-header .brand-icon {
            width: 58px; height: 58px;
            background: #FF6B00;
            border-radius: 16px;
            display: inline-flex; align-items: center; justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.75rem;
            color: white;
            box-shadow: 0 8px 20px rgba(255, 107, 0, 0.35);
        }
        .form-body { padding: 2rem 2.25rem 2.25rem; }
        .section-label {
            font-size: 0.75rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1.2px; color: #FF6B00; margin-bottom: 1rem;
            display: flex; align-items: center; gap: 0.5rem;
        }
        .section-label::after {
            content: ''; flex: 1; height: 1px; background: #E2E8F0;
        }
        .form-label { font-weight: 600; font-size: 0.85rem; color: #111827; margin-bottom: 0.35rem; }
        .input-group-text {
            background: #F8FAFC; border-right: none; border-color: #E2E8F0; color: #94A3B8; border-radius: 12px 0 0 12px;
        }
        .form-control {
            border-left: none; border-color: #E2E8F0; background: #F8FAFC; border-radius: 0 12px 12px 0;
            font-size: 0.9rem; padding: 0.65rem 0.9rem;
            transition: all 0.2s;
        }
        .form-control:focus {
            border-color: #FF6B00 !important; box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15) !important;
            background: #FFFFFF;
        }
        .input-group:focus-within .input-group-text { border-color: #FF6B00 !important; color: #FF6B00 !important; background: #FFFFFF; }
        .btn-register {
            background: #FF6B00 !important;
            border: none; color: white !important; font-weight: 700;
            font-size: 1rem; padding: 0.85rem;
            border-radius: 12px; width: 100%;
            transition: all 0.2s; letter-spacing: 0.3px;
            box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);
        }
        .btn-register:hover { background: #FF7A1A !important; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(255, 107, 0, 0.4); color: white !important; }
        .btn-register:active { transform: translateY(0); }
        .login-link { text-align: center; margin-top: 1.25rem; font-size: 0.875rem; color: #6B7280; }
        .login-link a { color: #FF6B00 !important; font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; color: #FF7A1A !important; }
    </style>
</head>
<body>
<div class="register-card">
    <!-- Header -->
    <div class="register-header">
        <div class="brand-icon"><i class="bi bi-cpu-fill"></i></div>
        <h3 class="fw-bold mb-1" style="letter-spacing: -0.5px;">
            <span style="color:#111827;">Tạo Tài Khoản </span><span style="color:#FF6B00;">LUXTECH</span>
        </h3>
        <p class="text-secondary small mb-0">Đăng ký để mua sắm & theo dõi đơn hàng dễ dàng</p>
    </div>

    <!-- Form -->
    <div class="form-body">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center mb-3 rounded-3 p-3" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2 fs-5 text-danger"></i>
                <span class="small fw-medium">${errorMessage}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" novalidate>

            <!-- Thông tin cá nhân -->
            <div class="section-label"><i class="bi bi-person"></i> Thông tin cá nhân</div>

            <div class="row g-3 mb-3">
                <div class="col-12">
                    <label for="reg-name" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                        <input type="text" class="form-control" id="reg-name" name="name"
                               value="${name}" placeholder="Nguyễn Văn A" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="reg-phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                        <input type="tel" class="form-control" id="reg-phone" name="phone"
                               value="${phone}" placeholder="0912345678" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="reg-email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="email" class="form-control" id="reg-email" name="email"
                               value="${email}" placeholder="example@email.com">
                    </div>
                </div>
                <div class="col-12">
                    <label for="reg-address" class="form-label">Địa chỉ nhận hàng</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                        <input type="text" class="form-control" id="reg-address" name="address"
                               value="${address}" placeholder="Số nhà, tên đường, quận/huyện...">
                    </div>
                </div>
            </div>

            <!-- Tài khoản đăng nhập -->
            <div class="section-label mt-2"><i class="bi bi-shield-lock"></i> Tài khoản đăng nhập</div>

            <div class="row g-3 mb-4">
                <div class="col-12">
                    <label for="reg-username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-at"></i></span>
                        <input type="text" class="form-control" id="reg-username" name="username"
                               value="${username}" placeholder="Tối thiểu 3 ký tự" required minlength="3">
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="reg-password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-key"></i></span>
                        <input type="password" class="form-control" id="reg-password" name="password"
                               placeholder="Tối thiểu 6 ký tự" required minlength="6">
                    </div>
                </div>
                <div class="col-md-6">
                    <label for="reg-password2" class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                        <input type="password" class="form-control" id="reg-password2" name="password2"
                               placeholder="Nhập lại mật khẩu" required>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-register">
                <i class="bi bi-person-plus me-2"></i>Tạo Tài Khoản
            </button>
        </form>

        <div class="login-link">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Client-side confirm password check
    document.querySelector('form').addEventListener('submit', function(e) {
        const p1 = document.getElementById('reg-password').value;
        const p2 = document.getElementById('reg-password2').value;
        if (p1 !== p2) {
            e.preventDefault();
            document.getElementById('reg-password2').setCustomValidity('Mật khẩu không khớp');
            document.getElementById('reg-password2').reportValidity();
        }
    });
    document.getElementById('reg-password2').addEventListener('input', function() {
        this.setCustomValidity('');
    });
</script>
</body>
</html>
