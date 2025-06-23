<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String filterStatus = request.getParameter("status");

    java.util.List<Order> orders = ServiceLayer.getOrdersByUser(u.getId());
%>
<html>
<head>
    <title>我的订单</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/orders.css"/>
</head>
<body>
<!-- 顶部导航栏 -->
<header class="header">
    <div class="header-top">
        <div class="logo">
            <a href="index.jsp" style="color:#ff6700;text-decoration:none;font-weight:600;">小米商城</a>
        </div>
        <div class="page-title">我的订单</div>
        <div class="user-info">
            <% if(session.getAttribute("user")!=null){ %>
                <a href="logout.jsp" class="logout-btn">退出</a>
            <% }else{ %>
                <a href="login.jsp" class="login-btn">登录</a>
            <% } %>
        </div>
    </div>
</header>

<div class="container">
    <div class="order-filter">
        <a href="orders.jsp" class="filter-link <%= filterStatus==null || filterStatus.isEmpty() ? "active" : "" %>">全部</a>
        <a href="orders.jsp?status=unpaid" class="filter-link <%= "unpaid".equals(filterStatus) ? "active" : "" %>">待付款</a>
        <a href="orders.jsp?status=paid" class="filter-link <%= "paid".equals(filterStatus) ? "active" : "" %>">已支付</a>
        <a href="orders.jsp?status=cancelled" class="filter-link <%= "cancelled".equals(filterStatus) ? "active" : "" %>">已取消</a>
    </div>
    <!-- 订单列表 -->
    <div class="order-list">
        <h3 style="margin: 20px 16px 10px 16px; color: #333; font-size: 16px; font-weight: 600;">订单列表</h3>
        <% for(Order o:orders){
            boolean match = true;
            if("paid".equals(filterStatus)) match = o.isPaid();
            else if("unpaid".equals(filterStatus)) match = !o.isPaid() && !"CANCELLED".equalsIgnoreCase(o.getStatus());
            else if("cancelled".equals(filterStatus)) match = "CANCELLED".equalsIgnoreCase(o.getStatus());
            if(!match) continue;
            String statusText = o.isPaid() ? "已付款" : "待付款";
            String statusClass = o.isPaid() ? "paid" : "";
            if("CANCELLED".equalsIgnoreCase(o.getStatus())){ statusText = "已取消"; statusClass = "cancelled"; }
        %>
        <div class="order-card" style="margin: 5px 5px">
            <div class="order-card-header">
                <div class="order-id">订单号：<%= o.getId() %></div>
                <div class="order-status <%= statusClass %>"><%= statusText %></div>
            </div>
            <div class="order-total">¥<%= o.getTotal() %></div>
            <div style="font-size: 12px; color: #999; margin: 5px 0;">状态：<%= o.getStatus() %></div>
            <div class="order-actions">
                <a href="order-detail.jsp?id=<%= o.getId() %>" class="btn-detail">查看详情</a>
                <% if(!o.isPaid() && !"CANCELLED".equalsIgnoreCase(o.getStatus())){ %>
                <a href="payment.jsp?orderId=<%= o.getId() %>" class="btn-pay">立即支付</a>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</div>



<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
