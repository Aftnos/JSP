<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Binding" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if("bind".equals(request.getParameter("action"))){
        String code = request.getParameter("code");
        if(ServiceLayer.bindSN(u.getId(), code)) message="绑定成功"; else message="绑定失败";
    }
    java.util.List<Binding> list = ServiceLayer.getBindingsByUser(u.getId());
%>
<html>
<head>
    <title>SN绑定</title>
    <link rel="stylesheet" href="../css/main.css"/>
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
    <h2>SN绑定</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <input type="hidden" name="action" value="bind"/>
        <label>SN Code:<input type="text" name="code" required></label>
        <button type="submit">绑定</button>
    </form>
    <table class="cart-table">
        <tr><th>ID</th><th>SN码</th><th>绑定时间</th></tr>
        <% for(Binding b : list){ %>
        <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getSnCode() %></td>
            <td><%= b.getBindTime() %></td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
