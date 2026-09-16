<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Đơn Hàng - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1.25rem 0; margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }
        .checkout-card {
            background: #FFFFFF; border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--card-shadow);
        }
        .payment-option-card {
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            cursor: pointer;
            transition: all 0.2s ease;
            background: #FFFFFF;
        }
        .payment-option-card:hover {
            border-color: #FF6B00;
            background: #FFF7F0;
        }
        .payment-option-card.selected {
            border-color: #FF6B00;
            background: #FFF7F0;
            box-shadow: 0 4px 14px rgba(255, 107, 0, 0.12);
        }
        .summary-img {
            width: 54px; height: 54px; border-radius: var(--radius-sm);
            border: 1px solid var(--border-color); object-fit: contain;
            background: #FFFFFF; padding: 0.25rem;
        }
        .btn-place-order {
            background: #FF6B00; color: #FFFFFF; border: none;
            border-radius: var(--radius-pill); padding: 0.9rem;
            font-weight: 700; font-size: 1.05rem; width: 100%;
            transition: all 0.2s ease; box-shadow: 0 4px 14px rgba(255, 107, 0, 0.25);
            display: flex; align-items: center; justify-content: center; gap: 0.5rem;
        }
        .btn-place-order:hover {
            background: #FF7A1A; color: #FFFFFF;
            box-shadow: 0 6px 20px rgba(255, 107, 0, 0.4);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

<!-- Navbar -->
<jsp:include page="/WEB-INF/views/common/customer-navbar.jsp"/>

<!-- Header -->
<div class="page-header">
    <div class="container">
        <h3 class="fw-bold mb-1 text-dark">Thanh Toán & Đặt Hàng</h3>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart" class="text-secondary text-decoration-none">Giỏ hàng</a></li>
                <li class="breadcrumb-item active" style="color:#FF6B00 !important; font-weight:600;">Thanh toán</li>
            </ol>
        </nav>
    </div>
</div>

<main class="container pb-5">
    <!-- Error alert -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 rounded-3 shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
            <div>${errorMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm" onsubmit="return validateAndSubmit(event);">
        <input type="hidden" name="action" value="process">

        <div class="row g-4">
            <!-- Left: Shipping & Payment Info -->
            <div class="col-lg-7">
                <!-- Shipping Info Card -->
                <div class="checkout-card p-4 mb-4">
                    <h5 class="fw-bold text-dark border-bottom pb-3 mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-geo-alt-fill text-primary" style="color:#FF6B00 !important;"></i> Thông Tin Giao Hàng
                    </h5>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label fw-semibold text-dark">Họ và tên người nhận <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   value="${customer != null ? customer.name : ''}" required placeholder="Ví dụ: Nguyễn Văn An">
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label fw-semibold text-dark">Số điện thoại nhận hàng <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="phone" name="phone" 
                                   value="${customer != null ? customer.phone : ''}" required placeholder="Ví dụ: 0912345678">
                        </div>
                        <div class="col-12">
                            <label for="email" class="form-label fw-semibold text-dark">Địa chỉ Email</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="${customer != null ? customer.email : ''}" placeholder="email@example.com (nhận thông báo đơn hàng)">
                        </div>
                        <div class="col-12">
                            <label for="address" class="form-label fw-semibold text-dark">Địa chỉ nhận hàng chi tiết <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="address" name="address" rows="3" required placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố">${customer != null ? customer.address : ''}</textarea>
                        </div>
                    </div>
                </div>

                <!-- Payment Method Card -->
                <div class="checkout-card p-4">
                    <h5 class="fw-bold text-dark border-bottom pb-3 mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-credit-card-2-front-fill text-primary" style="color:#FF6B00 !important;"></i> Phương Thức Thanh Toán
                    </h5>

                    <div class="d-flex flex-column gap-3">
                        <!-- COD Option -->
                        <div class="payment-option-card selected" id="codOption" onclick="selectPayment('cod')">
                            <div class="form-check d-flex align-items-center gap-3 ps-0 mb-0">
                                <input class="form-check-input ms-0 mt-0" type="radio" name="paymentMethod" id="payCOD" value="COD" checked>
                                <div class="flex-grow-1">
                                    <div class="fw-bold text-dark d-flex align-items-center gap-2">
                                        <i class="bi bi-cash-stack text-success fs-5"></i>
                                        <span>Thanh toán khi nhận hàng (COD)</span>
                                    </div>
                                    <small class="text-secondary">Bạn kiểm tra hàng trước và thanh toán tiền mặt trực tiếp cho nhân viên giao hàng.</small>
                                </div>
                            </div>
                        </div>

                        <!-- VNPay Option -->
                        <div class="payment-option-card" id="vnpayOption" onclick="selectPayment('vnpay')">
                            <div class="form-check d-flex align-items-center gap-3 ps-0 mb-0">
                                <input class="form-check-input ms-0 mt-0" type="radio" name="paymentMethod" id="payVNPAY" value="VNPAY">
                                <div class="flex-grow-1">
                                    <div class="fw-bold text-dark d-flex align-items-center gap-2">
                                        <i class="bi bi-qr-code-scan text-primary fs-5" style="color:#FF6B00 !important;"></i>
                                        <span>Cổng thanh toán VNPay QR / Thẻ ATM / Visa</span>
                                        <span class="badge badge-luxtech ms-auto">Khuyên dùng</span>
                                    </div>
                                    <small class="text-secondary">Quét mã VNPAY-QR hoặc dùng thẻ ATM, Internet Banking, Visa/Mastercard an toàn tiện lợi.</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Order Summary -->
            <div class="col-lg-5">
                <div class="checkout-card p-4">
                    <h5 class="fw-bold text-dark border-bottom pb-3 mb-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-bag-check-fill text-primary me-2" style="color:#FF6B00 !important;"></i>Đơn Hàng Của Bạn</span>
                        <span class="badge bg-light text-dark border">${cart.totalItems} sản phẩm</span>
                    </h5>

                    <!-- Order items list -->
                    <div class="mb-3" style="max-height: 280px; overflow-y: auto;">
                        <c:forEach var="item" items="${cart.items}">
                            <div class="d-flex align-items-center gap-3 py-2 border-bottom">
                                <c:choose>
                                    <c:when test="${not empty item.image and item.image.startsWith('http')}">
                                        <img src="${item.image}" alt="${item.name}" class="summary-img">
                                    </c:when>
                                    <c:when test="${not empty item.image}">
                                        <img src="${pageContext.request.contextPath}/assets/images/products/${item.image}"
                                             alt="${item.name}" class="summary-img">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="summary-img d-flex align-items-center justify-content-center text-muted">
                                            <i class="bi bi-box-seam fs-4"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="flex-grow-1 overflow-hidden">
                                    <div class="fw-semibold text-dark text-truncate small">${item.name}</div>
                                    <c:if test="${not empty item.color}">
                                        <small class="text-muted d-block" style="font-size:0.75rem;">Màu: ${item.color}</small>
                                    </c:if>
                                    <small class="text-secondary" style="font-size:0.8rem;">SL: ${item.quantity} × <fmt:formatNumber value="${item.price}" pattern="#,##0"/> ₫</small>
                                </div>
                                <div class="fw-bold text-dark text-end small">
                                    <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Price calculation -->
                    <div class="d-flex justify-content-between mb-2 small text-secondary">
                        <span>Tạm tính giỏ hàng:</span>
                        <span class="fw-semibold text-dark"><fmt:formatNumber value="${cart.total}" pattern="#,##0"/> ₫</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small text-secondary">
                        <span>Phí vận chuyển:</span>
                        <span class="badge bg-success-subtle text-success border border-success-subtle">Miễn phí toàn quốc</span>
                    </div>
                    <hr class="my-3">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <span class="fw-bold text-dark d-block">TỔNG THANH TOÁN</span>
                            <small class="text-muted">(Đã bao gồm thuế VAT)</small>
                        </div>
                        <span class="fs-4 fw-bold" style="color:#FF6B00;">
                            <fmt:formatNumber value="${cart.total}" pattern="#,##0"/> ₫
                        </span>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="btnSubmitOrder" class="btn-place-order">
                        <i class="bi bi-shield-check"></i>
                        <span id="btnText">Xác Nhận Đặt Hàng</span>
                        <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    </button>

                    <p class="text-center text-muted small mt-2 mb-0" style="font-size:0.75rem;">
                        Nhấn "Xác Nhận Đặt Hàng" đồng nghĩa bạn đồng ý với Điều khoản mua hàng của LuxTech.
                    </p>
                </div>
            </div>
        </div>
    </form>
</main>

<!-- Footer -->
<footer class="footer-luxtech py-4 text-center mt-auto">
    <div class="container">
        <p class="mb-1"><span style="color:#FF6B00; font-weight:700;">LUXTECH STORE</span> – Hệ Thống Bán Lẻ Thiết Bị Điện Tử</p>
        <p class="mb-0 small">© 2026 LuxTech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function selectPayment(type) {
        const codBox = document.getElementById('codOption');
        const vnpayBox = document.getElementById('vnpayOption');
        if (type === 'cod') {
            codBox.classList.add('selected');
            vnpayBox.classList.remove('selected');
            document.getElementById('payCOD').checked = true;
        } else {
            vnpayBox.classList.add('selected');
            codBox.classList.remove('selected');
            document.getElementById('payVNPAY').checked = true;
        }
    }

    function validateAndSubmit(e) {
        const name = document.getElementById('name').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const address = document.getElementById('address').value.trim();

        if (!name || name.length < 2) {
            alert('Vui lòng nhập họ và tên người nhận hợp lệ (ít nhất 2 ký tự).');
            document.getElementById('name').focus();
            return false;
        }

        const phoneRegex = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;
        if (!phone || !phoneRegex.test(phone)) {
            alert('Vui lòng nhập số điện thoại hợp lệ (10 số, bắt đầu bằng 03, 05, 07, 08, 09 hoặc +84).');
            document.getElementById('phone').focus();
            return false;
        }

        if (!address || address.length < 5) {
            alert('Vui lòng nhập địa chỉ giao hàng chi tiết (ít nhất 5 ký tự).');
            document.getElementById('address').focus();
            return false;
        }

        const btn = document.getElementById('btnSubmitOrder');
        const btnText = document.getElementById('btnText');
        const btnSpinner = document.getElementById('btnSpinner');

        btn.disabled = true;
        btnText.textContent = 'Đang xử lý đơn hàng...';
        btnSpinner.classList.remove('d-none');

        return true;
    }
</script>
</body>
</html>
