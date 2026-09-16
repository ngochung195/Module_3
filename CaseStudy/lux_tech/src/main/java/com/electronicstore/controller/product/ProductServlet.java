package com.electronicstore.controller.product;

import com.electronicstore.model.Category;
import com.electronicstore.model.Product;
import com.electronicstore.model.ProductColor;
import com.electronicstore.service.CategoryService;
import com.electronicstore.service.ProductService;
import com.electronicstore.util.PageResult;
import com.electronicstore.util.PaginationHelper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class ProductServlet extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                if (!isAdmin(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                showCreateForm(request, response);
                break;
            case "edit":
                if (!isAdmin(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                showEditForm(request, response);
                break;
            case "delete":
                if (!isAdmin(request)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }
                deleteProduct(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createProduct(request, response);
        } else if ("edit".equals(action)) {
            updateProduct(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        String role = (String) session.getAttribute("role");
        return "ADMIN".equalsIgnoreCase(role);
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (session.getAttribute("successMessage") != null) {
            request.setAttribute("successMessage", session.getAttribute("successMessage"));
            session.removeAttribute("successMessage");
        }
        if (session.getAttribute("errorMessage") != null) {
            request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
            session.removeAttribute("errorMessage");
        }

        int page = PaginationHelper.parsePage(request.getParameter("page"));
        int pageSize = 10;
        List<Product> allProducts = productService.findAll();
        PageResult<Product> pageResult = PaginationHelper.paginate(allProducts, page, pageSize);
        List<Category> categories = categoryService.findAll();

        request.setAttribute("products", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("categories", categories);
        request.setAttribute("paginationUrl", request.getContextPath() + "/products");
        request.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(request, response);
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = null;

        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        int page = PaginationHelper.parsePage(request.getParameter("page"));
        int pageSize = 10;
        List<Product> allProducts = productService.search(keyword, categoryId);
        PageResult<Product> pageResult = PaginationHelper.paginate(allProducts, page, pageSize);
        List<Category> categories = categoryService.findAll();

        StringBuilder paginationUrl = new StringBuilder(request.getContextPath() + "/products?action=search");
        if (keyword != null && !keyword.trim().isEmpty()) {
            paginationUrl.append("&keyword=").append(URLEncoder.encode(keyword.trim(), StandardCharsets.UTF_8));
        }
        if (categoryId != null && categoryId > 0) {
            paginationUrl.append("&categoryId=").append(categoryId);
        }

        request.setAttribute("products", pageResult.getItems());
        request.setAttribute("pageResult", pageResult);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("paginationUrl", paginationUrl.toString());
        request.getRequestDispatcher("/WEB-INF/views/product/list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.setAttribute("pageTitle", "Thêm Sản Phẩm Mới");
        request.setAttribute("formAction", "create");
        request.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productService.findById(id);
            if (product == null) {
                request.getSession().setAttribute("errorMessage", "Sản phẩm không tồn tại.");
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }
            String page = request.getParameter("page");
            List<Category> categories = categoryService.findAll();
            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageTitle", "Chỉnh Sửa Sản Phẩm");
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID sản phẩm không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String categoryIdStr = request.getParameter("categoryId");
        String image = handleImageUpload(request, null);

        BigDecimal price = null;
        int quantity = 0;
        int categoryId = 0;

        try {
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = new BigDecimal(priceStr.trim());
            }
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityStr.trim());
            }
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            }
        } catch (NumberFormatException ignored) {
        }

        Product product = new Product(0, name, price, quantity, categoryId, image != null && !image.trim().isEmpty() ? image.trim() : null);
        List<ProductColor> colors = extractColorsFromRequest(request);
        product.setColors(colors);

        String errorMsg = productService.save(product);

        if (errorMsg != null) {
            List<Category> categories = categoryService.findAll();
            request.setAttribute("errorMessage", errorMsg);
            request.setAttribute("product", product);
            request.setAttribute("categories", categories);
            request.setAttribute("pageTitle", "Thêm Sản Phẩm Mới");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("successMessage", "Thêm sản phẩm '" + name.trim() + "' thành công!");
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product existingProduct = productService.findById(id);
            String existingImage = existingProduct != null ? existingProduct.getImage() : null;

            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String categoryIdStr = request.getParameter("categoryId");
            String image = handleImageUpload(request, existingImage);
            String currentPage = request.getParameter("currentPage");

            BigDecimal price = null;
            int quantity = 0;
            int categoryId = 0;

            if (priceStr != null && !priceStr.trim().isEmpty()) {
                price = new BigDecimal(priceStr.trim());
            }
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                quantity = Integer.parseInt(quantityStr.trim());
            }
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr.trim());
            }

            Product product = new Product(id, name, price, quantity, categoryId, image != null && !image.trim().isEmpty() ? image.trim() : null);
            List<ProductColor> colors = extractColorsFromRequest(request);
            product.setColors(colors);

            String errorMsg = productService.update(product);

            if (errorMsg != null) {
                List<Category> categories = categoryService.findAll();
                request.setAttribute("errorMessage", errorMsg);
                request.setAttribute("product", product);
                request.setAttribute("categories", categories);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("pageTitle", "Chỉnh Sửa Sản Phẩm");
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/WEB-INF/views/product/form.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
                String redirectUrl = request.getContextPath() + "/products";
                if (currentPage != null && !currentPage.trim().isEmpty() && !currentPage.trim().equals("1")) {
                    redirectUrl += "?page=" + currentPage.trim();
                }
                response.sendRedirect(redirectUrl);
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID hoặc thông tin nhập vào không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }

    private String handleImageUpload(HttpServletRequest request, String existingImage) {
        try {
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String submittedFileName = filePart.getSubmittedFileName();
                if (submittedFileName != null && !submittedFileName.trim().isEmpty()) {
                    String originalFileName = Paths.get(submittedFileName).getFileName().toString();
                    String cleanName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                    String fileName = cleanName;

                    // 1. Read file bytes into memory
                    byte[] fileBytes;
                    try (InputStream input = filePart.getInputStream()) {
                        fileBytes = input.readAllBytes();
                    }

                    // 2. Save to deployed webapp folder (for instant browser rendering)
                    String uploadPath = getServletContext().getRealPath("/assets/images/products");
                    if (uploadPath != null) {
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        File targetFile = new File(uploadDir, fileName);
                        Files.write(targetFile.toPath(), fileBytes);
                    }

                    // 3. Save to source directory src/main/webapp/assets/images/products (so it is NEVER lost on clean package)
                    File sourceProductsDir = findSourceProductsDir();
                    if (sourceProductsDir != null && sourceProductsDir.exists()) {
                        File srcTarget = new File(sourceProductsDir, fileName);
                        Files.write(srcTarget.toPath(), fileBytes);
                    }

                    return fileName;
                }
            }
        } catch (Exception e) {
            System.err.println("Direct image upload warning: " + e.getMessage());
        }

        // Fallback: check manual text input
        String imageUrlOrName = request.getParameter("image");
        if (imageUrlOrName != null && !imageUrlOrName.trim().isEmpty()) {
            return imageUrlOrName.trim();
        }

        // Retain existing image if neither new file nor new text was provided
        return (existingImage != null && !existingImage.trim().isEmpty()) ? existingImage.trim() : null;
    }

    private File findSourceProductsDir() {
        // 1. Try from user.dir
        try {
            String userDir = System.getProperty("user.dir");
            if (userDir != null) {
                File pDir = new File(userDir, "src/main/webapp/assets/images/products");
                if (pDir.exists() && pDir.isDirectory()) {
                    return pDir;
                }
            }
        } catch (Exception ignored) {}

        // 2. Try traversing up from deployed getRealPath("/")
        try {
            String realPath = getServletContext().getRealPath("/");
            if (realPath != null) {
                File current = new File(realPath);
                for (int i = 0; i < 6 && current != null; i++) {
                    File pom = new File(current, "pom.xml");
                    File pDir = new File(current, "src/main/webapp/assets/images/products");
                    if (pom.exists() && pDir.exists() && pDir.isDirectory()) {
                        return pDir;
                    }
                    current = current.getParentFile();
                }
            }
        } catch (Exception ignored) {}

        return null;
    }

    private List<ProductColor> extractColorsFromRequest(HttpServletRequest request) {
        List<ProductColor> colors = new java.util.ArrayList<>();
        String[] names = request.getParameterValues("colorNames");
        String[] hexes = request.getParameterValues("colorHexes");
        if (names != null && hexes != null) {
            int len = Math.min(names.length, hexes.length);
            for (int i = 0; i < len; i++) {
                String n = names[i];
                String h = hexes[i];
                if (n != null && !n.trim().isEmpty()) {
                    if (h == null || h.trim().isEmpty()) {
                        h = "#000000";
                    }
                    colors.add(new com.electronicstore.model.ProductColor(n.trim(), h.trim()));
                }
            }
        }
        return colors;
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String page = request.getParameter("page");
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String errorMsg = productService.delete(id);
            if (errorMsg != null) {
                request.getSession().setAttribute("errorMessage", errorMsg);
            } else {
                request.getSession().setAttribute("successMessage", "Xóa sản phẩm thành công!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID sản phẩm không hợp lệ.");
        }
        String redirectUrl = request.getContextPath() + "/products";
        if (page != null && !page.trim().isEmpty() && !page.trim().equals("1")) {
            redirectUrl += "?page=" + page.trim();
        }
        response.sendRedirect(redirectUrl);
    }
}
