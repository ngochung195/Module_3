<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="my-orders" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #ORD-${order.id} - LuxTech Store</title>

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

        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1.25rem 0;
            margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }

        .detail-card {
            background: white;
            border-radius: 18px;
            border: 1px solid var(--card-border);
            padding: 1.75rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .card-title-custom {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.6rem;
            margin-bottom: 1.25rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #f1f5f9;
        }

        /* Order Progress Tracker */
        .progress-track {
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            margin: 1.5rem 0 2rem;
            padding: 0 1rem;
        }
        .progress-track::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 5%;
            width: 90%;
            height: 4px;
            background: #e2e8f0;
            z-index: 1;
        }
        .track-step {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            width: 120px;
        }
        .track-icon {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #ffffff;
            border: 3px solid #e2e8f0;
            color: #94a3b8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }
        .track-step.active .track-icon {
            border-color: var(--primary);
            background: var(--primary);
            color: white;
            box-shadow: 0 0 0 5px rgba(255, 107, 0, 0.15);
        }
        .track-step.completed .track-icon {
            border-color: #10b981;
            background: #10b981;
            color: white;
        }
        .track-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: #64748b;
        }
        .track-step.active .track-label {
            color: var(--primary);
            font-weight: 700;
        }
        .track-step.completed .track-label {
            color: #10b981;
        }

        /* Order Items */
        .detail-item-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .detail-item-row:last-child {
            border-bottom: none;
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/my-orders" class="text-secondary text-decoration-none">Đơn hàng của tôi</a></li>
                    <li class="breadcrumb-item active" style="color:#FF6B00 !important; font-weight:600;">Chi tiết #ORD-${order.id}</li>
                </ol>
            </nav>
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                <div>
                    <h3 class="fw-bold mb-1 text-dark">
                        Chi Tiết Đơn Hàng #ORD-${order.id}
                    </h3>
                    <p class="mb-0 text-secondary small">
                        Ngày đặt hàng: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" />
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                        <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5" style="max-width: 900px;">
        <!-- Order Progress Tracker (chỉ hiển thị nếu đơn chưa bị hủy) -->
        <div class="detail-card">
            <c:choose>
                <c:when test="${order.status == 'CANCELLED'}">
                    <div class="alert alert-danger d-flex align-items-center gap-3 rounded-4 mb-0 border-0 p-3" style="background:#fef2f2;">
                        <i class="bi bi-x-circle-fill fs-2 text-danger flex-shrink-0"></i>
                        <div>
                            <h6 class="fw-bold text-danger mb-1">Đơn hàng này đã bị hủy</h6>
                            <p class="mb-0 text-muted" style="font-size: 0.875rem;">
                                Đơn hàng đã được hủy và toàn bộ số lượng sản phẩm đã được hoàn trả lại tồn kho của hệ thống.
                            </p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="progress-track">
                        <!-- Step 1: PENDING / PAID -->
                        <div class="track-step ${order.status == 'PENDING' ? 'active' : (order.status == 'PAID' || order.status == 'CONFIRMED' || order.status == 'COMPLETED' ? 'completed' : '')}">
                            <div class="track-icon">
                                <i class="bi ${order.status == 'PAID' || order.status == 'CONFIRMED' || order.status == 'COMPLETED' ? 'bi-check-lg' : 'bi-hourglass-split'}"></i>
                            </div>
                            <span class="track-label">${order.status == 'PAID' ? '1. Đã thanh toán (VNPay)' : '1. Chờ xác nhận'}</span>
                        </div>

                        <!-- Step 2: CONFIRMED -->
                        <div class="track-step ${order.status == 'CONFIRMED' ? 'active' : (order.status == 'COMPLETED' ? 'completed' : '')}">
                            <div class="track-icon">
                                <i class="bi ${order.status == 'COMPLETED' ? 'bi-check-lg' : 'bi-truck'}"></i>
                            </div>
                            <span class="track-label">2. Đã xác nhận & Giao hàng</span>
                        </div>

                        <!-- Step 3: COMPLETED -->
                        <div class="track-step ${order.status == 'COMPLETED' ? 'completed active' : ''}">
                            <div class="track-icon">
                                <i class="bi bi-box2-heart"></i>
                            </div>
                            <span class="track-label">3. Giao thành công</span>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Order Information Detail Card -->
        <div class="detail-card">
            <div class="card-title-custom">
                <i class="bi bi-person-lines-fill text-primary"></i>
                <span>Thông Tin Nhận Hàng & Thanh Toán</span>
            </div>

            <div class="row g-3">
                <div class="col-md-6">
                    <div class="text-muted small">Người nhận:</div>
                    <div class="fw-bold text-dark">${customer != null ? customer.name : order.customerName}</div>
                </div>
                <div class="col-md-6">
                    <div class="text-muted small">Số điện thoại:</div>
                    <div class="fw-bold text-dark">${customer != null ? customer.phone : 'Chưa cập nhật'}</div>
                </div>
                <div class="col-md-6">
                    <div class="text-muted small">Địa chỉ nhận hàng:</div>
                    <div class="fw-medium text-dark">${customer != null ? customer.address : 'Chưa cập nhật'}</div>
                </div>
                <div class="col-md-6">
                    <div class="text-muted small">Phương thức thanh toán:</div>
                    <div class="fw-medium text-dark">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'VNPAY'}">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 rounded">
                                    <i class="bi bi-qr-code me-1"></i>VNPay
                                </span>
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'PAID' or order.status == 'PAID'}">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle ms-1">Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle ms-1">Chưa thanh toán</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-cash-stack text-success me-1"></i>Thanh toán khi nhận hàng (COD)
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Items Detail -->
        <div class="detail-card">
            <div class="card-title-custom justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-bag-check-fill text-primary"></i>
                    <span>Danh Sách Sản Phẩm</span>
                </div>
                <span class="badge bg-light text-dark border px-2 py-1 rounded-pill">
                    ${order.orderDetails != null ? order.orderDetails.size() : 0} mặt hàng
                </span>
            </div>

            <div>
                <c:forEach var="detail" items="${order.orderDetails}">
                    <div class="detail-item-row">
                        <div>
                            <div class="fw-bold text-dark fs-6 mb-1">${detail.productName}</div>
                            <div class="text-muted small">
                                Đơn giá: <fmt:formatNumber value="${detail.price}" type="number" groupingUsed="true"/> ₫ 
                                × Số lượng: <strong class="text-dark">${detail.quantity}</strong>
                            </div>
                        </div>
                        <div class="fw-bold text-dark text-end fs-6">
                            <fmt:formatNumber value="${detail.subtotal}" type="number" groupingUsed="true"/> ₫
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Total price calculation -->
            <div class="pt-3 mt-3 border-top">
                <div class="d-flex justify-content-between text-muted mb-2 small">
                    <span>Tạm tính tiền hàng:</span>
                    <span class="fw-semibold text-dark">
                        <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                    </span>
                </div>
                <div class="d-flex justify-content-between text-muted mb-3 small">
                    <span>Phí vận chuyển:</span>
                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-0.5 fw-bold">
                        Miễn phí toàn quốc
                    </span>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                    <div class="fw-bold fs-5 text-dark">TỔNG THANH TOÁN:</div>
                    <div class="fw-bold fs-4 text-primary">
                        <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                    </div>
                </div>
            </div>
        </div>

        <!-- Retry VNPay Payment Banner (Only if PENDING and VNPAY) -->
        <c:if test="${order.status == 'PENDING' and order.paymentMethod == 'VNPAY'}">
            <div class="detail-card text-center p-4 border-warning-subtle mb-4" style="background: #fffbeb;">
                <h6 class="fw-bold text-dark mb-2">Đơn hàng chưa hoàn tất thanh toán VNPay</h6>
                <p class="text-muted mb-3 small" style="max-width: 500px; margin: 0 auto;">
                    Đơn hàng đang ở trạng thái Chờ thanh toán. Bạn có thể bấm nút bên dưới để thanh toán ngay qua cổng VNPay Sandbox mà không tạo đơn hàng mới.
                </p>
                <a href="${pageContext.request.contextPath}/checkout?action=retryVNPay&orderId=${order.id}" 
                   class="btn btn-warning rounded-pill px-4 py-2 fw-semibold text-dark shadow-sm">
                    <i class="bi bi-credit-card me-1"></i>Tiếp Tục Thanh Toán Qua VNPay
                </a>
            </div>
        </c:if>

        <!-- Cancel Order Action (Only if PENDING) -->
        <c:if test="${order.status == 'PENDING'}">
            <div class="detail-card text-center p-4 border-danger-subtle" style="background: #fffafa;">
                <h6 class="fw-bold text-danger mb-2">Bạn có muốn hủy đơn hàng này?</h6>
                <p class="text-muted mb-3 small" style="max-width: 500px; margin: 0 auto;">
                    Lưu ý: Chỉ có thể hủy khi đơn hàng chưa được cửa hàng xác nhận xuất kho. Toàn bộ số lượng sản phẩm trong đơn sẽ được tự động hoàn trả lại kho hàng.
                </p>
                <form action="${pageContext.request.contextPath}/my-orders" method="post" class="m-0"
                      onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng #ORD-${order.id}? Hành động này không thể hoàn tác.');">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id" value="${order.id}">
                    <button type="submit" class="btn btn-danger rounded-pill px-4 py-2 fw-semibold">
                        <i class="bi bi-x-circle me-1"></i>Xác Nhận Hủy Đơn Hàng
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</main>

<!-- Footer -->
<footer class="bg-white border-top py-4 text-center text-muted" style="font-size: 0.875rem;">
    <div class="container">
        <p class="mb-1 fw-medium text-dark">© 2026 LuxTech Store - Đẳng Cấp Công Nghệ Số</p>
        <p class="mb-0 text-muted" style="font-size: 0.8rem;">Hỗ trợ khách hàng: 1800 6868</p>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
