<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Category" %>
<%
    java.util.List<Category> list = ServiceLayer.listCategories();
%>
<html>
<head>
    <title>分类列表</title>
    <link rel="stylesheet" href="../css/main.css"/>
</head>
<body>
<header>
    <div><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div>
        <% if(session.getAttribute("user")!=null){ %>
        欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %>
        | <a href="cart.jsp">购物车</a>
        | <a href="orders.jsp">订单</a>
        | <a href="categories.jsp">分类</a>
        | <a href="addresses.jsp">地址</a>
        | <a href="notifications.jsp">通知</a>
        | <a href="bindings.jsp">绑定</a>
        | <a href="aftersales.jsp">售后</a>
        | <a href="logout.jsp">退出</a>
        <% }else{ %>
        <a href="login.jsp">登录</a> | <a href="register.jsp">注册</a>
        <% } %>
    </div>
</header>
<div class="container">
    <h2>分类列表</h2>
    <ul>
        <% for(Category c : list){ %>
        <li><%= c.getName() %> (ID:<%= c.getId() %>)</li>
        <% } %>
    </ul>
</div>
</body>
</html>
