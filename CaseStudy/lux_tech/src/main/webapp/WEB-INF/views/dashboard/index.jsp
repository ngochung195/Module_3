<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="dashboard" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Thống Kê - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #111827;
        }
        .stat-card {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <!-- Main Container -->
    <div class="container-fluid px-4 pb-5">
        <!-- Page Title Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Dashboard Thống Kê Overview</h3>
                <p class="text-secondary mb-0">Tổng quan tình hình kinh doanh cửa hàng LuxTech</p>
            </div>
            <a href="${pageContext.request.contextPath}/orders?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                <i class="bi bi-cart-plus me-2"></i>Tạo Đơn Hàng Mới
            </a>
        </div>

        <!-- Summary Stat Cards -->
        <div class="row g-4 mb-4">
            <!-- 1. Total Products -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card stat-card p-3 bg-white h-100">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary me-3">
                            <i class="bi bi-phone"></i>
                        </div>
                        <div>
                            <span class="text-muted fs-6 d-block mb-1">Sản Phẩm</span>
                            <h3 class="fw-bold mb-0 text-dark">${totalProducts}</h3>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Pending Orders (Call to action) -->
            <div class="col-12 col-sm-6 col-xl-3">
                <a href="${pageContext.request.contextPath}/orders?status=PENDING" class="text-decoration-none">
                    <div class="card stat-card p-3 bg-white h-100 border-warning ${pendingOrders > 0 ? 'border-2' : ''}">
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <div class="stat-icon bg-warning bg-opacity-10 text-warning me-3">
                                    <i class="bi bi-hourglass-split"></i>
                                </div>
                                <div>
                                    <span class="text-muted fs-6 d-block mb-1">Đơn Chờ Xử Lý</span>
                                    <div class="d-flex align-items-baseline gap-2">
                                        <h3 class="fw-bold mb-0 text-warning">${pendingOrders}</h3>
                                        <c:if test="${pendingOrders > 0}">
                                            <span class="badge bg-danger animate-pulse">Cần duyệt</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <i class="bi bi-arrow-right-circle fs-4 text-muted"></i>
                        </div>
                    </div>
                </a>
            </div>

            <!-- 3. Total Orders & Sources -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card stat-card p-3 bg-white h-100">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon bg-info bg-opacity-10 text-info me-3">
                            <i class="bi bi-cart3"></i>
                        </div>
                        <div class="flex-grow-1">
                            <span class="text-muted fs-6 d-block mb-1">Tổng Đơn Hàng</span>
                            <div class="d-flex align-items-baseline justify-content-between">
                                <h3 class="fw-bold mb-0 text-dark">${totalOrders}</h3>
                                <div class="small text-end">
                                    <span class="badge bg-primary bg-opacity-10 text-primary me-1"><i class="bi bi-globe me-1"></i>${onlineOrders} Online</span>
                                    <span class="badge bg-secondary bg-opacity-10 text-secondary"><i class="bi bi-shop me-1"></i>${staffOrders} Quầy</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 4. Total Revenue & Online Revenue -->
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="card stat-card p-3 bg-white h-100">
                    <div class="d-flex align-items-center">
                        <div class="stat-icon bg-success bg-opacity-10 text-success me-3">
                            <i class="bi bi-cash-coin"></i>
                        </div>
                        <div>
                            <span class="text-muted fs-6 d-block mb-1">Doanh Thu</span>
                            <h4 class="fw-bold mb-0 text-success">
                                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> đ
                            </h4>
                            <small class="text-muted">Online: <fmt:formatNumber value="${onlineRevenue}" pattern="#,##0"/> đ</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Best Selling Products Section -->
        <div class="row">
            <div class="col-12">
                <div class="card border-0 rounded-4 shadow-sm">
                    <div class="card-header bg-white py-3 px-4 d-flex justify-content-between align-items-center border-0">
                        <h5 class="fw-bold mb-0 text-dark">
                            <i class="bi bi-fire text-danger me-2"></i>Top 5 Sản Phẩm Bán Chạy Nhất
                        </h5>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-sm btn-light border text-secondary rounded-pill px-3">
                            Xem tất cả sản phẩm <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4" style="width: 60px;">#</th>
                                        <th>Tên Sản Phẩm</th>
                                        <th>Danh Mục</th>
                                        <th class="text-end">Đơn Giá</th>
                                        <th class="text-center">Tồn Kho</th>
                                        <th class="text-center pe-4">Số Lượng Đã Bán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty topProducts}">
                                            <c:forEach var="prod" items="${topProducts}" varStatus="loop">
                                                <tr>
                                                    <td class="ps-4 fw-semibold text-secondary">${loop.count}</td>
                                                    <td>
                                                        <span class="fw-bold text-dark">${prod.name}</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-light text-dark border">${prod.categoryName}</span>
                                                    </td>
                                                    <td class="text-end fw-semibold text-primary">
                                                        <fmt:formatNumber value="${prod.price}" pattern="#,##0"/> VNĐ
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge ${prod.quantity > 5 ? 'bg-success-subtle text-success border border-success-subtle' : 'bg-danger-subtle text-danger border border-danger-subtle'}">
                                                            ${prod.quantity}
                                                        </span>
                                                    </td>
                                                    <td class="text-center pe-4">
                                                        <span class="badge bg-primary rounded-pill px-3 py-2 fs-6">
                                                            ${prod.totalSold} đã bán
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center py-4 text-muted">
                                                    Chưa có dữ liệu thống kê sản phẩm bán chạy.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
