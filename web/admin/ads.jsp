<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Advertisement" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Advertisement> list = ServiceLayer.getAllAdvertisements();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>广告管理</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav>
        <a href="dashboard.jsp">返回控制台</a>
        <a href="ad_form.jsp">添加广告</a>
    </nav>
    <table>
        <tr><th>ID</th><th>标题</th><th>链接</th><th>状态</th><th>操作</th></tr>
        <% for (Advertisement ad : list) { %>
        <tr>
            <td><%= ad.id %></td>
            <td><%= ad.title %></td>
            <td><a href="<%= ad.targetUrl %>" target="_blank"><%= ad.targetUrl %></a></td>
            <td><%= ad.enabled ? "启用" : "停用" %></td>
            <td>
                <a href="ad_form.jsp?id=<%= ad.id %>">编辑</a>
                <a href="delete_ad.jsp?id=<%= ad.id %>" onclick="return confirm('确定删除?');">删除</a>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
