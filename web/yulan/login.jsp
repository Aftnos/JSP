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
<div class="bottom-nav">
    <a href="index.jsp">首页</a>
    <a href="categories.jsp">分类</a>
    <a href="service.jsp">服务</a>
    <a href="cart.jsp">购物车</a>
    <a href="my.jsp">我的</a>
</div>
</body>
</html>
