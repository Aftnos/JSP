<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Category" %>
<%@ page import="com.entity.Product" %>
<%
    request.setCharacterEncoding("UTF-8");
    String selectedCategory = request.getParameter("category");
    
    java.util.List<Category> categories = ServiceLayer.listCategories();
    java.util.List<Product> products;
    if(selectedCategory!=null){
        products = ServiceLayer.listProductsByCategory(Integer.parseInt(selectedCategory));
    } else {
        products = ServiceLayer.listProducts();
    }
    
    // 获取通知数量
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
    <title>分类 - 小米商城</title>
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
                <input type="text" name="q" placeholder="搜索商品名称" class="search-input"/>
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

<!-- 分类页面主体 -->
<div class="category-container">
    <!-- 左侧分类导航 -->
    <aside class="category-sidebar">
        <div class="category-nav">
            <% for(Category category : categories) { %>
            <a href="categories.jsp?category=<%= category.getId() %>" 
               class="category-item <%= String.valueOf(category.getId()).equals(selectedCategory) ? "active" : "" %>">
                <span class="category-name"><%= category.getName() %></span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="#ccc">
                    <path d="M8.59 16.59L13.17 12 8.59 7.41 10 6l6 6-6 6-1.41-1.41z"/>
                </svg>
            </a>
            <% } %>
        </div>
    </aside>
    
    <!-- 右侧产品展示区域 -->
    <main class="category-content">
        <div class="category-header">
            <h1>Xiaomi 数字旗舰</h1>
        </div>
        
        <!-- 产品列表 -->
        <div class="product-grid">
            <% for(Product product : products) { %>
            <div class="product-card">
                <div class="product-image">
                    <img src="static/image/product-placeholder.jpg" alt="<%= product.getName() %>" 
                         onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDIwMCAyMDAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik0xMDAgNzBDOTQuNDc3MiA3MCA5MCA3NC40NzcyIDkwIDgwVjEyMEM5MCA5NC40NzcyIDk0LjQ3NzIgOTAgMTAwIDkwSDEwMEMxMDUuNTIzIDkwIDExMCA5NC40NzcyIDExMCAxMDBWMTIwQzExMCAxMjUuNTIzIDEwNS41MjMgMTMwIDEwMCAxMzBIOTBWMTQwSDExMEMxMTYuNjI3IDE0MCAxMjIgMTM0LjYyNyAxMjIgMTI4VjkyQzEyMiA4NS4zNzI2IDExNi42MjcgODAgMTEwIDgwSDEwMFoiIGZpbGw9IiNDQ0MiLz4KPC9zdmc+'"/>
                </div>
                <div class="product-info">
                    <h3 class="product-title"><%= product.getName() %></h3>
                    <p class="product-price">¥<%= product.getPrice() %>起</p>
                    <% if(product.getStock() <= 5) { %>
                        <span class="stock-badge">现货</span>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>
    </main>
</div>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
