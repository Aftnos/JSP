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
    <link rel="stylesheet" href="css/main.css"/>
</head>
<body>
<header><div>小米商城</div></header>
<div class="container">
    <h2>用户登录</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <label>用户名:<input type="text" name="username" required/></label>
        <label>密码:<input type="password" name="password" required/></label>
        <button type="submit">登录</button>
    </form>
    <p>没有账号？<a href="register.jsp">立即注册</a></p>
</div>
</body>
</html>
