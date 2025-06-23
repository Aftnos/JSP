<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.Category" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="../checkAdmin.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品功能测试</title>
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
        input[type="text"], input[type="number"], textarea, select {
            width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        textarea {
            height: 80px;
            resize: vertical;
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
        .product-list {
            background-color: #e9ecef;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            max-height: 400px;
            overflow-y: auto;
        }
        .product-item {
            padding: 8px;
            border-bottom: 1px solid #ccc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .product-item:last-child {
            border-bottom: none;
        }
        .product-info {
            flex: 1;
        }
        .product-actions {
            display: flex;
            gap: 5px;
        }
        .product-actions button {
            padding: 5px 10px;
            font-size: 12px;
        }
        .category-list {
            background-color: #fff3cd;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
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
    </style>
</head>
<body>
    <div class="container">
        <h1>商品功能测试页面</h1>
        <p>此页面用于测试商品相关功能是否正常工作</p>
        
        <!-- 统计信息 -->
        <div class="stats">
            <h3>系统统计</h3>
            <%
                List<Product> allProducts = ServiceLayer.listProducts();
                List<Category> allCategories = ServiceLayer.listCategories();
                int productCount = (allProducts != null) ? allProducts.size() : 0;
                int categoryCount = (allCategories != null) ? allCategories.size() : 0;
            %>
            <p><strong>商品总数:</strong> <%= productCount %></p>
            <p><strong>分类总数:</strong> <%= categoryCount %></p>
        </div>
        
        <!-- 分类列表 -->
        <div class="test-section">
            <h2>商品分类列表</h2>
            <div class="category-list">
                <%
                    if (allCategories != null && !allCategories.isEmpty()) {
                        for (Category category : allCategories) {
                %>
                    <div style="padding: 5px; border-bottom: 1px solid #ccc;">
                        ID: <%= category.getId() %> | 名称: <%= category.getName() %>
                    </div>
                <%
                        }
                    } else {
                %>
                    <p>暂无分类数据</p>
                <%
                    }
                %>
            </div>
        </div>
        
        <!-- 商品列表 -->
        <div class="test-section">
            <h2>当前商品列表</h2>
            <div class="product-list">
                <%
                    if (allProducts != null && !allProducts.isEmpty()) {
                        for (Product product : allProducts) {
                %>
                    <div class="product-item">
                        <div class="product-info">
                            <strong>ID:</strong> <%= product.getId() %> | 
                            <strong>名称:</strong> <%= product.getName() %> | 
                            <strong>价格:</strong> ¥<%= product.getPrice() %> | 
                            <strong>库存:</strong> <%= product.getStock() %> | 
                            <strong>分类ID:</strong> <%= product.getCategoryId() %>
                            <% if (product.getDescription() != null && !product.getDescription().trim().isEmpty()) { %>
                                <br><small><strong>描述:</strong> <%= product.getDescription() %></small>
                            <% } %>
                        </div>
                        <div class="product-actions">
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="action" value="view">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">
                                <button type="submit">查看</button>
                            </form>
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="productId" value="<%= product.getId() %>">
                                <button type="submit" class="danger" onclick="return confirm('确定要删除商品 <%= product.getName() %> 吗？')">删除</button>
                            </form>
                        </div>
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
        
        <!-- 添加商品 -->
        <div class="test-section">
            <h2>添加新商品</h2>
            <form method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="productName">商品名称:</label>
                    <input type="text" id="productName" name="productName" required>
                </div>
                
                <div class="form-group">
                    <label for="productPrice">商品价格:</label>
                    <input type="number" id="productPrice" name="productPrice" step="0.01" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="productStock">库存数量:</label>
                    <input type="number" id="productStock" name="productStock" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="categoryId">商品分类:</label>
                    <select id="categoryId" name="categoryId">
                        <option value="">请选择分类</option>
                        <%
                            if (allCategories != null) {
                                for (Category category : allCategories) {
                        %>
                            <option value="<%= category.getId() %>"><%= category.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="productDescription">商品描述:</label>
                    <textarea id="productDescription" name="productDescription"></textarea>
                </div>
                
                <button type="submit" class="success">添加商品</button>
            </form>
        </div>
        
        <!-- 更新商品 -->
        <div class="test-section">
            <h2>更新商品信息</h2>
            <form method="post">
                <input type="hidden" name="action" value="update">
                
                <div class="form-group">
                    <label for="updateProductId">商品ID:</label>
                    <input type="number" id="updateProductId" name="updateProductId" required>
                </div>
                
                <div class="form-group">
                    <label for="updateProductName">新商品名称:</label>
                    <input type="text" id="updateProductName" name="updateProductName" required>
                </div>
                
                <div class="form-group">
                    <label for="updateProductPrice">新商品价格:</label>
                    <input type="number" id="updateProductPrice" name="updateProductPrice" step="0.01" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="updateProductStock">新库存数量:</label>
                    <input type="number" id="updateProductStock" name="updateProductStock" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="updateCategoryId">新商品分类:</label>
                    <select id="updateCategoryId" name="updateCategoryId">
                        <option value="">请选择分类</option>
                        <%
                            if (allCategories != null) {
                                for (Category category : allCategories) {
                        %>
                            <option value="<%= category.getId() %>"><%= category.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="updateProductDescription">新商品描述:</label>
                    <textarea id="updateProductDescription" name="updateProductDescription"></textarea>
                </div>
                
                <button type="submit">更新商品</button>
            </form>
        </div>
        
        <!-- 查询商品 -->
        <div class="test-section">
            <h2>查询单个商品</h2>
            <form method="post">
                <input type="hidden" name="action" value="view">
                
                <div class="form-group">
                    <label for="viewProductId">商品ID:</label>
                    <input type="number" id="viewProductId" name="productId" required>
                </div>
                
                <button type="submit">查询商品</button>
            </form>
        </div>
        
        <!-- 按分类查询商品 -->
        <div class="test-section">
            <h2>按分类查询商品</h2>
            <form method="post">
                <input type="hidden" name="action" value="listByCategory">
                
                <div class="form-group">
                    <label for="searchCategoryId">选择分类:</label>
                    <select id="searchCategoryId" name="searchCategoryId" required>
                        <option value="">请选择分类</option>
                        <%
                            if (allCategories != null) {
                                for (Category category : allCategories) {
                        %>
                            <option value="<%= category.getId() %>"><%= category.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <button type="submit">查询该分类商品</button>
            </form>
        </div>
        
        <!-- 测试结果显示区域 -->
        <%
            String action = request.getParameter("action");
            String testResult = "";
            
            if (action != null) {
                try {
                    if ("add".equals(action)) {
                        // 添加商品
                        String name = request.getParameter("productName");
                        String priceStr = request.getParameter("productPrice");
                        String stockStr = request.getParameter("productStock");
                        String categoryIdStr = request.getParameter("categoryId");
                        String description = request.getParameter("productDescription");
                        
                        if (name != null && priceStr != null && stockStr != null) {
                            Product newProduct = new Product();
                            newProduct.setName(name);
                            newProduct.setPrice(new BigDecimal(priceStr));
                            newProduct.setStock(Integer.parseInt(stockStr));
                            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                                newProduct.setCategoryId(Integer.parseInt(categoryIdStr));
                            }
                            newProduct.setDescription(description);
                            
                            boolean result = ServiceLayer.addProduct(newProduct);
                            testResult = "添加商品结果: " + (result ? "成功" : "失败") + "\n";
                            testResult += "商品名称: " + name + "\n";
                            testResult += "商品价格: ¥" + priceStr + "\n";
                            testResult += "库存数量: " + stockStr + "\n";
                            if (result) {
                                testResult += "\n商品已成功添加到系统中！";
                                // 刷新页面数据
                                response.sendRedirect(request.getRequestURI());
                                return;
                            }
                        }
                        
                    } else if ("update".equals(action)) {
                        // 更新商品
                        String idStr = request.getParameter("updateProductId");
                        String name = request.getParameter("updateProductName");
                        String priceStr = request.getParameter("updateProductPrice");
                        String stockStr = request.getParameter("updateProductStock");
                        String categoryIdStr = request.getParameter("updateCategoryId");
                        String description = request.getParameter("updateProductDescription");
                        
                        if (idStr != null && name != null && priceStr != null && stockStr != null) {
                            int productId = Integer.parseInt(idStr);
                            Product existingProduct = ServiceLayer.getProductById(productId);
                            
                            if (existingProduct != null) {
                                existingProduct.setName(name);
                                existingProduct.setPrice(new BigDecimal(priceStr));
                                existingProduct.setStock(Integer.parseInt(stockStr));
                                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                                    existingProduct.setCategoryId(Integer.parseInt(categoryIdStr));
                                }
                                existingProduct.setDescription(description);
                                
                                boolean result = ServiceLayer.updateProduct(existingProduct);
                                testResult = "更新商品结果: " + (result ? "成功" : "失败") + "\n";
                                testResult += "商品ID: " + productId + "\n";
                                testResult += "新名称: " + name + "\n";
                                testResult += "新价格: ¥" + priceStr + "\n";
                                testResult += "新库存: " + stockStr + "\n";
                                if (result) {
                                    testResult += "\n商品信息已成功更新！";
                                    // 刷新页面数据
                                    response.sendRedirect(request.getRequestURI());
                                    return;
                                }
                            } else {
                                testResult = "错误: 找不到ID为 " + productId + " 的商品";
                            }
                        }
                        
                    } else if ("view".equals(action)) {
                        // 查看商品
                        String idStr = request.getParameter("productId");
                        if (idStr != null) {
                            int productId = Integer.parseInt(idStr);
                            Product product = ServiceLayer.getProductById(productId);
                            
                            if (product != null) {
                                testResult = "商品详细信息:\n";
                                testResult += "ID: " + product.getId() + "\n";
                                testResult += "名称: " + product.getName() + "\n";
                                testResult += "价格: ¥" + product.getPrice() + "\n";
                                testResult += "库存: " + product.getStock() + "\n";
                                testResult += "分类ID: " + product.getCategoryId() + "\n";
                                testResult += "描述: " + (product.getDescription() != null ? product.getDescription() : "无") + "\n";
                            } else {
                                testResult = "错误: 找不到ID为 " + productId + " 的商品";
                            }
                        }
                        
                    } else if ("delete".equals(action)) {
                        // 删除商品
                        String idStr = request.getParameter("productId");
                        if (idStr != null) {
                            int productId = Integer.parseInt(idStr);
                            Product product = ServiceLayer.getProductById(productId);
                            
                            if (product != null) {
                                String productName = product.getName();
                                boolean result = ServiceLayer.deleteProduct(productId);
                                testResult = "删除商品结果: " + (result ? "成功" : "失败") + "\n";
                                testResult += "商品ID: " + productId + "\n";
                                testResult += "商品名称: " + productName + "\n";
                                if (result) {
                                    testResult += "\n商品已成功删除！";
                                    // 刷新页面数据
                                    response.sendRedirect(request.getRequestURI());
                                    return;
                                }
                            } else {
                                testResult = "错误: 找不到ID为 " + productId + " 的商品";
                            }
                        }
                        
                    } else if ("listByCategory".equals(action)) {
                        // 按分类查询商品
                        String categoryIdStr = request.getParameter("searchCategoryId");
                        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                            int categoryId = Integer.parseInt(categoryIdStr);
                            List<Product> categoryProducts = ServiceLayer.listProductsByCategory(categoryId);
                            
                            // 获取分类名称
                            String categoryName = "未知分类";
                            if (allCategories != null) {
                                for (Category cat : allCategories) {
                                    if (cat.getId() == categoryId) {
                                        categoryName = cat.getName();
                                        break;
                                    }
                                }
                            }
                            
                            testResult = "分类 '" + categoryName + "' (ID: " + categoryId + ") 下的商品:\n\n";
                            
                            if (categoryProducts != null && !categoryProducts.isEmpty()) {
                                testResult += "共找到 " + categoryProducts.size() + " 个商品:\n\n";
                                for (Product product : categoryProducts) {
                                    testResult += "ID: " + product.getId() + "\n";
                                    testResult += "名称: " + product.getName() + "\n";
                                    testResult += "价格: ¥" + product.getPrice() + "\n";
                                    testResult += "库存: " + product.getStock() + "\n";
                                    if (product.getDescription() != null && !product.getDescription().trim().isEmpty()) {
                                        testResult += "描述: " + product.getDescription() + "\n";
                                    }
                                    testResult += "\n";
                                }
                            } else {
                                testResult += "该分类下暂无商品";
                            }
                        }
                    }
                    
                } catch (Exception e) {
                    testResult = "操作过程中发生异常: " + e.getMessage() + "\n";
                    testResult += "异常类型: " + e.getClass().getSimpleName();
                }
            }
            
            if (!testResult.isEmpty()) {
        %>
        <div class="test-section">
            <h2>操作结果</h2>
            <div class="test-result"><%= testResult %></div>
        </div>
        <%
            }
        %>
        
        <!-- 功能测试按钮 -->
        <div class="test-section">
            <h2>快速功能测试</h2>
            <p>点击下面的按钮执行预定义的测试操作：</p>
            
            <form method="post" style="display: inline;">
                <input type="hidden" name="action" value="testAdd">
                <button type="submit" class="success">测试添加随机商品</button>
            </form>
            
            <form method="post" style="display: inline;">
                <input type="hidden" name="action" value="testIntegrity">
                <button type="submit">测试系统完整性</button>
            </form>
        </div>
        
        <%
            // 处理快速测试操作
            if ("testAdd".equals(action)) {
                try {
                    // 创建随机测试商品
                    long timestamp = System.currentTimeMillis();
                    Product testProduct = new Product();
                    testProduct.setName("测试商品_" + timestamp);
                    testProduct.setPrice(new BigDecimal("99.99"));
                    testProduct.setStock(50);
                    testProduct.setDescription("这是一个自动生成的测试商品 - " + timestamp);
                    
                    // 如果有分类，使用第一个分类
                    if (allCategories != null && !allCategories.isEmpty()) {
                        testProduct.setCategoryId(allCategories.get(0).getId());
                    }
                    
                    boolean result = ServiceLayer.addProduct(testProduct);
                    String quickTestResult = "快速添加测试结果: " + (result ? "成功" : "失败") + "\n";
                    quickTestResult += "商品名称: " + testProduct.getName() + "\n";
                    quickTestResult += "商品价格: ¥" + testProduct.getPrice() + "\n";
                    quickTestResult += "库存数量: " + testProduct.getStock() + "\n";
                    
                    if (result) {
                        quickTestResult += "\n测试商品已成功添加！页面将自动刷新...";
        %>
        <div class="test-section">
            <h2>快速测试结果</h2>
            <div class="test-result"><%= quickTestResult %></div>
        </div>
        <script>
            setTimeout(function() {
                window.location.reload();
            }, 2000);
        </script>
        <%
                    } else {
        %>
        <div class="test-section">
            <h2>快速测试结果</h2>
            <div class="test-result"><%= quickTestResult %></div>
        </div>
        <%
                    }
                } catch (Exception e) {
        %>
        <div class="test-section">
            <h2>快速测试结果</h2>
            <div class="test-result">测试过程中发生异常: <%= e.getMessage() %></div>
        </div>
        <%
                }
            } else if ("testIntegrity".equals(action)) {
                // 系统完整性测试
                StringBuilder integrityResult = new StringBuilder();
                integrityResult.append("=== 商品管理系统完整性测试 ===\n\n");
                
                try {
                    // 测试获取商品列表
                    List<Product> products = ServiceLayer.listProducts();
                    integrityResult.append("1. 商品列表获取: ").append(products != null ? "成功" : "失败").append("\n");
                    integrityResult.append("   当前商品数量: ").append(products != null ? products.size() : 0).append("\n\n");
                    
                    // 测试获取分类列表
                    List<Category> categories = ServiceLayer.listCategories();
                    integrityResult.append("2. 分类列表获取: ").append(categories != null ? "成功" : "失败").append("\n");
                    integrityResult.append("   当前分类数量: ").append(categories != null ? categories.size() : 0).append("\n\n");
                    
                    // 测试单个商品查询
                    if (products != null && !products.isEmpty()) {
                        Product firstProduct = products.get(0);
                        Product retrievedProduct = ServiceLayer.getProductById(firstProduct.getId());
                        integrityResult.append("3. 单个商品查询: ").append(retrievedProduct != null ? "成功" : "失败").append("\n");
                        if (retrievedProduct != null) {
                            integrityResult.append("   测试商品: ").append(retrievedProduct.getName()).append("\n");
                        }
                    } else {
                        integrityResult.append("3. 单个商品查询: 跳过（无商品数据）\n");
                    }
                    integrityResult.append("\n");
                    
                    // 测试按分类查询
                    if (categories != null && !categories.isEmpty()) {
                        Category firstCategory = categories.get(0);
                        List<Product> categoryProducts = ServiceLayer.listProductsByCategory(firstCategory.getId());
                        integrityResult.append("4. 按分类查询商品: ").append(categoryProducts != null ? "成功" : "失败").append("\n");
                        integrityResult.append("   分类 '").append(firstCategory.getName()).append("' 下的商品数: ")
                                     .append(categoryProducts != null ? categoryProducts.size() : 0).append("\n\n");
                    } else {
                        integrityResult.append("4. 按分类查询商品: 跳过（无分类数据）\n\n");
                    }
                    
                    integrityResult.append("=== 测试完成 ===\n");
                    integrityResult.append("系统基本功能正常运行！");
                    
                } catch (Exception e) {
                    integrityResult.append("测试过程中发生异常: ").append(e.getMessage());
                }
        %>
        <div class="test-section">
            <h2>系统完整性测试结果</h2>
            <div class="test-result"><%= integrityResult.toString() %></div>
        </div>
        <%
            }
        %>
        
        <div style="margin-top: 30px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
            <h3>使用说明</h3>
            <ul>
                <li><strong>商品列表:</strong> 显示当前系统中的所有商品，可以直接查看或删除</li>
                <li><strong>添加商品:</strong> 填写商品信息并提交，系统会自动验证并添加</li>
                <li><strong>更新商品:</strong> 输入要更新的商品ID和新信息，系统会更新对应商品</li>
                <li><strong>查询商品:</strong> 输入商品ID查看详细信息</li>
                <li><strong>按分类查询:</strong> 选择分类查看该分类下的所有商品</li>
                <li><strong>快速测试:</strong> 一键执行预定义的测试操作</li>
            </ul>
        </div>
    </div>
</body>
</html>