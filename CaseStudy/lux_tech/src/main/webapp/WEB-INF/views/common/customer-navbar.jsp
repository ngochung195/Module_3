<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Customer Online Shop Navbar – LuxTech Orange Theme --%>

<%-- Đếm số item trong cart (từ session) --%>
<c:set var="cartCount" value="0"/>
<c:if test="${not empty sessionScope.cart}">
    <c:set var="cartCount" value="${sessionScope.cart.totalItems}"/>
</c:if>

<style>
    .navbar-customer-luxtech .nav-link {
        color: rgba(255, 255, 255, 0.92) !important;
        font-weight: 500;
        white-space: nowrap !important;
        display: inline-flex !important;
        align-items: center !important;
        transition: all 0.2s ease-in-out;
    }
    .navbar-customer-luxtech .nav-link:hover {
        color: #FFFFFF !important;
        background: rgba(255, 255, 255, 0.18) !important;
        transform: translateY(-1px);
    }
    .navbar-customer-luxtech .nav-link.active {
        background: rgba(255, 255, 255, 0.25) !important;
        color: #FFFFFF !important;
        font-weight: 700 !important;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.35);
    }
    .navbar-customer-luxtech .btn {
        white-space: nowrap !important;
        flex-shrink: 0 !important;
    }
    .navbar-customer-luxtech .btn-cart-nav:hover {
        background: rgba(255, 255, 255, 0.3) !important;
        transform: translateY(-1px);
    }
    .navbar-customer-luxtech .navbar-brand {
        white-space: nowrap !important;
        flex-shrink: 0 !important;
    }
</style>

<nav class="navbar navbar-expand-lg sticky-top navbar-customer-luxtech shadow-sm" style="background: linear-gradient(135deg, #FF6B00 0%, #FF7A1A 100%) !important; border-bottom: 1px solid rgba(255,255,255,0.2) !important;">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2 text-decoration-none" href="${pageContext.request.contextPath}/shop">
            <div class="logo-icon-wrap" style="width:38px; height:38px; background:#FFFFFF !important; border-radius:10px; display:flex; align-items:center; justify-content:center; color:#FF6B00 !important; font-size:1.15rem; box-shadow:0 2px 8px rgba(0,0,0,0.15);">
                <i class="bi bi-cpu-fill"></i>
            </div>
            <span class="fs-4 fw-bold">
                <span style="color:#FFFFFF; font-weight:900;">LUX</span><span style="color:#111827; font-weight:900;">TECH</span>
            </span>
        </a>

        <!-- Mobile Hamburger Toggle -->
        <button class="navbar-toggler border-0 text-white" type="button" data-bs-toggle="collapse" data-bs-target="#shopNavbar">
            <i class="bi bi-list fs-2 text-white"></i>
        </button>

        <div class="collapse navbar-collapse" id="shopNavbar">
            <!-- Navigation Links -->
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0 gap-1">
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'shop-home' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/shop">
                        <i class="bi bi-house me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'shop-products' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/shop?action=products">
                        <i class="bi bi-grid me-1"></i>Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'my-orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/my-orders">
                        <i class="bi bi-receipt me-1"></i>Đơn hàng của tôi
                    </a>
                </li>
            </ul>

            <!-- Right Actions: Cart & User Account -->
            <div class="d-flex align-items-center gap-2">
                <!-- Cart Button -->
                <a href="${pageContext.request.contextPath}/cart"
                   class="btn btn-sm btn-cart-nav position-relative d-flex align-items-center gap-2 px-3 py-2 rounded-pill"
                   style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.35); color: #FFFFFF; font-weight:600; backdrop-filter: blur(4px); transition: all 0.2s ease-in-out;">
                    <i class="bi bi-cart3 fs-6"></i>
                    <span>Giỏ hàng</span>
                    <c:if test="${cartCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill" style="background:#FFFFFF; color:#FF6B00; font-size:0.72rem; font-weight:800; box-shadow: 0 2px 6px rgba(0,0,0,0.2);">
                            ${cartCount}
                        </span>
                    </c:if>
                </a>

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- Logged in dropdown -->
                        <div class="dropdown">
                            <button class="btn btn-sm dropdown-toggle d-flex align-items-center gap-2 rounded-pill px-3 py-2"
                                    type="button" data-bs-toggle="dropdown"
                                    style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.35); color: #FFFFFF; font-size:0.875rem; backdrop-filter: blur(4px);">
                                <div style="width:24px;height:24px;background:#FFFFFF;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:0.75rem;color:#FF6B00;">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <span class="fw-semibold text-white">${sessionScope.user.username}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0" style="border-radius:12px; margin-top:8px; min-width:200px;">
                                <li>
                                    <div class="dropdown-header text-muted small">Tài khoản khách hàng</div>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/my-orders">
                                        <i class="bi bi-receipt me-2" style="color:#FF6B00;"></i>Đơn hàng của tôi
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person-gear me-2" style="color:#FF6B00;"></i>Thông tin tài khoản
                                    </a>
                                </li>
                                <c:if test="${sessionScope.user.role == 'ADMIN' or sessionScope.user.role == 'STAFF'}">
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li>
                                        <a class="dropdown-item py-2 text-primary" href="${pageContext.request.contextPath}/dashboard">
                                            <i class="bi bi-speedometer2 me-2"></i>Quản trị Back-Office
                                        </a>
                                    </li>
                                </c:if>
                                <li><hr class="dropdown-divider my-1"></li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Not logged in -->
                        <a href="${pageContext.request.contextPath}/login"
                           class="btn btn-sm rounded-pill px-3 py-2"
                           style="background: rgba(255,255,255,0.18); border: 1px solid rgba(255,255,255,0.4); color: #FFFFFF; font-size:0.875rem; font-weight:600;">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register"
                           class="btn btn-sm rounded-pill px-3 py-2"
                           style="background: #FFFFFF; border: 1px solid #FFFFFF; color: #FF6B00; font-weight:700; font-size:0.875rem; box-shadow: 0 2px 8px rgba(0,0,0,0.15);">
                            <i class="bi bi-person-plus me-1"></i>Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<%-- Tích hợp LuxTech AI Chatbox (Phase 11 - Gemini 3.5 Flash) --%>
<jsp:include page="/WEB-INF/views/common/ai-chatbox.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/luxtech-ai-chat.js?v=1.0" defer></script>

