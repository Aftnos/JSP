<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.AfterSale" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if("apply".equals(request.getParameter("action"))){
        AfterSale a = new AfterSale();
        a.setUserId(u.getId());
        a.setSnCode(request.getParameter("sn"));
        a.setType(request.getParameter("type"));
        a.setReason(request.getParameter("reason"));
        if(ServiceLayer.applyAfterSale(a)) message="已提交"; else message="提交失败";
    }
    java.util.List<AfterSale> list = ServiceLayer.getAfterSalesByUser(u.getId());
%>
<html>
<head>
    <title>售后服务</title>
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
    <h2>售后服务</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <input type="hidden" name="action" value="apply"/>
        <label>SN码:<input type="text" name="sn" required></label>
        <label>类型:<input type="text" name="type" required></label>
        <label>原因:<input type="text" name="reason" required></label>
        <button type="submit">提交申请</button>
    </form>
    <table class="cart-table">
        <tr><th>ID</th><th>SN码</th><th>类型</th><th>原因</th><th>状态</th><th>备注</th></tr>
        <% for(AfterSale a : list){ %>
        <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getSnCode() %></td>
            <td><%= a.getType() %></td>
            <td><%= a.getReason() %></td>
            <td><%= a.getStatus() %></td>
            <td><%= a.getRemark() %></td>
        </tr>
        <% } %>
    </table>
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
