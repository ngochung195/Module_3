<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="customers" scope="request" />
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
            max-width: 650px;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5">
        <!-- Header -->
        <div class="mb-4 text-center">
            <h3 class="fw-bold text-dark mb-1">${pageTitle}</h3>
            <p class="text-secondary mb-0">Nhập đầy đủ các thông tin cần thiết của khách hàng</p>
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

                <form action="${pageContext.request.contextPath}/customers" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="${formAction}">
                    <c:if test="${formAction == 'edit'}">
                        <input type="hidden" name="id" value="${customer.id}">
                    </c:if>

                    <!-- Họ Tên -->
                    <div class="mb-4">
                        <label for="name" class="form-label fw-semibold">Họ Tên Khách Hàng <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-person text-secondary"></i></span>
                            <input type="text" 
                                   class="form-control" 
                                   id="name" 
                                   name="name" 
                                   value="${customer != null ? customer.name : ''}" 
                                   placeholder="Ví dụ: Nguyễn Văn A" 
                                   required>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Số Điện Thoại -->
                        <div class="col-md-6 mb-4">
                            <label for="phone" class="form-label fw-semibold">Số Điện Thoại <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-telephone text-secondary"></i></span>
                                <input type="text" 
                                       class="form-control" 
                                       id="phone" 
                                       name="phone" 
                                       value="${customer != null ? customer.phone : ''}" 
                                       placeholder="Ví dụ: 0912345678" 
                                       required>
                            </div>
                            <small class="form-text text-muted">Định dạng: 09xx, 03xx, 05xx, 07xx, 08xx</small>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6 mb-4">
                            <label for="email" class="form-label fw-semibold">Email</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope text-secondary"></i></span>
                                <input type="email" 
                                       class="form-control" 
                                       id="email" 
                                       name="email" 
                                       value="${customer != null ? customer.email : ''}" 
                                       placeholder="Ví dụ: abc@gmail.com">
                            </div>
                        </div>
                    </div>

                    <!-- Địa Chỉ -->
                    <div class="mb-4">
                        <label for="address" class="form-label fw-semibold">Địa Chỉ</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-geo-alt text-secondary"></i></span>
                            <textarea class="form-control" 
                                      id="address" 
                                      name="address" 
                                      rows="3" 
                                      placeholder="Ví dụ: 123 Nguyễn Trãi, Quận 1, TP.HCM">${customer != null ? customer.address : ''}</textarea>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/customers" class="btn btn-light rounded-pill px-4">
                            <i class="bi bi-x-lg me-1"></i>Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">
                            <i class="bi bi-floppy me-1"></i>
                            <c:choose>
                                <c:when test="${formAction == 'edit'}">Cập Nhật Khách Hàng</c:when>
                                <c:otherwise>Lưu Khách Hàng</c:otherwise>
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
