<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Product> list = ServiceLayer.getAllProducts();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav>
        <a href="dashboard.jsp">返回控制台</a>
        <a href="product_form.jsp">添加商品</a>
    </nav>
    <table>
        <tr><th>ID</th><th>名称</th><th>价格</th><th>库存</th><th>操作</th></tr>
        <% for (Product p : list) { %>
        <tr>
            <td><%= p.id %></td>
            <td><%= p.name %></td>
            <td><%= ServiceLayer.formatPrice(p.price) %></td>
            <td><%= p.stock %></td>
            <td>
                <a href="product_form.jsp?id=<%= p.id %>">编辑</a>
                <a href="delete_product.jsp?id=<%= p.id %>" onclick="return confirm('确定删除?');">删除</a>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
