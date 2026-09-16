<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="products" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - LuxTech Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .card-form {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            max-width: 650px;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <!-- Include Navbar -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <div class="container-fluid px-4 pb-5">
        <!-- Header -->
        <div class="mb-4 text-center">
            <h3 class="fw-bold text-dark mb-1">${pageTitle}</h3>
            <p class="text-secondary mb-0">Nhập đầy đủ các thông tin cần thiết của sản phẩm điện tử</p>
        </div>

        <div class="card card-form">
            <div class="card-body p-4 p-md-5">
                <!-- Error Alert -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2 fs-5"></i>
                        <div>${errorMessage}</div>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/products" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="${formAction}">
                    <input type="hidden" name="currentPage" value="${not empty param.page ? param.page : (not empty currentPage ? currentPage : '1')}">
                    <c:if test="${formAction == 'edit'}">
                        <input type="hidden" name="id" value="${product.id}">
                    </c:if>

                    <!-- Name -->
                    <div class="mb-4">
                        <label for="name" class="form-label fw-semibold">Tên Sản Phẩm <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-box-seam text-secondary"></i></span>
                            <input type="text" 
                                   class="form-control" 
                                   id="name" 
                                   name="name" 
                                   value="${product != null ? product.name : ''}" 
                                   placeholder="Ví dụ: iPhone 17 Pro Max 256GB" 
                                   required>
                        </div>
                    </div>

                    <!-- Category -->
                    <div class="mb-4">
                        <label for="categoryId" class="form-label fw-semibold">Danh Mục <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-grid text-secondary"></i></span>
                            <select class="form-select" id="categoryId" name="categoryId" required>
                                <option value="">-- Chọn danh mục sản phẩm --</option>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.id}" ${product != null && product.categoryId == c.id ? 'selected' : ''}>${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Image Upload & Selection -->
                    <div class="mb-4">
                        <label class="form-label fw-semibold d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-image text-primary me-1"></i> Hình Ảnh Sản Phẩm</span>
                            <span class="badge bg-light text-secondary border fw-normal">Hỗ trợ tải trực tiếp / URL</span>
                        </label>
                        
                        <!-- Upload Container -->
                        <div class="p-3 border rounded-3 bg-light">
                            <div class="d-flex flex-column flex-sm-row align-items-center gap-3">
                                <!-- Image Preview Box -->
                                <div class="position-relative flex-shrink-0" style="width: 110px; height: 110px; border-radius: 12px; overflow: hidden; background: #fff; border: 2px dashed #d1d5db; display: flex; align-items: center; justify-content: center;">
                                    <c:set var="hasInitialImg" value="${product != null && not empty product.image}" />
                                    <c:set var="initialImgSrc" value="${hasInitialImg ? (product.image.startsWith('http') ? product.image : pageContext.request.contextPath.concat('/assets/images/products/').concat(product.image)) : ''}" />
                                    
                                    <img id="imagePreview" 
                                         src="${initialImgSrc}" 
                                         alt="Xem trước ảnh" 
                                         style="width: 100%; height: 100%; object-fit: contain; ${hasInitialImg ? '' : 'display: none;'}"
                                         onerror="this.style.display='none'; document.getElementById('imagePlaceholder').style.display='flex';">
                                    
                                    <div id="imagePlaceholder" class="flex-column align-items-center justify-content-center text-muted" style="${hasInitialImg ? 'display: none;' : 'display: flex;'}">
                                        <i class="bi bi-cloud-arrow-up fs-2 text-primary"></i>
                                        <span style="font-size: 0.72rem;">Chưa có ảnh</span>
                                    </div>
                                </div>

                                <!-- File Select & URL Inputs -->
                                <div class="flex-grow-1 w-100">
                                    <!-- Direct File Upload Button / Input -->
                                    <div class="mb-2">
                                        <label for="imageFileInput" class="form-label small fw-semibold text-dark mb-1">
                                            <i class="bi bi-folder2-open text-primary me-1"></i> Chọn ảnh trực tiếp từ thiết bị:
                                        </label>
                                        <input type="file" 
                                               class="form-control form-control-sm" 
                                               id="imageFileInput" 
                                               name="imageFile" 
                                               accept="image/png, image/jpeg, image/webp, image/gif, image/svg+xml"
                                               onchange="handleFileSelect(this)">
                                        <div id="fileSelectedInfo" class="form-text text-success small mt-1" style="display: none;">
                                            <i class="bi bi-check-circle-fill me-1"></i>Đã chọn ảnh trực tiếp từ máy tính.
                                        </div>
                                    </div>

                                    <!-- Manual URL / Filename Input -->
                                    <div>
                                        <label for="image" class="form-label small fw-semibold text-muted mb-1">
                                            <i class="bi bi-link-45deg me-1"></i> Hoặc nhập đường dẫn online / tên file ảnh:
                                        </label>
                                        <div class="input-group input-group-sm">
                                            <input type="text" 
                                                   class="form-control" 
                                                   id="image" 
                                                   name="image" 
                                                   value="${product != null ? product.image : ''}" 
                                                   placeholder="vd: iphone-17.png hoặc https://example.com/anh.jpg"
                                                   oninput="handleUrlChange(this.value)">
                                            <button class="btn btn-outline-secondary" type="button" onclick="clearImageSelection()" title="Xóa chọn lại">
                                                <i class="bi bi-x-lg"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Price -->
                        <div class="col-md-6 mb-4">
                            <label for="price" class="form-label fw-semibold">Giá Bán (VNĐ) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-cash-stack text-secondary"></i></span>
                                <input type="number" 
                                       class="form-control" 
                                       id="price" 
                                       name="price" 
                                       step="1000"
                                       min="1000"
                                       value="${product != null ? product.price : ''}" 
                                       placeholder="Ví dụ: 34990000" 
                                       required>
                            </div>
                        </div>

                        <!-- Quantity -->
                        <div class="col-md-6 mb-4">
                            <label for="quantity" class="form-label fw-semibold">Số Lượng Tồn Kho <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-boxes text-secondary"></i></span>
                                <input type="number" 
                                       class="form-control" 
                                       id="quantity" 
                                       name="quantity" 
                                       min="0"
                                       value="${product != null ? product.quantity : '0'}" 
                                       placeholder="Ví dụ: 10" 
                                       required>
                            </div>
                        </div>
                    </div>

                    <!-- Product Colors Section -->
                    <div class="mb-4 pt-3 border-top">
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <div>
                                <label class="form-label fw-bold mb-0 d-flex align-items-center gap-2">
                                    <i class="bi bi-palette-fill text-primary fs-5"></i>
                                    Tùy Chọn Màu Sắc Sản Phẩm
                                </label>
                                <div class="text-muted small">Thêm các phiên bản màu sắc để khách hàng lựa chọn khi mua hàng.</div>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3 fw-semibold" onclick="addColorRow('', '#4f46e5')">
                                <i class="bi bi-plus-lg me-1"></i>Thêm Màu Sắc
                            </button>
                        </div>

                        <!-- Color List Rows -->
                        <div id="colorRowsContainer" class="d-flex flex-column gap-2 mt-3">
                            <c:forEach var="c" items="${product != null ? product.availableColors : null}">
                                <div class="color-row-item p-2 rounded-3 border bg-light d-flex align-items-center gap-2">
                                    <!-- Color Picker Swatch -->
                                    <input type="color" class="form-control form-control-color p-0 border-0" 
                                           value="${not empty c.hexCode ? c.hexCode : '#393836'}" 
                                           style="width: 38px; height: 38px; border-radius: 8px; cursor: pointer;"
                                           onchange="syncHex(this)" title="Chọn màu sắc trực quan">
                                    
                                    <!-- Hex Code Input -->
                                    <input type="text" name="colorHexes" class="form-control text-center font-monospace" 
                                           style="width: 105px; font-size: 0.85rem;" 
                                           value="${not empty c.hexCode ? c.hexCode : '#393836'}" 
                                           placeholder="#hex" oninput="syncPicker(this)" required>

                                    <!-- Color Name Input -->
                                    <input type="text" name="colorNames" class="form-control" 
                                           value="${c.name}" 
                                           placeholder="Tên màu (VD: Titan Sa Mạc, Đen Nhám...)" required>

                                    <!-- Remove Button -->
                                    <button type="button" class="btn btn-outline-danger btn-sm rounded-circle px-2" 
                                            onclick="removeColorRow(this)" title="Xóa màu này">
                                        <i class="bi bi-trash3"></i>
                                    </button>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Empty state when no color rows -->
                        <div id="noColorMessage" class="text-center p-3 border rounded-3 text-muted small bg-white mt-2" 
                             style="${product != null && not empty product.availableColors ? 'display: none;' : ''}">
                            <i class="bi bi-palette text-secondary fs-4 d-block mb-1"></i>
                            Chưa có màu sắc nào được thiết lập. 
                            <a href="javascript:void(0)" onclick="addColorRow('Đen Tiêu Chuẩn', '#1f2937')" class="text-decoration-none fw-semibold">
                                + Thêm màu mặc định ngay
                            </a>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/products${(not empty param.page and param.page != '1') ? '?page='.concat(param.page) : ((not empty currentPage and currentPage != '1') ? '?page='.concat(currentPage) : '')}" class="btn btn-light rounded-pill px-4">
                            <i class="bi bi-x-lg me-1"></i>Hủy Bỏ
                        </a>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm">
                            <i class="bi bi-floppy me-1"></i>
                            <c:choose>
                                <c:when test="${formAction == 'edit'}">Cập Nhật Sản Phẩm</c:when>
                                <c:otherwise>Lưu Sản Phẩm</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const contextPath = '${pageContext.request.contextPath}';

        function handleFileSelect(input) {
            const preview = document.getElementById('imagePreview');
            const placeholder = document.getElementById('imagePlaceholder');
            const info = document.getElementById('fileSelectedInfo');
            const urlInput = document.getElementById('image');

            if (input.files && input.files[0]) {
                const file = input.files[0];
                const reader = new FileReader();

                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    placeholder.style.display = 'none';
                };

                reader.readAsDataURL(file);
                info.style.display = 'block';
                info.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i>Đã chọn: <strong>' + file.name + '</strong> (' + (file.size / 1024).toFixed(1) + ' KB)';
                if (urlInput) {
                    urlInput.value = file.name;
                }
            }
        }

        function handleUrlChange(val) {
            const preview = document.getElementById('imagePreview');
            const placeholder = document.getElementById('imagePlaceholder');
            const fileInput = document.getElementById('imageFileInput');
            const info = document.getElementById('fileSelectedInfo');

            val = val.trim();
            if (val) {
                fileInput.value = '';
                info.style.display = 'none';

                if (val.startsWith('http://') || val.startsWith('https://')) {
                    preview.src = val;
                } else {
                    preview.src = contextPath + '/assets/images/products/' + val;
                }
                preview.style.display = 'block';
                placeholder.style.display = 'none';
            } else {
                preview.style.display = 'none';
                placeholder.style.display = 'flex';
            }
        }

        function clearImageSelection() {
            const preview = document.getElementById('imagePreview');
            const placeholder = document.getElementById('imagePlaceholder');
            const fileInput = document.getElementById('imageFileInput');
            const urlInput = document.getElementById('image');
            const info = document.getElementById('fileSelectedInfo');

            fileInput.value = '';
            urlInput.value = '';
            info.style.display = 'none';
            preview.src = '';
            preview.style.display = 'none';
            placeholder.style.display = 'flex';
        }

        function updateEmptyState() {
            const container = document.getElementById('colorRowsContainer');
            const emptyMsg = document.getElementById('noColorMessage');
            if (container.children.length === 0) {
                emptyMsg.style.display = 'block';
            } else {
                emptyMsg.style.display = 'none';
            }
        }

        function syncHex(colorPicker) {
            const row = colorPicker.closest('.color-row-item');
            if (row) {
                const hexInput = row.querySelector('input[name="colorHexes"]');
                if (hexInput) hexInput.value = colorPicker.value;
            }
        }

        function syncPicker(hexInput) {
            const row = hexInput.closest('.color-row-item');
            if (row) {
                let val = hexInput.value.trim();
                if (!val.startsWith('#')) val = '#' + val;
                if (/^#[0-9A-Fa-f]{6}$/.test(val)) {
                    const picker = row.querySelector('input[type="color"]');
                    if (picker) picker.value = val;
                }
            }
        }

        function removeColorRow(btn) {
            const row = btn.closest('.color-row-item');
            if (row) {
                row.remove();
                updateEmptyState();
            }
        }

        function addColorRow(name = '', hex = '#3b82f6') {
            const container = document.getElementById('colorRowsContainer');
            if (!hex.startsWith('#')) hex = '#' + hex;

            const div = document.createElement('div');
            div.className = 'color-row-item p-2 rounded-3 border bg-light d-flex align-items-center gap-2';
            div.innerHTML = `
                <input type="color" class="form-control form-control-color p-0 border-0" 
                       value="${hex}" 
                       style="width: 38px; height: 38px; border-radius: 8px; cursor: pointer;"
                       onchange="syncHex(this)" title="Chọn màu sắc trực quan">
                
                <input type="text" name="colorHexes" class="form-control text-center font-monospace" 
                       style="width: 105px; font-size: 0.85rem;" 
                       value="${hex}" 
                       placeholder="#hex" oninput="syncPicker(this)" required>

                <input type="text" name="colorNames" class="form-control" 
                       value="${name}" 
                       placeholder="Tên màu (VD: Titan Sa Mạc, Đen Nhám...)" required>

                <button type="button" class="btn btn-outline-danger btn-sm rounded-circle px-2" 
                        onclick="removeColorRow(this)" title="Xóa màu này">
                    <i class="bi bi-trash3"></i>
                </button>
            `;

            container.appendChild(div);
            updateEmptyState();
            div.querySelector('input[name="colorNames"]').focus();
        }

        // Tự động thêm 1 dòng mẫu khi tạo mới sản phẩm nếu chưa có màu nào
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.getElementById('colorRowsContainer');
            if (container && container.children.length === 0) {
                // Trang tạo mới
                addColorRow('Màu Mặc Định', '#1e293b');
            }
        });
    </script>
</body>
</html>
