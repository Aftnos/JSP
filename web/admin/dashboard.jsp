<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>后台管理</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <h2>欢迎，<%= admin %></h2>
    <nav>
        <a href="products.jsp">商品管理</a>
        <a href="users.jsp">用户管理</a>
        <a href="orders.jsp">订单管理</a>
        <a href="after_sale.jsp">售后管理</a>
        <a href="ads.jsp">广告管理</a>
        <a href="logout.jsp">退出</a>
    </nav>
</div>
</body>
</html>
