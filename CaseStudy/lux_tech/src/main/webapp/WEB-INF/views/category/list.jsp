<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="categories" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục - LuxTech Store</title>
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
        .card-table {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Quản Lý Danh Mục Sản Phẩm</h3>
                <p class="text-secondary mb-0">Danh sách tất cả các nhóm phân loại hàng hóa điện tử</p>
            </div>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/categories?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>Thêm Danh Mục Mới
                </a>
            </c:if>
        </div>

        <!-- Success Alert -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-check-circle me-2 fs-5"></i>
                <div>${successMessage}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Error Alert -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle me-2 fs-5"></i>
                <div>${errorMessage}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Categories Table Card -->
        <div class="card card-table overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width: 100px;">Mã (ID)</th>
                                <th>Tên Danh Mục</th>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <th class="text-end pe-4" style="width: 200px;">Thao Tác</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty categories}">
                                    <c:forEach var="cat" items="${categories}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">#${cat.id}</td>
                                            <td>
                                                <span class="fw-bold text-dark fs-6">${cat.name}</span>
                                            </td>
                                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                                <td class="text-end pe-4">
                                                    <a href="${pageContext.request.contextPath}/categories?action=edit&id=${cat.id}" 
                                                       class="btn btn-sm btn-outline-primary rounded-pill me-1 px-3">
                                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteModal${cat.id}">
                                                        <i class="bi bi-trash me-1"></i>Xóa
                                                    </button>

                                                    <!-- Delete Confirmation Modal -->
                                                    <div class="modal fade text-start" id="deleteModal${cat.id}" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content rounded-4 border-0 shadow">
                                                                <div class="modal-header border-0 pb-0">
                                                                    <h5 class="modal-title fw-bold text-danger">
                                                                        <i class="bi bi-exclamation-triangle me-2"></i>Xác Nhận Xóa
                                                                    </h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body py-3">
                                                                    Bạn có chắc chắn muốn xóa danh mục <strong>"${cat.name}"</strong> (ID: #${cat.id})?<br/>
                                                                    <small class="text-muted">Lưu ý: Không thể xóa danh mục nếu đang có sản phẩm thuộc danh mục này.</small>
                                                                </div>
                                                                <div class="modal-footer border-0 pt-0">
                                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                                    <a href="${pageContext.request.contextPath}/categories?action=delete&id=${cat.id}" 
                                                                       class="btn btn-danger rounded-pill px-4">
                                                                        Xác Nhận Xóa
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="text-center py-4 text-muted">
                                            Chưa có danh mục nào được khởi tạo trong hệ thống.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Component -->
                <jsp:include page="/WEB-INF/views/common/admin-pagination.jsp" />
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
