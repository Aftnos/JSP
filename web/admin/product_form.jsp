<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
    Product product = null;
    if (id > 0) product = ServiceLayer.getProductById(id);
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        double price = ServiceLayer.safeParseDouble(request.getParameter("price"), 0);
        int stock = ServiceLayer.safeParseInt(request.getParameter("stock"), 0);
        String desc = request.getParameter("description");
        if (id > 0) {
            message = ServiceLayer.updateProduct(id, name, price, stock, desc);
        } else {
            message = ServiceLayer.addProduct(name, price, stock, desc);
        }
        if ("success".equals(message)) {
            response.sendRedirect("products.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= (id>0?"编辑":"添加") %>商品</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav><a href="products.jsp">返回列表</a></nav>
    <h2><%= (id>0?"编辑":"添加") %>商品</h2>
    <% if (message != null && !"success".equals(message)) { %>
    <p class="message"><%= message %></p>
    <% } %>
    <form method="post">
        <label>名称:<input type="text" name="name" value="<%= product!=null?product.name:"" %>"></label><br>
        <label>价格:<input type="text" name="price" value="<%= product!=null?product.price:"" %>"></label><br>
        <label>库存:<input type="number" name="stock" value="<%= product!=null?product.stock:"0" %>"></label><br>
        <label>描述:<br><textarea name="description" rows="4" cols="50"><%= product!=null?product.description:"" %></textarea></label><br>
        <button type="submit">提交</button>
    </form>
</div>
</body>
</html>
