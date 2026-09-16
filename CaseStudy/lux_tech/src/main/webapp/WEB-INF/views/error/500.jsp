<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 Internal Error - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css">
    <style>
        body {
            background-color: #171717;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        .error-card {
            max-width: 520px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
            background: #262626;
        }
        .icon-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background-color: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }
    </style>
</head>
<body>
    <div class="container text-center px-4">
        <div class="card error-card mx-auto p-4 p-md-5">
            <div class="card-body p-0">
                <div class="icon-circle">
                    <i class="bi bi-exclamation-triangle"></i>
                </div>
                <h1 class="display-4 fw-bold text-white mb-2">500</h1>
                <h4 class="fw-bold text-warning mb-3">Lỗi Xử Lý Hệ Thống</h4>
                <p class="text-light text-opacity-75 mb-4">
                    Hệ thống đã ghi nhận sự cố bất ngờ khi xử lý yêu cầu.<br/>
                    Đội ngũ kỹ thuật sẽ sớm khắc phục. Vui lòng thử lại sau.
                </p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-light rounded-pill px-4 py-2">
                        <i class="bi bi-shop me-2"></i>Trang Mua Sắm
                    </a>
                    <a href="javascript:history.back()" class="btn btn-primary rounded-pill px-4 py-2 shadow-sm">
                        <i class="bi bi-arrow-left me-2"></i>Quay Lại
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
