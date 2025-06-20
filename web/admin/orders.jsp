<%@ include file="check_admin.jspf" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Order" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        if (ServiceLayer.updateOrderStatus(id, status)) message = "更新成功"; else message = "更新失败";
    }
    java.util.List<Order> list = ServiceLayer.listAllOrders();
%>
<html>
<head>
    <title>订单管理</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <div class="admin-wrapper">
        <%@ include file="sidebar.jsp" %>
        <div class="content">
            <h2>订单管理</h2>
            <% if (message != null) { %><div class="message"><%= message %></div><% } %>
            <table>
                <tr><th>ID</th><th>用户ID</th><th>地址ID</th><th>状态</th><th>总额</th><th>已付款</th><th>操作</th></tr>
                <% for (Order o : list) { %>
                <tr>
                    <td><%= o.getId() %></td>
                    <td><%= o.getUserId() %></td>
                    <td><%= o.getAddressId() %></td>
                    <td><%= o.getStatus() %></td>
                    <td><%= o.getTotal() %></td>
                    <td><%= o.isPaid() %></td>
                    <td>
                        <form method="post" style="display:inline">
                            <input type="hidden" name="id" value="<%= o.getId() %>"/>
                            <input type="text" name="status" value="<%= o.getStatus() %>"/>
                            <button type="submit">修改状态</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</div>
</body>
</html>
