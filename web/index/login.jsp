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
<div class="login-container">
    <div class="login-image"></div>
    <div class="login-form-section">
        <div class="login-form-container">
            <h2 class="login-title">用户登录</h2>
            <% if(message!=null){ %>
            <div id="errorMessage" class="error-message show"><%= message %></div>
            <% } else { %>
            <div id="errorMessage" class="error-message"></div>
            <% } %>
            <form id="loginForm" method="post">
                <div class="form-group">
                    <label for="username" class="form-label">用户名</label>
                    <div class="input-container">
                        <input type="text" id="username" name="username" class="form-input" required/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="password" class="form-label">密码</label>
                    <div class="input-container">
                        <input type="password" id="password" name="password" class="form-input has-toggle" required/>
                    </div>
                </div>
                <button type="submit" id="loginBtn" class="login-btn">登录</button>
            </form>
            <div class="register-link">没有账号？<a href="register.jsp" id="registerLink">立即注册</a></div>
        </div>
    </div>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
<script src="js/login.js"></script>
</body>
</html>
