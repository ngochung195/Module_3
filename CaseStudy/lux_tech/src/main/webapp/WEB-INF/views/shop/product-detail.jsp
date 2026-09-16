<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${product.name} – Mua tại LuxTech Store">
    <title>${product.name} - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1rem 0;
            margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }
        .detail-card {
            background: #FFFFFF; border-radius: var(--radius-lg);
            border: 1px solid var(--border-color);
            overflow: hidden; margin-bottom: 2rem;
        }
        .product-img-panel {
            background: #FFFFFF;
            display: flex; align-items: center; justify-content: center;
            min-height: 360px; position: relative; padding: 2.5rem;
            border-right: 1px solid var(--border-color);
        }
        .category-badge {
            position: absolute; top: 1.25rem; left: 1.25rem;
            background: rgba(255, 107, 0, 0.12);
            color: #FF6B00; padding: 0.35rem 0.85rem;
            border-radius: var(--radius-pill); font-size: 0.75rem; font-weight: 700;
            border: 1px solid rgba(255, 107, 0, 0.25);
        }
        .detail-info { padding: 2.5rem; }
        .detail-category {
            font-size: 0.8rem; font-weight: 700; color: #FF6B00;
            text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.35rem;
        }
        .detail-name {
            font-size: 1.85rem; font-weight: 800; color: #111827;
            line-height: 1.25; margin-bottom: 1rem;
        }
        .detail-price {
            font-size: 2.2rem; font-weight: 800;
            color: #FF6B00;
            margin-bottom: 0.25rem; display: block;
        }
        .price-label { font-size: 0.825rem; color: #6B7280; margin-bottom: 1.5rem; }

        .info-row {
            display: flex; align-items: center; gap: 0.85rem;
            padding: 0.85rem 0; border-bottom: 1px solid #F3F4F6;
        }
        .info-row:last-child { border-bottom: none; }
        .info-icon {
            width: 38px; height: 38px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            background: #FFF7F0; color: #FF6B00; font-size: 1.05rem; flex-shrink: 0;
            border: 1px solid rgba(255, 107, 0, 0.15);
        }
        .info-label { font-size: 0.8rem; color: #6B7280; font-weight: 500; }
        .info-value { font-size: 0.95rem; color: #111827; font-weight: 600; }
        .stock-good { color: #15803D; font-weight: 700; }
        .stock-low  { color: #D97706; font-weight: 700; }
        .stock-out  { color: #DC2626; font-weight: 700; }

        .qty-control {
            display: inline-flex; align-items: center;
            border: 1.5px solid #E5E7EB; border-radius: 12px; overflow: hidden;
            background: #FFFFFF; box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }
        .qty-btn {
            width: 42px; height: 42px; border: none; background: #F9FAFB;
            color: #111827; font-size: 1.15rem; cursor: pointer;
            transition: all 0.2s ease; display: flex; align-items: center; justify-content: center;
            font-weight: 700;
        }
        .qty-btn:hover:not(:disabled) { background: #FFF7F0; color: #FF6B00; }
        .qty-btn:disabled { opacity: 0.4; cursor: not-allowed; }
        .qty-input {
            width: 56px; height: 42px; border: none; border-left: 1.5px solid #E5E7EB;
            border-right: 1.5px solid #E5E7EB;
            text-align: center; font-weight: 700; font-size: 1.05rem; color: #111827;
            background: white; outline: none;
        }

        .color-section {
            margin: 1.5rem 0 1.25rem;
            padding: 1.25rem;
            background: #F9FAFB;
            border: 1px solid #E5E7EB;
            border-radius: 14px;
        }
        .color-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 0.85rem;
        }
        .color-title { font-size: 0.875rem; font-weight: 700; color: #111827; display: flex; align-items: center; }
        .color-selected-badge {
            font-size: 0.8rem; font-weight: 700; color: #FF6B00;
            background: #FFF7F0; border: 1px solid rgba(255,107,0,0.25);
            padding: 0.25rem 0.75rem; border-radius: 20px;
            display: inline-flex; align-items: center;
        }
        .color-options-grid {
            display: flex; flex-wrap: wrap; gap: 0.65rem;
        }
        .color-option-btn {
            display: inline-flex; align-items: center; gap: 0.55rem;
            padding: 0.55rem 1rem; border-radius: 10px;
            border: 2px solid #E5E7EB; background: white;
            color: #374151; font-size: 0.875rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s ease;
            position: relative; user-select: none;
        }
        .color-option-btn:hover {
            border-color: #FF6B00; background: #FFF7F0; transform: translateY(-1px);
        }
        .color-option-btn.active {
            border-color: #FF6B00; background: #FFF7F0;
            color: #FF6B00; box-shadow: 0 4px 12px rgba(255, 107, 0, 0.15);
            font-weight: 700;
        }
        .color-swatch-circle {
            width: 18px; height: 18px; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            flex-shrink: 0; position: relative;
        }
        .color-swatch-circle i {
            font-size: 0.7rem; color: white; display: none;
        }
        .color-option-btn.active .color-swatch-circle i {
            display: block;
        }

        .btn-continue-view {
            border: 1.5px solid #D1D5DB !important;
            color: #4B5563 !important;
            background: #FFFFFF !important;
            font-weight: 600 !important;
            padding: 0.75rem 1.75rem !important;
            border-radius: 9999px !important;
            transition: all 0.2s ease !important;
            display: inline-flex !important;
            align-items: center !important;
        }
        .btn-continue-view:hover {
            border-color: #FF6B00 !important;
            color: #FF6B00 !important;
            background: #FFF7F0 !important;
            transform: translateY(-2px) !important;
        }

        .btn-primary, #btn-add-to-cart, .btn-add-cart-luxtech {
            background: linear-gradient(135deg, #FF6B00 0%, #FF7A1A 100%) !important;
            background-color: #FF6B00 !important;
            border: none !important;
            color: #FFFFFF !important;
            box-shadow: 0 4px 16px rgba(255, 107, 0, 0.35) !important;
            transition: all 0.25s ease !important;
            font-weight: 700 !important;
            padding: 0.75rem 2.25rem !important;
            font-size: 1rem !important;
            border-radius: 9999px !important;
            display: inline-flex !important;
            align-items: center !important;
        }
        .btn-primary:hover, #btn-add-to-cart:hover, .btn-add-cart-luxtech:hover {
            background: linear-gradient(135deg, #FF7A1A 0%, #FF8A33 100%) !important;
            background-color: #FF7A1A !important;
            color: #FFFFFF !important;
            box-shadow: 0 6px 22px rgba(255, 107, 0, 0.45) !important;
            transform: translateY(-2px) !important;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<jsp:include page="/WEB-INF/views/common/customer-navbar.jsp"/>

<!-- Header -->
<div class="page-header">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0 small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop?action=products" class="text-secondary text-decoration-none">Sản phẩm</a></li>
                <li class="breadcrumb-item active" aria-current="page" style="color:#FF6B00 !important; font-weight:600;">${product.name}</li>
            </ol>
        </nav>
    </div>
</div>

<div class="container mb-5">
    <c:choose>
        <c:when test="${not empty product}">
            <div class="detail-card shadow-sm">
                <div class="row g-0">
                    <!-- Product Image Panel -->
                    <div class="col-md-5">
                        <div class="product-img-panel h-100">
                            <span class="category-badge">${product.categoryName}</span>
                            <c:choose>
                                <c:when test="${not empty product.displayImage}">
                                    <c:choose>
                                        <c:when test="${product.displayImage.startsWith('http://') or product.displayImage.startsWith('https://')}">
                                            <img id="detail-product-img" src="${product.displayImage}"
                                                 alt="${product.name}" style="max-height: 280px; max-width: 90%; object-fit: contain; transition: transform 0.3s ease;"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        </c:when>
                                        <c:otherwise>
                                            <img id="detail-product-img" src="${pageContext.request.contextPath}/assets/images/products/${product.displayImage}"
                                                 alt="${product.name}" style="max-height: 280px; max-width: 90%; object-fit: contain; transition: transform 0.3s ease;"
                                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="product-emoji" style="display:none; font-size:4rem; color:#FF6B00;">
                                        <i class="bi bi-box-seam"></i>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-box-seam" style="font-size:5rem; color:#FF6B00;"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Product Info Panel -->
                    <div class="col-md-7">
                        <div class="detail-info">
                            <div class="detail-category">${product.categoryName}</div>
                            <h1 class="detail-name">${product.name}</h1>

                            <!-- Price -->
                            <span class="detail-price">
                                <fmt:formatNumber value="${product.price}" pattern="#,##0"/> ₫
                            </span>
                            <div class="price-label">Giá niêm yết chính hãng (Đã bao gồm VAT)</div>

                            <!-- Info Rows -->
                            <div class="mb-3">
                                <div class="info-row">
                                    <div class="info-icon"><i class="bi bi-tag-fill"></i></div>
                                    <div>
                                        <div class="info-label">Danh mục</div>
                                        <div class="info-value">${product.categoryName}</div>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-icon"><i class="bi bi-box-seam-fill"></i></div>
                                    <div>
                                        <div class="info-label">Tình trạng kho</div>
                                        <c:choose>
                                            <c:when test="${product.quantity > 5}">
                                                <div class="info-value stock-good">
                                                    <i class="bi bi-check-circle-fill me-1"></i>Còn hàng (${product.quantity} sản phẩm)
                                                </div>
                                            </c:when>
                                            <c:when test="${product.quantity > 0}">
                                                <div class="info-value stock-low">
                                                    <i class="bi bi-exclamation-triangle-fill me-1"></i>Sắp hết hàng (còn ${product.quantity})
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="info-value stock-out">
                                                    <i class="bi bi-x-circle-fill me-1"></i>Hết hàng
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-icon"><i class="bi bi-shield-check"></i></div>
                                    <div>
                                        <div class="info-label">Chính sách bảo hành</div>
                                        <div class="info-value">Bảo hành 12 tháng chính hãng, 1 đổi 1 trong 30 ngày</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Color Selector Section -->
                            <c:if test="${not empty product.availableColors}">
                                <div class="color-section">
                                    <div class="color-header">
                                        <span class="color-title">
                                            <i class="bi bi-palette-fill me-2" style="color:#FF6B00;"></i>Tùy chọn màu sắc:
                                        </span>
                                        <span id="selected-color-badge" class="color-selected-badge">
                                            <i class="bi bi-check2-circle me-1"></i>${product.availableColors[0].name}
                                        </span>
                                    </div>
                                    <div class="color-options-grid" id="colorOptionsGrid">
                                        <c:forEach items="${product.availableColors}" var="c" varStatus="st">
                                            <button type="button" class="color-option-btn ${st.first ? 'active' : ''}"
                                                    data-color-name="${c.name}"
                                                    data-color-hex="${c.hexCode}"
                                                    onclick="selectColor('${c.name}', '${c.hexCode}', this)">
                                                <span class="color-swatch-circle"
                                                      style="background-color: ${c.hexCode}; border: 1px solid ${not empty c.borderHex ? c.borderHex : '#9CA3AF'};">
                                                    <i class="bi bi-check2"></i>
                                                </span>
                                                <span>${c.name}</span>
                                            </button>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Add to Cart Form -->
                            <c:choose>
                                <c:when test="${product.quantity > 0}">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user}">
                                            <form action="${pageContext.request.contextPath}/cart" method="post" id="addToCartForm">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${product.id}">
                                                <input type="hidden" name="color" id="selected-color-input" value="${not empty product.availableColors ? product.availableColors[0].name : ''}">

                                                <div class="d-flex align-items-center gap-3 my-4">
                                                    <span class="fw-semibold text-dark">Số lượng:</span>
                                                    <div class="qty-control">
                                                        <button type="button" class="qty-btn" id="btn-minus" onclick="changeQty(-1)">−</button>
                                                        <input type="number" class="qty-input" id="qty-input" name="quantity" value="1" min="1" max="${product.quantity}" readonly>
                                                        <button type="button" class="qty-btn" id="btn-plus" onclick="changeQty(1)">+</button>
                                                    </div>
                                                    <small class="text-secondary">(Tối đa ${product.quantity})</small>
                                                </div>

                                                <div class="d-flex gap-3 flex-wrap align-items-center mt-2">
                                                    <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-continue-view">
                                                        <i class="bi bi-arrow-left me-2"></i>Tiếp tục xem
                                                    </a>
                                                    <button type="submit" class="btn btn-primary btn-add-cart-luxtech" id="btn-add-to-cart">
                                                        <i class="bi bi-cart-plus me-2 fs-5"></i>Thêm Vào Giỏ Hàng
                                                    </button>
                                                </div>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-warning d-flex align-items-center gap-2 mt-4 rounded-3">
                                                <i class="bi bi-info-circle-fill fs-5 text-warning"></i>
                                                <div>
                                                    Vui lòng <a href="${pageContext.request.contextPath}/login" class="fw-bold text-dark">đăng nhập</a> hoặc <a href="${pageContext.request.contextPath}/register" class="fw-bold text-dark">đăng ký</a> để thêm sản phẩm vào giỏ hàng.
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex gap-3 flex-wrap mt-4">
                                        <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-outline-secondary rounded-pill px-4">
                                            <i class="bi bi-arrow-left me-1"></i>Quay lại
                                        </a>
                                        <button class="btn btn-secondary rounded-pill px-4" disabled>
                                            <i class="bi bi-slash-circle me-1"></i>Tạm Hết Hàng
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card card-luxtech text-center py-5">
                <div style="font-size:4rem; color:#D1D5DB;"><i class="bi bi-question-circle"></i></div>
                <h4 class="mt-3 fw-bold text-dark">Không tìm thấy sản phẩm</h4>
                <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary mt-3 rounded-pill px-4">
                    Xem tất cả sản phẩm
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Footer -->
<footer class="footer-luxtech py-4 text-center">
    <div class="container">
        <p class="mb-1"><span style="color:#FF6B00; font-weight:700;">LUXTECH STORE</span> – Hệ Thống Bán Lẻ Thiết Bị Điện Tử</p>
        <p class="mb-0 small">© 2026 LuxTech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const maxQty = ${product != null ? product.quantity : 1};

    function changeQty(delta) {
        const input = document.getElementById('qty-input');
        if (!input) return;
        let val = parseInt(input.value) + delta;
        if (val < 1) val = 1;
        if (val > maxQty) val = maxQty;
        input.value = val;
        updateQtyButtons(val);
    }

    function updateQtyButtons(val) {
        const minus = document.getElementById('btn-minus');
        const plus  = document.getElementById('btn-plus');
        if (minus) minus.disabled = val <= 1;
        if (plus)  plus.disabled  = val >= maxQty;
    }

    const qtyInput = document.getElementById('qty-input');
    if (qtyInput) {
        updateQtyButtons(parseInt(qtyInput.value));
    }

    function selectColor(colorName, colorHex, el) {
        document.querySelectorAll('.color-option-btn').forEach(btn => btn.classList.remove('active'));
        if (el) el.classList.add('active');

        const badge = document.getElementById('selected-color-badge');
        if (badge) {
            badge.innerHTML = '<i class="bi bi-check2-circle me-1"></i>' + colorName;
        }

        const input = document.getElementById('selected-color-input');
        if (input) {
            input.value = colorName;
        }

        const img = document.getElementById('detail-product-img');
        if (img) {
            img.style.transform = 'scale(0.96)';
            setTimeout(() => { img.style.transform = 'scale(1)'; }, 150);
        }
    }
</script>
</body>
</html>
