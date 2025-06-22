<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Address" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    java.util.List<Address> list = ServiceLayer.getAddresses(u.getId());
%>
<html>
<head>
    <title>我的</title>
    <link rel="stylesheet" href="css/main.css"/>
</head>
<body>
<header>
    <div><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div>
        欢迎，<%= u.getUsername() %>
        | <a href="cart.jsp">购物车</a>
        | <a href="orders.jsp">订单</a>
        | <a href="categories.jsp">分类</a>
        | <a href="my.jsp">我的</a>
        | <a href="logout.jsp">退出</a>
    </div>
</header>
<div class="container">
    <h2>个人信息</h2>
    <p>用户名：<%= u.getUsername() %></p>
    <p>邮箱：<%= u.getEmail() == null ? "" : u.getEmail() %></p>
    <p>电话：<%= u.getPhone() == null ? "" : u.getPhone() %></p>
    <h3>收货地址</h3>
    <ul>
        <% for(Address a : list){ %>
        <li><%= a.getDetail() %> (<%= a.getReceiver() %> <%= a.getPhone() %>)<% if(a.isDefault()){ %> [默认]<% } %></li>
        <% } %>
    </ul>
    <p><a href="addresses.jsp">管理地址</a></p>
</div>
</body>
</html>
