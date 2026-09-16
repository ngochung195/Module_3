<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="orders" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #ORD-${order.id} - LuxTech Back Office</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
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
        .card-custom {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            background: white;
            padding: 1.75rem;
            margin-bottom: 1.5rem;
        }
        .badge-status-pending {
            background: #fef3c7; color: #92400e; border: 1px solid #fde68a;
        }
        .badge-status-paid {
            background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0;
        }
        .badge-status-confirmed {
            background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd;
        }
        .badge-status-completed {
            background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0;
        }
        .badge-status-cancelled {
            background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5" style="max-width: 1100px;">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
            <div>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline-secondary btn-sm rounded-pill mb-2">
                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách đơn hàng
                </a>
                <h3 class="fw-bold text-dark mb-0 d-flex align-items-center gap-2">
                    Chi Tiết Đơn Hàng #ORD-${order.id}
                    <c:choose>
                        <c:when test="${order.status == 'PAID'}">
                            <span class="badge badge-status-paid fs-6 px-3 py-1 rounded-pill">PAID</span>
                        </c:when>
                        <c:when test="${order.status == 'PENDING'}">
                            <span class="badge badge-status-pending fs-6 px-3 py-1 rounded-pill">PENDING</span>
                        </c:when>
                        <c:when test="${order.status == 'CONFIRMED'}">
                            <span class="badge badge-status-confirmed fs-6 px-3 py-1 rounded-pill">CONFIRMED</span>
                            <c:if test="${order.paymentStatus eq 'PAID'}">
                                <span class="badge bg-success-subtle text-success border border-success-subtle fs-6 px-3 py-1 rounded-pill ms-1">ĐÃ THANH TOÁN</span>
                            </c:if>
                        </c:when>
                        <c:when test="${order.status == 'COMPLETED'}">
                            <span class="badge badge-status-completed fs-6 px-3 py-1 rounded-pill">COMPLETED</span>
                            <c:if test="${order.paymentStatus eq 'PAID'}">
                                <span class="badge bg-success-subtle text-success border border-success-subtle fs-6 px-3 py-1 rounded-pill ms-1">ĐÃ THANH TOÁN</span>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-status-cancelled fs-6 px-3 py-1 rounded-pill">CANCELLED</span>
                        </c:otherwise>
                    </c:choose>
                </h3>
            </div>
            <div>
                <small class="text-muted">Thời gian đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" /></small>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty flashSuccess}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-check-circle me-2 fs-5"></i>
                <div>${flashSuccess}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty flashError}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4 rounded-4 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle me-2 fs-5"></i>
                <div>${flashError}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- Left: Customer info & Order details -->
            <div class="col-lg-8">
                <!-- Customer Info Card -->
                <div class="card-custom">
                    <h5 class="fw-bold text-dark border-bottom pb-3 mb-3">
                        <i class="bi bi-person-circle text-primary me-2"></i>Thông Tin Khách Hàng & Thanh Toán
                    </h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="text-muted small">Họ và tên:</div>
                            <div class="fw-semibold text-dark fs-6">${customer != null ? customer.name : order.customerName}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Số điện thoại:</div>
                            <div class="fw-semibold text-dark fs-6">${customer != null ? customer.phone : 'Chưa cập nhật'}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Email:</div>
                            <div class="fw-medium text-dark">${customer != null ? customer.email : 'Chưa cập nhật'}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Hình thức thanh toán:</div>
                            <div class="fw-semibold text-dark fs-6">
                                <span class="badge ${order.paymentMethod eq 'VNPAY' ? 'bg-primary-subtle text-primary border border-primary-subtle' : 'bg-success-subtle text-success border border-success-subtle'} px-2 py-1 rounded">
                                    <i class="bi ${order.paymentMethod eq 'VNPAY' ? 'bi-qr-code' : 'bi-cash'} me-1"></i>${order.paymentMethod != null ? order.paymentMethod : 'COD'}
                                </span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Mã khách hàng:</div>
                            <div class="fw-medium text-dark">#CUST-${order.customerId}</div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Trạng thái thanh toán:</div>
                            <div class="fw-medium text-dark">
                                <c:choose>
                                    <c:when test="${order.paymentStatus eq 'PAID' or order.status eq 'PAID'}">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle">Đã thanh toán (PAID)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle">Chưa thanh toán (UNPAID)</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Nguồn đơn hàng:</div>
                            <div class="fw-medium text-dark">
                                <c:choose>
                                    <c:when test="${order.source eq 'STAFF'}">
                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1 rounded-pill">
                                            <i class="bi bi-shop me-1"></i>TẠI QUẦY (STAFF)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info-subtle text-primary border border-info-subtle px-2 py-1 rounded-pill">
                                            <i class="bi bi-globe me-1"></i>ONLINE (WEBSITE)
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="text-muted small">Địa chỉ nhận hàng:</div>
                            <div class="fw-medium text-dark">${customer != null ? customer.address : 'Tại quầy / Chưa cập nhật'}</div>
                        </div>
                    </div>
                </div>

                <!-- Products in Order Card -->
                <div class="card-custom">
                    <h5 class="fw-bold text-dark border-bottom pb-3 mb-3 d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-box-seam text-primary me-2"></i>Sản Phẩm Trong Đơn</span>
                        <span class="badge bg-light text-dark border">${order.orderDetails != null ? order.orderDetails.size() : 0} mặt hàng</span>
                    </h5>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Sản Phẩm</th>
                                    <th class="text-center" style="width: 100px;">Số Lượng</th>
                                    <th class="text-end" style="width: 150px;">Đơn Giá</th>
                                    <th class="text-end" style="width: 150px;">Thành Tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="detail" items="${order.orderDetails}">
                                    <tr>
                                        <td>
                                            <div class="fw-semibold text-dark">${detail.productName}</div>
                                            <small class="text-muted">Mã SP: ${detail.productId}</small>
                                        </td>
                                        <td class="text-center fw-bold">${detail.quantity}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${detail.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                        <td class="text-end fw-bold text-dark">
                                            <fmt:formatNumber value="${detail.subtotal}" type="number" groupingUsed="true"/> ₫
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot class="border-top">
                                <tr>
                                    <td colspan="3" class="text-end fw-bold fs-6">TỔNG CỘNG:</td>
                                    <td class="text-end fw-bold text-primary fs-5">
                                        <fmt:formatNumber value="${order.total}" type="number" groupingUsed="true"/> ₫
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Right: Status Update & Actions -->
            <div class="col-lg-4">
                <div class="card-custom">
                    <h5 class="fw-bold text-dark border-bottom pb-3 mb-3">
                        <i class="bi bi-sliders text-primary me-2"></i>Xử Lý Đơn Hàng
                    </h5>

                    <div class="mb-3">
                        <div class="text-muted small mb-1">Trạng thái hiện tại:</div>
                        <div>
                            <c:choose>
                                <c:when test="${order.status == 'PAID'}">
                                    <span class="badge badge-status-paid fs-6 px-3 py-2 rounded-pill fw-bold w-100 text-center">
                                        <i class="bi bi-check-circle me-1"></i>PAID (Đã thanh toán VNPay)
                                    </span>
                                </c:when>
                                <c:when test="${order.status == 'PENDING'}">
                                    <span class="badge badge-status-pending fs-6 px-3 py-2 rounded-pill fw-bold w-100 text-center">
                                        <i class="bi bi-hourglass-split me-1"></i>PENDING (Chờ xác nhận)
                                    </span>
                                </c:when>
                                <c:when test="${order.status == 'CONFIRMED'}">
                                    <span class="badge badge-status-confirmed fs-6 px-3 py-2 rounded-pill fw-bold w-100 text-center">
                                        <i class="bi bi-truck me-1"></i>CONFIRMED (Đã xác nhận)
                                    </span>
                                </c:when>
                                <c:when test="${order.status == 'COMPLETED'}">
                                    <span class="badge badge-status-completed fs-6 px-3 py-2 rounded-pill fw-bold w-100 text-center">
                                        <i class="bi bi-check-all me-1"></i>COMPLETED (Hoàn thành)
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-status-cancelled fs-6 px-3 py-2 rounded-pill fw-bold w-100 text-center">
                                        <i class="bi bi-x-circle me-1"></i>CANCELLED (Đã hủy)
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Update Status Form -->
                    <c:choose>
                        <c:when test="${order.status != 'COMPLETED' and order.status != 'CANCELLED'}">
                            <form action="${pageContext.request.contextPath}/orders" method="post" 
                                  onsubmit="return confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này?');">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="id" value="${order.id}">

                                <div class="mb-3">
                                    <label for="newStatus" class="form-label text-secondary fw-semibold small">Chuyển sang trạng thái:</label>
                                    <select class="form-select bg-light" id="newStatus" name="newStatus" required>
                                        <c:if test="${order.status == 'PAID' or order.status == 'PENDING'}">
                                            <option value="CONFIRMED">CONFIRMED (Xác nhận & Giao hàng)</option>
                                            <option value="CANCELLED">CANCELLED (Hủy & Hoàn trả tồn kho)</option>
                                        </c:if>
                                        <c:if test="${order.status == 'CONFIRMED'}">
                                            <option value="COMPLETED">COMPLETED (Giao hàng thành công)</option>
                                            <option value="CANCELLED">CANCELLED (Khách trả hàng / Hủy)</option>
                                        </c:if>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-primary rounded-pill w-100 py-2 fw-semibold">
                                    <i class="bi bi-arrow-repeat me-1"></i>Cập Nhật Trạng Thái
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-secondary mb-0 rounded-4 text-center small">
                                <i class="bi bi-lock-fill me-1"></i>
                                Đơn hàng đã ở trạng thái kết thúc (<strong>${order.status}</strong>), không thể thay đổi trạng thái.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
