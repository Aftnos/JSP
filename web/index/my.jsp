<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    u = ServiceLayer.getUserById(u.getId());
    if(u!=null) session.setAttribute("user", u);
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
<div class="profile-container">
    <!-- 用户信息头部 -->
    <div class="profile-header">
        <div class="profile-info">
            <div class="avatar">
                <%= u.getUsername().substring(0,1).toUpperCase() %>
            </div>
            <div class="user-details">
                <h2><%= u.getUsername() %></h2>
                <div class="contact-info">
                    <div class="contact-row">
                        <span>邮箱：</span>
                        <span><%= u.getEmail() == null ? "未绑定" : u.getEmail() %></span>
                    </div>
                    <div class="contact-row">
                        <span>电话：</span>
                        <span><%= u.getPhone() == null ? "未绑定" : u.getPhone() %></span>
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
            <a href="orders.jsp" class="order-stat">
                <div class="stat-icon">📦</div>
                <div class="stat-label">全部订单</div>
                <div class="stat-count"><%= orders.size() %></div>
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
        <a href="aftersales.jsp" class="menu-item">
            <div class="menu-icon">🛠️</div>
            <div class="menu-content">
                <div class="menu-title">售后申请</div>
            </div>
            <div class="menu-arrow">></div>
        </a>
        <a href="settings.jsp" class="menu-item">
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
