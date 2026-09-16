<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    .navbar-admin-luxtech .nav-link {
        color: rgba(255, 255, 255, 0.92) !important;
        font-weight: 500;
        white-space: nowrap !important;
        display: inline-flex !important;
        align-items: center !important;
        transition: all 0.2s ease-in-out;
    }
    .navbar-admin-luxtech .nav-link:hover {
        color: #FFFFFF !important;
        background: rgba(255, 255, 255, 0.18) !important;
        transform: translateY(-1px);
    }
    .navbar-admin-luxtech .nav-link.active {
        background: rgba(255, 255, 255, 0.25) !important;
        color: #FFFFFF !important;
        font-weight: 700 !important;
        box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.35);
    }
    .navbar-admin-luxtech .btn {
        white-space: nowrap !important;
        flex-shrink: 0 !important;
    }
    .navbar-admin-luxtech .btn-action-nav:hover {
        background: rgba(255, 255, 255, 0.3) !important;
        transform: translateY(-1px);
    }
    .navbar-admin-luxtech .navbar-brand {
        white-space: nowrap !important;
        flex-shrink: 0 !important;
    }
</style>

<nav class="navbar navbar-expand-lg sticky-top navbar-admin-luxtech shadow-sm mb-4" style="background: linear-gradient(135deg, #FF6B00 0%, #FF7A1A 100%) !important; border-bottom: 1px solid rgba(255,255,255,0.2) !important;">
    <div class="container-fluid px-4">
        <!-- Brand / Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2 text-decoration-none" href="${pageContext.request.contextPath}/dashboard">
            <div class="logo-icon-wrap" style="width:38px; height:38px; background:#FFFFFF !important; border-radius:10px; display:flex; align-items:center; justify-content:center; color:#FF6B00 !important; font-size:1.15rem; box-shadow:0 2px 8px rgba(0,0,0,0.15);">
                <i class="bi bi-cpu-fill"></i>
            </div>
            <span class="fs-4 fw-bold d-flex align-items-center">
                <span style="color:#FFFFFF; font-weight:900;">LUX</span><span style="color:#111827; font-weight:900;">TECH</span>
                <span class="badge ms-2" style="background:rgba(0,0,0,0.22); color:#FFFFFF; font-size:0.68rem; font-weight:700; letter-spacing:0.5px; border: 1px solid rgba(255,255,255,0.25);">BACK-OFFICE</span>
            </span>
        </a>

        <button class="navbar-toggler border-0 text-white" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <i class="bi bi-list fs-2 text-white"></i>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Left Nav Links -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 gap-1 ms-lg-3 flex-nowrap">
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'dashboard' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/dashboard">
                        <i class="bi bi-speedometer2 me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'products' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-box-seam me-1"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'categories' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/categories">
                        <i class="bi bi-grid me-1"></i> Danh mục
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'customers' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/customers">
                        <i class="bi bi-people me-1"></i> Khách hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/orders">
                        <i class="bi bi-receipt me-1"></i> Đơn hàng
                    </a>
                </li>
                <c:if test="${sessionScope.user.role == 'ADMIN' or sessionScope.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link px-3 py-2 rounded-pill ${activePage == 'users' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/users">
                            <i class="bi bi-shield-lock me-1"></i> Người dùng
                        </a>
                    </li>
                </c:if>
            </ul>

            <!-- Right User Info & Actions -->
            <div class="d-flex align-items-center gap-3 flex-shrink-0">
                <a href="${pageContext.request.contextPath}/shop" target="_blank"
                   class="btn btn-sm btn-action-nav rounded-pill px-3 py-2 d-inline-flex align-items-center gap-1 text-nowrap"
                   style="background: rgba(255,255,255,0.2); border: 1px solid rgba(255,255,255,0.35); color: #FFFFFF; font-weight:600; backdrop-filter: blur(4px); white-space: nowrap !important; transition: all 0.2s ease-in-out;"
                   title="Xem Cửa Hàng Khách">
                    <i class="bi bi-shop me-1"></i><span>Shop Online</span>
                </a>
                <div class="text-white text-end me-1 d-flex flex-column align-items-end flex-shrink-0">
                    <div class="fw-semibold small d-flex align-items-center gap-1 text-nowrap" style="white-space: nowrap !important;">
                        <div style="width:22px; height:22px; background:#FFFFFF; border-radius:50%; display:flex; align-items:center; justify-content:center; color:#FF6B00; font-size:0.75rem;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <span class="text-white">${sessionScope.user.username}</span>
                    </div>
                    <span class="badge rounded-pill mt-1" style="background:rgba(0,0,0,0.25); color:#FFFFFF; font-size:0.65rem; border: 1px solid rgba(255,255,255,0.2);">${sessionScope.user.role != null ? sessionScope.user.role : sessionScope.role}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout"
                   class="btn btn-sm rounded-pill px-3 py-2 d-inline-flex align-items-center gap-1 text-nowrap"
                   style="background: #FFFFFF; border: 1px solid #FFFFFF; color: #DC2626; font-weight:700; font-size:0.875rem; box-shadow: 0 2px 8px rgba(0,0,0,0.15); white-space: nowrap !important; transition: all 0.2s ease-in-out;">
                    <i class="bi bi-box-arrow-right me-1"></i><span>Đăng xuất</span>
                </a>
            </div>
        </div>
    </div>
</nav>
