<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Binding" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if("bind".equals(request.getParameter("action"))){
        String code = request.getParameter("code");
        if(ServiceLayer.bindSN(u.getId(), code)) message="绑定成功"; else message="绑定失败";
    }
    java.util.List<Binding> list = ServiceLayer.getBindingsByUser(u.getId());
%>
<html>
<head>
    <title>SN绑定</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
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
<style>
    .bind-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px;
        background: #fff;
        border-bottom: 1px solid #e0e0e0;
    }
    .bind-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
    }
    .back-btn {
        background: #f5f5f5;
        color: #666;
        border: none;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        cursor: pointer;
        text-decoration: none;
    }
    .bind-form {
        background: white;
        margin: 16px;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
    }
    .form-input {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        font-size: 16px;
        background: #f9f9f9;
    }
    .form-input:focus {
        outline: none;
        border-color: #ff6700;
        background: white;
    }
    .submit-btn {
        width: 100%;
        background: #ff6700;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
    }
    .submit-btn:hover {
        background: #e55a00;
    }
    .message {
        background: #e8f5e8;
        color: #2d7d2d;
        padding: 12px 16px;
        margin: 16px;
        border-radius: 8px;
        border-left: 4px solid #4caf50;
    }
    .message.error {
        background: #ffeaea;
        color: #d32f2f;
        border-left-color: #f44336;
    }
    .device-list {
        margin: 16px;
    }
    .list-title {
        font-size: 16px;
        font-weight: 600;
        color: #333;
        margin-bottom: 12px;
    }
    .device-item {
        background: white;
        border-radius: 12px;
        padding: 16px;
        margin-bottom: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        display: flex;
        align-items: center;
        gap: 16px;
    }
    .device-icon {
        width: 48px;
        height: 48px;
        background: #f5f5f5;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
    }
    .device-details {
        flex: 1;
    }
    .device-sn {
        font-size: 16px;
        font-weight: 600;
        color: #333;
        margin-bottom: 4px;
    }
    .bind-time {
        font-size: 14px;
        color: #666;
    }
    .device-status {
        background: #e8f5e8;
        color: #2d7d2d;
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 500;
    }
</style>

<div class="bind-header">
    <div class="bind-title">SN绑定</div>
    <a href="service.jsp" class="back-btn">返回</a>
</div>

<% if(message!=null){ %>
    <div class="message <%= message.contains("失败") ? "error" : "" %>"><%= message %></div>
<% } %>

<div class="bind-form">
    <form method="post">
        <input type="hidden" name="action" value="bind"/>
        <div class="form-group">
            <label class="form-label">设备SN码</label>
            <input type="text" name="code" class="form-input" placeholder="请输入设备SN码" required>
        </div>
        <button type="submit" class="submit-btn">绑定设备</button>
    </form>
</div>

<div class="device-list">
    <div class="list-title">已绑定设备</div>
    <% if(list != null && !list.isEmpty()) { %>
        <% for(Binding b : list){ %>
            <div class="device-item">
                <div class="device-icon">📱</div>
                <div class="device-details">
                    <div class="device-sn">SN: <%= b.getSnCode() %></div>
                    <div class="bind-time">绑定时间: <%= b.getBindTime() %></div>
                </div>
                <div class="device-status">已绑定</div>
            </div>
        <% } %>
    <% } else { %>
        <div style="text-align: center; padding: 40px; color: #999;">
            <div style="font-size: 48px; margin-bottom: 16px;">📱</div>
            <div>暂无绑定设备</div>
        </div>
    <% } %>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
