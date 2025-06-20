<%@ include file="check_admin.jspf" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="java.math.BigDecimal" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("add".equals(action)) {
            Product p = new Product();
            p.setName(request.getParameter("name"));
            p.setPrice(new BigDecimal(request.getParameter("price")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setDescription(request.getParameter("description"));
            if (ServiceLayer.addProduct(p)) message = "添加成功"; else message = "添加失败";
        } else if ("update".equals(action)) {
            Product p = new Product();
            p.setId(Integer.parseInt(request.getParameter("id")));
            p.setName(request.getParameter("name"));
            p.setPrice(new BigDecimal(request.getParameter("price")));
            p.setStock(Integer.parseInt(request.getParameter("stock")));
            p.setDescription(request.getParameter("description"));
            if (ServiceLayer.updateProduct(p)) message = "更新成功"; else message = "更新失败";
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (ServiceLayer.deleteProduct(id)) message = "删除成功"; else message = "删除失败";
        }
    }
    java.util.List<Product> list = ServiceLayer.listProducts();
    Product edit = null;
    String editIdStr = request.getParameter("editId");
    if (editIdStr != null) {
        edit = ServiceLayer.getProductById(Integer.parseInt(editIdStr));
    }
%>
<html>
<head>
    <title>商品管理</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <%@ include file="sidebar.jsp" %>
    <h2>商品管理</h2>
    <% if (message != null) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <form method="post">
        <input type="hidden" name="action" value="<%= (edit != null) ? "update" : "add" %>"/>
        <% if (edit != null) { %>
            <input type="hidden" name="id" value="<%= edit.getId() %>"/>
        <% } %>
        <label>名称:<input type="text" name="name" value="<%= edit!=null?edit.getName():"" %>" required/></label>
        <label>价格:<input type="text" name="price" value="<%= edit!=null?edit.getPrice():"" %>" required/></label>
        <label>库存:<input type="number" name="stock" value="<%= edit!=null?edit.getStock():0 %>" required/></label>
        <label>描述:<input type="text" name="description" value="<%= edit!=null?edit.getDescription():"" %>"/></label>
        <button type="submit"><%= (edit!=null)?"更新":"添加" %></button>
        <% if (edit != null) { %><a href="products.jsp">取消编辑</a><% } %>
    </form>
    <table>
        <tr><th>ID</th><th>名称</th><th>价格</th><th>库存</th><th>描述</th><th>操作</th></tr>
        <% for (Product p : list) { %>
        <tr>
            <td><%= p.getId() %></td>
            <td><%= p.getName() %></td>
            <td><%= p.getPrice() %></td>
            <td><%= p.getStock() %></td>
            <td><%= p.getDescription() %></td>
            <td>
                <a href="products.jsp?editId=<%= p.getId() %>">编辑</a>
                <form method="post" style="display:inline" onsubmit="return confirm('确定删除?');">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%= p.getId() %>"/>
                    <button type="submit">删除</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
