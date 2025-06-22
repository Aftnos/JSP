<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%
    request.setCharacterEncoding("UTF-8");
    String q = request.getParameter("q");
    java.util.List<Product> list = ServiceLayer.listProducts();
    if(q!=null && q.trim().length()>0){
        java.util.List<Product> filtered = new java.util.ArrayList<>();
        for(Product p : list){
            if(p.getName().contains(q)) filtered.add(p);
        }
        list = filtered;
    }
    int unread = 0;
    if(session.getAttribute("user")!=null){
        com.entity.User u=(com.entity.User)session.getAttribute("user");
        java.util.List<com.entity.Notification> notes = ServiceLayer.getNotifications(u.getId());
        for(com.entity.Notification n:notes){ if(!n.isRead()) unread++; }
    }
%>
<html>
<head>
    <title>小米商城</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <script src="js/main.js"></script>
</head>
<body>
<header>
    <div class="top-row">
        <div class="logo"><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
        <div class="user">
            <% if(session.getAttribute("user")!=null){ %>
            欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" style="color:#fff;">退出</a>
            <% }else{ %>
            <a href="login.jsp" style="color:#fff;">登录</a> | <a href="register.jsp" style="color:#fff;">注册</a>
            <% } %>
        </div>
    </div>
    <div class="search-row">
        <form action="index.jsp" method="get" class="search-form">
            <input type="text" name="q" placeholder="搜索产品" value="<%= q==null?"":q %>"/>
        </form>
        <a href="notifications.jsp" class="notify-link">通知<% if(unread>0){ %><span class="badge"><%= unread %></span><% } %></a>
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
<div class="bottom-nav">
    <a href="index.jsp">首页</a>
    <a href="categories.jsp">分类</a>
    <a href="service.jsp">服务</a>
    <a href="cart.jsp">购物车</a>
    <a href="my.jsp">我的</a>
</div>
</body>
</html>
