<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${paymentSuccess ? 'Thanh Toán Thành Công' : 'Thanh Toán Thất Bại'} - LuxTech Store</title>

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
            --success: #10b981;
            --danger: #ef4444;
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

        /* Success Hero */
        .result-hero.success {
            background: linear-gradient(180deg, #F0FDF4 0%, #FFFFFF 100%);
            color: #111827;
            padding: 2.5rem 0 2rem;
            text-align: center;
            border-bottom: 1px solid #DCFCE7;
        }

        /* Failed Hero */
        .result-hero.failed {
            background: linear-gradient(180deg, #FEF2F2 0%, #FFFFFF 100%);
            color: #111827;
            padding: 2.5rem 0 2rem;
            text-align: center;
            border-bottom: 1px solid #FEE2E2;
        }

        .icon-wrap-success {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: rgba(16, 185, 129, 0.2);
            border: 3px solid #10b981;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #34d399;
            margin-bottom: 1.25rem;
            animation: popIn 0.5s ease-out;
        }

        .icon-wrap-failed {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: rgba(239, 68, 68, 0.2);
            border: 3px solid #ef4444;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: #f87171;
            margin-bottom: 1.25rem;
            animation: popIn 0.5s ease-out;
        }

        @keyframes popIn {
            0% { transform: scale(0.6); opacity: 0; }
            80% { transform: scale(1.08); }
            100% { transform: scale(1); opacity: 1; }
        }

        .order-badge {
            display: inline-block;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
            padding: 0.5rem 1.25rem;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1.1rem;
            letter-spacing: 0.5px;
            margin-top: 0.5rem;
        }
        .order-badge.success-code {
            color: #a7f3d0;
        }
        .order-badge.failed-code {
            color: #fecdd3;
        }

        .content-card {
            background: white;
            border-radius: 20px;
            border: 1px solid var(--card-border);
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: #171717;
            display: flex;
            align-items: center;
            gap: 0.6rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 1.5px solid #f1f5f9;
        }

        .info-label {
            font-size: 0.85rem;
            color: #6B7280;
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 1rem;
            font-weight: 600;
            color: #171717;
        }

        .btn-action-primary {
            background: linear-gradient(135deg, #FF6B00 0%, #FF7A1A 100%);
            color: white;
            border-radius: 12px;
            padding: 0.85rem 1.75rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(255, 107, 0, 0.3);
        }
        .btn-action-primary:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 6px 16px rgba(255, 107, 0, 0.4);
        }

        .btn-action-retry {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            color: white;
            border-radius: 12px;
            padding: 0.85rem 1.75rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
        }
        .btn-action-retry:hover {
            transform: translateY(-2px);
            color: white;
            box-shadow: 0 6px 16px rgba(220, 38, 38, 0.4);
        }

        .btn-action-secondary {
            background: white;
            color: #334155;
            border: 1.5px solid #cbd5e1;
            border-radius: 12px;
            padding: 0.85rem 1.75rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }
        .btn-action-secondary:hover {
            background: #f8fafc;
            border-color: #94a3b8;
            color: #0f172a;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/customer-navbar.jsp" %>

<main>
    <c:choose>
        <%-- ======================================================= --%>
        <%-- 1. THANH TOÁN THÀNH CÔNG                                --%>
        <%-- ======================================================= --%>
        <c:when test="${paymentSuccess}">
            <div class="result-hero success">
                <div class="container">
                    <div class="icon-wrap-success">
                        <i class="bi bi-check-lg"></i>
                    </div>
                    <h2 class="fw-bold fs-2 mb-2 text-dark">THANH TOÁN THÀNH CÔNG</h2>
                    <p class="text-secondary mb-3" style="font-size: 1rem;">
                        Giao dịch thanh toán trực tuyến qua cổng VNPay đã được xác thực thành công.
                    </p>
                    <c:if test="${not empty order}">
                        <div>
                            <span class="order-badge success-code">
                                <i class="bi bi-receipt me-1"></i> Mã đơn hàng: #ORD-${order.id}
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="container my-5" style="max-width: 860px;">
                <!-- Success Alert Banner -->
                <div class="alert alert-success d-flex align-items-center gap-3 rounded-4 shadow-sm mb-4 border-0 p-3" style="background:#ecfdf5; border-left: 5px solid #10b981 !important;">
                    <i class="bi bi-shield-fill-check fs-3 text-success flex-shrink-0"></i>
                    <div style="font-size: 0.925rem; color: #065f46;">
                        <strong>Giao dịch bảo mật:</strong> Chữ ký điện tử HMAC-SHA512 đã được kiểm định hợp lệ. Đơn hàng của bạn đã chuyển sang trạng thái <strong>Đã thanh toán (PAID)</strong>.
                    </div>
                </div>

                <!-- Transaction Details Card -->
                <div class="content-card">
                    <div class="section-title">
                        <i class="bi bi-credit-card-2-front text-success"></i>
                        <span>Chi Tiết Giao Dịch VNPay</span>
                    </div>

                    <div class="row g-4">
                        <div class="col-sm-6 col-md-4">
                            <div class="info-label">Mã đơn hàng:</div>
                            <div class="info-value text-primary">#ORD-${order.id}</div>
                        </div>

                        <div class="col-sm-6 col-md-4">
                            <div class="info-label">Phương thức:</div>
                            <div class="info-value">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 rounded">
                                    <i class="bi bi-qr-code me-1"></i>VNPay Sandbox
                                </span>
                            </div>
                        </div>

                        <div class="col-sm-6 col-md-4">
                            <div class="info-label">Số tiền:</div>
                            <div class="info-value text-success fs-5">
                                <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                            </div>
                        </div>

                        <div class="col-sm-6 col-md-4">
                            <div class="info-label">Trạng thái đơn:</div>
                            <div>
                                <span class="badge bg-success-subtle text-success-emphasis border border-success-subtle px-3 py-2 fw-bold rounded-pill">
                                    <i class="bi bi-check-circle me-1"></i>Đã thanh toán (PAID)
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty vnPayResult.transactionNo}">
                            <div class="col-sm-6 col-md-4">
                                <div class="info-label">Mã giao dịch VNPay:</div>
                                <div class="info-value text-muted font-monospace">${vnPayResult.transactionNo}</div>
                            </div>
                        </c:if>

                        <c:if test="${not empty vnPayResult.bankCode}">
                            <div class="col-sm-6 col-md-4">
                                <div class="info-label">Ngân hàng thanh toán:</div>
                                <div class="info-value text-dark">${vnPayResult.bankCode}</div>
                            </div>
                        </c:if>

                        <div class="col-sm-6 col-md-6">
                            <div class="info-label">Khách hàng:</div>
                            <div class="info-value">${customer != null ? customer.name : order.customerName}</div>
                        </div>

                        <div class="col-sm-6 col-md-6">
                            <div class="info-label">Địa chỉ nhận hàng:</div>
                            <div class="info-value text-muted" style="font-size: 0.95rem;">${customer != null ? customer.address : 'Theo thông tin đơn'}</div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex align-items-center justify-content-center flex-wrap gap-3 mt-4">
                    <a href="${pageContext.request.contextPath}/checkout?action=success&orderId=${order.id}" class="btn-action-primary">
                        <i class="bi bi-receipt"></i> Xem Đơn Hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/shop" class="btn-action-secondary">
                        <i class="bi bi-bag"></i> Tiếp Tục Mua Sắm
                    </a>
                </div>
            </div>
        </c:when>

        <%-- ======================================================= --%>
        <%-- 2. THANH TOÁN THẤT BẠI / HỦY BỎ                         --%>
        <%-- ======================================================= --%>
        <c:otherwise>
            <div class="result-hero failed">
                <div class="container">
                    <div class="icon-wrap-failed">
                        <i class="bi bi-x-lg"></i>
                    </div>
                    <h2 class="fw-bold fs-2 mb-2 text-dark">THANH TOÁN THẤT BẠI</h2>
                    <p class="text-secondary mb-3" style="font-size: 1rem;">
                        ${not empty errorMessage ? errorMessage : 'Giao dịch thanh toán qua VNPay không thành công hoặc đã bị hủy.'}
                    </p>
                    <c:if test="${not empty order}">
                        <div>
                            <span class="order-badge failed-code">
                                <i class="bi bi-receipt me-1"></i> Mã đơn hàng: #ORD-${order.id}
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="container my-5" style="max-width: 860px;">
                <!-- Warning Notification Banner -->
                <div class="alert alert-danger d-flex align-items-center gap-3 rounded-4 shadow-sm mb-4 border-0 p-3" style="background:#fef2f2; border-left: 5px solid #ef4444 !important;">
                    <i class="bi bi-exclamation-triangle-fill fs-3 text-danger flex-shrink-0"></i>
                    <div style="font-size: 0.925rem; color: #991b1b;">
                        <strong>Thông báo:</strong> Đơn hàng của bạn vẫn được lưu tạm ở trạng thái <strong>Chờ xác nhận (PENDING)</strong>. Bạn có thể bấm nút <strong>[Thử thanh toán lại]</strong> để tiếp tục thanh toán qua VNPay mà không bị mất sản phẩm trong giỏ.
                    </div>
                </div>

                <!-- Transaction Details Card -->
                <div class="content-card">
                    <div class="section-title">
                        <i class="bi bi-info-circle text-danger"></i>
                        <span>Thông Tin Chi Tiết Giao Dịch</span>
                    </div>

                    <div class="row g-4">
                        <c:if test="${not empty order}">
                            <div class="col-sm-6 col-md-4">
                                <div class="info-label">Mã đơn hàng:</div>
                                <div class="info-value text-primary">#ORD-${order.id}</div>
                            </div>
                        </c:if>

                        <div class="col-sm-6 col-md-4">
                            <div class="info-label">Phương thức:</div>
                            <div class="info-value">
                                <span class="badge bg-secondary-subtle text-secondary border px-2 py-1 rounded">
                                    <i class="bi bi-qr-code me-1"></i>VNPay
                                </span>
                            </div>
                        </div>

                        <c:if test="${not empty order.total}">
                            <div class="col-sm-6 col-md-4">
                                <div class="info-label">Số tiền cần thanh toán:</div>
                                <div class="info-value text-dark fs-5">
                                    <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                                </div>
                            </div>
                        </c:if>

                        <div class="col-sm-6 col-md-6">
                            <div class="info-label">Lý do thất bại:</div>
                            <div class="info-value text-danger">
                                <i class="bi bi-x-circle me-1"></i>${not empty errorMessage ? errorMessage : 'Khách hàng hủy hoặc hết hạn giao dịch.'}
                            </div>
                        </div>

                        <c:if test="${not empty vnPayResult.responseCode}">
                            <div class="col-sm-6 col-md-6">
                                <div class="info-label">Mã phản hồi từ VNPay:</div>
                                <div class="info-value font-monospace">${vnPayResult.responseCode}</div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex align-items-center justify-content-center flex-wrap gap-3 mt-4">
                    <c:if test="${not empty order}">
                        <a href="${pageContext.request.contextPath}/checkout?action=retryVNPay&orderId=${order.id}" class="btn-action-retry">
                            <i class="bi bi-arrow-repeat"></i> Thử Thanh Toán Lại
                        </a>
                        <a href="${pageContext.request.contextPath}/checkout?action=success&orderId=${order.id}" class="btn-action-secondary">
                            <i class="bi bi-receipt"></i> Xem Đơn Hàng
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/shop" class="btn-action-secondary">
                        <i class="bi bi-shop"></i> Về Cửa Hàng
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<!-- Footer -->
<footer class="bg-white border-top py-4 text-center text-muted mt-auto" style="font-size: 0.875rem;">
    <div class="container">
        <p class="mb-1 fw-medium text-dark">© 2026 LuxTech Store - Cổng Thanh Toán VNPay Sandbox</p>
        <p class="mb-0 text-muted" style="font-size: 0.8rem;">Mọi giao dịch được bảo mật đa tầng HMAC-SHA512 theo tiêu chuẩn quốc tế</p>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
