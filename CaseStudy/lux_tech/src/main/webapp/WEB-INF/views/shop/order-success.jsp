<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        .success-hero {
            background: linear-gradient(180deg, #F0FDF4 0%, #FFFFFF 100%);
            color: #111827;
            padding: 2.5rem 0 2rem;
            text-align: center;
            border-bottom: 1px solid #DCFCE7;
        }
        .success-icon-wrap {
            width: 72px; height: 72px; border-radius: 50%;
            background: rgba(34, 197, 94, 0.15);
            border: 2px solid #22C55E;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 2.2rem; color: #22C55E;
            margin-bottom: 1rem;
        }
        .order-card {
            background: #FFFFFF; border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--card-shadow);
        }
    </style>
</head>
<body>

<!-- Navbar -->
<jsp:include page="/WEB-INF/views/common/customer-navbar.jsp"/>

<!-- Success Hero -->
<div class="success-hero">
    <div class="container">
        <div class="success-icon-wrap">
            <i class="bi bi-check-lg"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">ĐẶT HÀNG THÀNH CÔNG!</h2>
        <p class="text-secondary mb-3">Cảm ơn quý khách đã tin tưởng mua sắm tại LuxTech Store.</p>
        <div class="badge px-3 py-2 rounded-pill fs-6" style="background: rgba(255,107,0,0.12); color:#FF6B00; border: 1px solid rgba(255,107,0,0.3); font-weight:700;">
            Mã đơn hàng: #ORD-${order.id}
        </div>
    </div>
</div>

<main class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="order-card p-4 p-md-5">
                <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4 flex-wrap gap-2">
                    <h5 class="fw-bold text-dark mb-0">Chi Tiết Đơn Hàng #ORD-${order.id}</h5>
                    <span class="badge badge-status-pending px-3 py-2 rounded-pill">
                        <i class="bi bi-hourglass-split me-1"></i>${order.status}
                    </span>
                </div>

                <!-- Customer info summary -->
                <div class="row g-3 mb-4 bg-light p-3 rounded-3 border">
                    <div class="col-sm-6">
                        <small class="text-muted d-block">Người nhận:</small>
                        <span class="fw-semibold text-dark">${customer != null ? customer.name : order.customerName}</span>
                    </div>
                    <div class="col-sm-6">
                        <small class="text-muted d-block">Số điện thoại:</small>
                        <span class="fw-semibold text-dark">${customer != null ? customer.phone : ''}</span>
                    </div>
                    <div class="col-sm-6">
                        <small class="text-muted d-block">Phương thức thanh toán:</small>
                        <span class="badge bg-light text-dark border">${order.paymentMethod != null ? order.paymentMethod : 'COD'}</span>
                    </div>
                    <div class="col-sm-6">
                        <small class="text-muted d-block">Tổng thanh toán:</small>
                        <span class="fw-bold" style="color:#FF6B00;"><fmt:formatNumber value="${order.total}" pattern="#,##0"/> ₫</span>
                    </div>
                    <div class="col-12">
                        <small class="text-muted d-block">Địa chỉ giao hàng:</small>
                        <span class="text-dark">${customer != null ? customer.address : ''}</span>
                    </div>
                </div>

                <!-- Products in Order -->
                <h6 class="fw-bold text-dark mb-3">Sản Phẩm Đã Đặt</h6>
                <div class="table-responsive mb-4">
                    <table class="table align-middle">
                        <thead class="table-light small">
                            <tr>
                                <th>Sản phẩm</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${order.orderDetails}" var="d">
                                <tr>
                                    <td class="fw-semibold">${d.productName}</td>
                                    <td class="text-end text-secondary"><fmt:formatNumber value="${d.price}" pattern="#,##0"/> ₫</td>
                                    <td class="text-center">${d.quantity}</td>
                                    <td class="text-end fw-bold"><fmt:formatNumber value="${d.subtotal}" pattern="#,##0"/> ₫</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Actions -->
                <div class="d-flex justify-content-center gap-3 flex-wrap pt-2">
                    <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-primary rounded-pill px-4">
                        <i class="bi bi-receipt me-2"></i>Xem Đơn Hàng Của Tôi
                    </a>
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        <i class="bi bi-house me-2"></i>Về Trang Chủ Mua Sắm
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="footer-luxtech py-4 text-center mt-auto">
    <div class="container">
        <p class="mb-1"><span style="color:#FF6B00; font-weight:700;">LUXTECH STORE</span> – Hệ Thống Bán Lẻ Thiết Bị Điện Tử</p>
        <p class="mb-0 small">© 2026 LuxTech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
