<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="LuxTech Store – Cửa hàng thiết bị điện tử hiện đại, chính hãng cho giới trẻ. Điện thoại, Laptop, Tai nghe, Phụ kiện.">
    <title>LuxTech Store – Cửa Hàng Điện Tử Hiện Đại</title>
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
        .hero-section {
            background: linear-gradient(135deg, #FFF7F0 0%, #FFFFFF 100%);
            padding: 4rem 0 3.5rem;
            position: relative;
            border-bottom: 1px solid rgba(255, 107, 0, 0.12);
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 0.5rem;
            background: rgba(255, 107, 0, 0.12);
            border: 1px solid rgba(255, 107, 0, 0.25);
            color: #FF6B00; padding: 0.4rem 1rem;
            border-radius: 9999px; font-size: 0.8rem; font-weight: 700;
            margin-bottom: 1.25rem;
        }
        .hero-title {
            font-size: clamp(2rem, 4vw, 3rem);
            font-weight: 800; color: #111827; line-height: 1.2;
            margin-bottom: 1rem;
        }
        .hero-title span { color: #FF6B00; }
        .hero-sub {
            color: #6B7280; font-size: 1.05rem;
            margin-bottom: 2rem; max-width: 540px;
        }
        .stats-bar {
            background: #FFFFFF;
            border-bottom: 1px solid #E5E7EB;
            padding: 1.25rem 0;
        }
        .stat-item { text-align: center; padding: 0.5rem 1rem; }
        .stat-num { font-size: 1.5rem; font-weight: 800; color: #FF6B00; }
        .stat-label { font-size: 0.8rem; color: #6B7280; font-weight: 600; }

        .section-badge {
            display: inline-block; background: #FFF7F0; color: #FF6B00;
            padding: 0.3rem 0.9rem; border-radius: 9999px;
            font-size: 0.75rem; font-weight: 700; margin-bottom: 0.5rem;
            border: 1px solid rgba(255,107,0,0.25);
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

        .category-card {
            background: #FFFFFF; border: 1px solid #E5E7EB;
            border-radius: 14px; padding: 1.5rem 1rem;
            text-align: center; text-decoration: none; color: #111827;
            display: block; transition: all 0.2s ease;
        }
        .category-card:hover {
            border-color: #FF6B00;
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(255, 107, 0, 0.12);
            color: #FF6B00;
        }
        .category-icon {
            font-size: 2rem; color: #FF6B00; margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<jsp:include page="/WEB-INF/views/common/customer-navbar.jsp"/>

<!-- ==================== HERO SECTION ==================== -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-7">
                <div class="hero-badge">
                    <i class="bi bi-lightning-charge-fill"></i> CÔNG NGHỆ CHO THẾ HỆ MỚI
                </div>
                <h1 class="hero-title">
                    Khám Phá Đỉnh Cao<br>
                    <span>Công Nghệ Hiện Đại</span>
                </h1>
                <p class="hero-sub">
                    Trải nghiệm mua sắm thiết bị điện tử chính hãng với mức giá tối ưu nhất tại LuxTech Store.
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary rounded-pill px-4 py-2 shadow-sm d-inline-flex align-items-center gap-2">
                        <i class="bi bi-bag-fill"></i> Mua sắm ngay
                    </a>
                    <a href="#featured-section" class="btn btn-outline-secondary rounded-pill px-4 py-2 d-inline-flex align-items-center gap-2">
                        <i class="bi bi-arrow-down-circle"></i> Xem sản phẩm hot
                    </a>
                </div>
            </div>
            <div class="col-lg-5 text-center">
                <div style="background: #FFFFFF; border: 1px solid rgba(255,107,0,0.15); border-radius: 24px; padding: 2rem; box-shadow: 0 12px 36px rgba(255,107,0,0.08);">
                    <div style="width: 70px; height: 70px; background: rgba(255,107,0,0.12); border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; color: #FF6B00; font-size: 2rem; margin-bottom: 1rem;">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h5 class="fw-bold mb-2">100% Chính Hãng LuxTech</h5>
                    <p class="text-secondary small mb-3">Bảo hành 1 đổi 1 trong 30 ngày, giao hàng toàn quốc và thanh toán bảo mật đa kênh.</p>
                    <div class="d-flex justify-content-center gap-2">
                        <span class="badge bg-light text-dark border">COD Nhận Hàng</span>
                        <span class="badge bg-light text-dark border">VNPay QR</span>
                        <span class="badge bg-light text-dark border">Chuyển Khoản</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==================== STATS BAR ==================== -->
<section class="stats-bar">
    <div class="container">
        <div class="row g-3">
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-num">100%</div>
                    <div class="stat-label">Hàng Chính Hãng</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-num">24/7</div>
                    <div class="stat-label">Hỗ Trợ Kỹ Thuật</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-num">Fast</div>
                    <div class="stat-label">Giao Hàng Siêu Tốc</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-item">
                    <div class="stat-num">Safe</div>
                    <div class="stat-label">Thanh Toán An Toàn</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ==================== FEATURED PRODUCTS ==================== -->
<section class="py-5" id="featured-section">
    <div class="container">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <div class="section-badge"><i class="bi bi-fire me-1"></i> Sản phẩm Hot</div>
                <h3 class="fw-bold mb-1">Sản Phẩm Nổi Bật</h3>
                <p class="text-secondary mb-0">Các thiết bị công nghệ mới nhất và được săn đón nhiều nhất</p>
            </div>
            <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-outline-primary rounded-pill px-4 d-none d-md-inline-flex align-items-center gap-2">
                Xem tất cả <i class="bi bi-arrow-right"></i>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty featuredProducts}">
                <div class="row g-4">
                    <c:forEach items="${featuredProducts}" var="p">
                        <div class="col-sm-6 col-lg-4">
                            <div class="product-card p-3">
                                <div class="product-img-wrap mb-2">
                                    <span class="position-absolute top-0 start-0 badge badge-luxtech m-2">HOT</span>
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
                                            <div class="product-fallback-icon" style="display:none; font-size:3rem; color:#FF6B00;">
                                                <i class="bi bi-box-seam"></i>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-box-seam" style="font-size:3.5rem; color:#FF6B00;"></i>
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
                                    
                                    <!-- Color dots -->
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
                                            Chi tiết <i class="bi bi-arrow-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-muted">
                    <i class="bi bi-box-seam mb-3" style="font-size:3rem; color:#cbd5e1;"></i>
                    <p>Chưa có sản phẩm nào.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="text-center mt-4 d-md-none">
            <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-outline-primary rounded-pill px-4">
                Xem tất cả sản phẩm <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>
    </div>
</section>

<!-- ==================== CATEGORIES ==================== -->
<section class="py-5" id="categories-section" style="background: #FFFFFF; border-top: 1px solid var(--border-color);">
    <div class="container">
        <div class="section-header text-center">
            <div class="section-badge"><i class="bi bi-grid-fill me-1"></i> Danh mục</div>
            <h3 class="fw-bold mb-1">Khám Phá Theo Danh Mục</h3>
            <p class="text-secondary">Tìm nhanh thiết bị công nghệ bạn mong muốn</p>
        </div>

        <c:choose>
            <c:when test="${not empty categories}">
                <div class="row g-3 justify-content-center">
                    <c:forEach items="${categories}" var="cat">
                        <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                            <a href="${pageContext.request.contextPath}/shop?action=products&categoryId=${cat.id}" class="category-card">
                                <div class="category-icon">
                                    <c:choose>
                                        <c:when test="${cat.name == 'Điện thoại'}"><i class="bi bi-phone"></i></c:when>
                                        <c:when test="${cat.name == 'Laptop'}"><i class="bi bi-laptop"></i></c:when>
                                        <c:when test="${cat.name == 'Tai nghe'}"><i class="bi bi-headphones"></i></c:when>
                                        <c:when test="${cat.name == 'Sạc dự phòng'}"><i class="bi bi-battery-charging"></i></c:when>
                                        <c:when test="${cat.name == 'Bàn phím'}"><i class="bi bi-keyboard"></i></c:when>
                                        <c:when test="${cat.name == 'Chuột'}"><i class="bi bi-mouse"></i></c:when>
                                        <c:otherwise><i class="bi bi-box-seam"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="fw-semibold small">${cat.name}</div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-center text-muted">Chưa có danh mục.</p>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ==================== CTA BANNER ==================== -->
<section style="background: #171717; border-top: 2px solid #FF6B00; padding: 3.5rem 0;">
    <div class="container text-center text-white">
        <h3 class="fw-bold mb-2">Sẵn Sàng Trải Nghiệm Công Nghệ LuxTech?</h3>
        <p class="text-light text-opacity-75 mb-4">Đăng ký tài khoản để theo dõi đơn hàng và tận hưởng đặc quyền thành viên.</p>
        <div class="d-flex justify-content-center gap-3 flex-wrap">
            <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary fw-semibold px-4 py-2 rounded-pill shadow-sm">
                <i class="bi bi-bag-check-fill me-2"></i>Xem toàn bộ sản phẩm
            </a>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light fw-semibold px-4 py-2 rounded-pill">
                    <i class="bi bi-person-plus-fill me-2"></i>Đăng ký tài khoản
                </a>
            </c:if>
        </div>
    </div>
</section>

<!-- ==================== FOOTER ==================== -->
<footer class="footer-luxtech py-4 text-center">
    <div class="container">
        <p class="mb-1">
            <span style="color:#FF6B00; font-weight:700;">LUXTECH STORE</span> – Hệ Thống Bán Lẻ Thiết Bị Điện Tử
        </p>
        <p class="mb-0 small">© 2026 LuxTech. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
