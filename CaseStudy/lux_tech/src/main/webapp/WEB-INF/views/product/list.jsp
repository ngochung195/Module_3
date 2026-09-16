<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="products" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- LuxTech Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/luxtech-theme.css?v=2.0">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #111827;
        }
        .card-table, .card-filter {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-dark mb-1">Danh Sách Sản Phẩm</h3>
                <p class="text-secondary mb-0">Quản lý kho hàng, tìm kiếm và chi tiết thông tin sản phẩm điện tử</p>
            </div>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/products?action=create" class="btn btn-primary rounded-pill px-4 shadow-sm">
                    <i class="bi bi-plus-lg me-2"></i>Thêm Sản Phẩm Mới
                </a>
            </c:if>
        </div>

        <!-- Success Alert -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                <div>${successMessage}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Error Alert -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                <div>${errorMessage}</div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Search & Filter Card -->
        <div class="card card-filter mb-4">
            <div class="card-body p-3 p-md-4">
                <form action="${pageContext.request.contextPath}/products" method="get" class="row g-3 align-items-center">
                    <input type="hidden" name="action" value="search">

                    <!-- Keyword Search -->
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-secondary"></i></span>
                            <input type="text" 
                                   class="form-control border-start-0" 
                                   name="keyword" 
                                   value="${keyword}" 
                                   placeholder="Nhập tên sản phẩm cần tìm...">
                        </div>
                    </div>

                    <!-- Category Filter -->
                    <div class="col-md-4">
                        <select class="form-select" name="categoryId">
                            <option value="">-- Tất cả danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.id}" ${selectedCategoryId == c.id ? 'selected' : ''}>${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Action Buttons -->
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary rounded-pill px-3 flex-fill shadow-sm">
                            <i class="bi bi-funnel me-1"></i>Tìm Kiếm
                        </button>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary rounded-pill px-3">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Đặt Lại
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Products Table Card -->
        <div class="card card-table overflow-hidden">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width: 80px;">Mã (ID)</th>
                                <th>Tên Sản Phẩm</th>
                                <th>Danh Mục</th>
                                <th>Giá Bán (VNĐ)</th>
                                <th>Tồn Kho</th>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <th class="text-end pe-4" style="width: 200px;">Thao Tác</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty products}">
                                    <c:forEach var="p" items="${products}">
                                        <tr>
                                            <td class="ps-4 fw-semibold text-secondary">#${p.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center gap-3">
                                                    <c:choose>
                                                        <c:when test="${not empty p.displayImage}">
                                                            <c:choose>
                                                                <c:when test="${p.displayImage.startsWith('http://') or p.displayImage.startsWith('https://')}">
                                                                    <img src="${p.displayImage}"
                                                                         alt="${p.name}" class="rounded border" style="width: 44px; height: 44px; object-fit: contain; background:#f8fafc; padding:2px;"
                                                                         onerror="this.style.display='none'; this.nextElementSibling.classList.remove('d-none'); this.nextElementSibling.classList.add('d-flex');">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/assets/images/products/${p.displayImage}"
                                                                         alt="${p.name}" class="rounded border" style="width: 44px; height: 44px; object-fit: contain; background:#f8fafc; padding:2px;"
                                                                         onerror="this.style.display='none'; this.nextElementSibling.classList.remove('d-none'); this.nextElementSibling.classList.add('d-flex');">
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div class="rounded border bg-light d-none align-items-center justify-content-center" style="width: 44px; height: 44px; color: #6366f1;">
                                                                <i class="bi bi-box-seam fs-5"></i>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="rounded border bg-light d-flex align-items-center justify-content-center" style="width: 44px; height: 44px; color: #6366f1;">
                                                                <c:choose>
                                                                    <c:when test="${p.categoryName == 'Điện thoại'}"><i class="bi bi-phone fs-5"></i></c:when>
                                                                    <c:when test="${p.categoryName == 'Laptop'}"><i class="bi bi-laptop fs-5"></i></c:when>
                                                                    <c:when test="${p.categoryName == 'Tai nghe'}"><i class="bi bi-headphones fs-5"></i></c:when>
                                                                    <c:when test="${p.categoryName == 'Sạc dự phòng'}"><i class="bi bi-battery-charging fs-5"></i></c:when>
                                                                    <c:when test="${p.categoryName == 'Bàn phím'}"><i class="bi bi-keyboard fs-5"></i></c:when>
                                                                    <c:when test="${p.categoryName == 'Chuột'}"><i class="bi bi-mouse fs-5"></i></c:when>
                                                                    <c:otherwise><i class="bi bi-box-seam fs-5"></i></c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="fw-bold text-dark fs-6">${p.name}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">
                                                    <i class="bi bi-tag me-1 text-primary"></i>${p.categoryName}
                                                </span>
                                            </td>
                                            <td class="fw-bold text-primary fs-6">
                                                <fmt:formatNumber value="${p.price}" pattern="#,##0"/> ₫
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.quantity == 0}">
                                                        <span class="badge bg-danger px-3 py-2 rounded-pill">Hết hàng</span>
                                                    </c:when>
                                                    <c:when test="${p.quantity <= 5}">
                                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Sắp hết (${p.quantity})</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success px-3 py-2 rounded-pill">Còn hàng (${p.quantity})</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${sessionScope.role == 'ADMIN'}">
                                                <td class="text-end pe-4">
                                                    <a href="${pageContext.request.contextPath}/products?action=edit&id=${p.id}&page=${pageResult.currentPage}" 
                                                        class="btn btn-sm btn-outline-primary rounded-pill me-1 px-3">
                                                        <i class="bi bi-pencil-square me-1"></i>Sửa
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteModal${p.id}">
                                                        <i class="bi bi-trash3 me-1"></i>Xóa
                                                    </button>

                                                    <!-- Delete Confirmation Modal -->
                                                    <div class="modal fade text-start" id="deleteModal${p.id}" tabindex="-1" aria-hidden="true">
                                                        <div class="modal-dialog modal-dialog-centered">
                                                            <div class="modal-content rounded-4 border-0 shadow">
                                                                <div class="modal-header border-0 pb-0">
                                                                    <h5 class="modal-title fw-bold text-danger">
                                                                        <i class="bi bi-exclamation-triangle-fill me-2"></i>Xác Nhận Xóa Sản Phẩm
                                                                    </h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                </div>
                                                                <div class="modal-body py-3">
                                                                    Bạn có chắc chắn muốn xóa sản phẩm <strong>"${p.name}"</strong> (ID: #${p.id})?<br/>
                                                                    <small class="text-muted">Lưu ý: Không thể xóa sản phẩm nếu đã có trong lịch sử đơn hàng.</small>
                                                                </div>
                                                                <div class="modal-footer border-0 pt-0">
                                                                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy</button>
                                                                    <a href="${pageContext.request.contextPath}/products?action=delete&id=${p.id}&page=${pageResult.currentPage}" 
                                                                        class="btn btn-danger rounded-pill px-4">
                                                                        Xác Nhận Xóa
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="${sessionScope.role == 'ADMIN' ? 6 : 5}" class="text-center py-5 text-muted">
                                            <i class="bi bi-box-seam fs-1 mb-2 text-secondary opacity-50"></i><br/>
                                            Không tìm thấy sản phẩm nào phù hợp với yêu cầu.
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Component -->
                <jsp:include page="/WEB-INF/views/common/admin-pagination.jsp" />
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
