<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="customers" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng - LuxTech Store</title>
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
        .card-table, .card-filter {
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
                <h3 class="fw-bold text-dark mb-1">Danh Sách Khách Hàng</h3>
                <p class="text-secondary mb-0">Quản lý thông tin khách hàng, tìm kiếm và chỉnh sửa</p>
            </div>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/customers?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>Thêm Khách Hàng Mới
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

        <!-- Search & Filter Card -->
        <div class="card card-filter mb-4">
            <div class="card-body p-3 p-md-4">
                <form action="${pageContext.request.contextPath}/customers" method="get" class="row g-3 align-items-center">
                    <input type="hidden" name="action" value="search">

                    <!-- Keyword Search -->
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                            <input type="text" 
                                   class="form-control border-start-0" 
                                   name="keyword" 
                                   value="${keyword}" 
                                   placeholder="Tìm theo tên, số điện thoại hoặc email...">
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="col-md-4 d-flex gap-2">
                        <button type="submit" class="btn btn-primary rounded-pill px-3 flex-fill shadow-sm">
                            <i class="bi bi-funnel me-1"></i>Tìm Kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/customers" class="btn btn-outline-secondary rounded-pill px-3">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Đặt Lại
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Customers Table Card -->
        <div class="card card-table overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width: 80px;">Mã (ID)</th>
                                <th>Họ Tên</th>
                                <th>Số Điện Thoại</th>
                                <th>Email</th>
                                <th>Địa Chỉ</th>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <th class="text-end pe-4" style="width: 200px;">Thao Tác</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty customers}">
                                    <c:forEach var="c" items="${customers}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">#${c.id}</td>
                                            <td>
                                                <span class="fw-bold text-dark fs-6">
                                                    <i class="bi bi-person-circle me-1 text-primary"></i>${c.name}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">
                                                    <i class="bi bi-telephone me-1 text-success"></i>${c.phone}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty c.email}">
                                                        <i class="bi bi-envelope me-1 text-secondary"></i>${c.email}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Chưa cung cấp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty c.address}">
                                                        <span title="${c.address}">
                                                            <i class="bi bi-geo-alt me-1 text-danger"></i>
                                                            <c:choose>
                                                                <c:when test="${c.address.length() > 40}">
                                                                    ${c.address.substring(0, 40)}...
                                                                </c:when>
                                                                <c:otherwise>${c.address}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted fst-italic">Chưa cung cấp</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                                <td class="text-end pe-4">
                                                    <a href="${pageContext.request.contextPath}/customers?action=edit&id=${c.id}" 
                                                       class="btn btn-sm btn-outline-primary rounded-pill me-1 px-3">
                                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteModal${c.id}">
                                                        <i class="bi bi-trash me-1"></i>Xóa
                                                    </button>

                                                    <!-- Delete Confirmation Modal -->
                                                    <div class="modal fade text-start" id="deleteModal${c.id}" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content rounded-4 border-0 shadow">
                                                                <div class="modal-header border-0 pb-0">
                                                                    <h5 class="modal-title fw-bold text-danger">
                                                                        <i class="bi bi-exclamation-triangle me-2"></i>Xác Nhận Xóa Khách Hàng
                                                                    </h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body py-3">
                                                                    Bạn có chắc chắn muốn xóa khách hàng <strong>"${c.name}"</strong> (ID: #${c.id})?<br/>
                                                                    <small class="text-muted">Lưu ý: Không thể xóa khách hàng nếu đã có đơn hàng liên kết.</small>
                                                                </div>
                                                                <div class="modal-footer border-0 pt-0">
                                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                                    <a href="${pageContext.request.contextPath}/customers?action=delete&id=${c.id}" 
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
                                        <td colspan="${sessionScope.role == 'ADMIN' ? 6 : 5}" class="text-center py-5 text-muted">
                                            <i class="bi bi-people fs-1 mb-2 text-secondary opacity-50"></i><br/>
                                            Không tìm thấy khách hàng nào phù hợp với yêu cầu.
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
