<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="my-orders" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn Hàng Của Tôi - LuxTech Store</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">

    <style>
        :root {
            --primary: #FF6B00;
            --primary-hover: #FF7A1A;
            --dark: #171717;
            --surface-bg: #f8f9fa;
            --card-border: #e5e7eb;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--surface-bg);
            color: #111827;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        main {
            flex: 1;
        }

        /* Page Header */
        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1.25rem 0;
            margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }

        .btn-primary {
            background-color: #FF6B00 !important;
            border-color: #FF6B00 !important;
            color: #FFFFFF !important;
        }
        .btn-primary:hover {
            background-color: #FF7A1A !important;
            border-color: #FF7A1A !important;
            color: #FFFFFF !important;
        }

        /* Status Filter Tabs */
        .status-nav-tabs {
            background: white;
            border-radius: 16px;
            padding: 0.5rem;
            border: 1px solid var(--card-border);
            display: flex;
            gap: 0.5rem;
            overflow-x: auto;
            margin-bottom: 1.75rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        .status-nav-link {
            padding: 0.65rem 1.25rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.875rem;
            color: #6B7280;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .status-nav-link:hover {
            color: var(--primary);
            background: #fff7f0;
        }
        .status-nav-link.active {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 10px rgba(255, 107, 0, 0.25);
        }
        .status-badge-pill {
            padding: 0.15rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(0, 0, 0, 0.08);
        }
        .status-nav-link.active .status-badge-pill {
            background: rgba(255, 255, 255, 0.25);
            color: white;
        }

        /* Order Cards */
        .order-card {
            background: white;
            border-radius: 18px;
            border: 1px solid var(--card-border);
            margin-bottom: 1.25rem;
            transition: all 0.2s ease;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        .order-card:hover {
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.05);
            border-color: #cbd5e1;
        }
        .order-card-header {
            padding: 1.15rem 1.5rem;
            background: #ffffff;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.75rem;
        }
        .order-card-body {
            padding: 1.25rem 1.5rem;
        }
        .order-card-footer {
            padding: 1rem 1.5rem;
            background: #f8fafc;
            border-top: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        /* Status Badges */
        .badge-status-pending {
            background: #fef3c7;
            color: #92400e;
            border: 1px solid #fde68a;
        }
        .badge-status-confirmed {
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
        }
        .badge-status-completed {
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }
        .badge-status-cancelled {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        /* Empty orders */
        .empty-orders-card {
            background: white;
            border-radius: 20px;
            border: 1px solid var(--card-border);
            padding: 4.5rem 2rem;
            text-align: center;
        }
        .empty-orders-icon {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: #fff7f0;
            color: var(--primary);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 2.75rem;
            margin-bottom: 1.25rem;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/customer-navbar.jsp" %>

<main>
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1 small">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none">Trang chủ</a></li>
                    <li class="breadcrumb-item active" style="color:#FF6B00 !important; font-weight:600;">Đơn hàng của tôi</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                <i class="bi bi-receipt-cutoff" style="color:#FF6B00;"></i>
                Đơn Hàng Của Tôi
            </h3>
            <p class="mb-0 text-secondary small">
                Theo dõi tiến độ giao nhận và lịch sử mua sắm tại LuxTech Store
            </p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- Flash Messages -->
        <c:if test="${not empty flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div>${flashSuccess}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <c:if test="${not empty flashError}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div>${flashError}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <!-- Status Filter Tabs -->
        <div class="status-nav-tabs">
            <a href="${pageContext.request.contextPath}/my-orders?status=ALL" 
               class="status-nav-link ${selectedStatus == 'ALL' ? 'active' : ''}">
                <i class="bi bi-collection"></i> Tất cả
                <span class="status-badge-pill">${countAll}</span>
            </a>

            <a href="${pageContext.request.contextPath}/my-orders?status=PENDING" 
               class="status-nav-link ${selectedStatus == 'PENDING' ? 'active' : ''}">
                <i class="bi bi-clock-history"></i> Chờ xác nhận
                <span class="status-badge-pill">${countPending}</span>
            </a>

            <a href="${pageContext.request.contextPath}/my-orders?status=CONFIRMED" 
               class="status-nav-link ${selectedStatus == 'CONFIRMED' ? 'active' : ''}">
                <i class="bi bi-check2-circle"></i> Đã xác nhận
                <span class="status-badge-pill">${countConfirmed}</span>
            </a>

            <a href="${pageContext.request.contextPath}/my-orders?status=COMPLETED" 
               class="status-nav-link ${selectedStatus == 'COMPLETED' ? 'active' : ''}">
                <i class="bi bi-box2-heart"></i> Hoàn thành
                <span class="status-badge-pill">${countCompleted}</span>
            </a>

            <a href="${pageContext.request.contextPath}/my-orders?status=CANCELLED" 
               class="status-nav-link ${selectedStatus == 'CANCELLED' ? 'active' : ''}">
                <i class="bi bi-x-circle"></i> Đã hủy
                <span class="status-badge-pill">${countCancelled}</span>
            </a>
        </div>

        <!-- Orders List -->
        <c:choose>
            <c:when test="${not empty orders}">
                <div class="order-list">
                    <c:forEach var="order" items="${orders}">
                        <div class="order-card">
                            <!-- Card Header -->
                            <div class="order-card-header">
                                <div class="d-flex align-items-center gap-3">
                                    <span class="fw-bold text-dark fs-6">
                                        <i class="bi bi-receipt me-1 text-primary"></i>#ORD-${order.id}
                                    </span>
                                    <span class="text-muted" style="font-size: 0.85rem;">
                                        <i class="bi bi-calendar3 me-1"></i>
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </span>
                                </div>

                                <!-- Status Badge -->
                                <div>
                                    <c:choose>
                                        <c:when test="${order.status == 'PAID'}">
                                            <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle px-3 py-2 rounded-pill fw-semibold" style="font-size: 0.8rem;">
                                                <i class="bi bi-check-circle me-1"></i>Đã thanh toán (VNPay)
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'PENDING'}">
                                            <span class="badge badge-status-pending px-3 py-2 rounded-pill fw-semibold" style="font-size: 0.8rem;">
                                                <i class="bi bi-hourglass-split me-1"></i>Chờ xác nhận
                                            </span>
                                        </c:when>
                                        <c:when test="${order.status == 'CONFIRMED'}">
                                            <span class="badge badge-status-confirmed px-3 py-2 rounded-pill fw-semibold" style="font-size: 0.8rem;">
                                                <i class="bi bi-truck me-1"></i>Đã xác nhận & Giao hàng
                                            </span>
                                            <c:if test="${order.paymentStatus == 'PAID'}">
                                                <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle px-2 py-1 rounded-pill fw-semibold ms-1" style="font-size: 0.75rem;">
                                                    <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                </span>
                                            </c:if>
                                        </c:when>
                                        <c:when test="${order.status == 'COMPLETED'}">
                                            <span class="badge badge-status-completed px-3 py-2 rounded-pill fw-semibold" style="font-size: 0.8rem;">
                                                <i class="bi bi-check-all me-1"></i>Hoàn thành
                                            </span>
                                            <c:if test="${order.paymentStatus == 'PAID'}">
                                                <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle px-2 py-1 rounded-pill fw-semibold ms-1" style="font-size: 0.75rem;">
                                                    <i class="bi bi-check-circle me-1"></i>Đã thanh toán
                                                </span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-status-cancelled px-3 py-2 rounded-pill fw-semibold" style="font-size: 0.8rem;">
                                                <i class="bi bi-x-circle me-1"></i>Đã hủy
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Card Body -->
                            <div class="order-card-body">
                                <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                                    <div>
                                        <div class="text-muted" style="font-size: 0.85rem;">Người nhận:</div>
                                        <div class="fw-semibold text-dark">${order.customerName}</div>
                                    </div>
                                    <div>
                                        <div class="text-muted" style="font-size: 0.85rem;">Hình thức thanh toán:</div>
                                        <div class="fw-medium text-dark">
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'VNPAY'}">
                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 rounded">
                                                        <i class="bi bi-qr-code me-1"></i>VNPay
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-cash me-1 text-success"></i>Thanh toán khi nhận hàng (COD)
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="text-muted" style="font-size: 0.85rem;">Tổng tiền thanh toán:</div>
                                        <div class="fw-bold fs-5 text-primary">
                                            <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Card Footer: Actions -->
                            <div class="order-card-footer">
                                <div class="text-muted" style="font-size: 0.8rem;">
                                    <i class="bi bi-shield-check text-success me-1"></i>Được bảo hiểm an toàn giao dịch bởi LuxTech
                                </div>

                                <div class="d-flex align-items-center gap-2">
                                    <!-- Retry VNPay button if PENDING and VNPAY -->
                                    <c:if test="${order.status == 'PENDING' and order.paymentMethod == 'VNPAY'}">
                                        <a href="${pageContext.request.contextPath}/checkout?action=retryVNPay&orderId=${order.id}" 
                                           class="btn btn-warning btn-sm px-3 rounded-pill fw-semibold text-dark">
                                            <i class="bi bi-credit-card me-1"></i>Thanh toán VNPay
                                        </a>
                                    </c:if>

                                    <!-- Cancel button (ONLY if status == PENDING) -->
                                    <c:if test="${order.status == 'PENDING'}">
                                        <form action="${pageContext.request.contextPath}/my-orders" method="post" class="m-0"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #ORD-${order.id}? Số lượng sản phẩm sẽ được tự động hoàn trả lại kho hàng.');">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="id" value="${order.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm px-3 rounded-pill fw-semibold">
                                                <i class="bi bi-x-circle me-1"></i>Hủy đơn hàng
                                            </button>
                                        </form>
                                    </c:if>

                                    <!-- View Detail Button -->
                                    <a href="${pageContext.request.contextPath}/my-orders?action=detail&id=${order.id}" 
                                       class="btn btn-outline-primary btn-sm px-3 rounded-pill fw-semibold">
                                        <i class="bi bi-eye me-1"></i>Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-orders-card">
                    <div class="empty-orders-icon">
                        <i class="bi bi-bag-x"></i>
                    </div>
                    <h4 class="fw-bold text-dark mb-2">Chưa Có Đơn Hàng Nào</h4>
                    <p class="text-muted mb-4" style="max-width: 420px; margin: 0 auto;">
                        <c:choose>
                            <c:when test="${selectedStatus != 'ALL'}">
                                Không có đơn hàng nào ở trạng thái này. Vui lòng chọn tab khác hoặc tiếp tục mua sắm.
                            </c:when>
                            <c:otherwise>
                                Bạn chưa phát sinh giao dịch mua sắm nào. Hãy dạo quanh cửa hàng và chọn những thiết bị công nghệ ưng ý nhất!
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold">
                        <i class="bi bi-cart-plus me-1"></i>Khám Phá Cửa Hàng Ngay
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<!-- Footer -->
<footer class="bg-white border-top py-4 text-center text-muted" style="font-size: 0.875rem;">
    <div class="container">
        <p class="mb-1 fw-medium text-dark">© 2026 LuxTech Store - Đẳng Cấp Công Nghệ Số</p>
        <p class="mb-0 text-muted" style="font-size: 0.8rem;">Hệ thống chăm sóc khách hàng 24/7 - Hotline: 1800 6868</p>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
