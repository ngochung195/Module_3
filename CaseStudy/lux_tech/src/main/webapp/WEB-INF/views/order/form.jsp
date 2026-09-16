<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="orders" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Đơn Hàng Tại Quầy - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .card-form {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            max-width: 720px;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5">
        <!-- Header -->
        <div class="mb-4 text-center">
            <h3 class="fw-bold text-dark mb-1">Tạo Đơn Hàng Tại Quầy (Staff POS)</h3>
            <p class="text-secondary mb-0">Tạo đơn hàng trực tiếp cho khách mua tại cửa hàng với nguồn STAFF</p>
        </div>

        <div class="card card-form bg-white">
            <div class="card-body p-4 p-md-5">
                <!-- Flash Error Alert -->
                <c:if test="${not empty flashError}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 rounded-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                        <div>${flashError}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/orders" method="post" id="createOrderForm">
                    <input type="hidden" name="action" value="create">

                    <!-- Customer Selection -->
                    <div class="mb-4">
                        <label for="customerId" class="form-label fw-semibold text-dark">
                            Khách Hàng <span class="text-danger">*</span>
                        </label>
                        <select class="form-select form-select-lg bg-light" id="customerId" name="customerId" required>
                            <option value="">-- Chọn khách hàng --</option>
                            <c:forEach var="c" items="${customers}">
                                <option value="${c.id}">${c.name} - SĐT: ${c.phone} (${c.email})</option>
                            </c:forEach>
                        </select>
                        <div class="form-text">
                            Chưa có khách hàng? <a href="${pageContext.request.contextPath}/customers?action=create" target="_blank">Thêm khách hàng mới</a>
                        </div>
                    </div>

                    <!-- Product Selection -->
                    <div class="mb-4">
                        <label for="productId" class="form-label fw-semibold text-dark">
                            Sản Phẩm <span class="text-danger">*</span>
                        </label>
                        <select class="form-select form-select-lg bg-light" id="productId" name="productId" required onchange="calculateTotal()">
                            <option value="" data-price="0" data-stock="0">-- Chọn sản phẩm --</option>
                            <c:forEach var="p" items="${products}">
                                <c:if test="${p.quantity > 0}">
                                    <option value="${p.id}" data-price="${p.price}" data-stock="${p.quantity}">
                                        ${p.name} - <fmt:formatNumber value="${p.price}" pattern="#,##0"/> đ (Kho: ${p.quantity})
                                    </option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Quantity -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="quantity" class="form-label fw-semibold text-dark">
                                Số Lượng Mua <span class="text-danger">*</span>
                            </label>
                            <input type="number" class="form-control form-control-lg bg-light" id="quantity" 
                                   name="quantity" min="1" value="1" required oninput="calculateTotal()">
                            <div id="stockHint" class="form-text text-muted"></div>
                        </div>

                        <div class="col-md-6">
                            <label for="paymentMethod" class="form-label fw-semibold text-dark">
                                Hình Thức Thanh Toán
                            </label>
                            <select class="form-select form-select-lg bg-light" id="paymentMethod" name="paymentMethod">
                                <option value="COD">Tiền mặt tại quầy</option>
                                <option value="BANK_TRANSFER">Chuyển khoản / Quẹt thẻ</option>
                                <option value="VNPAY">Cổng VNPay QR</option>
                            </select>
                        </div>
                    </div>

                    <!-- Total Price Preview Box -->
                    <div class="card bg-light border-0 rounded-4 p-4 mb-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-secondary fw-semibold d-block">Tạm tính thành tiền</span>
                                <small class="text-muted">Đơn giá × Số lượng</small>
                            </div>
                            <div class="text-end">
                                <span class="fs-3 fw-bold text-primary" id="totalPreview">0 đ</span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-end gap-3 pt-2">
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="bi bi-arrow-left me-1"></i>Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 shadow-sm fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i>Tạo Đơn Hàng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function calculateTotal() {
            const productSelect = document.getElementById('productId');
            const selectedOpt = productSelect.options[productSelect.selectedIndex];
            const price = parseFloat(selectedOpt.getAttribute('data-price') || 0);
            const maxStock = parseInt(selectedOpt.getAttribute('data-stock') || 0);

            const qtyInput = document.getElementById('quantity');
            let qty = parseInt(qtyInput.value || 0);
            if (qty < 1) qty = 1;

            const stockHint = document.getElementById('stockHint');
            if (maxStock > 0) {
                stockHint.innerText = 'Số lượng tối đa còn trong kho: ' + maxStock;
                qtyInput.max = maxStock;
            } else {
                stockHint.innerText = '';
            }

            const total = price * qty;
            document.getElementById('totalPreview').innerText = new Intl.NumberFormat('vi-VN').format(total) + ' đ';
        }
    </script>
</body>
</html>
