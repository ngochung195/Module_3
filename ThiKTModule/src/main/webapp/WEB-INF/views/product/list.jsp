<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý sản phẩm - CodeGym</title>
                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Bootstrap Icons -->
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
                <!-- Google Fonts -->
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: #f4f6f9;
                        color: #333;
                    }

                    .navbar-custom {
                        background-color: #0d6efd;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .card-custom {
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
                        background: #fff;
                    }

                    .table-custom thead th {
                        background-color: #f8fafc;
                        color: #475569;
                        font-weight: 600;
                        border-bottom: 2px solid #e2e8f0;
                        font-size: 0.875rem;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .table-custom tbody tr:hover {
                        background-color: #f1f5f9;
                    }

                    .table-custom td {
                        vertical-align: middle;
                        font-size: 0.925rem;
                    }

                    .btn-delete {
                        color: #dc3545;
                        background-color: #fff;
                        border: 1px solid #fecdd3;
                        transition: all 0.2s;
                    }

                    .btn-delete:hover {
                        background-color: #dc3545;
                        color: #fff;
                    }

                    .badge-color {
                        padding: 4px 10px;
                        border-radius: 20px;
                        font-size: 0.8rem;
                        font-weight: 500;
                        background-color: #e2e8f0;
                        color: #334155;
                        display: inline-block;
                    }

                    .badge-category {
                        background-color: #e0f2fe;
                        color: #0369a1;
                        font-weight: 600;
                        padding: 4px 10px;
                        border-radius: 6px;
                        font-size: 0.825rem;
                    }
                </style>
            </head>

            <body>

                <!-- Header / Navbar -->
                <nav class="navbar navbar-dark navbar-custom px-4 py-2">
                    <div class="container-fluid px-0">
                        <a class="navbar-brand fw-bold fs-5" href="${pageContext.request.contextPath}/products">
                            <i class="bi bi-box-seam me-2"></i>Management Product
                        </a>
                        <button type="button" class="btn btn-light text-primary fw-semibold shadow-sm"
                            data-bs-toggle="modal" data-bs-target="#createModal">
                            <i class="bi bi-plus-circle me-1"></i> Add Product
                        </button>
                    </div>
                </nav>

                <div class="container-fluid px-4 py-4">

                    <!-- Thông báo thành công nếu có -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm"
                            role="alert">
                            <i class="bi bi-check-circle-fill fs-5 me-2"></i>
                            <div class="fw-medium">${successMessage}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Khung Tìm kiếm (Find Product) -->
                    <div class="card card-custom mb-4">
                        <div class="card-body p-4">
                            <h6 class="card-title fw-bold text-dark mb-3">Find Product</h6>
                            <form action="${pageContext.request.contextPath}/products" method="get"
                                class="row g-3 align-items-end">
                                <input type="hidden" name="action" value="search">

                                <div class="col-md-4">
                                    <label for="searchName" class="form-label text-muted small fw-semibold">Product
                                        Name</label>
                                    <input type="text" class="form-control" id="searchName" name="searchName"
                                        value="${searchName}" placeholder="Enter Product Name">
                                </div>

                                <div class="col-md-3">
                                    <label for="searchPrice"
                                        class="form-label text-muted small fw-semibold">Price</label>
                                    <input type="text" class="form-control" id="searchPrice" name="searchPrice"
                                        value="${searchPrice}" placeholder="Enter Price">
                                </div>

                                <div class="col-md-3">
                                    <label for="searchCategory"
                                        class="form-label text-muted small fw-semibold">Category</label>
                                    <select class="form-select" id="searchCategory" name="searchCategory">
                                        <option value="">-- Tất cả danh mục --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}" ${searchCategory==cat.id ? 'selected' : '' }>
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-2 d-flex gap-2">
                                    <button type="submit" class="btn btn-primary px-3 fw-semibold w-100">
                                        <i class="bi bi-search me-1"></i> Search
                                    </button>
                                    <c:if
                                        test="${not empty searchName or not empty searchPrice or not empty searchCategory}">
                                        <a href="${pageContext.request.contextPath}/products"
                                            class="btn btn-outline-secondary" title="Đặt lại bộ lọc">
                                            <i class="bi bi-arrow-counterclockwise"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Bảng Danh sách Sản phẩm -->
                    <div class="card card-custom">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-custom table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th class="text-center" style="width: 60px;">STT</th>
                                            <th>Product Name</th>
                                            <th>Price</th>
                                            <th class="text-center">Quantity</th>
                                            <th>Color</th>
                                            <th>Category</th>
                                            <th class="text-center" style="width: 140px;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty products}">
                                                <c:forEach var="prod" items="${products}" varStatus="status">
                                                    <tr>
                                                        <td class="text-center fw-medium text-muted">${status.count}
                                                        </td>
                                                        <td class="fw-semibold text-dark">${prod.name}</td>
                                                        <td>
                                                            <span class="text-primary fw-bold">
                                                                <fmt:formatNumber value="${prod.price}" type="currency"
                                                                    currencySymbol="₫" maxFractionDigits="0" />
                                                            </span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge bg-light text-dark border px-2 py-1">${prod.quantity}</span>
                                                        </td>
                                                        <td>${prod.color}</td>
                                                        <td>
                                                            <span class="badge-category">${prod.categoryName}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <button type="button"
                                                                class="btn btn-sm btn-outline-primary me-1"
                                                                onclick="openEditModal('${prod.id}', '${prod.name}', '${prod.plainPrice}', '${prod.quantity}', '${prod.color}', '${prod.description}', '${prod.categoryId}')"
                                                                title="Sửa">
                                                                <i class="bi bi-pencil-square"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-delete"
                                                                onclick="confirmDelete('${prod.id}', '${prod.name}')"
                                                                title="Xóa">
                                                                <i class="bi bi-trash3 me-1"></i>Delete
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" class="text-center py-4 text-muted">
                                                        <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                                        Không tìm thấy sản phẩm nào phù hợp.
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div
                            class="card-footer bg-white border-top text-muted small py-3 px-4 d-flex justify-content-between align-items-center">
                            <span>Tổng số sản phẩm: <strong>${products.size()}</strong></span>
                        </div>
                    </div>

                </div>

                <!-- ============================================================ -->
                <!-- MODAL 1: THÊM MỚI SẢN PHẨM (Add New Product) -->
                <!-- ============================================================ -->
                <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-light">
                                <h5 class="modal-title fw-bold" id="createModalLabel">Add new product</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="createProductForm" action="${pageContext.request.contextPath}/products"
                                method="post" onsubmit="return validateCreateForm(event)">
                                <input type="hidden" name="action" value="create">

                                <div class="modal-body p-4">

                                    <!-- Tên sản phẩm (Name) -->
                                    <div class="mb-3">
                                        <label for="createName" class="form-label fw-semibold">
                                            Name <span class="text-danger">*</span>
                                        </label>
                                        <input type="text"
                                            class="form-control ${not empty errors.name ? 'is-invalid' : ''}"
                                            id="createName" name="name"
                                            value="${draftProduct != null ? draftProduct.name : ''}"
                                            placeholder="Nhập tên sản phẩm">
                                        <div id="nameError"
                                            class="invalid-feedback ${not empty errors.name ? 'd-block' : ''}">
                                            ${errors.name}
                                        </div>
                                    </div>

                                    <!-- Giá (Price) -->
                                    <div class="mb-3">
                                        <label for="createPrice" class="form-label fw-semibold">
                                            Price (VNĐ) <span class="text-danger">*</span>
                                        </label>
                                        <input type="number" step="any"
                                            class="form-control ${not empty errors.price ? 'is-invalid' : ''}"
                                            id="createPrice" name="price"
                                            value="${draftProduct != null && draftProduct.price > 0 ? draftProduct.plainPrice : ''}"
                                            placeholder="Nhập giá sản phẩm (> 10.000.000 VNĐ)">
                                        <div class="form-text text-muted small">Giá phải lớn hơn 10.000.000 VNĐ.</div>
                                        <div id="priceError"
                                            class="invalid-feedback ${not empty errors.price ? 'd-block' : ''}">
                                            ${errors.price}
                                        </div>
                                    </div>

                                    <!-- Số lượng (Quantity) -->
                                    <div class="mb-3">
                                        <label for="createQuantity" class="form-label fw-semibold">
                                            Quantity <span class="text-danger">*</span>
                                        </label>
                                        <input type="number"
                                            class="form-control ${not empty errors.quantity ? 'is-invalid' : ''}"
                                            id="createQuantity" name="quantity"
                                            value="${draftProduct != null && draftProduct.quantity > 0 ? draftProduct.quantity : ''}"
                                            placeholder="Nhập số lượng sản phẩm (> 0)">
                                        <div class="form-text text-muted small">Số lượng phải là số nguyên dương.</div>
                                        <div id="quantityError"
                                            class="invalid-feedback ${not empty errors.quantity ? 'd-block' : ''}">
                                            ${errors.quantity}
                                        </div>
                                    </div>

                                    <!-- Màu sắc (Color) -->
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <label class="form-label fw-semibold mb-0">
                                                Color <span class="text-danger">*</span>
                                            </label>
                                            <button type="button"
                                                class="btn btn-sm text-primary p-0 border-0 bg-transparent text-decoration-none fw-medium"
                                                style="font-size: 0.825rem;"
                                                onclick="addColorDropdown('createColorContainer')">
                                                <i class="bi bi-plus-circle me-1"></i> Thêm màu
                                            </button>
                                        </div>
                                        <div id="createColorContainer" class="d-flex flex-column gap-2">
                                            <div class="input-group color-select-row">
                                                <select
                                                    class="form-select ${not empty errors.color ? 'is-invalid' : ''}"
                                                    name="color">
                                                    <option value="">-- Chọn màu sắc --</option>
                                                    <option value="Đỏ" ${draftProduct !=null &&
                                                        draftProduct.color.contains('Đỏ') ? 'selected' : '' }>Đỏ
                                                    </option>
                                                    <option value="Xanh" ${draftProduct !=null &&
                                                        draftProduct.color.contains('Xanh') ? 'selected' : '' }>Xanh
                                                    </option>
                                                    <option value="Đen" ${draftProduct !=null &&
                                                        draftProduct.color.contains('Đen') ? 'selected' : '' }>Đen
                                                    </option>
                                                    <option value="Trắng" ${draftProduct !=null &&
                                                        draftProduct.color.contains('Trắng') ? 'selected' : '' }>Trắng
                                                    </option>
                                                    <option value="Vàng" ${draftProduct !=null &&
                                                        draftProduct.color.contains('Vàng') ? 'selected' : '' }>Vàng
                                                    </option>
                                                </select>
                                            </div>
                                        </div>
                                        <div id="colorError"
                                            class="invalid-feedback ${not empty errors.color ? 'd-block' : ''}">
                                            ${errors.color}
                                        </div>
                                    </div>

                                    <!-- Mô tả (Description) -->
                                    <div class="mb-3">
                                        <label for="createDescription"
                                            class="form-label fw-semibold">Description</label>
                                        <textarea class="form-control" id="createDescription" name="description"
                                            rows="3"
                                            placeholder="Nhập mô tả sản phẩm">${draftProduct != null ? draftProduct.description : ''}</textarea>
                                    </div>

                                    <!-- Danh mục (Category) -->
                                    <div class="mb-3">
                                        <label for="createCategory" class="form-label fw-semibold">
                                            Category <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select ${not empty errors.categoryId ? 'is-invalid' : ''}"
                                            id="createCategory" name="categoryId">
                                            <option value="">-- Chọn danh mục --</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}" ${draftProduct !=null &&
                                                    draftProduct.categoryId==cat.id ? 'selected' : '' }>
                                                    ${cat.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <div id="categoryError"
                                            class="invalid-feedback ${not empty errors.categoryId ? 'd-block' : ''}">
                                            ${errors.categoryId}
                                        </div>
                                    </div>

                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="submit" class="btn btn-success px-4 fw-semibold">
                                        <i class="bi bi-check2-circle me-1"></i> Create
                                    </button>
                                    <button type="button" class="btn btn-secondary px-4 fw-semibold"
                                        data-bs-dismiss="modal">
                                        Back
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ============================================================ -->
                <!-- MODAL 2: SỬA SẢN PHẨM (Edit Product) -->
                <!-- ============================================================ -->
                <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-light">
                                <h5 class="modal-title fw-bold" id="editModalLabel">Edit product</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="editProductForm" action="${pageContext.request.contextPath}/products"
                                method="post" onsubmit="return validateEditForm(event)">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" id="editId" name="id" value="">

                                <div class="modal-body p-4">

                                    <div class="mb-3">
                                        <label for="editName" class="form-label fw-semibold">
                                            Name <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="editName" name="name" required>
                                        <div id="editNameError" class="invalid-feedback"></div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editPrice" class="form-label fw-semibold">
                                            Price (VNĐ) <span class="text-danger">*</span>
                                        </label>
                                        <input type="number" step="any" class="form-control" id="editPrice" name="price"
                                            required>
                                        <div class="form-text text-muted small">Giá phải lớn hơn 10.000.000 VNĐ.</div>
                                        <div id="editPriceError" class="invalid-feedback"></div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editQuantity" class="form-label fw-semibold">
                                            Quantity <span class="text-danger">*</span>
                                        </label>
                                        <input type="number" class="form-control" id="editQuantity" name="quantity"
                                            required>
                                        <div id="editQuantityError" class="invalid-feedback"></div>
                                    </div>

                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <label class="form-label fw-semibold mb-0">
                                                Color <span class="text-danger">*</span>
                                            </label>
                                            <button type="button"
                                                class="btn btn-sm text-primary p-0 border-0 bg-transparent text-decoration-none fw-medium"
                                                style="font-size: 0.825rem;"
                                                onclick="addColorDropdown('editColorContainer')">
                                                <i class="bi bi-plus-circle me-1"></i>+ Thêm màu
                                            </button>
                                        </div>
                                        <div id="editColorContainer" class="d-flex flex-column gap-2">
                                            <div class="input-group color-select-row">
                                                <select class="form-select" name="color">
                                                    <option value="">-- Chọn màu sắc --</option>
                                                    <option value="Đỏ">Đỏ</option>
                                                    <option value="Xanh">Xanh</option>
                                                    <option value="Đen">Đen</option>
                                                    <option value="Trắng">Trắng</option>
                                                    <option value="Vàng">Vàng</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div id="editColorError" class="invalid-feedback"></div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editDescription" class="form-label fw-semibold">Description</label>
                                        <textarea class="form-control" id="editDescription" name="description"
                                            rows="3"></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="editCategory" class="form-label fw-semibold">
                                            Category <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="editCategory" name="categoryId" required>
                                            <option value="">-- Chọn danh mục --</option>
                                            <c:forEach var="cat" items="${categories}">
                                                <option value="${cat.id}">${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="editCategoryError" class="invalid-feedback"></div>
                                    </div>

                                </div>
                                <div class="modal-footer bg-light">
                                    <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                        <i class="bi bi-save me-1"></i> Save Changes
                                    </button>
                                    <button type="button" class="btn btn-secondary px-4 fw-semibold"
                                        data-bs-dismiss="modal">
                                        Back
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ============================================================ -->
                <!-- MODAL 3: XÁC NHẬN XÓA SẢN PHẨM (Delete Confirm Popup) -->
                <!-- ============================================================ -->
                <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title fw-bold" id="deleteModalLabel">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Xác nhận xóa
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4 text-center">
                                <p class="fs-5 mb-0" id="deleteModalMessage">
                                    Bạn có muốn xóa sản phẩm này hay không?
                                </p>
                            </div>
                            <div class="modal-footer bg-light justify-content-center">
                                <form id="deleteForm" action="${pageContext.request.contextPath}/products"
                                    method="post">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" id="deleteProductId" name="id" value="">
                                    <button type="button" class="btn btn-secondary px-4 fw-semibold"
                                        data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-danger px-4 fw-semibold">
                                        <i class="bi bi-trash3 me-1"></i>Đồng ý
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap 5 JS Bundle -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    const COLOR_OPTIONS = ['Đỏ', 'Xanh', 'Đen', 'Trắng', 'Vàng'];

                    // Thêm 1 dropdown màu mới
                    function addColorDropdown(containerId, selectedValue = '') {
                        const container = document.getElementById(containerId);
                        const rows = container.querySelectorAll('.color-select-row');
                        if (rows.length >= 3) {
                            alert('Tối đa 3 màu cho mỗi sản phẩm!');
                            return;
                        }

                        const row = document.createElement('div');
                        row.className = 'input-group color-select-row';

                        let optionsHtml = '<option value="">-- Chọn màu sắc --</option>';
                        COLOR_OPTIONS.forEach(function(c) {
                            const isSelected = (selectedValue && selectedValue.trim().toLowerCase() === c.toLowerCase()) ? 'selected' : '';
                            optionsHtml += '<option value="' + c + '" ' + isSelected + '>' + c + '</option>';
                        });

                        if (selectedValue && !COLOR_OPTIONS.some(function(c) { return c.toLowerCase() === selectedValue.trim().toLowerCase(); })) {
                            const trimmedVal = selectedValue.trim();
                            optionsHtml += '<option value="' + trimmedVal + '" selected>' + trimmedVal + '</option>';
                        }

                        row.innerHTML = 
                            '<select class="form-select" name="color">' +
                                optionsHtml +
                            '</select>' +
                            '<button class="btn btn-outline-danger btn-sm px-2" type="button" onclick="this.closest(\'.color-select-row\').remove()" title="Xóa ô màu này">' +
                                '<i class="bi bi-x-lg"></i>' +
                            '</button>';

                        container.appendChild(row);
                    }

                    // Mở popup xác nhận xóa với nội dung chuẩn theo đề bài:
                    // "Bạn có muốn xóa sản phẩm [A] hay không?"
                    function confirmDelete(id, name) {
                        document.getElementById('deleteProductId').value = id;
                        document.getElementById('deleteModalMessage').innerHTML =
                            'Bạn có muốn xóa sản phẩm <strong class="text-danger">' + escapeHtml(name) + '</strong> hay không?';

                        var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                        deleteModal.show();
                    }

                    // Mở popup sửa sản phẩm
                    function openEditModal(id, name, price, quantity, color, description, categoryId) {
                        document.getElementById('editId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editPrice').value = (price && !isNaN(price)) ? Number(price) : price;
                        document.getElementById('editQuantity').value = quantity;
                        document.getElementById('editDescription').value = description;
                        document.getElementById('editCategory').value = categoryId;

                        const container = document.getElementById('editColorContainer');
                        container.innerHTML = '';

                        if (color && color.trim()) {
                            const colors = color.split(',').map(function(c) { return c.trim(); }).filter(function(c) { return c.length > 0; });
                            colors.forEach(function(c, index) {
                                const row = document.createElement('div');
                                row.className = 'input-group color-select-row';

                                let optionsHtml = '<option value="">-- Chọn màu sắc --</option>';
                                COLOR_OPTIONS.forEach(function(ac) {
                                    const isSelected = (ac.toLowerCase() === c.toLowerCase()) ? 'selected' : '';
                                    optionsHtml += '<option value="' + ac + '" ' + isSelected + '>' + ac + '</option>';
                                });

                                if (!COLOR_OPTIONS.some(function(ac) { return ac.toLowerCase() === c.toLowerCase(); })) {
                                    optionsHtml += '<option value="' + c + '" selected>' + c + '</option>';
                                }

                                if (index === 0) {
                                    row.innerHTML = '<select class="form-select" name="color">' + optionsHtml + '</select>';
                                } else {
                                    row.innerHTML = 
                                        '<select class="form-select" name="color">' + optionsHtml + '</select>' +
                                        '<button class="btn btn-outline-danger btn-sm px-2" type="button" onclick="this.closest(\'.color-select-row\').remove()" title="Xóa ô màu này">' +
                                            '<i class="bi bi-x-lg"></i>' +
                                        '</button>';
                                }
                                container.appendChild(row);
                            });
                        } else {
                            const row = document.createElement('div');
                            row.className = 'input-group color-select-row';
                            let optionsHtml = '<option value="">-- Chọn màu sắc --</option>';
                            COLOR_OPTIONS.forEach(function(ac) {
                                optionsHtml += '<option value="' + ac + '">' + ac + '</option>';
                            });
                            row.innerHTML = '<select class="form-select" name="color">' + optionsHtml + '</select>';
                            container.appendChild(row);
                        }

                        var editModal = new bootstrap.Modal(document.getElementById('editModal'));
                        editModal.show();
                    }

                    // Client-side validation cho Form Thêm mới
                    function validateCreateForm(event) {
                        let isValid = true;

                        const nameInput = document.getElementById('createName');
                        const priceInput = document.getElementById('createPrice');
                        const quantityInput = document.getElementById('createQuantity');
                        const categoryInput = document.getElementById('createCategory');
                        const colorSelects = document.querySelectorAll('#createColorContainer select[name="color"]');
                        const selectedColors = Array.from(colorSelects).map(s => s.value.trim()).filter(v => v.length > 0);

                        const nameError = document.getElementById('nameError');
                        const priceError = document.getElementById('priceError');
                        const quantityError = document.getElementById('quantityError');
                        const colorError = document.getElementById('colorError');
                        const categoryError = document.getElementById('categoryError');

                        // Reset errors
                        [nameInput, priceInput, quantityInput, categoryInput].forEach(el => el.classList.remove('is-invalid'));
                        colorSelects.forEach(el => el.classList.remove('is-invalid'));
                        [nameError, priceError, quantityError, colorError, categoryError].forEach(el => {
                            el.classList.remove('d-block');
                            el.innerText = '';
                        });

                        // 1. Tên không được trống
                        if (!nameInput.value.trim()) {
                            nameInput.classList.add('is-invalid');
                            nameError.classList.add('d-block');
                            nameError.innerText = 'Tên sản phẩm không được để trống';
                            isValid = false;
                        }

                        // 2. Giá không để trống và > 10.000.000 VNĐ
                        const priceVal = parseFloat(priceInput.value);
                        if (!priceInput.value.trim()) {
                            priceInput.classList.add('is-invalid');
                            priceError.classList.add('d-block');
                            priceError.innerText = 'Giá không được để trống';
                            isValid = false;
                        } else if (isNaN(priceVal) || priceVal <= 10000000) {
                            priceInput.classList.add('is-invalid');
                            priceError.classList.add('d-block');
                            priceError.innerText = 'Giá phải lớn hơn 10.000.000 VNĐ';
                            isValid = false;
                        }

                        // 3. Số lượng không để trống và là số nguyên dương (> 0)
                        const qtyVal = parseInt(quantityInput.value, 10);
                        if (!quantityInput.value.trim()) {
                            quantityInput.classList.add('is-invalid');
                            quantityError.classList.add('d-block');
                            quantityError.innerText = 'Số lượng không được để trống';
                            isValid = false;
                        } else if (isNaN(qtyVal) || qtyVal <= 0 || !Number.isInteger(Number(quantityInput.value))) {
                            quantityInput.classList.add('is-invalid');
                            quantityError.classList.add('d-block');
                            quantityError.innerText = 'Số lượng phải là số nguyên dương (> 0)';
                            isValid = false;
                        }

                        // 4. Màu sắc phải có giá trị
                        if (selectedColors.length === 0) {
                            colorSelects.forEach(el => el.classList.add('is-invalid'));
                            colorError.classList.add('d-block');
                            colorError.innerText = 'Màu sắc phải có giá trị';
                            isValid = false;
                        }

                        // 5. Danh mục phải có giá trị
                        if (!categoryInput.value.trim()) {
                            categoryInput.classList.add('is-invalid');
                            categoryError.classList.add('d-block');
                            categoryError.innerText = 'Danh mục phải có giá trị';
                            isValid = false;
                        }

                        if (!isValid) {
                            event.preventDefault();
                            return false;
                        }
                        return true;
                    }

                    // Client-side validation cho Form Sửa
                    function validateEditForm(event) {
                        let isValid = true;
                        const nameInput = document.getElementById('editName');
                        const priceInput = document.getElementById('editPrice');
                        const quantityInput = document.getElementById('editQuantity');
                        const categoryInput = document.getElementById('editCategory');
                        const editColorSelects = document.querySelectorAll('#editColorContainer select[name="color"]');
                        const selectedEditColors = Array.from(editColorSelects).map(s => s.value.trim()).filter(v => v.length > 0);

                        const priceVal = parseFloat(priceInput.value);
                        const qtyVal = parseInt(quantityInput.value, 10);

                        if (!nameInput.value.trim() || isNaN(priceVal) || priceVal <= 10000000 ||
                            isNaN(qtyVal) || qtyVal <= 0 || selectedEditColors.length === 0 || !categoryInput.value.trim()) {
                            alert('Vui lòng kiểm tra lại thông tin: Giá > 10.000.000 VNĐ, Số lượng > 0, chọn ít nhất 1 Màu sắc và các trường bắt buộc!');
                            event.preventDefault();
                            return false;
                        }
                        return true;
                    }

                    function escapeHtml(text) {
                        var div = document.createElement('div');
                        div.appendChild(document.createTextNode(text));
                        return div.innerHTML;
                    }

                    // Nếu server trả về lỗi validate, tự động mở lại modal create
                    <c:if test="${openCreateModal}">
                        document.addEventListener("DOMContentLoaded", function() {
                var createModal = new bootstrap.Modal(document.getElementById('createModal'));
                        createModal.show();
            });
                    </c:if>
                </script>
            </body>

            </html>