<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="categories" scope="request" />
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
            border-radius: 20px;
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
        <div class="card card-form p-4 bg-white">
            <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                <a href="${pageContext.request.contextPath}/categories" class="btn btn-light rounded-circle me-3">
                    <i class="bi bi-arrow-left"></i>
                </a>
                <div>
                    <h4 class="fw-bold text-dark mb-0">${pageTitle}</h4>
                    <small class="text-secondary">Điền thông tin chi tiết danh mục sản phẩm</small>
                </div>
            </div>

            <!-- Error Alert -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle me-2 fs-5"></i>
                    <div>${errorMessage}</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/categories" method="post">
                <input type="hidden" name="action" value="${formAction}" />
                <c:if test="${formAction == 'edit'}">
                    <input type="hidden" name="id" value="${category.id}" />
                </c:if>

                <!-- Input Name -->
                <div class="mb-4">
                    <label for="name" class="form-label fw-semibold text-dark">Tên danh mục <span class="text-danger">*</span></label>
                    <input type="text" 
                           class="form-control form-control-lg bg-light" 
                           id="name" 
                           name="name" 
                           value="${category.name}" 
                           placeholder="Nhập tên danh mục (ví dụ: Điện thoại, Laptop, Bàn phím...)" 
                           required 
                           autofocus>
                    <div class="form-text">Tên danh mục không được để trống và không được trùng lặp.</div>
                </div>

                <!-- Form Action Buttons -->
                <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                    <a href="${pageContext.request.contextPath}/categories" class="btn btn-light rounded-pill px-4">
                        Hủy Bỏ
                    </a>
                    <button type="submit" class="btn btn-primary rounded-pill px-4">
                        <i class="bi bi-floppy me-2"></i>Lưu Danh Mục
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
