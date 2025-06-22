<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if("POST".equalsIgnoreCase(request.getMethod())){
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User u = ServiceLayer.login(username,password);
        if(u!=null){
            session.setAttribute("user", u);
            response.sendRedirect("index.jsp");
            return;
        }else{
            message = "登录失败";
        }
    }
%>
<html>
<head>
    <title>登录</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/login.css"/>
</head>
<body>
<div class="auth-header">
    <button class="back-btn" onclick="history.back();">←</button>
    <div class="header-title">登录</div>
</div>
<div class="login-container">
    <h2 style="text-align:center;margin-bottom:16px;">用户登录</h2>
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
        <button type="submit" class="submit-btn">登录</button>
    </form>
    <p class="register-link">没有账号？<a href="register.jsp">立即注册</a></p>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
