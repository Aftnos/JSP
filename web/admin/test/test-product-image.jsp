<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.ProductImage" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        input[type="text"], input[type="number"], select {
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
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        h2 {
            color: #007bff;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
        }
        .nav-links {
            text-align: center;
            margin-bottom: 20px;
        }
        .nav-links a {
            color: #007bff;
            text-decoration: none;
            margin: 0 10px;
        }
        .nav-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>商品图片功能测试</h1>
        
        <div class="nav-links">
            <a href="../index.jsp">返回管理首页</a> |
            <a href="test-product.jsp">商品测试</a> |
            <a href="test-user-delete.jsp">用户测试</a> |
            <a href="test-order.jsp">订单测试</a>
        </div>

        <!-- 获取商品图片列表 -->
        <div class="test-section">
            <h2>1. 获取商品图片列表</h2>
            <form method="post">
                <div class="form-group">
                    <label for="productId">选择商品:</label>
                    <select name="productId" id="productId">
                        <option value="">请选择商品</option>
                        <%
                            List<Product> products = ServiceLayer.listProducts();
                            if (products != null) {
                                for (Product product : products) {
                        %>
                        <option value="<%= product.getId() %>"><%= product.getName() %> (ID: <%= product.getId() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <button type="submit" name="action" value="listImages">获取图片列表</button>
            </form>
            
            <%
                String action = request.getParameter("action");
                if ("listImages".equals(action)) {
                    String productIdStr = request.getParameter("productId");
                    if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                        try {
                            int productId = Integer.parseInt(productIdStr);
                            List<ProductImage> images = ServiceLayer.listProductImages(productId);
            %>
            <div class="test-result">
成功获取商品 ID <%= productId %> 的图片列表
图片总数: <%= images != null ? images.size() : 0 %>

<%
                            if (images != null && !images.isEmpty()) {
                                for (ProductImage img : images) {
%>
ID: <%= img.getId() %>, URL: <%= img.getImageUrl() %>, 主图: <%= img.getIsMain() %>
<%
                                }
                            } else {
%>
该商品暂无图片
<%
                            }
%>
            </div>
            <%
                        } catch (NumberFormatException e) {
            %>
            <div class="test-result">错误: 商品ID格式不正确</div>
            <%
                        }
                    } else {
            %>
            <div class="test-result">错误: 请选择商品</div>
            <%
                    }
                }
            %>
        </div>

        <!-- 新增商品图片 -->
        <div class="test-section">
            <h2>2. 新增商品图片</h2>
            <form method="post">
                <div class="form-group">
                    <label for="addProductId">选择商品:</label>
                    <select name="addProductId" id="addProductId">
                        <option value="">请选择商品</option>
                        <%
                            if (products != null) {
                                for (Product product : products) {
                        %>
                        <option value="<%= product.getId() %>"><%= product.getName() %> (ID: <%= product.getId() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="imageUrl">图片URL:</label>
                    <input type="text" name="imageUrl" id="imageUrl" placeholder="/images/product_image.jpg" required>
                </div>
                <div class="form-group">
                    <label for="isMain">是否为主图:</label>
                    <select name="isMain" id="isMain">
                        <option value="false">否</option>
                        <option value="true">是</option>
                    </select>
                </div>
                <button type="submit" name="action" value="addImage" class="success">添加图片</button>
            </form>
            
            <%
                if ("addImage".equals(action)) {
                    String addProductIdStr = request.getParameter("addProductId");
                    String imageUrl = request.getParameter("imageUrl");
                    String isMainStr = request.getParameter("isMain");
                    
                    if (addProductIdStr != null && !addProductIdStr.trim().isEmpty() && 
                        imageUrl != null && !imageUrl.trim().isEmpty()) {
                        try {
                            int addProductId = Integer.parseInt(addProductIdStr);
                            boolean isMain = "true".equals(isMainStr);
                            
                            ProductImage newImage = new ProductImage();
                            newImage.setProductId(addProductId);
                            newImage.setImageUrl(imageUrl.trim());
                            newImage.setIsMain(isMain);
                            
                            boolean result = ServiceLayer.addProductImage(newImage);
            %>
            <div class="test-result">
添加图片结果: <%= result ? "成功" : "失败" %>
商品ID: <%= addProductId %>
图片URL: <%= imageUrl %>
是否主图: <%= isMain %>
            </div>
            <%
                        } catch (NumberFormatException e) {
            %>
            <div class="test-result">错误: 商品ID格式不正确</div>
            <%
                        }
                    } else {
            %>
            <div class="test-result">错误: 请填写完整信息</div>
            <%
                    }
                }
            %>
        </div>

        <!-- 按ID查询商品图片 -->
        <div class="test-section">
            <h2>3. 按ID查询商品图片</h2>
            <form method="post">
                <div class="form-group">
                    <label for="imageId">图片ID:</label>
                    <input type="number" name="imageId" id="imageId" placeholder="请输入图片ID" required>
                </div>
                <button type="submit" name="action" value="getImage">查询图片</button>
            </form>
            
            <%
                if ("getImage".equals(action)) {
                    String imageIdStr = request.getParameter("imageId");
                    if (imageIdStr != null && !imageIdStr.trim().isEmpty()) {
                        try {
                            int imageId = Integer.parseInt(imageIdStr);
                            ProductImage image = ServiceLayer.getProductImageById(imageId);
            %>
            <div class="test-result">
查询图片 ID <%= imageId %> 的结果:
<%
                            if (image != null) {
%>
图片ID: <%= image.getId() %>
商品ID: <%= image.getProductId() %>
图片URL: <%= image.getImageUrl() %>
是否主图: <%= image.getIsMain() %>
<%
                            } else {
%>
未找到指定ID的图片
<%
                            }
%>
            </div>
            <%
                        } catch (NumberFormatException e) {
            %>
            <div class="test-result">错误: 图片ID格式不正确</div>
            <%
                        }
                    } else {
            %>
            <div class="test-result">错误: 请输入图片ID</div>
            <%
                    }
                }
            %>
        </div>

        <!-- 更新商品图片信息 -->
        <div class="test-section">
            <h2>4. 更新商品图片信息</h2>
            <form method="post">
                <div class="form-group">
                    <label for="updateImageId">图片ID:</label>
                    <input type="number" name="updateImageId" id="updateImageId" placeholder="请输入要更新的图片ID" required>
                </div>
                <div class="form-group">
                    <label for="updateImageUrl">新图片URL:</label>
                    <input type="text" name="updateImageUrl" id="updateImageUrl" placeholder="/images/new_image.jpg" required>
                </div>
                <div class="form-group">
                    <label for="updateIsMain">是否为主图:</label>
                    <select name="updateIsMain" id="updateIsMain">
                        <option value="false">否</option>
                        <option value="true">是</option>
                    </select>
                </div>
                <button type="submit" name="action" value="updateImage">更新图片</button>
            </form>
            
            <%
                if ("updateImage".equals(action)) {
                    String updateImageIdStr = request.getParameter("updateImageId");
                    String updateImageUrl = request.getParameter("updateImageUrl");
                    String updateIsMainStr = request.getParameter("updateIsMain");
                    
                    if (updateImageIdStr != null && !updateImageIdStr.trim().isEmpty() && 
                        updateImageUrl != null && !updateImageUrl.trim().isEmpty()) {
                        try {
                            int updateImageId = Integer.parseInt(updateImageIdStr);
                            boolean updateIsMain = "true".equals(updateIsMainStr);
                            
                            // 先获取原图片信息
                            ProductImage originalImage = ServiceLayer.getProductImageById(updateImageId);
                            if (originalImage != null) {
                                // 更新图片信息
                                originalImage.setImageUrl(updateImageUrl.trim());
                                originalImage.setIsMain(updateIsMain);
                                
                                boolean result = ServiceLayer.updateProductImage(originalImage);
            %>
            <div class="test-result">
更新图片结果: <%= result ? "成功" : "失败" %>
图片ID: <%= updateImageId %>
新URL: <%= updateImageUrl %>
是否主图: <%= updateIsMain %>
            </div>
            <%
                            } else {
            %>
            <div class="test-result">错误: 未找到指定ID的图片</div>
            <%
                            }
                        } catch (NumberFormatException e) {
            %>
            <div class="test-result">错误: 图片ID格式不正确</div>
            <%
                        }
                    } else {
            %>
            <div class="test-result">错误: 请填写完整信息</div>
            <%
                    }
                }
            %>
        </div>

        <!-- 删除商品图片 -->
        <div class="test-section">
            <h2>5. 删除商品图片</h2>
            <form method="post">
                <div class="form-group">
                    <label for="deleteImageId">图片ID:</label>
                    <input type="number" name="deleteImageId" id="deleteImageId" placeholder="请输入要删除的图片ID" required>
                </div>
                <button type="submit" name="action" value="deleteImage" class="danger" 
                        onclick="return confirm('确定要删除这张图片吗？此操作不可恢复！')">删除图片</button>
            </form>
            
            <%
                if ("deleteImage".equals(action)) {
                    String deleteImageIdStr = request.getParameter("deleteImageId");
                    if (deleteImageIdStr != null && !deleteImageIdStr.trim().isEmpty()) {
                        try {
                            int deleteImageId = Integer.parseInt(deleteImageIdStr);
                            
                            // 先获取图片信息用于显示
                            ProductImage imageToDelete = ServiceLayer.getProductImageById(deleteImageId);
                            boolean result = ServiceLayer.deleteProductImage(deleteImageId);
            %>
            <div class="test-result">
删除图片结果: <%= result ? "成功" : "失败" %>
图片ID: <%= deleteImageId %>
<%
                            if (imageToDelete != null) {
%>
原图片URL: <%= imageToDelete.getImageUrl() %>
原商品ID: <%= imageToDelete.getProductId() %>
<%
                            }
%>
            </div>
            <%
                        } catch (NumberFormatException e) {
            %>
            <div class="test-result">错误: 图片ID格式不正确</div>
            <%
                        }
                    } else {
            %>
            <div class="test-result">错误: 请输入图片ID</div>
            <%
                    }
                }
            %>
        </div>

        <!-- 显示所有商品及其图片 -->
        <div class="test-section">
            <h2>6. 所有商品图片概览</h2>
            <button onclick="location.reload()">刷新页面</button>
            
            <div class="image-list">
                <%
                    if (products != null && !products.isEmpty()) {
                        for (Product product : products) {
                            List<ProductImage> productImages = ServiceLayer.listProductImages(product.getId());
                %>
                <div style="margin-bottom: 15px; padding: 10px; background-color: #f8f9fa; border-radius: 4px;">
                    <strong>商品: <%= product.getName() %> (ID: <%= product.getId() %>)</strong>
                    <div style="margin-top: 5px;">
                        图片数量: <%= productImages != null ? productImages.size() : 0 %>
                        <%
                            if (productImages != null && !productImages.isEmpty()) {
                                for (ProductImage img : productImages) {
                        %>
                        <div class="image-item">
                            <div class="image-info">
                                ID: <%= img.getId() %> | URL: <%= img.getImageUrl() %> | 主图: <%= img.getIsMain() ? "是" : "否" %>
                            </div>
                        </div>
                        <%
                                }
                            } else {
                        %>
                        <div style="color: #666; font-style: italic;">暂无图片</div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                        }
                    } else {
                %>
                <div>暂无商品数据</div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>