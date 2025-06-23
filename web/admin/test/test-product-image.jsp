<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.ProductImage" %>
<%@ page import="com.entity.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.UUID" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../checkAdmin.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品图片功能测试</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .test-result {
            background-color: #f8f9fa;
            padding: 10px;
            border-left: 4px solid #007bff;
            margin-top: 10px;
            white-space: pre-line;
            font-family: monospace;
            max-height: 300px;
            overflow-y: auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], input[type="file"], select {
            width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .danger {
            background-color: #dc3545;
        }
        .danger:hover {
            background-color: #c82333;
        }
        .success {
            background-color: #28a745;
        }
        .success:hover {
            background-color: #218838;
        }
        .image-list {
            background-color: #e9ecef;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            max-height: 400px;
            overflow-y: auto;
        }
        .image-item {
            padding: 8px;
            border-bottom: 1px solid #ccc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .image-item:last-child {
            border-bottom: none;
        }
        .image-info {
            flex: 1;
        }
        .image-actions {
            display: flex;
            gap: 5px;
        }
        .image-actions button {
            padding: 5px 10px;
            font-size: 12px;
        }
        .product-list {
            background-color: #fff3cd;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            max-height: 200px;
            overflow-y: auto;
        }
        .stats {
            background-color: #d1ecf1;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .stats h3 {
            margin-top: 0;
        }
        .image-preview {
            max-width: 100px;
            max-height: 100px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>商品图片功能测试页面</h1>
        <p>此页面用于测试商品图片相关功能是否正常工作</p>
        
        <%
            String action = request.getParameter("action");
            String message = "";
            
            // 处理表单提交
            if ("add".equals(action)) {
                String productIdStr = request.getParameter("productId");
                
                if (productIdStr != null) {
                    try {
                        int productId = Integer.parseInt(productIdStr);
                        
                        // 处理文件上传
                        Part filePart = request.getPart("imageFile");
                        if (filePart != null && filePart.getSize() > 0) {
                            String fileName = filePart.getSubmittedFileName();
                            if (fileName != null && !fileName.trim().isEmpty()) {
                                // 获取文件扩展名
                                String fileExtension = "";
                                int lastDotIndex = fileName.lastIndexOf(".");
                                if (lastDotIndex > 0) {
                                    fileExtension = fileName.substring(lastDotIndex);
                                }
                                
                                // 生成唯一文件名
                                String uniqueFileName = "product_" + productId + "_" + UUID.randomUUID().toString() + fileExtension;
                                
                                // 设置保存路径 - 保存到源码目录
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                System.out.println("=== 路径调试信息 ===");
                                System.out.println("Web应用根路径: " + application.getRealPath("/"));
                                System.out.println("图片保存路径: " + uploadPath);
                                System.out.println("源码目录路径: f:/项目文件/实训/JSP/web/images/products/");
                                System.out.println("注意: 现在文件将保存到源码目录中");
                                
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    boolean dirCreated = uploadDir.mkdirs();
                                    System.out.println("创建目录: " + uploadPath + ", 结果: " + dirCreated);
                                }
                                
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                System.out.println("准备保存文件到: " + filePath);
                                System.out.println("文件大小: " + filePart.getSize() + " bytes");
                                
                                try {
                                    // 保存文件
                                    filePart.write(filePath);
                                    
                                    // 验证文件是否真的保存了
                                    File savedFile = new File(filePath);
                                    boolean fileExists = savedFile.exists();
                                    long fileSize = savedFile.length();
                                    System.out.println("文件保存后检查: 存在=" + fileExists + ", 大小=" + fileSize);
                                    
                                    // 生成相对URL路径
                                    String imageUrl = "/images/products/" + uniqueFileName;
                                    
                                    // 保存到数据库
                                    ProductImage img = new ProductImage();
                                    img.setProductId(productId);
                                    img.setUrl(imageUrl);
                                    
                                    try {
                                        boolean result = ServiceLayer.addProductImage(img);
                                        if (result) {
                                            message = "✓ 图片上传并添加成功！\n文件名: " + uniqueFileName + "\nURL: " + imageUrl + "\n商品ID: " + productId + "\n图片ID: " + img.getId() + "\n\n=== 文件保存位置说明 ===\n" +
                                                    "实际保存路径: " + filePath + "\n" +
                                                    "文件存在: " + new File(filePath).exists() + "\n" +
                                                    "Web应用根目录: " + application.getRealPath("/") + "\n" +
                                                    "源码目录: f:/项目文件/实训/JSP/web/\n" +
                                                    "\n说明: 文件已保存到源码目录中！您可以在源码目录下找到该文件。";
                                        } else {
                                            message = "✗ 图片保存到数据库失败！数据库操作返回false";
                                            // 删除已上传的文件
                                            new File(filePath).delete();
                                        }
                                    } catch (Exception dbException) {
                                        message = "✗ 数据库操作异常：" + dbException.getMessage();
                                        dbException.printStackTrace();
                                        // 删除已上传的文件
                                        new File(filePath).delete();
                                    }
                                } catch (IOException e) {
                                    message = "✗ 文件保存失败：" + e.getMessage();
                                }
                            } else {
                                message = "✗ 文件名无效！";
                            }
                        } else {
                            message = "✗ 请选择要上传的图片文件！";
                        }
                    } catch (NumberFormatException e) {
                        message = "✗ 商品ID格式错误！";
                    } catch (Exception e) {
                        message = "✗ 文件上传处理失败：" + e.getMessage();
                    }
                } else {
                    message = "✗ 请选择商品！";
                }
            } else if ("update".equals(action)) {
                String imageIdStr = request.getParameter("imageId");
                String newUrl = request.getParameter("newUrl");
                
                if (imageIdStr != null && newUrl != null && !newUrl.trim().isEmpty()) {
                    try {
                        int imageId = Integer.parseInt(imageIdStr);
                        ProductImage img = ServiceLayer.getProductImageById(imageId);
                        if (img != null) {
                            img.setUrl(newUrl.trim());
                            boolean result = ServiceLayer.updateProductImage(img);
                            if (result) {
                                message = "✓ 图片更新成功！新URL: " + newUrl;
                            } else {
                                message = "✗ 图片更新失败！";
                            }
                        } else {
                            message = "✗ 图片不存在！";
                        }
                    } catch (NumberFormatException e) {
                        message = "✗ 图片ID格式错误！";
                    }
                } else {
                    message = "✗ 请填写完整的图片ID和新URL！";
                }
            } else if ("delete".equals(action)) {
                String imageIdStr = request.getParameter("imageId");
                
                if (imageIdStr != null) {
                    try {
                        int imageId = Integer.parseInt(imageIdStr);
                        boolean result = ServiceLayer.deleteProductImage(imageId);
                        if (result) {
                            message = "✓ 图片删除成功！";
                        } else {
                            message = "✗ 图片删除失败！";
                        }
                    } catch (NumberFormatException e) {
                        message = "✗ 图片ID格式错误！";
                    }
                } else {
                    message = "✗ 请提供图片ID！";
                }
            }
        %>
        
        <!-- 显示操作结果 -->
        <% if (!message.isEmpty()) { %>
            <div class="test-result"><%= message %></div>
        <% } %>
        
        <!-- 统计信息 -->
        <div class="stats">
            <h3>系统统计</h3>
            <%
                List<Product> allProducts = ServiceLayer.listProducts();
                int productCount = (allProducts != null) ? allProducts.size() : 0;
                int totalImageCount = 0;
                
                if (allProducts != null) {
                    for (Product product : allProducts) {
                        List<ProductImage> images = ServiceLayer.listProductImages(product.getId());
                        if (images != null) {
                            totalImageCount += images.size();
                        }
                    }
                }
            %>
            <p><strong>商品总数:</strong> <%= productCount %></p>
            <p><strong>图片总数:</strong> <%= totalImageCount %></p>
        </div>
        
        <!-- 商品列表 -->
        <div class="test-section">
            <h2>商品列表</h2>
            <div class="product-list">
                <%
                    if (allProducts != null && !allProducts.isEmpty()) {
                        for (Product product : allProducts) {
                            List<ProductImage> productImages = ServiceLayer.listProductImages(product.getId());
                            int imageCount = (productImages != null) ? productImages.size() : 0;
                %>
                    <div style="padding: 5px; border-bottom: 1px solid #ccc;">
                        <strong>ID:</strong> <%= product.getId() %> | 
                        <strong>名称:</strong> <%= product.getName() %> | 
                        <strong>图片数量:</strong> <%= imageCount %>
                    </div>
                <%
                        }
                    } else {
                %>
                    <p>暂无商品数据</p>
                <%
                    }
                %>
            </div>
        </div>
        
        <!-- 新增商品图片 -->
        <div class="test-section">
            <h2>新增商品图片</h2>
            <form method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="productId">选择商品:</label>
                    <select name="productId" id="productId" required>
                        <option value="">请选择商品</option>
                        <%
                            if (allProducts != null) {
                                for (Product product : allProducts) {
                        %>
                            <option value="<%= product.getId() %>"><%= product.getId() %> - <%= product.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="imageFile">选择图片文件:</label>
                    <input type="file" name="imageFile" id="imageFile" accept="image/*" required>
                    <small>支持的格式：JPG, PNG, GIF等图片格式，文件将保存到源码目录 f:/项目文件/实训/JSP/web/images/products/ 下</small>
                </div>
                
                <button type="submit" class="success">上传并添加图片</button>
            </form>
        </div>
        
        <!-- 查询商品图片 -->
        <div class="test-section">
            <h2>查询商品图片</h2>
            <form method="get">
                <div class="form-group">
                    <label for="queryProductId">选择商品:</label>
                    <select name="queryProductId" id="queryProductId">
                        <option value="">请选择商品</option>
                        <%
                            String queryProductIdStr = request.getParameter("queryProductId");
                            if (allProducts != null) {
                                for (Product product : allProducts) {
                                    String selected = String.valueOf(product.getId()).equals(queryProductIdStr) ? "selected" : "";
                        %>
                            <option value="<%= product.getId() %>" <%= selected %>><%= product.getId() %> - <%= product.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <button type="submit">查询图片</button>
            </form>
            
            <%
                if (queryProductIdStr != null && !queryProductIdStr.isEmpty()) {
                    try {
                        int queryProductId = Integer.parseInt(queryProductIdStr);
                        List<ProductImage> queryImages = ServiceLayer.listProductImages(queryProductId);
                        Product queryProduct = ServiceLayer.getProductById(queryProductId);
            %>
                <h3>商品 "<%= queryProduct != null ? queryProduct.getName() : "未知" %>" 的图片列表</h3>
                <div class="image-list">
                    <%
                        if (queryImages != null && !queryImages.isEmpty()) {
                            for (ProductImage img : queryImages) {
                    %>
                        <div class="image-item">
                            <div class="image-info">
                                <strong>图片ID:</strong> <%= img.getId() %> | 
                                <strong>URL:</strong> <%= img.getUrl() %>
                                <br>
                                <img src="<%= img.getUrl() %>" alt="商品图片" class="image-preview" onerror="this.style.display='none'">
                            </div>
                            <div class="image-actions">
                                <form method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="imageId" value="<%= img.getId() %>">
                                    <button type="submit" class="danger" onclick="return confirm('确定要删除这张图片吗？')">删除</button>
                                </form>
                            </div>
                        </div>
                    <%
                            }
                        } else {
                    %>
                        <p>该商品暂无图片</p>
                    <%
                        }
                    %>
                </div>
            <%
                    } catch (NumberFormatException e) {
                        out.println("<p style='color: red;'>商品ID格式错误</p>");
                    }
                }
            %>
        </div>
        
        <!-- 按ID查询图片 -->
        <div class="test-section">
            <h2>按ID查询图片</h2>
            <form method="get">
                <div class="form-group">
                    <label for="imageId">图片ID:</label>
                    <input type="number" name="imageId" id="imageId" placeholder="输入图片ID" value="<%= request.getParameter("imageId") != null ? request.getParameter("imageId") : "" %>">
                </div>
                
                <button type="submit">查询图片</button>
            </form>
            
            <%
                String imageIdStr = request.getParameter("imageId");
                if (imageIdStr != null && !imageIdStr.isEmpty()) {
                    try {
                        int imageId = Integer.parseInt(imageIdStr);
                        ProductImage queryImage = ServiceLayer.getProductImageById(imageId);
            %>
                <div class="test-result">
                    <%
                        if (queryImage != null) {
                            Product imageProduct = ServiceLayer.getProductById(queryImage.getProductId());
                    %>
                        <strong>查询结果:</strong><br>
                        图片ID: <%= queryImage.getId() %><br>
                        商品ID: <%= queryImage.getProductId() %><br>
                        商品名称: <%= imageProduct != null ? imageProduct.getName() : "未知" %><br>
                        图片URL: <%= queryImage.getUrl() %><br>
                        <img src="<%= queryImage.getUrl() %>" alt="商品图片" class="image-preview" onerror="this.style.display='none'">
                    <%
                        } else {
                    %>
                        <strong>查询结果:</strong> 图片不存在
                    <%
                        }
                    %>
                </div>
            <%
                    } catch (NumberFormatException e) {
                        out.println("<div class='test-result'><strong>错误:</strong> 图片ID格式错误</div>");
                    }
                }
            %>
        </div>
        
        <!-- 更新图片信息 -->
        <div class="test-section">
            <h2>更新图片信息</h2>
            <form method="post">
                <input type="hidden" name="action" value="update">
                
                <div class="form-group">
                    <label for="updateImageId">图片ID:</label>
                    <input type="number" name="imageId" id="updateImageId" placeholder="输入要更新的图片ID" required>
                </div>
                
                <div class="form-group">
                    <label for="newUrl">新的图片URL:</label>
                    <input type="text" name="newUrl" id="newUrl" placeholder="例如: /images/products/new-image.jpg" required>
                </div>
                
                <button type="submit" class="success">更新图片</button>
            </form>
        </div>
        
        <!-- 所有图片列表 -->
        <div class="test-section">
            <h2>所有商品图片</h2>
            <%
                if (allProducts != null && !allProducts.isEmpty()) {
                    for (Product product : allProducts) {
                        List<ProductImage> productImages = ServiceLayer.listProductImages(product.getId());
                        if (productImages != null && !productImages.isEmpty()) {
            %>
                <h4>商品: <%= product.getName() %> (ID: <%= product.getId() %>)</h4>
                <div class="image-list">
                    <%
                        for (ProductImage img : productImages) {
                    %>
                        <div class="image-item">
                            <div class="image-info">
                                <strong>图片ID:</strong> <%= img.getId() %> | 
                                <strong>URL:</strong> <%= img.getUrl() %>
                                <br>
                                <img src="<%= img.getUrl() %>" alt="商品图片" class="image-preview" onerror="this.style.display='none'">
                            </div>
                            <div class="image-actions">
                                <form method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="imageId" value="<%= img.getId() %>">
                                    <button type="submit" class="danger" onclick="return confirm('确定要删除这张图片吗？')">删除</button>
                                </form>
                            </div>
                        </div>
                    <%
                        }
                    %>
                </div>
            <%
                        }
                    }
                } else {
            %>
                <p>暂无商品数据</p>
            <%
                }
            %>
        </div>
        
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; text-align: center;">
            <p><a href="../index.jsp">返回管理后台</a> | <a href="../../index.jsp">返回首页</a></p>
        </div>
    </div>
</body>
</html>