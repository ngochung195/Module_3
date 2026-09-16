<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="profile" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Của Tôi - LuxTech Store</title>

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

        .page-header {
            background: linear-gradient(180deg, #FFF7F0 0%, #F8F9FA 100%);
            padding: 1.25rem 0;
            margin-bottom: 1.75rem;
            border-bottom: 1px solid #E5E7EB;
        }

        .profile-card {
            background: white;
            border-radius: 20px;
            border: 1px solid var(--card-border);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.02), 0 2px 4px -2px rgba(0, 0, 0, 0.02);
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .user-avatar-circle {
            width: 84px;
            height: 84px;
            background: linear-gradient(135deg, #FF6B00, #FFB020);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.2rem;
            font-weight: 700;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 16px rgba(255, 107, 0, 0.3);
            border: 4px solid #ffffff;
        }

        .nav-pills-custom .nav-link {
            color: #6B7280;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.85rem 1.25rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
            transition: all 0.2s ease;
        }
        .nav-pills-custom .nav-link:hover {
            color: var(--primary);
            background: #fff7f0;
        }
        .nav-pills-custom .nav-link.active {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 12px rgba(255, 107, 0, 0.25);
        }

        .stat-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 1.25rem;
            text-align: center;
            transition: transform 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            background: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        .stat-val {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--dark);
        }
        .stat-lbl {
            font-size: 0.8rem;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 0.25rem;
        }

        .form-control {
            border-radius: 10px;
            padding: 0.65rem 0.9rem;
            border-color: #cbd5e1;
            font-size: 0.95rem;
        }
        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }

        .input-group-text {
            background: #f8fafc;
            border-color: #cbd5e1;
            color: #64748b;
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/customer-navbar.jsp" %>

<main>
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1 small">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/shop" class="text-secondary text-decoration-none">Trang chủ</a>
                    </li>
                    <li class="breadcrumb-item active" style="color:#FF6B00 !important; font-weight:600;">Hồ sơ của tôi</li>
                </ol>
            </nav>
            <h3 class="fw-bold mb-1 text-dark d-flex align-items-center gap-2">
                <i class="bi bi-person-bounding-box" style="color:#FF6B00;"></i>
                Hồ Sơ & Tài Khoản Của Tôi
            </h3>
            <p class="mb-0 text-secondary small">
                Quản lý thông tin liên hệ giao hàng, theo dõi chi tiêu và bảo mật mật khẩu
            </p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- Flash Messages -->
        <c:if test="${not empty flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5 text-success"></i>
                <div>${flashSuccess}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <c:if test="${not empty flashError}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 shadow-sm border-0 d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5 text-danger"></i>
                <div>${flashError}</div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Đóng"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Left Column: User Summary & Navigation Tabs -->
            <div class="col-lg-4">
                <div class="profile-card p-4 text-center">
                    <div class="user-avatar-circle">
                        <c:choose>
                            <c:when test="${not empty customer.name}">
                                ${customer.name.substring(0, 1).toUpperCase()}
                            </c:when>
                            <c:otherwise>
                                ${user.username.substring(0, 1).toUpperCase()}
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h4 class="fw-bold text-dark mb-1">
                        <c:choose>
                            <c:when test="${not empty customer.name}">${customer.name}</c:when>
                            <c:otherwise>${user.username}</c:otherwise>
                        </c:choose>
                    </h4>
                    <div class="text-muted small mb-2">@${user.username}</div>

                    <div class="d-flex align-items-center justify-content-center gap-2 mb-3">
                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1 rounded-pill fw-semibold">
                            <i class="bi bi-shield-check me-1"></i>${user.role}
                        </span>
                        <c:if test="${user.customerId > 0}">
                            <span class="badge bg-light text-secondary border px-3 py-1 rounded-pill">
                                #CUST-${user.customerId}
                            </span>
                        </c:if>
                    </div>

                    <!-- Mini stats -->
                    <div class="row g-2 pt-3 border-top text-start">
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="stat-val text-primary">${totalOrders}</div>
                                <div class="stat-lbl">Tổng đơn</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <div class="stat-val text-success">
                                    <fmt:formatNumber value="${totalSpent / 1000000}" maxFractionDigits="1"/> tr
                                </div>
                                <div class="stat-lbl">Tích lũy</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tabs Navigation -->
                <div class="profile-card p-3">
                    <div class="nav flex-column nav-pills-custom" id="profile-tabs" role="tablist">
                        <button class="nav-link ${empty activeTab or activeTab == 'profile' ? 'active' : ''}" 
                                id="tab-profile-btn" data-bs-toggle="pill" data-bs-target="#tab-profile" type="button" role="tab">
                            <i class="bi bi-person-lines-fill fs-5"></i>
                            <span>Thông Tin Cá Nhân</span>
                        </button>
                        <button class="nav-link ${activeTab == 'password' ? 'active' : ''}" 
                                id="tab-password-btn" data-bs-toggle="pill" data-bs-target="#tab-password" type="button" role="tab">
                            <i class="bi bi-shield-lock-fill fs-5"></i>
                            <span>Đổi Mật Khẩu</span>
                        </button>
                        <button class="nav-link ${activeTab == 'activity' ? 'active' : ''}" 
                                id="tab-activity-btn" data-bs-toggle="pill" data-bs-target="#tab-activity" type="button" role="tab">
                            <i class="bi bi-clock-history fs-5"></i>
                            <span>Lịch Sử Gần Đây</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Right Column: Tab Contents -->
            <div class="col-lg-8">
                <div class="tab-content" id="profile-tabs-content">
                    
                    <!-- TAB 1: THÔNG TIN CÁ NHÂN -->
                    <div class="tab-pane fade ${empty activeTab or activeTab == 'profile' ? 'show active' : ''}" 
                         id="tab-profile" role="tabpanel">
                        <div class="profile-card p-4 p-md-5">
                            <div class="d-flex align-items-center justify-content-between mb-4 pb-3 border-bottom">
                                <div>
                                    <h4 class="fw-bold text-dark mb-1">
                                        <i class="bi bi-person-gear text-primary me-2"></i>Thông Tin Cá Nhân
                                    </h4>
                                    <p class="text-muted small mb-0">Cập nhật thông tin nhận hàng để tự động điền khi mua sắm</p>
                                </div>
                                <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">
                                    <i class="bi bi-person-check text-success me-1"></i>Hồ sơ hoạt động
                                </span>
                            </div>

                            <form action="${pageContext.request.contextPath}/profile" method="post">
                                <input type="hidden" name="action" value="updateProfile">

                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label for="name" class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                                            <input type="text" class="form-control" id="name" name="name" 
                                                   value="${customer != null ? customer.name : ''}" 
                                                   placeholder="Nhập họ và tên đầy đủ" required>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="phone" class="form-label fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                            <input type="tel" class="form-control" id="phone" name="phone" 
                                                   value="${customer != null ? customer.phone : ''}" 
                                                   placeholder="Ví dụ: 0912345678" required>
                                        </div>
                                    </div>

                                    <div class="col-12">
                                        <label for="email" class="form-label fw-semibold">Địa chỉ Email</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                            <input type="email" class="form-control" id="email" name="email" 
                                                   value="${customer != null ? customer.email : ''}" 
                                                   placeholder="Ví dụ: customer@example.com">
                                        </div>
                                        <div class="form-text text-muted">Dùng để nhận hóa đơn điện tử và thông báo trạng thái đơn hàng.</div>
                                    </div>

                                    <div class="col-12">
                                        <label for="address" class="form-label fw-semibold">Địa chỉ giao hàng mặc định</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                            <textarea class="form-control" id="address" name="address" rows="3" 
                                                      placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố">${customer != null ? customer.address : ''}</textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                    <button type="reset" class="btn btn-light rounded-pill px-4">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i>Hoàn tác
                                    </button>
                                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-sm">
                                        <i class="bi bi-floppy me-1"></i>Lưu Thay Đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- TAB 2: ĐỔI MẬT KHẨU -->
                    <div class="tab-pane fade ${activeTab == 'password' ? 'show active' : ''}" 
                         id="tab-password" role="tabpanel">
                        <div class="profile-card p-4 p-md-5">
                            <div class="d-flex align-items-center justify-content-between mb-4 pb-3 border-bottom">
                                <div>
                                    <h4 class="fw-bold text-dark mb-1">
                                        <i class="bi bi-shield-lock text-primary me-2"></i>Đổi Mật Khẩu
                                    </h4>
                                    <p class="text-muted small mb-0">Bảo vệ tài khoản của bạn bằng mật khẩu an toàn tối thiểu 6 ký tự</p>
                                </div>
                                <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">
                                    <i class="bi bi-lock-fill me-1"></i>BCrypt Encrypted
                                </span>
                            </div>

                            <form action="${pageContext.request.contextPath}/profile" method="post">
                                <input type="hidden" name="action" value="changePassword">

                                <div class="row g-3">
                                    <div class="col-12">
                                        <label for="currentPassword" class="form-label fw-semibold">Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-key"></i></span>
                                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" 
                                                   placeholder="Nhập mật khẩu đang sử dụng" required>
                                            <button class="btn btn-outline-secondary" type="button" onclick="togglePass('currentPassword', this)">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="newPassword" class="form-label fw-semibold">Mật khẩu mới <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-shield-plus"></i></span>
                                            <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                                   placeholder="Tối thiểu 6 ký tự" minlength="6" required>
                                            <button class="btn btn-outline-secondary" type="button" onclick="togglePass('newPassword', this)">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="bi bi-check2-circle"></i></span>
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                   placeholder="Nhập lại mật khẩu mới" minlength="6" required>
                                            <button class="btn btn-outline-secondary" type="button" onclick="togglePass('confirmPassword', this)">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="alert alert-light border rounded-3 p-3 mt-4 small text-muted">
                                    <div class="fw-semibold text-dark mb-1"><i class="bi bi-info-circle text-primary me-1"></i>Lưu ý về bảo mật:</div>
                                    <ul class="mb-0 ps-3">
                                        <li>Mật khẩu mới không được trùng với mật khẩu đang sử dụng.</li>
                                        <li>Sau khi đổi mật khẩu thành công, phiên đăng nhập hiện tại sẽ được tự động cập nhật an toàn.</li>
                                    </ul>
                                </div>

                                <div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
                                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-sm">
                                        <i class="bi bi-check-lg me-1"></i>Cập Nhật Mật Khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- TAB 3: LỊCH SỬ GẦN ĐÂY -->
                    <div class="tab-pane fade ${activeTab == 'activity' ? 'show active' : ''}" 
                         id="tab-activity" role="tabpanel">
                        <div class="profile-card p-4 p-md-5">
                            <div class="d-flex align-items-center justify-content-between mb-4 pb-3 border-bottom">
                                <div>
                                    <h4 class="fw-bold text-dark mb-1">
                                        <i class="bi bi-bag-check text-primary me-2"></i>Đơn Hàng Gần Đây
                                    </h4>
                                    <p class="text-muted small mb-0">Theo dõi 5 đơn hàng mới nhất của bạn</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-primary btn-sm rounded-pill px-3 fw-semibold">
                                    Xem tất cả <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>

                            <c:choose>
                                <c:when test="${not empty recentOrders}">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Mã đơn</th>
                                                    <th>Ngày đặt</th>
                                                    <th>Thanh toán</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-end">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="o" items="${recentOrders}">
                                                    <tr>
                                                        <td class="fw-bold text-dark">#ORD-${o.id}</td>
                                                        <td class="text-muted small">
                                                            <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${o.paymentMethod == 'VNPAY'}">
                                                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle">VNPay</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary-subtle text-secondary border">COD</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="fw-bold text-primary">
                                                            <fmt:formatNumber value="${o.total}" type="number" groupingUsed="true"/> ₫
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${o.status == 'PENDING'}">
                                                                    <span class="badge bg-warning-subtle text-warning border border-warning-subtle">Chờ duyệt</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 'CONFIRMED'}">
                                                                    <span class="badge bg-info-subtle text-info border border-info-subtle">Đang giao</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 'COMPLETED'}">
                                                                    <span class="badge bg-success-subtle text-success border border-success-subtle">Hoàn thành</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Đã hủy</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end">
                                                            <a href="${pageContext.request.contextPath}/my-orders?action=detail&id=${o.id}" 
                                                               class="btn btn-sm btn-outline-primary rounded-pill px-3">
                                                                Xem chi tiết
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center p-4 text-muted">
                                        <i class="bi bi-box2 fs-2 d-block mb-2 text-secondary"></i>
                                        Bạn chưa có đơn hàng nào.
                                        <div class="mt-2">
                                            <a href="${pageContext.request.contextPath}/shop?action=products" class="btn btn-primary btn-sm rounded-pill px-3">
                                                Mua sắm ngay
                                            </a>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-white border-top py-4 text-center text-muted" style="font-size: 0.875rem;">
    <div class="container">
        <p class="mb-1 fw-medium text-dark">© 2026 LuxTech Store. All rights reserved.</p>
        <p class="mb-0 text-secondary" style="font-size: 0.8rem;">
            Hệ thống bán lẻ thiết bị công nghệ & điện tử cao cấp
        </p>
    </div>
</footer>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function togglePass(inputId, btn) {
        const input = document.getElementById(inputId);
        const icon = btn.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('bi-eye');
            icon.classList.add('bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('bi-eye-slash');
            icon.classList.add('bi-eye');
        }
    }
</script>
</body>
</html>
