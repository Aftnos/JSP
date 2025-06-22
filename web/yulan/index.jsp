<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.Category" %>
<%
    request.setCharacterEncoding("UTF-8");
    String q = request.getParameter("q");
    String categoryFilter = request.getParameter("category");
    
    java.util.List<Category> categories = ServiceLayer.listCategories();
    java.util.List<Product> list;
    if(categoryFilter!=null && !categoryFilter.equals("all")){
        list = ServiceLayer.listProductsByCategory(Integer.parseInt(categoryFilter));
    } else {
        list = ServiceLayer.listProducts();
    }

    // 搜索过滤
    if(q!=null && q.trim().length()>0){
        java.util.List<Product> filtered = new java.util.ArrayList<>();
        for(Product p : list){
            if(p.getName().contains(q)) filtered.add(p);
        }
        list = filtered;
    }
    
    int unread = 0;
    if(session.getAttribute("user")!=null){
        com.entity.User u=(com.entity.User)session.getAttribute("user");
        java.util.List<com.entity.Notification> notes = ServiceLayer.getNotifications(u.getId());
        for(com.entity.Notification n:notes){ if(!n.isRead()) unread++; }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>小米商城</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/main.css"/>
    <script src="js/main.js"></script>
</head>
<body>
<!-- 顶部导航栏 -->
<header class="header">
    <div class="header-top">
        <div class="logo">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="#ff6700">
                <path d="M12 2L2 7v10c0 5.55 3.84 9.739 9 11 5.16-1.261 9-5.45 9-11V7l-10-5z"/>
            </svg>
            <span>小米商城</span>
        </div>
        <div class="search-container">
            <form action="index.jsp" method="get" class="search-form">
                <input type="text" name="q" placeholder="搜索商品名称" value="<%= q==null?"":q %>" class="search-input"/>
                <button type="submit" class="search-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="#999">
                        <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                </button>
            </form>
            <a href="notifications.jsp" class="notify-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="#666">
                    <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/>
                </svg>
                <% if(unread>0){ %><span class="badge"><%= unread %></span><% } %>
            </a>
            <div class="user-info">
                <% if(session.getAttribute("user")!=null){ %>
                    <span>欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %></span>
                    <a href="logout.jsp" class="logout-btn">退出</a>
                <% }else{ %>
                    <a href="login.jsp" class="login-btn">登录</a>
                <% } %>
            </div>
        </div>
    </div>
</header>

<!-- 导航标签 -->
<nav class="nav-tabs">
    <a href="index.jsp?category=all" class="nav-tab <%= (categoryFilter==null || categoryFilter.equals("all")) ? "active" : "" %>">推荐</a>
    <% for(Category category : categories) { %>
    <a href="index.jsp?category=<%= category.getId() %>" class="nav-tab <%= String.valueOf(category.getId()).equals(categoryFilter) ? "active" : "" %>"><%= category.getName() %></a>
    <% } %>
</nav>

<!-- 主要内容区域 -->
<main class="main-content">
    <!-- 轮播图/推荐商品区域 -->
    <section class="hero-section">
        <div class="hero-banner">
            <div class="banner-item active">
                <div class="banner-content">
                    <h2>小米自带线屏显充电宝</h2>
                    <p class="price">众筹价格 ¥179</p>
                    <p class="original-price">建议零售价 ¥199</p>
                    <div class="product-colors">
                        <span class="color-dot" style="background:#87CEEB;"></span>
                        <span class="color-dot" style="background:#F4A460;"></span>
                        <span class="color-dot" style="background:#90EE90;"></span>
                    </div>
                </div>
                <div class="banner-image">
                    <svg width="200" height="150" viewBox="0 0 200 150">
                        <!-- 充电宝图标 -->
                        <rect x="50" y="30" width="100" height="60" rx="10" fill="#87CEEB" stroke="#666" stroke-width="2"/>
                        <rect x="55" y="35" width="90" height="20" rx="5" fill="#fff"/>
                        <circle cx="70" cy="45" r="3" fill="#333"/>
                        <text x="80" y="50" font-size="8" fill="#333">10000 45W</text>
                        <!-- 充电线 -->
                        <path d="M150 60 Q170 60 170 80 Q170 100 150 100" stroke="#87CEEB" stroke-width="3" fill="none"/>
                        <circle cx="150" cy="100" r="4" fill="#87CEEB"/>
                    </svg>
                </div>
            </div>
        </div>
    </section>



    <!-- 产品展示区域 -->
    <section class="products-section">
        <% if(list != null && !list.isEmpty()) { %>
            <div class="products-grid">
                <% for(Product p : list){ %>
                <div class="product-item">
                    <div class="product-image">
                        <!-- 产品图片占位符 -->
                        <svg width="120" height="120" viewBox="0 0 120 120">
                            <rect width="120" height="120" fill="#f5f5f5" stroke="#ddd"/>
                            <text x="60" y="65" text-anchor="middle" font-size="12" fill="#999">产品图片</text>
                        </svg>
                    </div>
                    <div class="product-info">
                        <h3 class="product-name">
                            <a href="product.jsp?id=<%= p.getId() %>"><%= p.getName() %></a>
                        </h3>
                        <div class="product-price">
                            <span class="current-price">¥<%= p.getPrice() %></span>
                        </div>
                        <button class="buy-btn" onclick="addToCart(<%= p.getId() %>)">立即购买</button>
                    </div>
                </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-products">
                <p>暂无商品</p>
            </div>
        <% } %>
    </section>
</main>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
