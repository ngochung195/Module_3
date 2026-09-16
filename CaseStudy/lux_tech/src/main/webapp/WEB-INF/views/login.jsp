<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        body {
            background: linear-gradient(135deg, #0F172A 0%, #1E293B 50%, #0F172A 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            padding: 2rem 1rem;
            position: relative;
            overflow-x: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            top: 20%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 450px;
            height: 450px;
            background: radial-gradient(circle, rgba(255, 107, 0, 0.15) 0%, rgba(0, 0, 0, 0) 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .login-card {
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.4);
            background: #FFFFFF;
            overflow: hidden;
            width: 100%;
            max-width: 440px;
            position: relative;
            z-index: 1;
        }
        .login-header {
            padding: 2.5rem 2rem 1.5rem;
            text-align: center;
            background: #FFFFFF;
            border-bottom: 1px solid #F1F5F9;
        }
        .login-header .brand-icon-box {
            width: 58px;
            height: 58px;
            background: #FF6B00;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #FFFFFF;
            font-size: 1.75rem;
            margin-bottom: 1rem;
            box-shadow: 0 8px 20px rgba(255, 107, 0, 0.35);
        }
        .form-body {
            padding: 2rem 2.25rem 2.25rem;
        }
        .form-control {
            border-radius: 12px;
            padding: 0.7rem 1rem;
            font-size: 0.95rem;
            border: 1.5px solid #E2E8F0;
            background-color: #F8FAFC;
        }
        .form-control:focus {
            background-color: #FFFFFF;
            border-color: #FF6B00 !important;
            box-shadow: 0 0 0 3px rgba(255, 107, 0, 0.15) !important;
        }
        .input-group-text {
            border-radius: 12px 0 0 12px;
            background-color: #F8FAFC;
            border: 1.5px solid #E2E8F0;
            border-right: none;
            color: #94A3B8;
        }
        .input-group .form-control {
            border-left: none;
            border-radius: 0 12px 12px 0;
        }
        .input-group:focus-within .input-group-text {
            border-color: #FF6B00;
            color: #FF6B00;
            background-color: #FFFFFF;
        }
        .btn-login {
            background-color: #FF6B00 !important;
            border-color: #FF6B00 !important;
            color: #FFFFFF !important;
            border-radius: 12px;
            padding: 0.8rem;
            font-weight: 700;
            font-size: 1rem;
            letter-spacing: 0.3px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(255, 107, 0, 0.3);
        }
        .btn-login:hover {
            background-color: #FF7A1A !important;
            border-color: #FF7A1A !important;
            color: #FFFFFF !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 107, 0, 0.4);
        }
        .btn-login:active {
            transform: translateY(0);
        }
        .link-orange {
            color: #FF6B00 !important;
            font-weight: 600;
            text-decoration: none;
        }
        .link-orange:hover {
            color: #FF7A1A !important;
            text-decoration: underline;
        }
        .account-badge {
            background: #FFF7F0;
            color: #C2410C;
            border: 1px solid rgba(255, 107, 0, 0.2);
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            border-radius: 8px;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <!-- Header -->
        <div class="login-header">
            <div class="brand-icon-box">
                <i class="bi bi-cpu-fill"></i>
            </div>
            <h3 class="fw-bold mb-1" style="letter-spacing: -0.5px;">
                <span style="color:#111827;">LUX</span><span style="color:#FF6B00;">TECH</span>
            </h3>
            <p class="text-secondary small mb-0">Hệ Thống Bán Lẻ & Quản Lý Cửa Hàng Điện Tử</p>
        </div>

        <!-- Form Body -->
        <div class="form-body">
            <!-- Alert Registered Success Message -->
            <c:if test="${param.registered == 'true'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 rounded-3 p-3" role="alert">
                    <i class="bi bi-check-circle-fill me-2 fs-5 text-success"></i>
                    <div class="small fw-medium">Đăng ký tài khoản thành công! Vui lòng đăng nhập.</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Alert Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 rounded-3 p-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 fs-5 text-danger"></i>
                    <div class="small fw-medium">${errorMessage}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <!-- Username Input -->
                <div class="mb-3">
                    <label for="username" class="form-label text-dark fw-semibold small mb-1">Tên đăng nhập</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control" id="username" name="username" 
                               value="${username}" placeholder="Nhập username của bạn..." required autofocus>
                    </div>
                </div>

                <!-- Password Input -->
                <div class="mb-4">
                    <label for="password" class="form-label text-dark fw-semibold small mb-1">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="Nhập mật khẩu..." required>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="d-grid mb-3">
                    <button type="submit" class="btn btn-login">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Đăng Nhập
                    </button>
                </div>

                <!-- Register Link -->
                <div class="text-center mb-2">
                    <span class="text-secondary small">Chưa có tài khoản?</span>
                    <a href="${pageContext.request.contextPath}/register" class="link-orange small ms-1">Đăng ký ngay</a>
                </div>
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none small">
                        <i class="bi bi-shop me-1 text-primary" style="color:#FF6B00 !important;"></i>Vào cửa hàng Online
                    </a>
                </div>
            </form>

            <!-- Test Accounts Helper -->
            <div class="mt-4 pt-3 border-top text-center">
                <p class="mb-2 text-secondary small fw-semibold">Tài khoản thử nghiệm hệ thống:</p>
                <div class="d-flex flex-wrap justify-content-center gap-1">
                    <span class="account-badge">Admin: admin / 123456</span>
                    <span class="account-badge">Staff: staff / 123456</span>
                    <span class="account-badge">Customer: customer / 123456</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
