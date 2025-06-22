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
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .profile-header {
            background: linear-gradient(135deg, #ff6700 0%, #ff8533 100%);
            border-radius: 12px;
            padding: 30px 20px;
            color: white;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }
        .profile-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        .profile-info {
            display: flex;
            align-items: center;
            gap: 20px;
            position: relative;
            z-index: 1;
        }
        .avatar {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            border: 3px solid rgba(255,255,255,0.3);
        }
        .user-details h2 {
            margin: 0 0 8px 0;
            font-size: 24px;
            font-weight: 600;
        }
        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
            font-size: 14px;
            opacity: 0.9;
        }
        .contact-row {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .orders-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        .view-all {
            color: #ff6700;
            text-decoration: none;
            font-size: 14px;
        }
        .order-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .order-stat {
            text-align: center;
            padding: 20px;
            border-radius: 8px;
            background: #f8f8f8;
            transition: background 0.2s;
        }
        .order-stat:hover {
            background: #f0f0f0;
        }
        .stat-icon {
            font-size: 32px;
            margin-bottom: 10px;
            color: #666;
        }
        .stat-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .stat-count {
            font-size: 20px;
            font-weight: 600;
            color: #333;
        }
        .menu-section {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .menu-item {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            text-decoration: none;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.2s;
        }
        .menu-item:last-child {
            border-bottom: none;
        }
        .menu-item:hover {
            background: #f8f8f8;
        }
        .menu-icon {
            width: 40px;
            height: 40px;
            background: #ff6700;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 18px;
            color: white;
        }
        .menu-content {
            flex: 1;
        }
        .menu-title {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 2px;
        }
        .menu-subtitle {
            font-size: 12px;
            color: #999;
        }
        .menu-arrow {
            color: #ccc;
            font-size: 16px;
        }
        .address-preview {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .address-item {
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            color: #666;
        }
        .address-item:last-child {
            border-bottom: none;
        }
        .default-badge {
            background: #ff6700;
            color: white;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 12px;
            margin-left: 8px;
        }
        @media (max-width: 768px) {
            .profile-container {
                padding: 10px;
            }
            .profile-info {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            .order-stats {
                grid-template-columns: 1fr;
                gap: 10px;
            }
            .contact-info {
                align-items: center;
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
