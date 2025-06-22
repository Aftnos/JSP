<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Notification" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    String action = request.getParameter("action");
    if("read".equals(action)){
        int id = Integer.parseInt(request.getParameter("id"));
        if(ServiceLayer.markNotificationRead(id)) message="已标记已读"; else message="操作失败";
    }else if("delete".equals(action)){
        int id = Integer.parseInt(request.getParameter("id"));
        if(ServiceLayer.deleteNotification(id)) message="已删除"; else message="删除失败";
    }
    java.util.List<Notification> list = ServiceLayer.getNotifications(u.getId());
%>
<html>
<head>
    <title>通知</title>
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
        | <a href="notifications.jsp">通知</a>
        | <a href="service.jsp">服务</a>
        | <a href="logout.jsp">退出</a>
    </div>
</header>
<div class="container">
    <h2>通知</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <table class="cart-table">
        <tr><th>ID</th><th>内容</th><th>时间</th><th>已读</th><th>操作</th></tr>
        <% for(Notification n : list){ %>
        <tr>
            <td><%= n.getId() %></td>
            <td><%= n.getContent() %></td>
            <td><%= n.getCreatedAt() %></td>
            <td><%= n.isRead()?"是":"否" %></td>
            <td>
                <% if(!n.isRead()){ %>
                <form method="post" style="display:inline">
                    <input type="hidden" name="action" value="read"/>
                    <input type="hidden" name="id" value="<%= n.getId() %>"/>
                    <button type="submit">标记已读</button>
                </form>
                <% } %>
                <form method="post" style="display:inline" onsubmit="return confirm('确定删除?');">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%= n.getId() %>"/>
                    <button type="submit">删除</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
