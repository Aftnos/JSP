<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object obj=session.getAttribute("user");
    if(obj==null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u=(com.entity.User)obj;
%>
<html>
<head>
    <title>服务中心</title>
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
    <h2>服务中心</h2>
    <p><a href="bindings.jsp">SN绑定</a></p>
    <p><a href="aftersales.jsp">售后申请</a></p>
</div>
</body>
</html>
