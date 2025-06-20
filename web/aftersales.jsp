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
        | <a href="addresses.jsp">地址</a>
        | <a href="notifications.jsp">通知</a>
        | <a href="bindings.jsp">绑定</a>
        | <a href="aftersales.jsp">售后</a>
        | <a href="logout.jsp">退出</a>
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
</body>
</html>
