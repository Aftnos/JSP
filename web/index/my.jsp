<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    java.util.List<Address> addresses = ServiceLayer.getAddresses(u.getId());
    java.util.List<Order> orders = ServiceLayer.getOrdersByUser(u.getId());
    java.util.List<Notification> notifications = ServiceLayer.getNotifications(u.getId());
    
    // 统计订单状态
    int pendingCount = 0, shippedCount = 0, returnCount = 0;
    for(Order order : orders) {
        if("NEW".equals(order.getStatus()) || "PENDING".equals(order.getStatus())) {
            pendingCount++;
        } else if("SHIPPED".equals(order.getStatus()) || "DELIVERING".equals(order.getStatus())) {
            shippedCount++;
        } else if("RETURN".equals(order.getStatus()) || "REFUND".equals(order.getStatus())) {
            returnCount++;
        }
    }
%>
<html>
<head>
    <title>我的</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/my.css"/>
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

<div class="profile-container">
    <!-- 用户信息头部 -->
    <div class="profile-header">
        <div class="profile-info">
            <div class="avatar">
                <%= u.getUsername().substring(0,1).toUpperCase() %>
            </div>
            <div class="user-details">
                <h2>支付与方式</h2>
                <div class="contact-info">
                    <div class="contact-row">
                        <span>邮箱：</span>
                        <span><%= u.getEmail() == null ? "admin@xiaomi.com" : u.getEmail() %></span>
                    </div>
                    <div class="contact-row">
                        <span>电话：</span>
                        <span><%= u.getPhone() == null ? "13800138000" : u.getPhone() %></span>
                    </div>
                    <div class="contact-row">
                        <span>2282141538</span>
                    </div>
                    <div class="contact-row">
                        <span>2282141538</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 我的订单 -->
    <div class="orders-section">
        <div class="section-header">
            <div class="section-title">我的订单</div>
            <a href="orders.jsp" class="view-all">全部订单 ></a>
        </div>
        <div class="order-stats">
            <a href="orders.jsp?status=pending" class="order-stat">
                <div class="stat-icon">📦</div>
                <div class="stat-label">待付款</div>
                <div class="stat-count"><%= pendingCount %></div>
            </a>
            <a href="orders.jsp?status=shipped" class="order-stat">
                <div class="stat-icon">🚚</div>
                <div class="stat-label">待收货</div>
                <div class="stat-count"><%= shippedCount %></div>
            </a>
            <a href="aftersales.jsp" class="order-stat">
                <div class="stat-icon">🔧</div>
                <div class="stat-label">退换修</div>
                <div class="stat-count"><%= returnCount %></div>
            </a>
        </div>
    </div>
    
    <!-- 功能菜单 -->
    <div class="menu-section">
        <a href="addresses.jsp" class="menu-item">
            <div class="menu-icon">📍</div>
            <div class="menu-content">
                <div class="menu-title">收货地址</div>
            </div>
            <div class="menu-arrow">></div>
        </a>
        <a href="service.jsp" class="menu-item">
            <div class="menu-icon">😊</div>
            <div class="menu-content">
                <div class="menu-title">开发预留功能</div>
            </div>
            <div class="menu-arrow">></div>
        </a>
        <a href="#" class="menu-item">
            <div class="menu-icon">⚙️</div>
            <div class="menu-content">
                <div class="menu-title">设置</div>
            </div>
            <div class="menu-arrow">></div>
        </a>
    </div>
    
    <!-- 收货地址预览 -->
    <% if(!addresses.isEmpty()){ %>
    <div class="address-preview">
        <div class="section-header">
            <div class="section-title">收货地址</div>
            <a href="addresses.jsp" class="view-all">管理 ></a>
        </div>
        <% 
        int addressCount = 0;
        for(Address a : addresses){ 
            if(addressCount >= 3) break;
            addressCount++;
        %>
        <div class="address-item">
            <%= a.getDetail() %> (<%= a.getReceiver() %> <%= a.getPhone() %>)
            <% if(a.isDefault()){ %><span class="default-badge">默认</span><% } %>
        </div>
        <% } %>
    </div>
    <% } %>
</div>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
