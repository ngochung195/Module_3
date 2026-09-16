<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="orders" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng - LuxTech Store</title>
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
        .table > :not(caption) > * > * {
            padding: 1rem 1.25rem;
            vertical-align: middle;
        }
        .badge-status-pending {
            background: #fef3c7; color: #92400e; border: 1px solid #fde68a;
        }
        .badge-status-paid {
            background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0;
        }
        .badge-status-confirmed {
            background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd;
        }
        .badge-status-completed {
            background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0;
        }
        .badge-status-cancelled {
            background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca;
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
                <h3 class="fw-bold text-dark mb-1">Quản Lý Đơn Hàng</h3>
                <p class="text-secondary mb-0">Theo dõi, kiểm tra và xử lý đơn hàng Online & Tại quầy trên toàn hệ thống</p>
            </div>
            <a href="${pageContext.request.contextPath}/orders?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-plus-circle me-2"></i>Tạo Đơn Hàng Tại Quầy
            </a>
        </div>

        <!-- Flash Success Alert -->
        <c:if test="${not empty flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-check-circle me-2 fs-5"></i>
                <div>${flashSuccess}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Flash Error Alert -->
        <c:if test="${not empty flashError}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle me-2 fs-5"></i>
                <div>${flashError}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Filter Card -->
        <div class="card card-filter bg-white mb-4">
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/orders" method="get" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label for="keyword" class="form-label text-secondary fw-semibold">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search text-secondary"></i></span>
                            <input type="text" class="form-control bg-light" id="keyword" name="keyword" 
                                   value="${keyword}" placeholder="Tên hoặc SĐT khách hàng...">
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label for="status" class="form-label text-secondary fw-semibold">Trạng thái đơn hàng</label>
                        <select class="form-select bg-light" id="status" name="status">
                            <option value="" ${empty status ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                            <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Chờ xác nhận (PENDING)</option>
                            <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>Đã thanh toán (PAID)</option>
                            <option value="CONFIRMED" ${status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận (CONFIRMED)</option>
                            <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Đã hoàn thành (COMPLETED)</option>
                            <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy (CANCELLED)</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label for="source" class="form-label text-secondary fw-semibold">Nguồn đơn hàng</label>
                        <select class="form-select bg-light" id="source" name="source">
                            <option value="" ${empty source ? 'selected' : ''}>-- Tất cả nguồn --</option>
                            <option value="ONLINE" ${source == 'ONLINE' ? 'selected' : ''}>Đơn Online (Website)</option>
                            <option value="STAFF" ${source == 'STAFF' ? 'selected' : ''}>Tại quầy (Staff)</option>
                        </select>
                    </div>

                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn btn-primary rounded-pill px-3 flex-grow-1">
                            <i class="bi bi-funnel me-1"></i>Lọc
                        </button>
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary rounded-pill px-3" title="Làm mới">
                            <i class="bi bi-arrow-clockwise"></i>
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Orders Table Card -->
        <div class="card card-table bg-white">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="text-center" style="width: 90px;">Mã Đơn</th>
                                <th>Khách Hàng</th>
                                <th class="text-center" style="width: 110px;">Nguồn Đơn</th>
                                <th>Thời Gian Đặt</th>
                                <th class="text-center" style="width: 120px;">Thanh Toán</th>
                                <th class="text-end">Tổng Tiền</th>
                                <th class="text-center">Trạng Thái</th>
                                <th class="text-center" style="width: 140px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty orders}">
                                    <c:forEach var="order" items="${orders}">
                                        <tr>
                                            <td class="text-center fw-bold text-primary">#ORD-${order.id}</td>
                                            <td>
                                                <div class="fw-semibold text-dark">${order.customerName}</div>
                                                <small class="text-muted">ID Khách: ${order.customerId}</small>
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${order.source eq 'STAFF'}">
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1 rounded-pill fw-semibold" style="font-size: 0.75rem;">
                                                            <i class="bi bi-shop me-1"></i>STAFF
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info-subtle text-primary border border-info-subtle px-2 py-1 rounded-pill fw-semibold" style="font-size: 0.75rem;">
                                                            <i class="bi bi-globe me-1"></i>ONLINE
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${order.paymentMethod eq 'VNPAY' ? 'bg-primary-subtle text-primary border border-primary-subtle' : 'bg-success-subtle text-success border border-success-subtle'} px-2 py-1 rounded-pill fw-semibold" style="font-size: 0.75rem;">
                                                    <i class="bi ${order.paymentMethod eq 'VNPAY' ? 'bi-qr-code' : 'bi-cash'} me-1"></i>${order.paymentMethod != null ? order.paymentMethod : 'COD'}
                                                </span>
                                            </td>
                                            <td class="text-end fw-bold text-dark fs-6">
                                                <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${order.status == 'PAID'}">
                                                        <span class="badge badge-status-paid px-3 py-2 rounded-pill fw-semibold">
                                                            <i class="bi bi-check-circle me-1"></i>PAID
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'PENDING'}">
                                                        <span class="badge badge-status-pending px-3 py-2 rounded-pill fw-semibold">
                                                            <i class="bi bi-hourglass-split me-1"></i>PENDING
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'CONFIRMED'}">
                                                        <span class="badge badge-status-confirmed px-3 py-2 rounded-pill fw-semibold">
                                                            <i class="bi bi-truck me-1"></i>CONFIRMED
                                                        </span>
                                                        <c:if test="${order.paymentStatus eq 'PAID'}">
                                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill fw-semibold ms-1" style="font-size: 0.7rem;">
                                                                PAID
                                                            </span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:when test="${order.status == 'COMPLETED'}">
                                                        <span class="badge badge-status-completed px-3 py-2 rounded-pill fw-semibold">
                                                            <i class="bi bi-check-all me-1"></i>COMPLETED
                                                        </span>
                                                        <c:if test="${order.paymentStatus eq 'PAID'}">
                                                            <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1 rounded-pill fw-semibold ms-1" style="font-size: 0.7rem;">
                                                                PAID
                                                            </span>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status-cancelled px-3 py-2 rounded-pill fw-semibold">
                                                            <i class="bi bi-x-circle me-1"></i>CANCELLED
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/orders?action=detail&id=${order.id}" 
                                                   class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-semibold">
                                                    <i class="bi bi-eye me-1"></i>Xem Chi Tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-3 text-secondary"></i>
                                            Không tìm thấy đơn hàng nào phù hợp
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
