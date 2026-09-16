<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="shop-products" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Danh sách sản phẩm điện tử – LuxTech Store. Tìm kiếm và lọc theo danh mục.">
    <title>Sản Phẩm - LuxTech Store</title>
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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
            background-color: #F8F9FA;
            color: #111827;
        }
        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1.25rem 0;
            margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }
        .filter-panel {
            background: #FFFFFF; border-radius: 16px;
            border: 1px solid #E5E7EB; padding: 1.5rem;
            position: sticky; top: 85px;
        }
        .category-btn {
            display: flex; align-items: center; width: 100%; text-align: left;
            background: transparent; border: none; border-radius: 10px;
            padding: 0.65rem 0.9rem; font-size: 0.9rem; color: #4B5563;
            font-weight: 500; cursor: pointer; transition: all 0.2s ease;
            text-decoration: none; margin-bottom: 4px;
        }
        .category-btn:hover { background: #F3F4F6; color: #111827; }
        .category-btn.active {
            background: #FFF7F0;
            color: #FF6B00; font-weight: 700;
        }
        .search-bar-wrap {
            background: #FFFFFF; border-radius: 16px;
            border: 1px solid #E5E7EB; padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
        }

        /* Product Card Layout Fix */
        .product-card {
            background: #FFFFFF !important;
            border: 1px solid #E5E7EB !important;
            border-radius: 16px !important;
            overflow: hidden !important;
            transition: all 0.25s ease !important;
            height: 100% !important;
            display: flex !important;
            flex-direction: column !important;
            width: 100% !important;
            min-width: 0 !important;
        }
        .product-card:hover {
            transform: translateY(-4px) !important;
            border-color: #FF6B00 !important;
            box-shadow: 0 10px 25px rgba(255, 107, 0, 0.15) !important;
        }
        .product-img-wrap {
            width: 100% !important;
            height: 220px !important;
            min-height: 220px !important;
            max-height: 220px !important;
            background: #FFFFFF !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            padding: 1rem !important;
            position: relative !important;
            overflow: hidden !important;
        }
        .product-img-wrap img {
            max-width: 100% !important;
            max-height: 100% !important;
            width: auto !important;
            height: auto !important;
            object-fit: contain !important;
            transition: transform 0.3s ease !important;
        }
        .product-card:hover .product-img-wrap img {
            transform: scale(1.05) !important;
        }
        .product-price {
            color: #FF6B00 !important;
            font-weight: 700 !important;
            font-size: 1.15rem !important;
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
        .btn-outline-primary {
            border-color: #FF6B00 !important;
            color: #FF6B00 !important;
            background: transparent !important;
        }
        .btn-outline-primary:hover {
            background-color: #FF6B00 !important;
            border-color: #FF6B00 !important;
            color: #FFFFFF !important;
        }
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
                <h3 class="fw-bold mb-1 text-dark">Sản Phẩm Công Nghệ</h3>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0 small">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page" style="color:#FF6B00 !important; font-weight:600;">Sản phẩm</li>
                    </ol>
                </nav>
            </div>
            <span class="badge badge-luxtech px-3 py-2 rounded-pill fs-6" style="background:#FFFFFF; color:#FF6B00; border:1px solid rgba(255,107,0,0.3); font-weight:700;">
                <i class="bi bi-box-seam me-1"></i> ${not empty products ? products.size() : 0} Sản phẩm
            </span>
        </div>
    </div>
</div>

<!-- Main Container -->
<div class="container pb-5">
    <div class="row g-4">
        <!-- Sidebar Filter -->
        <div class="col-lg-3">
            <div class="filter-panel shadow-sm">
                <h6 class="fw-bold text-dark mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-funnel-fill text-primary" style="color:#FF6B00 !important;"></i> Danh Mục Sản Phẩm
                </h6>
                <div class="d-flex flex-column">
                    <a href="${pageContext.request.contextPath}/shop?action=products"
                       class="category-btn ${empty selectedCategoryId || selectedCategoryId == 0 ? 'active' : ''}">
                        <i class="bi bi-grid-fill me-2 text-primary"></i>Tất cả danh mục
                    </a>
                    <c:forEach items="${categories}" var="cat">
                        <a href="${pageContext.request.contextPath}/shop?action=products&categoryId=${cat.id}"
                           class="category-btn ${selectedCategoryId == cat.id ? 'active' : ''}">
                            <c:choose>
                                <c:when test="${cat.name == 'Điện thoại'}"><i class="bi bi-phone me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Laptop'}"><i class="bi bi-laptop me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Tai nghe'}"><i class="bi bi-headphones me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Sạc dự phòng'}"><i class="bi bi-battery-charging me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Bàn phím'}"><i class="bi bi-keyboard me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Chuột'}"><i class="bi bi-mouse me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Đồng hồ'}"><i class="bi bi-smartwatch me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Màn hình'}"><i class="bi bi-display me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Loa'}"><i class="bi bi-speaker me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Camera'}"><i class="bi bi-camera me-2 text-primary"></i></c:when>
                                <c:when test="${cat.name == 'Phụ kiện'}"><i class="bi bi-plug me-2 text-primary"></i></c:when>
                                <c:otherwise><i class="bi bi-cpu me-2 text-primary"></i></c:otherwise>
                            </c:choose>
                            ${cat.name}
                        </a>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Product Listing -->
        <div class="col-lg-9">
            <!-- Search Bar -->
            <div class="search-bar-wrap shadow-sm">
                <form action="${pageContext.request.contextPath}/shop" method="get" class="d-flex gap-2 flex-wrap align-items-center">
                    <input type="hidden" name="action" value="products">
                    <c:if test="${selectedCategoryId != null && selectedCategoryId > 0}">
                        <input type="hidden" name="categoryId" value="${selectedCategoryId}">
                    </c:if>
                    <div class="input-group flex-grow-1">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="keyword" class="form-control border-start-0" value="${keyword}" placeholder="Nhập tên sản phẩm cần tìm...">
                    </div>
                    <button type="submit" class="btn btn-primary px-4">
                        Tìm kiếm
                    </button>
                    <c:if test="${not empty keyword || (selectedCategoryId != null && selectedCategoryId > 0)}">
                        <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-outline-secondary rounded-pill px-3">
                            <i class="bi bi-arrow-clockwise me-1"></i>Xóa lọc
                        </a>
                    </c:if>
                </form>
            </div>

            <!-- Products Grid -->
            <c:choose>
                <c:when test="${not empty products}">
                    <div class="row g-3">
                        <c:forEach items="${products}" var="p">
                            <div class="col-sm-6 col-xl-4">
                                <div class="product-card p-3 shadow-sm">
                                    <div class="product-img-wrap mb-2">
                                        <c:choose>
                                            <c:when test="${not empty p.displayImage}">
                                                <c:choose>
                                                    <c:when test="${p.displayImage.startsWith('http://') or p.displayImage.startsWith('https://')}">
                                                        <img src="${p.displayImage}" alt="${p.name}" loading="lazy"
                                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/assets/images/products/${p.displayImage}"
                                                             alt="${p.name}" loading="lazy"
                                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="product-fallback-icon" style="display:none; font-size:2.8rem; color:#FF6B00;">
                                                    <i class="bi bi-box-seam"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-box-seam" style="font-size:3.2rem; color:#FF6B00;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="d-flex flex-column flex-grow-1">
                                        <span class="badge bg-light text-secondary border align-self-start mb-2">${p.categoryName}</span>
                                        <h6 class="fw-bold mb-2">
                                            <a href="${pageContext.request.contextPath}/shop?action=detail&id=${p.id}" class="text-dark text-decoration-none">
                                                ${p.name}
                                            </a>
                                        </h6>

                                        <!-- Colors Preview -->
                                        <div class="d-flex align-items-center gap-1 mb-3">
                                            <c:forEach items="${p.availableColors}" var="col" varStatus="colStatus">
                                                <c:if test="${colStatus.index < 4}">
                                                    <span style="width: 12px; height: 12px; border-radius: 50%; background-color: ${col.hexCode}; border: 1px solid ${not empty col.borderHex ? col.borderHex : '#cbd5e1'}; display: inline-block;"></span>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${p.availableColors.size() > 4}">
                                                <span class="text-muted small">+${p.availableColors.size() - 4}</span>
                                            </c:if>
                                            <small class="text-muted ms-1" style="font-size:0.75rem;">${p.availableColors.size()} màu</small>
                                        </div>

                                        <div class="mt-auto d-flex justify-content-between align-items-center pt-2 border-top">
                                            <span class="product-price">
                                                <fmt:formatNumber value="${p.price}" pattern="#,##0"/> ₫
                                            </span>
                                            <a href="${pageContext.request.contextPath}/shop?action=detail&id=${p.id}" class="btn btn-sm btn-primary rounded-pill px-3">
                                                Xem <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card card-luxtech text-center py-5">
                        <div style="font-size:3.5rem; color:#D1D5DB; margin-bottom:1rem;"><i class="bi bi-search"></i></div>
                        <h5 class="fw-bold text-dark">Không tìm thấy sản phẩm phù hợp</h5>
                        <p class="text-secondary mb-3">Thử tìm kiếm với từ khóa khác hoặc xóa bộ lọc.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary rounded-pill px-4">
                                Xem tất cả sản phẩm
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer-luxtech py-4 text-center">
    <div class="container">
        <p class="mb-1"><span style="color:#FF6B00; font-weight:700;">LUXTECH STORE</span> – Hệ Thống Bán Lẻ Thiết Bị Điện Tử</p>
        <p class="mb-0 small">© 2026 LuxTech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
