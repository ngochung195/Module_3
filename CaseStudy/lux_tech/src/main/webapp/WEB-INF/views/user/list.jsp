<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="users" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - LuxTech Store</title>
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
                <h3 class="fw-bold text-dark mb-1">Quản Lý Tài Khoản Người Dùng</h3>
                <p class="text-secondary mb-0">Danh sách tài khoản hệ thống và phân quyền truy cập (ADMIN / STAFF)</p>
            </div>
            <a href="${pageContext.request.contextPath}/users?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-person-plus me-2"></i>Thêm Người Dùng Mới
            </a>
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

        <!-- Users Table Card -->
        <div class="card card-table overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width: 100px;">Mã (ID)</th>
                                <th>Tên Đăng Nhập</th>
                                <th>Vai Trò (Role)</th>
                                <th class="text-end pe-4" style="width: 220px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty users}">
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">#${u.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-light rounded-circle p-2 me-3 text-primary">
                                                        <i class="bi bi-person"></i>
                                                    </div>
                                                    <div>
                                                        <span class="fw-bold text-dark fs-6">${u.username}</span>
                                                        <c:if test="${u.id == sessionScope.user.id}">
                                                            <span class="badge bg-soft-info text-info ms-2">(Tôi)</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.role == 'ADMIN'}">
                                                        <span class="badge bg-danger px-3 py-2 rounded-pill"><i class="bi bi-shield-half me-1"></i>ADMIN</span>
                                                    </c:when>
                                                    <c:when test="${u.role == 'CUSTOMER'}">
                                                        <span class="badge bg-success px-3 py-2 rounded-pill"><i class="bi bi-person me-1"></i>CUSTOMER</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-primary px-3 py-2 rounded-pill"><i class="bi bi-person-gear me-1"></i>STAFF</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/users?action=edit&id=${u.id}" 
                                                   class="btn btn-sm btn-outline-primary rounded-pill me-1 px-3">
                                                    <i class="bi bi-pencil-square me-1"></i>Sửa
                                                </a>

                                                <c:choose>
                                                    <c:when test="${u.id == sessionScope.user.id}">
                                                        <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" disabled title="Không thể xóa chính mình">
                                                            <i class="bi bi-slash-circle me-1"></i>Xóa
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#deleteModal${u.id}">
                                                            <i class="bi bi-trash me-1"></i>Xóa
                                                        </button>

                                                        <!-- Delete Confirmation Modal -->
                                                        <div class="modal fade text-start" id="deleteModal${u.id}" tabindex="-1" aria-hidden="true">
                                                            <div class="modal-dialog modal-dialog-centered">
                                                                <div class="modal-content rounded-4 border-0 shadow">
                                                                    <div class="modal-header border-0 pb-0">
                                                                        <h5 class="modal-title fw-bold text-danger">
                                                                            <i class="bi bi-exclamation-triangle me-2"></i>Xác Nhận Xóa Tài Khoản
                                                                        </h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body py-3">
                                                                        Bạn có chắc chắn muốn xóa tài khoản <strong>"${u.username}"</strong> (Role: ${u.role})?<br/>
                                                                        <small class="text-muted">Lưu ý: Thao tác này không thể hoàn tác.</small>
                                                                    </div>
                                                                    <div class="modal-footer border-0 pt-0">
                                                                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                                        <a href="${pageContext.request.contextPath}/users?action=delete&id=${u.id}" 
                                                                           class="btn btn-danger rounded-pill px-4">
                                                                            Xác Nhận Xóa
                                                                        </a>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">
                                            Chưa có tài khoản người dùng nào.
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
