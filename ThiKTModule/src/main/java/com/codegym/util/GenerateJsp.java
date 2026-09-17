package com.codegym.util;

import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;

public class GenerateJsp {
    public static void main(String[] args) throws Exception {
        String jsp = 
            "<%@ page contentType=\"text/html; charset=UTF-8\" pageEncoding=\"UTF-8\" %>\n" +
            "<%@ taglib prefix=\"c\" uri=\"jakarta.tags.core\" %>\n" +
            "<%@ taglib prefix=\"fmt\" uri=\"jakarta.tags.fmt\" %>\n" +
            "<!DOCTYPE html>\n" +
            "<html lang=\"vi\">\n" +
            "<head>\n" +
            "    <meta charset=\"UTF-8\">\n" +
            "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
            "    <title>Qu\u1ea3n l\u00fd s\u1ea3n ph\u1ea9m - CodeGym</title>\n" +
            "    <!-- Bootstrap 5 CSS -->\n" +
            "    <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n" +
            "    <!-- Bootstrap Icons -->\n" +
            "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css\">\n" +
            "    <!-- Google Fonts -->\n" +
            "    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n" +
            "    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n" +
            "    <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap\" rel=\"stylesheet\">\n" +
            "    <style>\n" +
            "        body {\n" +
            "            font-family: 'Inter', sans-serif;\n" +
            "            background-color: #f4f6f9;\n" +
            "            color: #333;\n" +
            "        }\n" +
            "        .navbar-custom {\n" +
            "            background-color: #0d6efd;\n" +
            "            box-shadow: 0 2px 4px rgba(0,0,0,0.1);\n" +
            "        }\n" +
            "        .card-custom {\n" +
            "            border: 1px solid #e2e8f0;\n" +
            "            border-radius: 8px;\n" +
            "            box-shadow: 0 2px 6px rgba(0,0,0,0.04);\n" +
            "            background: #fff;\n" +
            "        }\n" +
            "        .table-custom thead th {\n" +
            "            background-color: #f8fafc;\n" +
            "            color: #475569;\n" +
            "            font-weight: 600;\n" +
            "            border-bottom: 2px solid #e2e8f0;\n" +
            "            font-size: 0.875rem;\n" +
            "            text-transform: uppercase;\n" +
            "            letter-spacing: 0.5px;\n" +
            "        }\n" +
            "        .table-custom tbody tr:hover {\n" +
            "            background-color: #f1f5f9;\n" +
            "        }\n" +
            "        .table-custom td {\n" +
            "            vertical-align: middle;\n" +
            "            font-size: 0.925rem;\n" +
            "        }\n" +
            "        .btn-delete {\n" +
            "            color: #dc3545;\n" +
            "            background-color: #fff;\n" +
            "            border: 1px solid #fecdd3;\n" +
            "            transition: all 0.2s;\n" +
            "        }\n" +
            "        .btn-delete:hover {\n" +
            "            background-color: #dc3545;\n" +
            "            color: #fff;\n" +
            "        }\n" +
            "        .badge-color {\n" +
            "            padding: 4px 10px;\n" +
            "            border-radius: 20px;\n" +
            "            font-size: 0.8rem;\n" +
            "            font-weight: 500;\n" +
            "            background-color: #e2e8f0;\n" +
            "            color: #334155;\n" +
            "            display: inline-block;\n" +
            "        }\n" +
            "        .badge-category {\n" +
            "            background-color: #e0f2fe;\n" +
            "            color: #0369a1;\n" +
            "            font-weight: 600;\n" +
            "            padding: 4px 10px;\n" +
            "            border-radius: 6px;\n" +
            "            font-size: 0.825rem;\n" +
            "        }\n" +
            "    </style>\n" +
            "</head>\n" +
            "<body>\n\n" +
            "    <!-- Header / Navbar -->\n" +
            "    <nav class=\"navbar navbar-dark navbar-custom px-4 py-2\">\n" +
            "        <div class=\"container-fluid px-0\">\n" +
            "            <a class=\"navbar-brand fw-bold fs-5\" href=\"${pageContext.request.contextPath}/products\">\n" +
            "                <i class=\"bi bi-box-seam me-2\"></i>Management Product\n" +
            "            </a>\n" +
            "            <button type=\"button\" class=\"btn btn-light text-primary fw-semibold shadow-sm\" data-bs-toggle=\"modal\" data-bs-target=\"#createModal\">\n" +
            "                <i class=\"bi bi-plus-circle me-1\"></i> Add Product\n" +
            "            </button>\n" +
            "        </div>\n" +
            "    </nav>\n\n" +
            "    <div class=\"container-fluid px-4 py-4\">\n\n" +
            "        <!-- Th\u00f4ng b\u00e1o th\u00e0nh c\u00f4ng n\u1ebfu c\u00f3 -->\n" +
            "        <c:if test=\"${not empty successMessage}\">\n" +
            "            <div class=\"alert alert-success alert-dismissible fade show d-flex align-items-center mb-4 shadow-sm\" role=\"alert\">\n" +
            "                <i class=\"bi bi-check-circle-fill fs-5 me-2\"></i>\n" +
            "                <div class=\"fw-medium\">${successMessage}</div>\n" +
            "                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n" +
            "            </div>\n" +
            "        </c:if>\n\n" +
            "        <!-- Khung T\u00ecm ki\u1ebfm (Find Product) -->\n" +
            "        <div class=\"card card-custom mb-4\">\n" +
            "            <div class=\"card-body p-4\">\n" +
            "                <h6 class=\"card-title fw-bold text-dark mb-3\">Find Product</h6>\n" +
            "                <form action=\"${pageContext.request.contextPath}/products\" method=\"get\" class=\"row g-3 align-items-end\">\n" +
            "                    <input type=\"hidden\" name=\"action\" value=\"search\">\n" +
            "                    \n" +
            "                    <div class=\"col-md-4\">\n" +
            "                        <label for=\"searchName\" class=\"form-label text-muted small fw-semibold\">Product Name</label>\n" +
            "                        <input type=\"text\" class=\"form-control\" id=\"searchName\" name=\"searchName\" \n" +
            "                               value=\"${searchName}\" placeholder=\"Enter Product Name\">\n" +
            "                    </div>\n\n" +
            "                    <div class=\"col-md-3\">\n" +
            "                        <label for=\"searchPrice\" class=\"form-label text-muted small fw-semibold\">Price</label>\n" +
            "                        <input type=\"text\" class=\"form-control\" id=\"searchPrice\" name=\"searchPrice\" \n" +
            "                               value=\"${searchPrice}\" placeholder=\"Enter Price\">\n" +
            "                    </div>\n\n" +
            "                    <div class=\"col-md-3\">\n" +
            "                        <label for=\"searchCategory\" class=\"form-label text-muted small fw-semibold\">Category</label>\n" +
            "                        <select class=\"form-select\" id=\"searchCategory\" name=\"searchCategory\">\n" +
            "                            <option value=\"\">-- T\u1ea5t c\u1ea3 danh m\u1ee5c --</option>\n" +
            "                            <c:forEach var=\"cat\" items=\"${categories}\">\n" +
            "                                <option value=\"${cat.id}\" ${searchCategory == cat.id ? 'selected' : ''}>\n" +
            "                                    ${cat.name}\n" +
            "                                </option>\n" +
            "                            </c:forEach>\n" +
            "                        </select>\n" +
            "                    </div>\n\n" +
            "                    <div class=\"col-md-2 d-flex gap-2\">\n" +
            "                        <button type=\"submit\" class=\"btn btn-primary px-3 fw-semibold w-100\">\n" +
            "                            <i class=\"bi bi-search me-1\"></i> Search\n" +
            "                        </button>\n" +
            "                        <c:if test=\"${not empty searchName or not empty searchPrice or not empty searchCategory}\">\n" +
            "                            <a href=\"${pageContext.request.contextPath}/products\" class=\"btn btn-outline-secondary\" title=\"\u0110\u1eb7t l\u1ea1i b\u1ed9 l\u1ecdc\">\n" +
            "                                <i class=\"bi bi-arrow-counterclockwise\"></i>\n" +
            "                            </a>\n" +
            "                        </c:if>\n" +
            "                    </div>\n" +
            "                </form>\n" +
            "            </div>\n" +
            "        </div>\n\n" +
            "        <!-- B\u1ea3ng Danh s\u00e1ch S\u1ea3n ph\u1ea9m -->\n" +
            "        <div class=\"card card-custom\">\n" +
            "            <div class=\"card-body p-0\">\n" +
            "                <div class=\"table-responsive\">\n" +
            "                    <table class=\"table table-custom table-hover align-middle mb-0\">\n" +
            "                        <thead>\n" +
            "                            <tr>\n" +
            "                                <th class=\"text-center\" style=\"width: 60px;\">STT</th>\n" +
            "                                <th>Product Name</th>\n" +
            "                                <th>Price</th>\n" +
            "                                <th class=\"text-center\">Quantity</th>\n" +
            "                                <th>Color</th>\n" +
            "                                <th>Category</th>\n" +
            "                                <th class=\"text-center\" style=\"width: 140px;\">Action</th>\n" +
            "                            </tr>\n" +
            "                        </thead>\n" +
            "                        <tbody>\n" +
            "                            <c:choose>\n" +
            "                                <c:when test=\"${not empty products}\">\n" +
            "                                    <c:forEach var=\"prod\" items=\"${products}\" varStatus=\"status\">\n" +
            "                                        <tr>\n" +
            "                                            <td class=\"text-center fw-medium text-muted\">${status.count}</td>\n" +
            "                                            <td class=\"fw-semibold text-dark\">${prod.name}</td>\n" +
            "                                            <td>\n" +
            "                                                <span class=\"text-primary fw-bold\">\n" +
            "                                                    <fmt:formatNumber value=\"${prod.price}\" type=\"currency\" currencySymbol=\"\u20ab\" maxFractionDigits=\"0\"/>\n" +
            "                                                </span>\n" +
            "                                            </td>\n" +
            "                                            <td class=\"text-center\">\n" +
            "                                                <span class=\"badge bg-light text-dark border px-2 py-1\">${prod.quantity}</span>\n" +
            "                                            </td>\n" +
            "                                            <td>${prod.color}</td>\n" +
            "                                            <td>\n" +
            "                                                <span class=\"badge-category\">${prod.categoryName}</span>\n" +
            "                                            </td>\n" +
            "                                            <td class=\"text-center\">\n" +
            "                                                <button type=\"button\" class=\"btn btn-sm btn-outline-primary me-1\" \n" +
            "                                                        onclick=\"openEditModal('${prod.id}', '${prod.name}', '${prod.plainPrice}', '${prod.quantity}', '${prod.color}', '${prod.description}', '${prod.categoryId}')\"\n" +
            "                                                        title=\"S\u1eeda\">\n" +
            "                                                    <i class=\"bi bi-pencil-square\"></i>\n" +
            "                                                </button>\n" +
            "                                                <button type=\"button\" class=\"btn btn-sm btn-delete\" \n" +
            "                                                        onclick=\"confirmDelete('${prod.id}', '${prod.name}')\"\n" +
            "                                                        title=\"X\u00f3a\">\n" +
            "                                                    <i class=\"bi bi-trash3 me-1\"></i>Delete\n" +
            "                                                </button>\n" +
            "                                            </td>\n" +
            "                                        </tr>\n" +
            "                                    </c:forEach>\n" +
            "                                </c:when>\n" +
            "                                <c:otherwise>\n" +
            "                                    <tr>\n" +
            "                                        <td colspan=\"7\" class=\"text-center py-4 text-muted\">\n" +
            "                                            <i class=\"bi bi-inbox fs-2 d-block mb-2 text-secondary\"></i>\n" +
            "                                            Kh\u00f4ng t\u00ecm th\u1ea5y s\u1ea3n ph\u1ea9m n\u00e0o ph\u00f9 h\u1ee3p.\n" +
            "                                        </td>\n" +
            "                                    </tr>\n" +
            "                                </c:otherwise>\n" +
            "                            </c:choose>\n" +
            "                        </tbody>\n" +
            "                    </table>\n" +
            "                </div>\n" +
            "            </div>\n" +
            "            <div class=\"card-footer bg-white border-top text-muted small py-3 px-4 d-flex justify-content-between align-items-center\">\n" +
            "                <span>T\u1ed5ng s\u1ed1 s\u1ea3n ph\u1ea9m: <strong>${products.size()}</strong></span>\n" +
            "            </div>\n" +
            "        </div>\n\n" +
            "    </div>\n\n" +
            "    <!-- ============================================================ -->\n" +
            "    <!-- MODAL 1: TH\u00caM M\u1edaI S\u1ea2N PH\u1ea8M (Add New Product) -->\n" +
            "    <!-- ============================================================ -->\n" +
            "    <div class=\"modal fade\" id=\"createModal\" tabindex=\"-1\" aria-labelledby=\"createModalLabel\" aria-hidden=\"true\">\n" +
            "        <div class=\"modal-dialog modal-dialog-centered modal-lg\">\n" +
            "            <div class=\"modal-content\">\n" +
            "                <div class=\"modal-header bg-light\">\n" +
            "                    <h5 class=\"modal-title fw-bold\" id=\"createModalLabel\">Add new product</h5>\n" +
            "                    <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>\n" +
            "                </div>\n" +
            "                <form id=\"createProductForm\" action=\"${pageContext.request.contextPath}/products\" method=\"post\" onsubmit=\"return validateCreateForm(event)\">\n" +
            "                    <input type=\"hidden\" name=\"action\" value=\"create\">\n" +
            "                    \n" +
            "                    <div class=\"modal-body p-4\">\n\n" +
            "                        <!-- T\u00ean s\u1ea3n ph\u1ea9m (Name) -->\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"createName\" class=\"form-label fw-semibold\">\n" +
            "                                Name <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <input type=\"text\" class=\"form-control ${not empty errors.name ? 'is-invalid' : ''}\" \n" +
            "                                   id=\"createName\" name=\"name\" \n" +
            "                                   value=\"${draftProduct != null ? draftProduct.name : ''}\"\n" +
            "                                   placeholder=\"Nh\u1eadp t\u00ean s\u1ea3n ph\u1ea9m\">\n" +
            "                            <div id=\"nameError\" class=\"invalid-feedback ${not empty errors.name ? 'd-block' : ''}\">\n" +
            "                                ${errors.name}\n" +
            "                            </div>\n" +
            "                        </div>\n\n" +
            "                        <!-- Gi\u00e1 (Price) -->\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"createPrice\" class=\"form-label fw-semibold\">\n" +
            "                                Price (VN\u0110) <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <input type=\"number\" step=\"any\" class=\"form-control ${not empty errors.price ? 'is-invalid' : ''}\" \n" +
            "                                   id=\"createPrice\" name=\"price\" \n" +
            "                                   value=\"${draftProduct != null && draftProduct.price > 0 ? draftProduct.plainPrice : ''}\"\n" +
            "                                   placeholder=\"Nh\u1eadp gi\u00e1 s\u1ea3n ph\u1ea9m (> 10.000.000 VN\u0110)\">\n" +
            "                            <div class=\"form-text text-muted small\">Gi\u00e1 ph\u1ea3i l\u1edbn h\u01a1n 10.000.000 VN\u0110.</div>\n" +
            "                            <div id=\"priceError\" class=\"invalid-feedback ${not empty errors.price ? 'd-block' : ''}\">\n" +
            "                                ${errors.price}\n" +
            "                            </div>\n" +
            "                        </div>\n\n" +
            "                        <!-- S\u1ed1 l\u01b0\u1ee3ng (Quantity) -->\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"createQuantity\" class=\"form-label fw-semibold\">\n" +
            "                                Quantity <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <input type=\"number\" class=\"form-control ${not empty errors.quantity ? 'is-invalid' : ''}\" \n" +
            "                                   id=\"createQuantity\" name=\"quantity\" \n" +
            "                                   value=\"${draftProduct != null && draftProduct.quantity > 0 ? draftProduct.quantity : ''}\"\n" +
            "                                   placeholder=\"Nh\u1eadp s\u1ed1 l\u01b0\u1ee3ng s\u1ea3n ph\u1ea9m (> 0)\">\n" +
            "                            <div class=\"form-text text-muted small\">S\u1ed1 l\u01b0\u1ee3ng ph\u1ea3i l\u00e0 s\u1ed1 nguy\u00ean d\u01b0\u01a1ng.</div>\n" +
            "                            <div id=\"quantityError\" class=\"invalid-feedback ${not empty errors.quantity ? 'd-block' : ''}\">\n" +
            "                                ${errors.quantity}\n" +
            "                            </div>\n" +
            "                        </div>\n\n" +
            "                        <!-- M\u00e0u s\u1eafc (Color) -->\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <div class=\"d-flex justify-content-between align-items-center mb-1\">\n" +
            "                                <label class=\"form-label fw-semibold mb-0\">\n" +
            "                                    Color <span class=\"text-danger\">*</span>\n" +
            "                                </label>\n" +
            "                                <button type=\"button\" class=\"btn btn-sm text-primary p-0 border-0 bg-transparent text-decoration-none fw-medium\" \n" +
            "                                        style=\"font-size: 0.825rem;\" \n" +
            "                                        onclick=\"addColorDropdown('createColorContainer')\">\n" +
            "                                    <i class=\"bi bi-plus-circle me-1\"></i>+ Th\u00eam m\u00e0u\n" +
            "                                </button>\n" +
            "                            </div>\n" +
            "                            <div id=\"createColorContainer\" class=\"d-flex flex-column gap-2\">\n" +
            "                                <div class=\"input-group color-select-row\">\n" +
            "                                    <select class=\"form-select ${not empty errors.color ? 'is-invalid' : ''}\" name=\"color\">\n" +
            "                                        <option value=\"\">-- Ch\u1ecdn m\u00e0u s\u1eafc --</option>\n" +
            "                                        <option value=\"\u0110\u1ecf\" ${draftProduct != null && draftProduct.color.contains('\u0110\u1ecf') ? 'selected' : ''}>\u0110\u1ecf</option>\n" +
            "                                        <option value=\"Xanh\" ${draftProduct != null && draftProduct.color.contains('Xanh') ? 'selected' : ''}>Xanh</option>\n" +
            "                                        <option value=\"\u0110en\" ${draftProduct != null && draftProduct.color.contains('\u0110en') ? 'selected' : ''}>\u0110en</option>\n" +
            "                                        <option value=\"Tr\u1eafng\" ${draftProduct != null && draftProduct.color.contains('Tr\u1eafng') ? 'selected' : ''}>Tr\u1eafng</option>\n" +
            "                                        <option value=\"V\u00e0ng\" ${draftProduct != null && draftProduct.color.contains('V\u00e0ng') ? 'selected' : ''}>V\u00e0ng</option>\n" +
            "                                    </select>\n" +
            "                                </div>\n" +
            "                            </div>\n" +
            "                            <div id=\"colorError\" class=\"invalid-feedback ${not empty errors.color ? 'd-block' : ''}\">\n" +
            "                                ${errors.color}\n" +
            "                            </div>\n" +
            "                        </div>\n\n" +
            "                        <!-- M\u00f4 t\u1ea3 (Description) -->\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"createDescription\" class=\"form-label fw-semibold\">Description</label>\n" +
            "                            <textarea class=\"form-control\" id=\"createDescription\" name=\"description\" rows=\"3\" \n" +
            "                                      placeholder=\"Nh\u1eadp m\u00f4 t\u1ea3 s\u1ea3n ph\u1ea9m\">${draftProduct != null ? draftProduct.description : ''}</textarea>\n" +
            "                        </div>\n\n" +
            "                        <!-- Danh m\u1ee5c (Category) -->\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"createCategory\" class=\"form-label fw-semibold\">\n" +
            "                                Category <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <select class=\"form-select ${not empty errors.categoryId ? 'is-invalid' : ''}\" id=\"createCategory\" name=\"categoryId\">\n" +
            "                                <option value=\"\">-- Ch\u1ecdn danh m\u1ee5c --</option>\n" +
            "                                <c:forEach var=\"cat\" items=\"${categories}\">\n" +
            "                                    <option value=\"${cat.id}\" ${draftProduct != null && draftProduct.categoryId == cat.id ? 'selected' : ''}>\n" +
            "                                        ${cat.name}\n" +
            "                                    </option>\n" +
            "                                </c:forEach>\n" +
            "                            </select>\n" +
            "                            <div id=\"categoryError\" class=\"invalid-feedback ${not empty errors.categoryId ? 'd-block' : ''}\">\n" +
            "                                ${errors.categoryId}\n" +
            "                            </div>\n" +
            "                        </div>\n\n" +
            "                    </div>\n" +
            "                    <div class=\"modal-footer bg-light\">\n" +
            "                        <button type=\"submit\" class=\"btn btn-success px-4 fw-semibold\">\n" +
            "                            <i class=\"bi bi-check2-circle me-1\"></i> Create\n" +
            "                        </button>\n" +
            "                        <button type=\"button\" class=\"btn btn-secondary px-4 fw-semibold\" data-bs-dismiss=\"modal\">\n" +
            "                            Back\n" +
            "                        </button>\n" +
            "                    </div>\n" +
            "                </form>\n" +
            "            </div>\n" +
            "        </div>\n" +
            "    </div>\n\n" +
            "    <!-- ============================================================ -->\n" +
            "    <!-- MODAL 2: S\u1eecA S\u1ea2N PH\u1ea8M (Edit Product) -->\n" +
            "    <!-- ============================================================ -->\n" +
            "    <div class=\"modal fade\" id=\"editModal\" tabindex=\"-1\" aria-labelledby=\"editModalLabel\" aria-hidden=\"true\">\n" +
            "        <div class=\"modal-dialog modal-dialog-centered modal-lg\">\n" +
            "            <div class=\"modal-content\">\n" +
            "                <div class=\"modal-header bg-light\">\n" +
            "                    <h5 class=\"modal-title fw-bold\" id=\"editModalLabel\">Edit product</h5>\n" +
            "                    <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>\n" +
            "                </div>\n" +
            "                <form id=\"editProductForm\" action=\"${pageContext.request.contextPath}/products\" method=\"post\" onsubmit=\"return validateEditForm(event)\">\n" +
            "                    <input type=\"hidden\" name=\"action\" value=\"update\">\n" +
            "                    <input type=\"hidden\" id=\"editId\" name=\"id\" value=\"\">\n" +
            "                    \n" +
            "                    <div class=\"modal-body p-4\">\n\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"editName\" class=\"form-label fw-semibold\">\n" +
            "                                Name <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <input type=\"text\" class=\"form-control\" id=\"editName\" name=\"name\" required>\n" +
            "                            <div id=\"editNameError\" class=\"invalid-feedback\"></div>\n" +
            "                        </div>\n\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"editPrice\" class=\"form-label fw-semibold\">\n" +
            "                                Price (VN\u0110) <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <input type=\"number\" step=\"any\" class=\"form-control\" id=\"editPrice\" name=\"price\" required>\n" +
            "                            <div class=\"form-text text-muted small\">Gi\u00e1 ph\u1ea3i l\u1edbn h\u01a1n 10.000.000 VN\u0110.</div>\n" +
            "                            <div id=\"editPriceError\" class=\"invalid-feedback\"></div>\n" +
            "                        </div>\n\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"editQuantity\" class=\"form-label fw-semibold\">\n" +
            "                                Quantity <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <input type=\"number\" class=\"form-control\" id=\"editQuantity\" name=\"quantity\" required>\n" +
            "                            <div id=\"editQuantityError\" class=\"invalid-feedback\"></div>\n" +
            "                        </div>\n\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <div class=\"d-flex justify-content-between align-items-center mb-1\">\n" +
            "                                <label class=\"form-label fw-semibold mb-0\">\n" +
            "                                    Color <span class=\"text-danger\">*</span>\n" +
            "                                </label>\n" +
            "                                <button type=\"button\" class=\"btn btn-sm text-primary p-0 border-0 bg-transparent text-decoration-none fw-medium\" \n" +
            "                                        style=\"font-size: 0.825rem;\" \n" +
            "                                        onclick=\"addColorDropdown('editColorContainer')\">\n" +
            "                                    <i class=\"bi bi-plus-circle me-1\"></i>+ Th\u00eam m\u00e0u\n" +
            "                                </button>\n" +
            "                            </div>\n" +
            "                            <div id=\"editColorContainer\" class=\"d-flex flex-column gap-2\">\n" +
            "                                <div class=\"input-group color-select-row\">\n" +
            "                                    <select class=\"form-select\" name=\"color\">\n" +
            "                                        <option value=\"\">-- Ch\u1ecdn m\u00e0u s\u1eafc --</option>\n" +
            "                                        <option value=\"\u0110\u1ecf\">\u0110\u1ecf</option>\n" +
            "                                        <option value=\"Xanh\">Xanh</option>\n" +
            "                                        <option value=\"\u0110en\">\u0110en</option>\n" +
            "                                        <option value=\"Tr\u1eafng\">Tr\u1eafng</option>\n" +
            "                                        <option value=\"V\u00e0ng\">V\u00e0ng</option>\n" +
            "                                    </select>\n" +
            "                                </div>\n" +
            "                            </div>\n" +
            "                            <div id=\"editColorError\" class=\"invalid-feedback\"></div>\n" +
            "                        </div>\n\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"editDescription\" class=\"form-label fw-semibold\">Description</label>\n" +
            "                            <textarea class=\"form-control\" id=\"editDescription\" name=\"description\" rows=\"3\"></textarea>\n" +
            "                        </div>\n\n" +
            "                        <div class=\"mb-3\">\n" +
            "                            <label for=\"editCategory\" class=\"form-label fw-semibold\">\n" +
            "                                Category <span class=\"text-danger\">*</span>\n" +
            "                            </label>\n" +
            "                            <select class=\"form-select\" id=\"editCategory\" name=\"categoryId\" required>\n" +
            "                                <option value=\"\">-- Ch\u1ecdn danh m\u1ee5c --</option>\n" +
            "                                <c:forEach var=\"cat\" items=\"${categories}\">\n" +
            "                                    <option value=\"${cat.id}\">${cat.name}</option>\n" +
            "                                </c:forEach>\n" +
            "                            </select>\n" +
            "                            <div id=\"editCategoryError\" class=\"invalid-feedback\"></div>\n" +
            "                        </div>\n\n" +
            "                    </div>\n" +
            "                    <div class=\"modal-footer bg-light\">\n" +
            "                        <button type=\"submit\" class=\"btn btn-primary px-4 fw-semibold\">\n" +
            "                            <i class=\"bi bi-save me-1\"></i> Save Changes\n" +
            "                        </button>\n" +
            "                        <button type=\"button\" class=\"btn btn-secondary px-4 fw-semibold\" data-bs-dismiss=\"modal\">\n" +
            "                            Back\n" +
            "                        </button>\n" +
            "                    </div>\n" +
            "                </form>\n" +
            "            </div>\n" +
            "        </div>\n" +
            "    </div>\n\n" +
            "    <!-- ============================================================ -->\n" +
            "    <!-- MODAL 3: X\u00c1C NH\u1eacN X\u00d3A S\u1ea2N PH\u1ea8M (Delete Confirm Popup) -->\n" +
            "    <!-- ============================================================ -->\n" +
            "    <div class=\"modal fade\" id=\"deleteConfirmModal\" tabindex=\"-1\" aria-labelledby=\"deleteModalLabel\" aria-hidden=\"true\">\n" +
            "        <div class=\"modal-dialog modal-dialog-centered\">\n" +
            "            <div class=\"modal-content\">\n" +
            "                <div class=\"modal-header bg-danger text-white\">\n" +
            "                    <h5 class=\"modal-title fw-bold\" id=\"deleteModalLabel\">\n" +
            "                        <i class=\"bi bi-exclamation-triangle-fill me-2\"></i>X\u00e1c nh\u1eadn x\u00f3a\n" +
            "                    </h5>\n" +
            "                    <button type=\"button\" class=\"btn-close btn-close-white\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>\n" +
            "                </div>\n" +
            "                <div class=\"modal-body p-4 text-center\">\n" +
            "                    <p class=\"fs-5 mb-0\" id=\"deleteModalMessage\">\n" +
            "                        B\u1ea1n c\u00f3 mu\u1ed1n x\u00f3a s\u1ea3n ph\u1ea9m n\u00e0y hay kh\u00f4ng?\n" +
            "                    </p>\n" +
            "                </div>\n" +
            "                <div class=\"modal-footer bg-light justify-content-center\">\n" +
            "                    <form id=\"deleteForm\" action=\"${pageContext.request.contextPath}/products\" method=\"post\">\n" +
            "                        <input type=\"hidden\" name=\"action\" value=\"delete\">\n" +
            "                        <input type=\"hidden\" id=\"deleteProductId\" name=\"id\" value=\"\">\n" +
            "                        <button type=\"button\" class=\"btn btn-secondary px-4 fw-semibold\" data-bs-dismiss=\"modal\">H\u1ee7y</button>\n" +
            "                        <button type=\"submit\" class=\"btn btn-danger px-4 fw-semibold\">\n" +
            "                            <i class=\"bi bi-trash3 me-1\"></i>\u0110\u1ed3ng \u00fd\n" +
            "                        </button>\n" +
            "                    </form>\n" +
            "                </div>\n" +
            "            </div>\n" +
            "        </div>\n" +
            "    </div>\n\n" +
            "    <!-- Bootstrap 5 JS Bundle -->\n" +
            "    <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js\"></script>\n\n" +
            "    <script>\n" +
            "        const COLOR_OPTIONS = ['\u0110\u1ecf', 'Xanh', '\u0110en', 'Tr\u1eafng', 'V\u00e0ng'];\n\n" +
            "        // Th\u00eam 1 dropdown m\u00e0u m\u1edbi\n" +
            "        function addColorDropdown(containerId, selectedValue = '') {\n" +
            "            const container = document.getElementById(containerId);\n" +
            "            const rows = container.querySelectorAll('.color-select-row');\n" +
            "            if (rows.length >= 3) {\n" +
            "                alert('T\u1ed1i \u0111a 3 m\u00e0u cho m\u1ed7i s\u1ea3n ph\u1ea9m!');\n" +
            "                return;\n" +
            "            }\n\n" +
            "            const row = document.createElement('div');\n" +
            "            row.className = 'input-group color-select-row';\n\n" +
            "            let optionsHtml = '<option value=\"\">-- Ch\u1ecdn m\u00e0u s\u1eafc --</option>';\n" +
            "            COLOR_OPTIONS.forEach(function(c) {\n" +
            "                const isSelected = (selectedValue && selectedValue.trim().toLowerCase() === c.toLowerCase()) ? 'selected' : '';\n" +
            "                optionsHtml += '<option value=\"' + c + '\" ' + isSelected + '>' + c + '</option>';\n" +
            "            });\n\n" +
            "            if (selectedValue && !COLOR_OPTIONS.some(function(c) { return c.toLowerCase() === selectedValue.trim().toLowerCase(); })) {\n" +
            "                const trimmedVal = selectedValue.trim();\n" +
            "                optionsHtml += '<option value=\"' + trimmedVal + '\" selected>' + trimmedVal + '</option>';\n" +
            "            }\n\n" +
            "            row.innerHTML = \n" +
            "                '<select class=\"form-select\" name=\"color\">' +\n" +
            "                    optionsHtml +\n" +
            "                '</select>' +\n" +
            "                '<button class=\"btn btn-outline-danger btn-sm px-2\" type=\"button\" onclick=\"this.closest(\\\'.color-select-row\\\').remove()\" title=\"X\u00f3a \u00f4 m\u00e0u n\u00e0y\">' +\n" +
            "                    '<i class=\"bi bi-x-lg\"></i>' +\n" +
            "                '</button>';\n\n" +
            "            container.appendChild(row);\n" +
            "        }\n\n" +
            "        // M\u1edf popup x\u00e1c nh\u1eadn x\u00f3a v\u1edbi n\u1ed9i dung chu\u1ea9n theo \u0111\u1ec1 b\u00e0i:\n" +
            "        // \"B\u1ea1n c\u00f3 mu\u1ed1n x\u00f3a s\u1ea3n ph\u1ea9m [A] hay kh\u00f4ng?\"\n" +
            "        function confirmDelete(id, name) {\n" +
            "            document.getElementById('deleteProductId').value = id;\n" +
            "            document.getElementById('deleteModalMessage').innerHTML = \n" +
            "                'B\u1ea1n c\u00f3 mu\u1ed1n x\u00f3a s\u1ea3n ph\u1ea9m <strong class=\"text-danger\">' + escapeHtml(name) + '</strong> hay kh\u00f4ng?';\n" +
            "            \n" +
            "            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));\n" +
            "            deleteModal.show();\n" +
            "        }\n\n" +
            "        // M\u1edf popup s\u1eeda s\u1ea3n ph\u1ea9m\n" +
            "        function openEditModal(id, name, price, quantity, color, description, categoryId) {\n" +
            "            document.getElementById('editId').value = id;\n" +
            "            document.getElementById('editName').value = name;\n" +
            "            document.getElementById('editPrice').value = (price && !isNaN(price)) ? Number(price) : price;\n" +
            "            document.getElementById('editQuantity').value = quantity;\n" +
            "            document.getElementById('editDescription').value = description;\n" +
            "            document.getElementById('editCategory').value = categoryId;\n\n" +
            "            const container = document.getElementById('editColorContainer');\n" +
            "            container.innerHTML = '';\n\n" +
            "            if (color && color.trim()) {\n" +
            "                const colors = color.split(',').map(function(c) { return c.trim(); }).filter(function(c) { return c.length > 0; });\n" +
            "                colors.forEach(function(c, index) {\n" +
            "                    const row = document.createElement('div');\n" +
            "                    row.className = 'input-group color-select-row';\n\n" +
            "                    let optionsHtml = '<option value=\"\">-- Ch\u1ecdn m\u00e0u s\u1eafc --</option>';\n" +
            "                    COLOR_OPTIONS.forEach(function(ac) {\n" +
            "                        const isSelected = (ac.toLowerCase() === c.toLowerCase()) ? 'selected' : '';\n" +
            "                        optionsHtml += '<option value=\"' + ac + '\" ' + isSelected + '>' + ac + '</option>';\n" +
            "                    });\n\n" +
            "                    if (!COLOR_OPTIONS.some(function(ac) { return ac.toLowerCase() === c.toLowerCase(); })) {\n" +
            "                        optionsHtml += '<option value=\"' + c + '\" selected>' + c + '</option>';\n" +
            "                    }\n\n" +
            "                    if (index === 0) {\n" +
            "                        row.innerHTML = '<select class=\"form-select\" name=\"color\">' + optionsHtml + '</select>';\n" +
            "                    } else {\n" +
            "                        row.innerHTML = \n" +
            "                            '<select class=\"form-select\" name=\"color\">' + optionsHtml + '</select>' +\n" +
            "                            '<button class=\"btn btn-outline-danger btn-sm px-2\" type=\"button\" onclick=\"this.closest(\\\'.color-select-row\\\').remove()\" title=\"X\u00f3a \u00f4 m\u00e0u n\u00e0y\">' +\n" +
            "                                '<i class=\"bi bi-x-lg\"></i>' +\n" +
            "                            '</button>';\n" +
            "                    }\n" +
            "                    container.appendChild(row);\n" +
            "                });\n" +
            "            } else {\n" +
            "                const row = document.createElement('div');\n" +
            "                row.className = 'input-group color-select-row';\n" +
            "                let optionsHtml = '<option value=\"\">-- Ch\u1ecdn m\u00e0u s\u1eafc --</option>';\n" +
            "                COLOR_OPTIONS.forEach(function(ac) {\n" +
            "                    optionsHtml += '<option value=\"' + ac + '\">' + ac + '</option>';\n" +
            "                });\n" +
            "                row.innerHTML = '<select class=\"form-select\" name=\"color\">' + optionsHtml + '</select>';\n" +
            "                container.appendChild(row);\n" +
            "            }\n\n" +
            "            var editModal = new bootstrap.Modal(document.getElementById('editModal'));\n" +
            "            editModal.show();\n" +
            "        }\n\n" +
            "        // Client-side validation cho Form Th\u00eam m\u1edbi\n" +
            "        function validateCreateForm(event) {\n" +
            "            let isValid = true;\n\n" +
            "            const nameInput = document.getElementById('createName');\n" +
            "            const priceInput = document.getElementById('createPrice');\n" +
            "            const quantityInput = document.getElementById('createQuantity');\n" +
            "            const categoryInput = document.getElementById('createCategory');\n" +
            "            const colorSelects = document.querySelectorAll('#createColorContainer select[name=\"color\"]');\n" +
            "            const selectedColors = Array.from(colorSelects).map(s => s.value.trim()).filter(v => v.length > 0);\n\n" +
            "            const nameError = document.getElementById('nameError');\n" +
            "            const priceError = document.getElementById('priceError');\n" +
            "            const quantityError = document.getElementById('quantityError');\n" +
            "            const colorError = document.getElementById('colorError');\n" +
            "            const categoryError = document.getElementById('categoryError');\n\n" +
            "            // Reset errors\n" +
            "            [nameInput, priceInput, quantityInput, categoryInput].forEach(el => el.classList.remove('is-invalid'));\n" +
            "            colorSelects.forEach(el => el.classList.remove('is-invalid'));\n" +
            "            [nameError, priceError, quantityError, colorError, categoryError].forEach(el => {\n" +
            "                el.classList.remove('d-block');\n" +
            "                el.innerText = '';\n" +
            "            });\n\n" +
            "            // 1. T\u00ean kh\u00f4ng \u0111\u01b0\u1ee3c tr\u1ed1ng\n" +
            "            if (!nameInput.value.trim()) {\n" +
            "                nameInput.classList.add('is-invalid');\n" +
            "                nameError.classList.add('d-block');\n" +
            "                nameError.innerText = 'T\u00ean s\u1ea3n ph\u1ea9m kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng';\n" +
            "                isValid = false;\n" +
            "            }\n\n" +
            "            // 2. Gi\u00e1 kh\u00f4ng \u0111\u1ec3 tr\u1ed1ng v\u00e0 > 10.000.000 VN\u0110\n" +
            "            const priceVal = parseFloat(priceInput.value);\n" +
            "            if (!priceInput.value.trim()) {\n" +
            "                priceInput.classList.add('is-invalid');\n" +
            "                priceError.classList.add('d-block');\n" +
            "                priceError.innerText = 'Gi\u00e1 kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng';\n" +
            "                isValid = false;\n" +
            "            } else if (isNaN(priceVal) || priceVal <= 10000000) {\n" +
            "                priceInput.classList.add('is-invalid');\n" +
            "                priceError.classList.add('d-block');\n" +
            "                priceError.innerText = 'Gi\u00e1 ph\u1ea3i l\u1edbn h\u01a1n 10.000.000 VN\u0110';\n" +
            "                isValid = false;\n" +
            "            }\n\n" +
            "            // 3. S\u1ed1 l\u01b0\u1ee3ng kh\u00f4ng \u0111\u1ec3 tr\u1ed1ng v\u00e0 l\u00e0 s\u1ed1 nguy\u00ean d\u01b0\u01a1ng (> 0)\n" +
            "            const qtyVal = parseInt(quantityInput.value, 10);\n" +
            "            if (!quantityInput.value.trim()) {\n" +
            "                quantityInput.classList.add('is-invalid');\n" +
            "                quantityError.classList.add('d-block');\n" +
            "                quantityError.innerText = 'S\u1ed1 l\u01b0\u1ee3ng kh\u00f4ng \u0111\u01b0\u1ee3c \u0111\u1ec3 tr\u1ed1ng';\n" +
            "                isValid = false;\n" +
            "            } else if (isNaN(qtyVal) || qtyVal <= 0 || !Number.isInteger(Number(quantityInput.value))) {\n" +
            "                quantityInput.classList.add('is-invalid');\n" +
            "                quantityError.classList.add('d-block');\n" +
            "                quantityError.innerText = 'S\u1ed1 l\u01b0\u1ee3ng ph\u1ea3i l\u00e0 s\u1ed1 nguy\u00ean d\u01b0\u01a1ng (> 0)';\n" +
            "                isValid = false;\n" +
            "            }\n\n" +
            "            // 4. M\u00e0u s\u1eafc ph\u1ea3i c\u00f3 gi\u00e1 tr\u1ecb\n" +
            "            if (selectedColors.length === 0) {\n" +
            "                colorSelects.forEach(el => el.classList.add('is-invalid'));\n" +
            "                colorError.classList.add('d-block');\n" +
            "                colorError.innerText = 'M\u00e0u s\u1eafc ph\u1ea3i c\u00f3 gi\u00e1 tr\u1ecb';\n" +
            "                isValid = false;\n" +
            "            }\n\n" +
            "            // 5. Danh m\u1ee5c ph\u1ea3i c\u00f3 gi\u00e1 tr\u1ecb\n" +
            "            if (!categoryInput.value.trim()) {\n" +
            "                categoryInput.classList.add('is-invalid');\n" +
            "                categoryError.classList.add('d-block');\n" +
            "                categoryError.innerText = 'Danh m\u1ee5c ph\u1ea3i c\u00f3 gi\u00e1 tr\u1ecb';\n" +
            "                isValid = false;\n" +
            "            }\n\n" +
            "            if (!isValid) {\n" +
            "                event.preventDefault();\n" +
            "                return false;\n" +
            "            }\n" +
            "            return true;\n" +
            "        }\n\n" +
            "        // Client-side validation cho Form S\u1eeda\n" +
            "        function validateEditForm(event) {\n" +
            "            let isValid = true;\n" +
            "            const nameInput = document.getElementById('editName');\n" +
            "            const priceInput = document.getElementById('editPrice');\n" +
            "            const quantityInput = document.getElementById('editQuantity');\n" +
            "            const categoryInput = document.getElementById('editCategory');\n" +
            "            const editColorSelects = document.querySelectorAll('#editColorContainer select[name=\"color\"]');\n" +
            "            const selectedEditColors = Array.from(editColorSelects).map(s => s.value.trim()).filter(v => v.length > 0);\n\n" +
            "            const priceVal = parseFloat(priceInput.value);\n" +
            "            const qtyVal = parseInt(quantityInput.value, 10);\n\n" +
            "            if (!nameInput.value.trim() || isNaN(priceVal) || priceVal <= 10000000 || \n" +
            "                isNaN(qtyVal) || qtyVal <= 0 || selectedEditColors.length === 0 || !categoryInput.value.trim()) {\n" +
            "                alert('Vui l\u00f2ng ki\u1ec3m tra l\u1ea1i th\u00f4ng tin: Gi\u00e1 > 10.000.000 VN\u0110, S\u1ed1 l\u01b0\u1ee3ng > 0, ch\u1ecdn \u00edt nh\u1ea5t 1 M\u00e0u s\u1eafc v\u00e0 c\u00e1c tr\u01b0\u1eddng b\u1eaft bu\u1ed9c!');\n" +
            "                event.preventDefault();\n" +
            "                return false;\n" +
            "            }\n" +
            "            return true;\n" +
            "        }\n\n" +
            "        function escapeHtml(text) {\n" +
            "            var div = document.createElement('div');\n" +
            "            div.appendChild(document.createTextNode(text));\n" +
            "            return div.innerHTML;\n" +
            "        }\n\n" +
            "        // N\u1ebfu server tr\u1ea3 v\u1ec1 l\u1ed7i validate, t\u1ef1 \u0111\u1ed9ng m\u1edf l\u1ea1i modal create\n" +
            "        <c:if test=\"${openCreateModal}\">\n" +
            "            document.addEventListener(\"DOMContentLoaded\", function() {\n" +
            "                var createModal = new bootstrap.Modal(document.getElementById('createModal'));\n" +
            "                createModal.show();\n" +
            "            });\n" +
            "        </c:if>\n" +
            "    </script>\n" +
            "</body>\n" +
            "</html>\n";

        String targetPath = "d:/CodeGym/Module3/ThiKTModule/src/main/webapp/WEB-INF/views/product/list.jsp";
        try (OutputStreamWriter writer = new OutputStreamWriter(new FileOutputStream(targetPath), StandardCharsets.UTF_8)) {
            writer.write(jsp);
        }
        System.out.println("Generated clean UTF-8 JSP at " + targetPath);
    }
}
