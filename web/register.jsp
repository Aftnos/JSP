<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if("POST".equalsIgnoreCase(request.getMethod())){
        User u = new User();
        u.setUsername(request.getParameter("username"));
        u.setPassword(request.getParameter("password"));
        u.setEmail(request.getParameter("email"));
        if(ServiceLayer.register(u)){
            session.setAttribute("user", u);
            response.sendRedirect("index.jsp");
            return;
        }else{
            message = "注册失败";
        }
    }
%>
<html>
<head>
    <title>注册</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/register.css"/>
</head>
<body>
<div class="auth-header">
    <button class="back-btn" onclick="history.back();">←</button>
    <div class="header-title">注册</div>
</div>
<div class="register-container">
    <h2 style="text-align:center;margin-bottom:16px;">用户注册</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post" class="auth-form">
        <div class="form-group">
            <label class="form-label">用户名</label>
            <input type="text" name="username" class="form-input" required/>
        </div>
        <div class="form-group">
            <label class="form-label">密码</label>
            <input type="password" name="password" class="form-input" required/>
        </div>
        <div class="form-group">
            <label class="form-label">邮箱</label>
            <input type="email" name="email" class="form-input" required/>
        </div>
        <button type="submit" class="submit-btn">注册</button>
    </form>
    <p class="register-link">已有账号？<a href="login.jsp">立即登录</a></p>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
