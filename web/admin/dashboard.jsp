<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
List<Product> products = ServiceLayer.getAllProducts();
List<Order> orders = ServiceLayer.getAllOrders();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>后台首页</title>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<div class="main-content">
    <div class="content-container">
        <h1 class="mb-16">后台首页</h1>
        <p>商品数量：<%= products.size() %></p>
        <p>订单数量：<%= orders.size() %></p>
    </div>
</div>
</body>
</html>
