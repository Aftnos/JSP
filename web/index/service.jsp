<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Binding" %>
<%
    Object obj=session.getAttribute("user");
    if(obj==null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u=(com.entity.User)obj;
    // 获取用户绑定的设备列表
    java.util.List<Binding> bindings = ServiceLayer.getBindingsByUser(u.getId());
%>
<html>
<head>
    <title>设备列表</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/service.css"/>
</head>
<body>
<header>
    <div class="logo"><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div class="user">
        <% if(session.getAttribute("user")!=null){ %>
        欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" style="color:#fff;">退出</a>
        <% }else{ %>
        <a href="login.jsp" style="color:#fff;">登录</a> | <a href="register.jsp" style="color:#fff;">注册</a>
        <% } %>
    </div>
</header>

<div class="device-header">
    <div class="device-title">设备列表</div>
    <a href="bindings.jsp" class="add-device-btn">+ 添加设备</a>
</div>

<div class="device-notice">
    🔔 仅支持添加申请管理商品，如需更换货请通过订单申请
</div>

<div class="device-section">
    <div class="section-title">本机设备</div>
    <div class="device-grid">
        <% if(bindings != null && !bindings.isEmpty()) { %>
            <% for(Binding binding : bindings) { %>
                <div class="device-card">
                    <div class="device-image">
                        📱
                    </div>
                    <div class="device-info">
                        <div class="device-name">小米设备</div>
                        <div class="device-model">已绑定设备</div>
                        <div class="device-sn">SN: <%= binding.getSnCode() %></div>
                    </div>
                    <div class="device-actions">
                        <a href="aftersales.jsp?sn=<%= binding.getSnCode() %>" class="action-btn">申请售后</a>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="empty-state">
                <div class="empty-icon">📱</div>
                <div>暂无绑定设备</div>
                <div style="margin-top: 8px; font-size: 14px;">请先绑定您的设备</div>
            </div>
        <% } %>
    </div>
</div>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
