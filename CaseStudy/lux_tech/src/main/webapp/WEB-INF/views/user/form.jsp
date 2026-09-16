<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="users" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - LuxTech Store</title>
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
            background-color: #f8f9fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #111827;
        }
        .card-form {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            max-width: 600px;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5">
        <!-- Breadcrumb / Header -->
        <div class="mb-4 text-center">
            <h3 class="fw-bold text-dark mb-1">${pageTitle}</h3>
            <p class="text-secondary mb-0">Quản lý thông tin tài khoản và vai trò người dùng hệ thống</p>
        </div>

        <div class="card card-form">
            <div class="card-body p-4 p-md-5">
                <!-- Error Alert -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle me-2 fs-5"></i>
                        <div>${errorMessage}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/users" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="${formAction}">
                    <c:if test="${formAction == 'edit'}">
                        <input type="hidden" name="id" value="${userTarget.id}">
                    </c:if>

                    <!-- Username -->
                    <div class="mb-4">
                        <label for="username" class="form-label fw-semibold">Tên Đăng Nhập <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-person text-secondary"></i></span>
                            <input type="text" 
                                   class="form-control" 
                                   id="username" 
                                   name="username" 
                                   value="${userTarget != null ? userTarget.username : ''}" 
                                   placeholder="Nhập tên đăng nhập (ít nhất 3 ký tự)" 
                                   required>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="mb-4">
                        <label for="password" class="form-label fw-semibold">
                            Mật Khẩu 
                            <c:choose>
                                <c:when test="${formAction == 'create'}"><span class="text-danger">*</span></c:when>
                                <c:otherwise><small class="text-muted fw-normal">(Đổi mới - Để trống nếu giữ nguyên)</small></c:otherwise>
                            </c:choose>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-key text-secondary"></i></span>
                            <input type="password" 
                                   class="form-control" 
                                   id="password" 
                                   name="password" 
                                   placeholder="${formAction == 'create' ? 'Nhập mật khẩu (ít nhất 6 ký tự)' : 'Mật khẩu mới (tùy chọn)'}" 
                                   ${formAction == 'create' ? 'required' : ''}>
                        </div>
                    </div>

                    <!-- Role -->
                    <div class="mb-4">
                        <label for="role" class="form-label fw-semibold">Vai Trò (Role) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-shield-check text-secondary"></i></span>
                            <select class="form-select" id="role" name="role" required>
                                <option value="STAFF" ${userTarget != null && userTarget.role == 'STAFF' ? 'selected' : ''}>STAFF - Nhân viên bán hàng</option>
                                <option value="ADMIN" ${userTarget != null && userTarget.role == 'ADMIN' ? 'selected' : ''}>ADMIN - Quản trị viên</option>
                                <option value="CUSTOMER" ${userTarget != null && userTarget.role == 'CUSTOMER' ? 'selected' : ''}>CUSTOMER - Khách hàng</option>
                            </select>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/users" class="btn btn-light rounded-pill px-4">
                            <i class="bi bi-x-lg me-1"></i>Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">
                            <i class="bi bi-floppy me-1"></i>
                            <c:choose>
                                <c:when test="${formAction == 'edit'}">Cập Nhật</c:when>
                                <c:otherwise>Lưu Người Dùng</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
