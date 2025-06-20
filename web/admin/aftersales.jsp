<%@ include file="check_admin.jspf" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.AfterSale" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String remark = request.getParameter("remark");
        if (ServiceLayer.updateAfterSaleStatus(id, status, remark)) message = "更新成功"; else message="更新失败";
    }
    java.util.List<AfterSale> list = ServiceLayer.listAllAfterSales();
%>
<html>
<head>
    <title>售后管理</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <%@ include file="sidebar.jsp" %>
    <h2>售后管理</h2>
    <% if (message != null) { %><div class="message"><%= message %></div><% } %>
    <table>
        <tr><th>ID</th><th>用户ID</th><th>SN</th><th>类型</th><th>原因</th><th>状态</th><th>备注</th><th>操作</th></tr>
        <% for (AfterSale a : list) { %>
        <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getUserId() %></td>
            <td><%= a.getSnCode() %></td>
            <td><%= a.getType() %></td>
            <td><%= a.getReason() %></td>
            <td><%= a.getStatus() %></td>
            <td><%= a.getRemark() %></td>
            <td>
                <form method="post" style="display:inline">
                    <input type="hidden" name="id" value="<%= a.getId() %>"/>
                    <input type="text" name="status" value="<%= a.getStatus() %>"/>
                    <input type="text" name="remark" value="<%= a.getRemark() %>"/>
                    <button type="submit">更新</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
