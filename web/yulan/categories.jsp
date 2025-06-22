<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    java.util.List<Category> categories = ServiceLayer.listCategories();
    java.util.List<Product> products = ServiceLayer.listProducts();
    
    // 获取当前选中的分类ID
    String categoryIdParam = request.getParameter("categoryId");
    int selectedCategoryId = 0;
    if(categoryIdParam != null && !categoryIdParam.isEmpty()) {
        try {
            selectedCategoryId = Integer.parseInt(categoryIdParam);
            products = ServiceLayer.listProductsByCategory(selectedCategoryId);
        } catch(NumberFormatException e) {
            // 保持显示所有商品
        }
    }
    
    // 搜索功能
    String searchKeyword = request.getParameter("search");
    if(searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        // 简单的商品名称搜索过滤
        java.util.List<Product> filteredProducts = new java.util.ArrayList<>();
        for(Product p : products) {
            if(p.getName().toLowerCase().contains(searchKeyword.toLowerCase())) {
                filteredProducts.add(p);
            }
        }
        products = filteredProducts;
    }
%>
<html>
<head>
    <title>分类</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <style>
        .categories-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .search-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .search-box {
            display: flex;
            align-items: center;
            background: #f8f8f8;
            border-radius: 25px;
            padding: 12px 20px;
            margin-bottom: 15px;
        }
        .search-icon {
            color: #999;
            margin-right: 10px;
            font-size: 18px;
        }
        .search-input {
            flex: 1;
            border: none;
            background: none;
            outline: none;
            font-size: 16px;
            color: #333;
        }
        .search-input::placeholder {
            color: #999;
        }
        .recommendation-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .tag {
            background: #f0f0f0;
            color: #666;
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s;
        }
        .tag:hover, .tag.active {
            background: #ff6700;
            color: white;
        }
        .main-content {
            display: flex;
            gap: 20px;
        }
        .sidebar {
            width: 200px;
            background: white;
            border-radius: 12px;
            padding: 20px;
            height: fit-content;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .sidebar-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #ff6700;
        }
        .category-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .category-item {
            margin-bottom: 8px;
        }
        .category-link {
            display: block;
            padding: 12px 15px;
            color: #666;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.2s;
            font-size: 14px;
        }
        .category-link:hover, .category-link.active {
            background: #ff6700;
            color: white;
        }
        .products-section {
            flex: 1;
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
        }
        .product-count {
            color: #999;
            font-size: 14px;
        }
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }
        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
            color: inherit;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .product-image {
            width: 100%;
            height: 180px;
            background: #f8f8f8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #ddd;
        }
        .product-info {
            padding: 15px;
        }
        .product-name {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .product-price {
            font-size: 18px;
            font-weight: 600;
            color: #ff6700;
        }
        .price-unit {
            font-size: 14px;
            color: #999;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            color: #ddd;
        }
        .empty-text {
            font-size: 16px;
            margin-bottom: 10px;
        }
        .empty-subtext {
            font-size: 14px;
            color: #ccc;
        }
        @media (max-width: 768px) {
            .categories-container {
                padding: 10px;
            }
            .main-content {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                margin-bottom: 20px;
            }
            .products-grid {
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                gap: 15px;
            }
            .recommendation-tags {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
<header class="header">
    <div class="header-top">
        <div class="logo"><a href="index.jsp" style="color:#ff6700;text-decoration:none;">小米商城</a></div>
        <div class="user-info">
            <% if(session.getAttribute("user")!=null){ %>
            欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" class="logout-btn">退出</a>
            <% }else{ %>
            <a href="login.jsp" class="login-btn">登录</a> | <a href="register.jsp" class="login-btn">注册</a>
            <% } %>
        </div>
    </div>
</header>

<div class="categories-container">
    <!-- 搜索区域 -->
    <div class="search-section">
        <form method="get" action="categories.jsp">
            <div class="search-box">
                <span class="search-icon">🔍</span>
                <input type="text" name="search" class="search-input" 
                       placeholder="搜索商品名称" 
                       value="<%= searchKeyword == null ? "" : searchKeyword %>">
                <% if(categoryIdParam != null && !categoryIdParam.isEmpty()) { %>
                <input type="hidden" name="categoryId" value="<%= categoryIdParam %>">
                <% } %>
            </div>
        </form>
        
        <!-- 推荐标签 -->
        <div class="recommendation-tags">
            <a href="categories.jsp" class="tag <%= selectedCategoryId == 0 ? "active" : "" %>">推荐</a>
            <% for(Category c : categories) { %>
            <a href="categories.jsp?categoryId=<%= c.getId() %>" 
               class="tag <%= selectedCategoryId == c.getId() ? "active" : "" %>"><%= c.getName() %></a>
            <% } %>
        </div>
    </div>
    
    <div class="main-content">
        <!-- 左侧分类导航 -->
        <div class="sidebar">
            <div class="sidebar-title">Xiaomi手机</div>
            <ul class="category-list">
                <li class="category-item">
                    <a href="categories.jsp" class="category-link <%= selectedCategoryId == 0 ? "active" : "" %>">REDMI手机</a>
                </li>
                <% for(Category c : categories) { %>
                <li class="category-item">
                    <a href="categories.jsp?categoryId=<%= c.getId() %>" 
                       class="category-link <%= selectedCategoryId == c.getId() ? "active" : "" %>"><%= c.getName() %></a>
                </li>
                <% } %>
            </ul>
        </div>
        
        <!-- 右侧商品展示区域 -->
        <div class="products-section">
            <div class="section-header">
                <div class="section-title">
                    <% if(selectedCategoryId == 0) { %>
                    Xiaomi 数字旗舰
                    <% } else { %>
                    <% for(Category c : categories) { 
                        if(c.getId() == selectedCategoryId) { %>
                    <%= c.getName() %>
                    <% break; } } %>
                    <% } %>
                </div>
                <div class="product-count">共 <%= products.size() %> 件商品</div>
            </div>
            
            <% if(products.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">📱</div>
                <div class="empty-text">暂无商品</div>
                <div class="empty-subtext">该分类下暂时没有商品，请查看其他分类</div>
            </div>
            <% } else { %>
            <div class="products-grid">
                <% for(Product p : products) { %>
                <a href="product.jsp?id=<%= p.getId() %>" class="product-card">
                    <div class="product-image">
                        📱
                    </div>
                    <div class="product-info">
                        <div class="product-name"><%= p.getName() %></div>
                        <div class="product-price">
                            ¥<%= String.format("%.0f", p.getPrice()) %><span class="price-unit">起</span>
                        </div>
                    </div>
                </a>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
