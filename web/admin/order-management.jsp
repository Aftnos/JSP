<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Order" %>
<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
List<Order> orders = ServiceLayer.getAllOrders();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<div class="main-content">
    <div class="content-container">
        <h1>订单管理</h1>
        <table class="admin-table">
            <thead>
            <tr><th>ID</th><th>用户ID</th><th>下单时间</th><th>状态</th><th>总额</th></tr>
            </thead>
            <tbody>
            <% for(Order o : orders){ %>
                <tr>
                    <td><%=o.id%></td>
                    <td><%=o.userId%></td>
                    <td><%=ServiceLayer.formatDateTime(o.orderDate)%></td>
                    <td><%=o.status%></td>
                    <td><%=ServiceLayer.formatPrice(o.total)%></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
