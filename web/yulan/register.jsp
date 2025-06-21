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
    <link rel="stylesheet" href="../css/main.css"/>
</head>
<body>
<header><div>小米商城</div></header>
<div class="container">
    <h2>用户注册</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <label>用户名:<input type="text" name="username" required/></label>
        <label>密码:<input type="password" name="password" required/></label>
        <label>邮箱:<input type="email" name="email" required/></label>
        <button type="submit">注册</button>
    </form>
</div>
</body>
</html>
