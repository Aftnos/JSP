<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Order" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Order> list = ServiceLayer.getAllOrders();
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int oid = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
        String status = request.getParameter("status");
        msg = ServiceLayer.updateOrderStatus(oid, status);
        if ("success".equals(msg)) {
            response.sendRedirect("orders.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav><a href="dashboard.jsp">返回控制台</a></nav>
    <h2>订单管理</h2>
    <% if (msg != null && !"success".equals(msg)) { %>
    <p class="message"><%= msg %></p>
    <% } %>
    <table>
        <tr><th>ID</th><th>用户ID</th><th>时间</th><th>状态</th><th>金额</th><th>修改状态</th></tr>
        <% for (Order o : list) { %>
        <tr>
            <td><%= o.id %></td>
            <td><%= o.userId %></td>
            <td><%= ServiceLayer.formatDateTime(o.orderDate) %></td>
            <td><%= o.status %></td>
            <td><%= ServiceLayer.formatPrice(o.total) %></td>
            <td>
                <form method="post" style="display:inline-block;">
                    <input type="hidden" name="id" value="<%= o.id %>">
                    <input type="text" name="status" value="<%= o.status %>" size="8">
                    <button type="submit">更新</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
