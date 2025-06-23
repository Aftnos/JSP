<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.Category" %>
<%@ page import="com.entity.ProductImage" %>
<%@ page import="com.entity.ProductExtraImage" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.UUID" %>
<%
    // 获取搜索参数
    String searchKeyword = request.getParameter("searchKeyword");
    String searchCategory = request.getParameter("searchCategory");
    
    // 处理各种操作
    String action = request.getParameter("action");
    String operationResult = null;
    
    if ("add".equals(action)) {
        // 添加商品
        String name = request.getParameter("productName");
        String priceStr = request.getParameter("productPrice");
        String stockStr = request.getParameter("productStock");
        String categoryIdStr = request.getParameter("productCategory");
        String description = request.getParameter("productDescription");
        
        if (name != null && priceStr != null && stockStr != null) {
            try {
                Product newProduct = new Product();
                newProduct.setName(name);
                newProduct.setPrice(new java.math.BigDecimal(priceStr));
                newProduct.setStock(Integer.parseInt(stockStr));
                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    newProduct.setCategoryId(Integer.parseInt(categoryIdStr));
                }
                newProduct.setDescription(description);
                
                boolean result = ServiceLayer.addProduct(newProduct);
                operationResult = "添加商品结果: " + (result ? "成功" : "失败") + "\n";
                operationResult += "商品名称: " + name + "\n";
                operationResult += "商品价格: ¥" + priceStr + "\n";
                operationResult += "库存数量: " + stockStr;
                
                // 如果商品添加成功，处理图片上传
                if (result && newProduct.getId() > 0) {
                    try {
                        Part filePart = request.getPart("productImage");
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
                                String uniqueFileName = "product_" + newProduct.getId() + "_" + UUID.randomUUID().toString() + fileExtension;
                                
                                // 设置保存路径 - 保存到源码目录
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    uploadDir.mkdirs();
                                }
                                
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                
                                try {
                                    // 保存文件
                                    filePart.write(filePath);
                                    
                                    // 生成相对URL路径
                                    String imageUrl = "/images/products/" + uniqueFileName;
                                    
                                    // 保存到数据库
                                    ProductImage img = new ProductImage();
                                    img.setProductId(newProduct.getId());
                                    img.setUrl(imageUrl);
                                    
                                    boolean imageResult = ServiceLayer.addProductImage(img);
                                    if (imageResult) {
                                        operationResult += "\n图片上传成功: " + uniqueFileName;
                                    } else {
                                        operationResult += "\n图片保存到数据库失败";
                                        // 删除已上传的文件
                                        new File(filePath).delete();
                                    }
                                } catch (IOException e) {
                                    operationResult += "\n图片保存失败: " + e.getMessage();
                                }
                            }
                        }
                    } catch (Exception e) {
                        operationResult += "\n图片上传处理失败: " + e.getMessage();
                    }

                    // 处理副展示图
                    try {
                        Part secPart = request.getPart("secondaryImage");
                        if (secPart != null && secPart.getSize() > 0) {
                            String fileName = secPart.getSubmittedFileName();
                            if (fileName != null && !fileName.trim().isEmpty()) {
                                String fileExtension = "";
                                int lastDotIndex = fileName.lastIndexOf('.');
                                if (lastDotIndex > 0) {
                                    fileExtension = fileName.substring(lastDotIndex);
                                }
                                String uniqueFileName = "product_" + newProduct.getId() + "_" + UUID.randomUUID().toString() + fileExtension;
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    uploadDir.mkdirs();
                                }
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                try {
                                    secPart.write(filePath);
                                    String secUrl = "/images/products/" + uniqueFileName;
                                    ProductExtraImage img = new ProductExtraImage();
                                    img.setProductId(newProduct.getId());
                                    img.setUrl(secUrl);
                                    img.setType("secondary");
                                    boolean imageResult = ServiceLayer.addProductExtraImage(img);
                                    if (imageResult) {
                                        operationResult += "\n副图片上传成功: " + uniqueFileName;
                                    } else {
                                        operationResult += "\n副图片保存到数据库失败";
                                        new File(filePath).delete();
                                    }
                                } catch (IOException e) {
                                    operationResult += "\n副图片保存失败: " + e.getMessage();
                                }
                            }
                        }
                    } catch (Exception e) {
                        operationResult += "\n副图片上传处理失败: " + e.getMessage();
                    }

                    // 处理介绍图
                    try {
                        Part introPart = request.getPart("introImage");
                        if (introPart != null && introPart.getSize() > 0) {
                            String fileName = introPart.getSubmittedFileName();
                            if (fileName != null && !fileName.trim().isEmpty()) {
                                String fileExtension = "";
                                int lastDotIndex = fileName.lastIndexOf('.');
                                if (lastDotIndex > 0) {
                                    fileExtension = fileName.substring(lastDotIndex);
                                }
                                String uniqueFileName = "product_" + newProduct.getId() + "_" + UUID.randomUUID().toString() + fileExtension;
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    uploadDir.mkdirs();
                                }
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                try {
                                    introPart.write(filePath);
                                    String introUrl = "/images/products/" + uniqueFileName;
                                    ProductExtraImage img = new ProductExtraImage();
                                    img.setProductId(newProduct.getId());
                                    img.setUrl(introUrl);
                                    img.setType("intro");
                                    boolean imageResult = ServiceLayer.addProductExtraImage(img);
                                    if (imageResult) {
                                        operationResult += "\n介绍图片上传成功: " + uniqueFileName;
                                    } else {
                                        operationResult += "\n介绍图片保存到数据库失败";
                                        new File(filePath).delete();
                                    }
                                } catch (IOException e) {
                                    operationResult += "\n介绍图片保存失败: " + e.getMessage();
                                }
                            }
                        }
                    } catch (Exception e) {
                        operationResult += "\n介绍图片上传处理失败: " + e.getMessage();
                    }
                }
                
                if (result) {
                    // 添加成功，页面将自动显示更新后的商品列表
                    // 移除重定向，让页面自然刷新显示新数据
                }
            } catch (Exception e) {
                operationResult = "添加商品失败: " + e.getMessage();
            }
        }
    } else if ("edit".equals(action)) {
        // 编辑商品
        String productIdStr = request.getParameter("productId");
        String name = request.getParameter("productName");
        String priceStr = request.getParameter("productPrice");
        String stockStr = request.getParameter("productStock");
        String categoryIdStr = request.getParameter("productCategory");
        String description = request.getParameter("productDescription");
        
        if (productIdStr != null && name != null && priceStr != null && stockStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                Product updateProduct = new Product();
                updateProduct.setId(productId);
                updateProduct.setName(name);
                updateProduct.setPrice(new java.math.BigDecimal(priceStr));
                updateProduct.setStock(Integer.parseInt(stockStr));
                if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                    updateProduct.setCategoryId(Integer.parseInt(categoryIdStr));
                }
                updateProduct.setDescription(description);
                
                boolean result = ServiceLayer.updateProduct(updateProduct);
                operationResult = "编辑商品结果: " + (result ? "成功" : "失败") + "\n";
                operationResult += "商品名称: " + name + "\n";
                operationResult += "商品价格: ¥" + priceStr + "\n";
                operationResult += "库存数量: " + stockStr;

                if (result) {
                    try {
                        Part filePart = request.getPart("productImage");
                        if (filePart != null && filePart.getSize() > 0) {
                            String fileName = filePart.getSubmittedFileName();
                            if (fileName != null && !fileName.trim().isEmpty()) {
                                String fileExtension = "";
                                int lastDotIndex = fileName.lastIndexOf('.');
                                if (lastDotIndex > 0) {
                                    fileExtension = fileName.substring(lastDotIndex);
                                }
                                String uniqueFileName = "product_" + productId + "_" + UUID.randomUUID().toString() + fileExtension;
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    uploadDir.mkdirs();
                                }
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                try {
                                    filePart.write(filePath);
                                    String imageUrl = "/images/products/" + uniqueFileName;
                                    ProductImage img = new ProductImage();
                                    img.setProductId(productId);
                                    img.setUrl(imageUrl);
                                    ServiceLayer.addProductImage(img);
                                } catch (IOException e) {
                                    operationResult += "\n图片保存失败: " + e.getMessage();
                                }
                            }
                        }
                    } catch (Exception e) {
                        operationResult += "\n图片上传处理失败: " + e.getMessage();
                    }

                    try {
                        Part secPart = request.getPart("secondaryImage");
                        if (secPart != null && secPart.getSize() > 0) {
                            String fileName = secPart.getSubmittedFileName();
                            if (fileName != null && !fileName.trim().isEmpty()) {
                                String fileExtension = "";
                                int lastDotIndex = fileName.lastIndexOf('.');
                                if (lastDotIndex > 0) {
                                    fileExtension = fileName.substring(lastDotIndex);
                                }
                                String uniqueFileName = "product_" + productId + "_" + UUID.randomUUID().toString() + fileExtension;
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    uploadDir.mkdirs();
                                }
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                try {
                                    secPart.write(filePath);
                                    String secUrl = "/images/products/" + uniqueFileName;
                                    ProductExtraImage img = new ProductExtraImage();
                                    img.setProductId(productId);
                                    img.setUrl(secUrl);
                                    img.setType("secondary");
                                    ServiceLayer.addProductExtraImage(img);
                                } catch (IOException e) {
                                    operationResult += "\n副图片保存失败: " + e.getMessage();
                                }
                            }
                        }
                    } catch (Exception e) {
                        operationResult += "\n副图片上传处理失败: " + e.getMessage();
                    }

                    try {
                        Part introPart = request.getPart("introImage");
                        if (introPart != null && introPart.getSize() > 0) {
                            String fileName = introPart.getSubmittedFileName();
                            if (fileName != null && !fileName.trim().isEmpty()) {
                                String fileExtension = "";
                                int lastDotIndex = fileName.lastIndexOf('.');
                                if (lastDotIndex > 0) {
                                    fileExtension = fileName.substring(lastDotIndex);
                                }
                                String uniqueFileName = "product_" + productId + "_" + UUID.randomUUID().toString() + fileExtension;
                                String uploadPath = "f:/项目文件/实训/JSP/web/images/products/";
                                File uploadDir = new File(uploadPath);
                                if (!uploadDir.exists()) {
                                    uploadDir.mkdirs();
                                }
                                String filePath = uploadPath + File.separator + uniqueFileName;
                                try {
                                    introPart.write(filePath);
                                    String introUrl = "/images/products/" + uniqueFileName;
                                    ProductExtraImage img = new ProductExtraImage();
                                    img.setProductId(productId);
                                    img.setUrl(introUrl);
                                    img.setType("intro");
                                    ServiceLayer.addProductExtraImage(img);
                                } catch (IOException e) {
                                    operationResult += "\n介绍图片保存失败: " + e.getMessage();
                                }
                            }
                        }
                    } catch (Exception e) {
                        operationResult += "\n介绍图片上传处理失败: " + e.getMessage();
                    }

                    response.sendRedirect(request.getRequestURI());
                    return;
                }
            } catch (Exception e) {
                operationResult = "编辑商品失败: " + e.getMessage();
            }
        }
    } else if ("deleteProduct".equals(action)) {
        String productIdStr = request.getParameter("productId");
        if (productIdStr != null) {
            try {
                int productId = Integer.parseInt(productIdStr);
                boolean result = ServiceLayer.deleteProduct(productId);
                operationResult = "删除商品结果: " + (result ? "成功" : "失败");
            } catch (NumberFormatException e) {
                operationResult = "删除失败: 商品ID格式错误";
            }
        }
    } else if ("batchDelete".equals(action)) {
        String[] productIds = request.getParameterValues("productIds");
        if (productIds != null && productIds.length > 0) {
            int successCount = 0;
            for (String idStr : productIds) {
                try {
                    int productId = Integer.parseInt(idStr);
                    if (ServiceLayer.deleteProduct(productId)) {
                        successCount++;
                    }
                } catch (NumberFormatException e) {
                    // 忽略格式错误的ID
                }
            }
            operationResult = "批量删除结果: 成功删除 " + successCount + " 个商品，共 " + productIds.length + " 个";
        }
    }
    
    // 获取所有商品数据
    List<Product> allProducts = ServiceLayer.listProducts();
    
    // 根据搜索条件过滤商品
    List<Product> filteredProducts = new ArrayList<>();
    if (allProducts != null) {
        for (Product product : allProducts) {
            boolean matchKeyword = true;
            boolean matchCategory = true;
            
            // 检查关键词匹配（商品名称）
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = searchKeyword.trim().toLowerCase();
                String productName = (product.getName() != null) ? product.getName().toLowerCase() : "";
                matchKeyword = productName.contains(keyword);
            }
            
            // 检查分类匹配
            if (searchCategory != null && !searchCategory.trim().isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(searchCategory.trim());
                    matchCategory = (product.getCategoryId() != null && product.getCategoryId().equals(categoryId));
                } catch (NumberFormatException e) {
                    matchCategory = false;
                }
            }
            
            // 如果都匹配则添加到结果列表
            if (matchKeyword && matchCategory) {
                filteredProducts.add(product);
            }
        }
    }
    
    // 使用过滤后的商品列表
    List<Product> displayProducts = filteredProducts;
    
    // 获取所有分类数据
    List<Category> allCategories = ServiceLayer.listCategories();
    
    // 创建分类映射，方便显示分类名称
    java.util.Map<Integer, String> categoryMap = new java.util.HashMap<>();
    if (allCategories != null) {
        for (Category category : allCategories) {
            categoryMap.put(category.getId(), category.getName());
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理 - 小米商城管理系统</title>
    <!-- 引入基础样式 -->
    <link rel="stylesheet" type="text/css" href="../../static/css/admin-layout.css">
    <!-- 引入主样式 -->
    <link rel="stylesheet" type="text/css" href="../../css/main.css">
    <link rel="stylesheet" href="./main.css">
    <!-- 引入弹框样式 -->
    <link rel="stylesheet" href="./modal.css">
</head>
<body>
   <!-- 后台管理系统容器 -->
   <div class="admin-container">
        <!-- 侧边栏 -->
        <div class="sidebar" id="sidebar">
            <!-- 侧边栏头部 -->
            <div class="sidebar-header">
                <div class="logo">小米商城管理系统</div>
                <button class="sidebar-toggle" onclick="toggleSidebar()">
                    <i class="icon">☰</i>
                </button>
            </div>

            <!-- 菜单容器 -->
            <div class="sidebar-menu">
                <!-- 用户管理 -->
                <div class="menu-item" onclick="toggleSubmenu('user-menu')">
                    <div class="icon">👥</div>
                    <span class="text">用户管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="user-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('user-profile-management')">
                        <span class="text">用户资料管理</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('address-management')">
                        <span class="text">收货地址管理</span>
                    </div>
                </div>

                <!-- 商品管理 -->
                <div class="menu-item" onclick="toggleSubmenu('product-menu')">
                    <div class="icon">📦</div>
                    <span class="text">商品管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="product-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('product-management')">
                        <span class="text">商品管理</span>
                    </div>
                </div>

                <!-- 订单管理 -->
                <div class="menu-item" onclick="toggleSubmenu('order-menu')">
                    <div class="icon">📋</div>
                    <span class="text">订单管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="order-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('order-global-query')">
                        <span class="text">全局查询</span>
                    </div>
                </div>

                <!-- SN码管理 -->
                <div class="menu-item" onclick="toggleSubmenu('sn-menu')">
                    <div class="icon">🔢</div>
                    <span class="text">SN码管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="sn-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('sn-global-query')">
                        <span class="text">全局查询</span>
                    </div>
                </div>

                <!-- SN绑定管理 -->
                <div class="menu-item" onclick="toggleSubmenu('sn-binding-menu')">
                    <div class="icon">🔗</div>
                    <span class="text">SN绑定管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="sn-binding-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('sn-forced-unbinding')">
                        <span class="text">全局查询</span>
                    </div>
                </div>
                <!-- 售后管理 -->
                <div class="menu-item" onclick="toggleSubmenu('aftersales-menu')">
                    <div class="icon">🛠️</div>
                    <span class="text">售后管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="aftersales-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('aftersales-workflow-control')">
                        <span class="text">工单全流程控制</span>
                    </div>
                </div>

                <!-- 系统通知管理 -->
                <div class="menu-item" onclick="toggleSubmenu('notification-menu')">
                    <div class="icon">🔔</div>
                    <span class="text">系统通知管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="notification-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('message-center-maintenance')">
                        <span class="text">消息中心维护</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 主内容区域 -->
        <div class="main-content" id="mainContent">
            <!-- 顶部用户信息栏 -->
            <div class="top-header">
                <div class="user-info">
                    <div class="user-text">
                        <div class="greeting">Hi, <span id="username">小锦鲤</span></div>
                        <div class="welcome-text">欢迎进入小米商城管理系统</div>
                    </div>
                    <div class="user-avatar-container">
                        <img src="../../images/default-avatar.png" alt="用户头像" class="user-avatar" id="userAvatar" onclick="toggleUserMenu()" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNFNUU1RTUiLz4KPGNpcmNsZSBjeD0iMjAiIGN5PSIxNiIgcj0iNiIgZmlsbD0iIzk5OTk5OSIvPgo8cGF0aCBkPSJNMzAgMzJDMzAgMjYuNDc3MSAyNS41MjI5IDIyIDIwIDIyQzE0LjQ3NzEgMjIgMTAgMjYuNDc3MSAxMCAzMkgzMFoiIGZpbGw9IiM5OTk5OTkiLz4KPC9zdmc+'">
                        <!-- 用户下拉菜单 -->
                        <div class="user-dropdown" id="userDropdown">
                            <div class="dropdown-item" onclick="window.location.href='../../index.jsp'">
                                <i class="icon">🏠</i>
                                <span>返回用户端</span>
                            </div>
                            <div class="dropdown-item" onclick="logout()">
                                <i class="icon">🚪</i>
                                <span>退出登录</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 页面内容区域 -->
            <div class="page-content" id="pageContent">
                <!-- 页面标题 -->
                <div class="page-header">
                    <h1 class="page-title">商品管理</h1>
                    <p class="page-subtitle">管理商城商品信息、库存和分类</p>
                </div>
                
                <!-- 操作结果显示 -->
                <%
                    if (operationResult != null) {
                %>
                <div class="alert alert-info" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; font-family: monospace; white-space: pre-line;">
                    <strong>操作结果:</strong><br>
                    <%= operationResult %>
                </div>
                <%
                    }
                %>
                
                <!-- 搜索结果提示 -->
                <%
                    if ((searchKeyword != null && !searchKeyword.trim().isEmpty()) || (searchCategory != null && !searchCategory.trim().isEmpty())) {
                        String searchInfo = "";
                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            searchInfo += "关键词: \"" + searchKeyword + "\"";
                        }
                        if (searchCategory != null && !searchCategory.trim().isEmpty()) {
                            if (!searchInfo.isEmpty()) searchInfo += ", ";
                            String categoryName = "未知分类";
                            if (allCategories != null) {
                                for (Category cat : allCategories) {
                                    if (String.valueOf(cat.getId()).equals(searchCategory)) {
                                        categoryName = cat.getName();
                                        break;
                                    }
                                }
                            }
                            searchInfo += "分类: \"" + categoryName + "\"";
                        }
                        int resultCount = (displayProducts != null) ? displayProducts.size() : 0;
                %>
                <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <strong>搜索结果:</strong> <%= searchInfo %> - 找到 <%= resultCount %> 个商品
                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearSearch()" style="margin-left: 10px; font-size: 12px;">清除搜索</button>
                </div>
                <%
                    }
                %>
                
                <!-- 工具栏 -->
                <div class="toolbar">
                    <!-- 搜索区域 -->
                    <form method="get" action="" style="display: contents;">
                        <div class="search-section">
                            <input type="text" class="search-input" placeholder="搜索商品名称..." id="searchInput" name="searchKeyword" value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                            
                            <!-- 分类下拉框 -->
                            <select class="category-select" id="categorySelect" name="searchCategory">
                                <option value="">全部分类</option>
                                <%
                                    if (allCategories != null) {
                                        for (Category category : allCategories) {
                                            boolean isSelected = (searchCategory != null && searchCategory.equals(String.valueOf(category.getId())));
                                %>
                                    <option value="<%= category.getId() %>"<%= isSelected ? " selected" : "" %>><%= category.getName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            
                            <button type="submit" class="btn btn-primary">
                                🔍 搜索
                            </button>
                            
                            <!-- 清除搜索按钮 -->
                            <button type="button" class="btn btn-secondary" onclick="clearSearch()">
                                🗑️ 清除
                            </button>
                        </div>
                    </form>
                    
                    <!-- 操作按钮 -->
                    <div class="action-buttons">
                        <button class="btn btn-success" onclick="addProduct()">
                            ➕ 增加商品
                        </button>
                        <button class="btn btn-danger" onclick="batchDelete()">
                            🗑️ 批量删除
                        </button>
                    </div>
                </div>
                
                <!-- 数据表格 -->
                <div class="data-table">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th width="50">
                                        <input type="checkbox" class="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                    </th>
                                    <th width="80">序号</th>
                                    <th width="100">图片</th>
                                    <th width="180">名称</th>
                                    <th width="100">分类</th>
                                    <th width="120">价格</th>
                                    <th width="100">库存</th>
                                    <th width="200">简介</th>
                                    <th width="200">操作</th>
                                </tr>
                            </thead>
                            <tbody id="productTableBody">
                                <%
                                    if (displayProducts != null && !displayProducts.isEmpty()) {
                                        int index = 1;
                                        for (Product product : displayProducts) {
                                            String categoryName = "未分类";
                                            if (product.getCategoryId() != null && categoryMap.containsKey(product.getCategoryId())) {
                                                categoryName = categoryMap.get(product.getCategoryId());
                                            }
                                %>
                                <tr>
                                    <td>
                                        <input type="checkbox" class="checkbox row-checkbox" value="<%= product.getId() %>">
                                    </td>
                                    <td><%= index++ %></td>
                                    <td>
                                        <div class="product-image">
                                            <%
                                                // 获取商品的第一张图片
                                                List<ProductImage> productImages = ServiceLayer.listProductImages(product.getId());
                                                String imageUrl = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjYwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik0yMCAyMEg0MFY0MEgyMFYyMFoiIGZpbGw9IiNEREREREQiLz4KPGF0aCBkPSJNMjUgMjVIMzVWMzVIMjVWMjVaIiBmaWxsPSIjQkJCQkJCIi8+PC9zdmc+";
                                                if (productImages != null && !productImages.isEmpty()) {
                                                    imageUrl = productImages.get(0).getUrl();
                                                    if (imageUrl.startsWith("web/")) {
                                                        imageUrl = imageUrl.substring(3);
                                                    }
                                                    if (!imageUrl.startsWith("/")) {
                                                        imageUrl = "/" + imageUrl;
                                                    }
                                                    imageUrl = request.getContextPath() + imageUrl;
                                                }
                                            %>
                                            <img src="<%= imageUrl %>" alt="商品图片" class="product-thumb" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjYwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik0yMCAyMEg0MFY0MEgyMFYyMFoiIGZpbGw9IiNEREREREQiLz4KPGF0aCBkPSJNMjUgMjVIMzVWMzVIMjVWMjVaIiBmaWxsPSIjQkJCQkJCIi8+PC9zdmc+'">
                                        </div>
                                    </td>
                                    <td><%= product.getName() != null ? product.getName() : "" %></td>
                                    <td><%= categoryName %></td>
                                    <td>¥<%= product.getPrice() != null ? product.getPrice() : "0.00" %></td>
                                    <td><%= product.getStock() %></td>
                                    <td><%= product.getDescription() != null ? product.getDescription() : "" %></td>
                                    <td>
                                        <div class="table-actions">
                                            <button class="btn btn-primary btn-sm" onclick="editProduct(<%= product.getId() %>)">
                                                编辑
                                            </button>
                                            <button class="btn btn-success btn-sm" onclick="viewProduct(<%= product.getId() %>)">
                                                查看
                                            </button>
                                            <button class="btn btn-danger btn-sm" onclick="deleteProduct(<%= product.getId() %>)">
                                                删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 20px;">暂无商品数据</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- 分页 -->
                    <div class="pagination">
                        <div class="pagination-info">
                            <%
                                int totalProducts = (displayProducts != null) ? displayProducts.size() : 0;
                                if (totalProducts > 0) {
                            %>
                            显示第 1-<%= totalProducts %> 条，共 <%= totalProducts %> 条记录
                            <%
                                } else {
                            %>
                            暂无记录
                            <%
                                }
                            %>
                        </div>
                        <div class="pagination-controls">
                            <button class="page-btn" disabled>上一页</button>
                            <button class="page-btn active">1</button>
                            <button class="page-btn" disabled>下一页</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 添加/编辑商品弹框 -->
    <div class="modal" id="productModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">添加商品</h3>
                <span class="close" onclick="closeProductModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="productForm">
                    <input type="hidden" id="productId" name="productId">
                    
                    <div class="form-group">
                        <label for="productName">商品名称：</label>
                        <input type="text" id="productName" name="productName" class="form-control" required>
                        <span class="error-message" id="nameError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="productPrice">价格：</label>
                        <input type="number" id="productPrice" name="productPrice" class="form-control" step="0.01" min="0" required>
                        <span class="error-message" id="priceError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="productStock">库存：</label>
                        <input type="number" id="productStock" name="productStock" class="form-control" min="0" required>
                        <span class="error-message" id="stockError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="productCategory">分类：</label>
                        <select id="productCategory" name="productCategory" class="form-control" required>
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
                        <span class="error-message" id="categoryError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="productDescription">商品简介：</label>
                        <textarea id="productDescription" name="productDescription" class="form-control" rows="3"></textarea>
                        <span class="error-message" id="descriptionError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="productImage">商品图片：</label>
                        <input type="file" id="productImage" name="productImage" class="form-control" accept="image/*">
                        <span class="error-message" id="imageError"></span>
                        <div class="image-preview" id="imagePreview" style="display: none;">
                            <img id="previewImg" src="" alt="图片预览" style="max-width: 200px; max-height: 200px; margin-top: 10px;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="secondaryImage">副展示图：</label>
                        <input type="file" id="secondaryImage" name="secondaryImage" class="form-control" accept="image/*">
                    </div>
                    <div class="form-group">
                        <label for="introImage">详细介绍图：</label>
                        <input type="file" id="introImage" name="introImage" class="form-control" accept="image/*">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeProductModal()">取消</button>
                <button type="button" class="btn btn-primary" onclick="saveProduct()">保存</button>
            </div>
        </div>
    </div>
    
    <!-- 查看商品弹框 -->
    <div class="modal" id="viewProductModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>查看商品详情</h3>
                <span class="close" onclick="closeViewProductModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="view-form">
                    <div class="form-group">
                        <label>商品名称：</label>
                        <div class="view-field" id="viewProductName"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>价格：</label>
                        <div class="view-field" id="viewProductPrice"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>库存：</label>
                        <div class="view-field" id="viewProductStock"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>分类：</label>
                        <div class="view-field" id="viewProductCategory"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>商品简介：</label>
                        <div class="view-field" id="viewProductDescription"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>商品图片：</label>
                        <div class="view-field">
                            <div class="image-preview" id="viewImagePreview">
                                <img id="viewPreviewImg" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik02MCA2MEgxNDBWMTQwSDYwVjYwWiIgZmlsbD0iI0RERERERCIvPgo8cGF0aCBkPSJNODAgODBIMTIwVjEyMEg4MFY4MFoiIGZpbGw9IiNCQkJCQkIiLz4KPC9zdmc+" alt="商品图片" style="max-width: 200px; max-height: 200px; border: 1px solid #ddd; border-radius: 4px;" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik02MCA2MEgxNDBWMTQwSDYwVjYwWiIgZmlsbD0iI0RERERERCIvPgo8cGF0aCBkPSJNODAgODBIMTIwVjEyMEg4MFY4MFoiIGZpbGw9IiNCQkJCQkIiLz4KPC9zdmc+'">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeViewProductModal()">关闭</button>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="../../js/main.js"></script>
    <script src="./main.js"></script>
    
    <!-- 商品管理功能JavaScript -->
    <script>
        // 清除搜索条件
        function clearSearch() {
            window.location.href = window.location.pathname;
        }
        
        // 搜索功能（现在通过表单提交实现）
        function searchProducts() {
            // 表单会自动提交，不需要额外的JavaScript逻辑
        }
        
        // 添加商品
        function addProduct() {
            document.getElementById('modalTitle').textContent = '添加商品';
            document.getElementById('productForm').reset();
            document.getElementById('productId').value = '';
            document.getElementById('imagePreview').style.display = 'none';
            document.getElementById('productModal').style.display = 'block';
        }
        
        // 编辑商品
        function editProduct(productId) {
            document.getElementById('modalTitle').textContent = '编辑商品';
            document.getElementById('productId').value = productId;
            
            // 从表格中获取商品数据
            var rows = document.querySelectorAll('#productTableBody tr');
            for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                var checkbox = row.querySelector('.row-checkbox');
                if (checkbox && checkbox.value == productId) {
                    // 获取表格单元格数据
                    var cells = row.querySelectorAll('td');
                    var productName = cells[3].textContent.trim();
                    var categoryName = cells[4].textContent.trim();
                    var price = cells[5].textContent.replace('¥', '').trim();
                    var stock = cells[6].textContent.trim();
                    var description = cells[7].textContent.trim();
                    
                    // 填充表单字段
                    document.getElementById('productName').value = productName;
                    document.getElementById('productPrice').value = price;
                    document.getElementById('productStock').value = stock;
                    document.getElementById('productDescription').value = description;
                    
                    // 设置分类下拉框
                    var categorySelect = document.getElementById('productCategory');
                    for (var j = 0; j < categorySelect.options.length; j++) {
                        if (categorySelect.options[j].text === categoryName) {
                            categorySelect.selectedIndex = j;
                            break;
                        }
                    }
                    
                    break;
                }
            }
            
            document.getElementById('imagePreview').style.display = 'none';
            document.getElementById('productModal').style.display = 'block';
        }
        
        // 查看商品
        function viewProduct(productId) {
            // 从表格中获取商品数据
            var row = document.querySelector('tr[data-product-id="' + productId + '"]');
            if (!row) {
                // 如果没有找到对应行，尝试通过其他方式查找
                var rows = document.querySelectorAll('tbody tr');
                for (var i = 0; i < rows.length; i++) {
                    var checkbox = rows[i].querySelector('.row-checkbox');
                    if (checkbox && checkbox.value == productId) {
                        row = rows[i];
                        break;
                    }
                }
            }
            
            if (row) {
                var cells = row.querySelectorAll('td');
                
                // 获取商品信息（根据表格列的顺序）
                var productImage = cells[2].querySelector('img').src; // 获取图片URL
                var productName = cells[3].textContent.trim();
                var categoryName = cells[4].textContent.trim();
                var price = cells[5].textContent.trim();
                var stock = cells[6].textContent.trim();
                var description = cells[7].textContent.trim();
                
                // 填充查看弹窗的字段
                document.getElementById('viewProductName').textContent = productName;
                document.getElementById('viewProductPrice').textContent = price;
                document.getElementById('viewProductStock').textContent = stock;
                document.getElementById('viewProductCategory').textContent = categoryName;
                document.getElementById('viewProductDescription').textContent = description || '暂无描述';
                
                // 设置商品图片
                document.getElementById('viewPreviewImg').src = productImage;
                
                // 显示查看弹窗
                document.getElementById('viewProductModal').style.display = 'block';
            } else {
                alert('未找到商品信息！');
            }
        }
        
        // 关闭查看商品弹窗
        function closeViewProductModal() {
            document.getElementById('viewProductModal').style.display = 'none';
        }
        
        // 删除商品
        function deleteProduct(productId) {
            if (confirm('确定要删除该商品吗？此操作不可撤销！')) {
                // 创建隐藏表单提交删除请求
                var form = document.createElement('form');
                form.method = 'post';
                form.action = '';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteProduct';
                form.appendChild(actionInput);
                
                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'productId';
                idInput.value = productId;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 批量删除
        function batchDelete() {
            var checkboxes = document.querySelectorAll('.row-checkbox:checked');
            if (checkboxes.length === 0) {
                alert('请先选择要删除的商品！');
                return;
            }
            
            var productIds = [];
            checkboxes.forEach(function(checkbox) {
                productIds.push(checkbox.value);
            });
            
            if (confirm('确定要删除选中的 ' + productIds.length + ' 个商品吗？此操作不可撤销！')) {
                // 创建隐藏表单提交批量删除请求
                var form = document.createElement('form');
                form.method = 'post';
                form.action = '';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'batchDelete';
                form.appendChild(actionInput);
                
                // 添加所有选中的商品ID
                productIds.forEach(function(id) {
                    var idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'productIds';
                    idInput.value = id;
                    form.appendChild(idInput);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 保存商品
        function saveProduct() {
            var form = document.getElementById('productForm');
            
            // 验证必填字段
            var name = document.getElementById('productName').value.trim();
            var price = document.getElementById('productPrice').value;
            var stock = document.getElementById('productStock').value;
            var category = document.getElementById('productCategory').value;
            var productId = document.getElementById('productId').value;
            
            if (!name) {
                alert('请输入商品名称！');
                return;
            }
            if (!price || price <= 0) {
                alert('请输入有效的商品价格！');
                return;
            }
            if (!stock || stock < 0) {
                alert('请输入有效的库存数量！');
                return;
            }
            if (!category) {
                alert('请选择商品分类！');
                return;
            }
            
            // 创建支持文件上传的表单
            var submitForm = document.createElement('form');
            submitForm.method = 'post';
            submitForm.action = '';
            submitForm.enctype = 'multipart/form-data';
            
            // 添加action参数 - 根据是否有productId判断是添加还是编辑
            var actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = productId ? 'edit' : 'add';
            submitForm.appendChild(actionInput);
            
            // 如果是编辑，添加productId
            if (productId) {
                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'productId';
                idInput.value = productId;
                submitForm.appendChild(idInput);
            }
            
            // 添加表单数据
            var fields = ['productName', 'productPrice', 'productStock', 'productCategory', 'productDescription'];
            fields.forEach(function(fieldName) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = fieldName;
                input.value = document.getElementById(fieldName).value;
                submitForm.appendChild(input);
            });
            
            // 添加文件上传字段
            var fileInput = document.getElementById('productImage');
            if (fileInput.files.length > 0) {
                var clonedFileInput = fileInput.cloneNode(true);
                submitForm.appendChild(clonedFileInput);
            }

            var secInput = document.getElementById('secondaryImage');
            if (secInput.files.length > 0) {
                var cloneSec = secInput.cloneNode(true);
                submitForm.appendChild(cloneSec);
            }

            var introInput = document.getElementById('introImage');
            if (introInput.files.length > 0) {
                var cloneIntro = introInput.cloneNode(true);
                submitForm.appendChild(cloneIntro);
            }
            
            document.body.appendChild(submitForm);
            submitForm.submit();
        }
        
        // 关闭商品弹框
        function closeProductModal() {
            document.getElementById('productModal').style.display = 'none';
        }
        
        // 全选/取消全选
        function toggleSelectAll() {
            var selectAllCheckbox = document.getElementById('selectAll');
            var rowCheckboxes = document.querySelectorAll('.row-checkbox');
            
            rowCheckboxes.forEach(function(checkbox) {
                checkbox.checked = selectAllCheckbox.checked;
            });
        }
        
        // 图片预览
        document.getElementById('productImage').addEventListener('change', function(e) {
            var file = e.target.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('previewImg').src = e.target.result;
                    document.getElementById('imagePreview').style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                document.getElementById('imagePreview').style.display = 'none';
            }
        });
    </script>
</body>
</html>