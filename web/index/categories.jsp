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
    <link rel="stylesheet" href="css/categories.css"/>
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
            <div class="sidebar-title">
                <% if(selectedCategoryId == 0) { %>
                全部
                <% } else { %>
                <% for(Category c : categories) {
                    if(c.getId() == selectedCategoryId) { %>
                <%= c.getName() %>
                <% break; } } %>
                <% } %>
            </div>
            <ul class="category-list">
                <li class="category-item">
                    <a href="categories.jsp" class="category-link <%= selectedCategoryId == 0 ? "active" : "" %>">全部</a>
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
                    全部
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
                        <%
                            String imgUrl = "static/image/default-product.jpg";
                            java.util.List<com.entity.ProductImage> imgs = ServiceLayer.listProductImages(p.getId());
                            if(imgs != null && !imgs.isEmpty()) {
                                imgUrl = imgs.get(0).getUrl();
                            }
                        %>
                        <img src="<%= imgUrl %>" alt="<%= p.getName() %>" style="max-width:100%;height:auto;"/>
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
