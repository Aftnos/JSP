<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object obj=session.getAttribute("user");
    if(obj==null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u=(com.entity.User)obj;
%>
<html>
<head>
    <title>服务中心</title>
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
    <h2>服务中心</h2>
    <p><a href="bindings.jsp">SN绑定</a></p>
    <p><a href="aftersales.jsp">售后申请</a></p>
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
