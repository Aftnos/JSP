<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%
    java.util.List<Product> list = ServiceLayer.listProducts();
%>
<html>
<head>
    <title>小米商城</title>
    <link rel="stylesheet" href="css/main.css"/>
    <script src="js/main.js"></script>
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
        | <a href="my.jsp">我的</a>
        | <a href="notifications.jsp">通知</a>
        | <a href="service.jsp">服务</a>
        | <a href="logout.jsp">退出</a>
        <% }else{ %>
        <a href="login.jsp">登录</a> | <a href="register.jsp">注册</a>
        <% } %>
    </div>
</header>
<div class="container">
    <div class="products">
        <% for(Product p : list){ %>
        <div class="product-card">
            <h3><a href="product.jsp?id=<%= p.getId() %>"><%= p.getName() %></a></h3>
            <p>￥<%= p.getPrice() %></p>
            <button onclick="addToCart(<%= p.getId() %>)">加入购物车</button>
        </div>
        <% } %>
    </div>
</div>
<footer>Powered by JSP Demo</footer>
</body>
</html>
