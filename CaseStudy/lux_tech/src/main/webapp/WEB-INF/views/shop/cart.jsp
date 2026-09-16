<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Giỏ hàng của bạn – LuxTech Store. Xem lại các sản phẩm đã chọn và tiến hành đặt hàng.">
    <title>Giỏ Hàng (${not empty cart ? cart.totalItems : 0}) - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1.25rem 0; margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }
        .cart-card, .summary-card {
            background: #FFFFFF; border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            box-shadow: var(--card-shadow);
        }
        .cart-thumb {
            width: 72px; height: 72px; border-radius: var(--radius-sm);
            background: #FFFFFF; border: 1px solid var(--border-color);
            display: flex; align-items: center; justify-content: center;
            padding: 0.35rem; flex-shrink: 0;
        }
        .cart-thumb img { max-height: 100%; max-width: 100%; object-fit: contain; }
        .cart-qty-control {
            display: inline-flex; align-items: center;
            border: 1px solid var(--border-color); border-radius: var(--radius-sm);
            overflow: hidden; background: white;
        }
        .cart-qty-btn {
            width: 30px; height: 30px; border: none; background: #F9FAFB;
            color: #374151; font-size: 0.95rem; cursor: pointer;
            transition: all 0.2s; display: flex; align-items: center; justify-content: center;
            font-weight: 700;
        }
        .cart-qty-btn:hover:not(:disabled) { background: #E5E7EB; color: #111827; }
        .cart-qty-val {
            width: 40px; height: 30px; border: none;
            border-left: 1px solid var(--border-color); border-right: 1px solid var(--border-color);
            text-align: center; font-weight: 700; font-size: 0.9rem; color: #111827;
            outline: none; background: white;
        }
        .btn-remove {
            background: transparent; border: none; color: #EF4444;
            font-size: 1.1rem; cursor: pointer; padding: 0.35rem;
            transition: transform 0.2s, color 0.2s;
        }
        .btn-remove:hover { color: #DC2626; transform: scale(1.15); }
    </style>
</head>
<body>

<!-- Navbar -->
<jsp:include page="/WEB-INF/views/common/customer-navbar.jsp"/>

<!-- Header -->
<div class="page-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div>
                <h3 class="fw-bold mb-1 text-dark">Giỏ Hàng Của Bạn</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0 small">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none">Trang chủ</a></li>
                        <li class="breadcrumb-item active" style="color:#FF6B00 !important; font-weight:600;">Giỏ hàng</li>
                    </ol>
                </nav>
            </div>
            <span class="badge badge-luxtech px-3 py-2 rounded-pill fs-6" style="background:#FFFFFF; color:#FF6B00; border:1px solid rgba(255,107,0,0.3); font-weight:700;">
                <i class="bi bi-cart3 me-1"></i> ${not empty cart ? cart.totalItems : 0} Sản phẩm
            </span>
        </div>
    </div>
</div>

<main class="container pb-5">
    <c:if test="${not empty sessionScope.flashSuccess}">
        <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.flashSuccess}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.flashError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashError" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.flashWarning}">
        <div class="alert alert-warning alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
            <i class="bi bi-exclamation-circle-fill me-2"></i>${sessionScope.flashWarning}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashWarning" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="row g-4">
                <!-- Cart Items Table -->
                <div class="col-lg-8">
                    <div class="cart-card mb-3 overflow-hidden">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">Sản Phẩm</th>
                                        <th class="text-center">Màu Sắc</th>
                                        <th class="text-end">Đơn Giá</th>
                                        <th class="text-center">Số Lượng</th>
                                        <th class="text-end">Thành Tiền</th>
                                        <th class="text-center pe-4" style="width: 50px;"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cart.items}" var="item">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="cart-thumb">
                                                        <c:choose>
                                                            <c:when test="${not empty item.image and item.image.startsWith('http')}">
                                                                <img src="${item.image}" alt="${item.name}">
                                                            </c:when>
                                                            <c:when test="${not empty item.image}">
                                                                <img src="${pageContext.request.contextPath}/assets/images/products/${item.image}" alt="${item.name}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-box-seam fs-3 text-secondary"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/shop?action=detail&id=${item.productId}" class="fw-bold text-dark text-decoration-none">
                                                            ${item.name}
                                                        </a>
                                                        <small class="text-muted d-block">${item.categoryName}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge bg-light text-dark border">
                                                    ${not empty item.color ? item.color : 'Tiêu chuẩn'}
                                                </span>
                                            </td>
                                            <td class="text-end fw-semibold text-secondary">
                                                <fmt:formatNumber value="${item.price}" pattern="#,##0"/> ₫
                                            </td>
                                            <td class="text-center">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline-flex align-items-center gap-1">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="productId" value="${item.productId}">
                                                    <input type="hidden" name="color" value="${item.color}">
                                                    <div class="cart-qty-control">
                                                        <button type="submit" name="quantity" value="${item.quantity - 1}" class="cart-qty-btn" ${item.quantity <= 1 ? 'disabled' : ''}>−</button>
                                                        <input type="text" class="cart-qty-val" value="${item.quantity}" readonly>
                                                        <button type="submit" name="quantity" value="${item.quantity + 1}" class="cart-qty-btn" ${item.quantity >= item.maxStock ? 'disabled' : ''}>+</button>
                                                    </div>
                                                </form>
                                            </td>
                                            <td class="text-end fw-bold text-dark">
                                                <fmt:formatNumber value="${item.subtotal}" pattern="#,##0"/> ₫
                                            </td>
                                            <td class="text-center pe-4">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline" onsubmit="return confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?');">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="productId" value="${item.productId}">
                                                    <input type="hidden" name="color" value="${item.color}">
                                                    <button type="submit" class="btn-remove" title="Xóa">
                                                        <i class="bi bi-trash3"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-outline-secondary rounded-pill px-4">
                            <i class="bi bi-arrow-left me-1"></i>Tiếp tục mua sắm
                        </a>
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0" onsubmit="return confirm('Bạn có chắc chắn muốn làm trống toàn bộ giỏ hàng?');">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn btn-outline-danger rounded-pill px-4">
                                <i class="bi bi-trash me-1"></i>Xóa giỏ hàng
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Summary Panel -->
                <div class="col-lg-4">
                    <div class="summary-card p-4">
                        <h5 class="fw-bold text-dark border-bottom pb-3 mb-3">Tóm Tắt Đơn Hàng</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-secondary">Tổng số lượng:</span>
                            <span class="fw-semibold text-dark">${cart.totalItems} sản phẩm</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-secondary">Tạm tính:</span>
                            <span class="fw-semibold text-dark">
                                <fmt:formatNumber value="${cart.total}" pattern="#,##0"/> ₫
                            </span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-secondary">Vận chuyển:</span>
                            <span class="badge bg-success-subtle text-success border border-success-subtle">Miễn phí</span>
                        </div>
                        <hr class="my-3">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <span class="fw-bold fs-6 text-dark d-block">Tổng thanh toán</span>
                                <small class="text-muted">(Đã bao gồm VAT)</small>
                            </div>
                            <span class="fs-4 fw-bold" style="color:#FF6B00;">
                                <fmt:formatNumber value="${cart.total}" pattern="#,##0"/> ₫
                            </span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow-sm d-flex justify-content-center align-items-center gap-2">
                            <span>Tiến Hành Đặt Hàng</span>
                            <i class="bi bi-arrow-right"></i>
                        </a>

                        <div class="mt-4 pt-3 border-top small text-secondary">
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <i class="bi bi-shield-check text-success fs-5"></i>
                                <span>100% Chính Hãng LuxTech</span>
                            </div>
                            <div class="d-flex align-items-center gap-2 mb-2">
                                <i class="bi bi-arrow-repeat text-primary fs-5" style="color:#FF6B00 !important;"></i>
                                <span>Đổi trả miễn phí 30 ngày</span>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-truck text-warning fs-5"></i>
                                <span>Giao hàng toàn quốc an toàn</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card card-luxtech text-center py-5">
                <div style="font-size:4.5rem; color:#D1D5DB; margin-bottom:1rem;">
                    <i class="bi bi-cart-x"></i>
                </div>
                <h4 class="fw-bold text-dark mb-2">Giỏ hàng của bạn đang trống</h4>
                <p class="text-secondary mb-4 mx-auto" style="max-width: 480px;">
                    Hãy khám phá ngay những thiết bị điện tử mới nhất với giá ưu đãi tại LuxTech Store!
                </p>
                <div>
                    <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary rounded-pill px-5 py-2 fw-semibold shadow-sm">
                        <i class="bi bi-bag-plus me-2"></i>Khám Phá Sản Phẩm Ngay
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<!-- Footer -->
<footer class="footer-luxtech py-4 text-center mt-auto">
    <div class="container">
        <p class="mb-1"><span style="color:#FF6B00; font-weight:700;">LUXTECH STORE</span> – Hệ Thống Bán Lẻ Thiết Bị Điện Tử</p>
        <p class="mb-0 small">© 2026 LuxTech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
