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
    <link rel="stylesheet" href="css/bindings.css"/>
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
