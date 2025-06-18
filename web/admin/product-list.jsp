<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%
if(session.getAttribute("admin") == null){
    response.sendRedirect("login.jsp");
    return;
}
request.setCharacterEncoding("UTF-8");
String action = request.getParameter("action");
String msg = null;
if("add".equals(action)){
    String name = request.getParameter("name");
    double price = ServiceLayer.safeParseDouble(request.getParameter("price"),0);
    int stock = ServiceLayer.safeParseInt(request.getParameter("stock"),0);
    String desc = request.getParameter("description");
    msg = ServiceLayer.addProduct(name, price, stock, desc);
} else if("delete".equals(action)){
    int id = ServiceLayer.safeParseInt(request.getParameter("id"),0);
    msg = ServiceLayer.deleteProduct(id);
} else if("update".equals(action)){
    int id = ServiceLayer.safeParseInt(request.getParameter("id"),0);
    String name = request.getParameter("name");
    double price = ServiceLayer.safeParseDouble(request.getParameter("price"),0);
    int stock = ServiceLayer.safeParseInt(request.getParameter("stock"),0);
    String desc = request.getParameter("description");
    msg = ServiceLayer.updateProduct(id, name, price, stock, desc);
}
List<Product> products = ServiceLayer.getAllProducts();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理</title>
</head>
<body>
<%@ include file="sidebar.jsp" %>
<div class="main-content">
    <div class="content-container">
        <h1>商品管理</h1>
        <% if(msg != null){ %>
        <p class="mb-16 <%= "success".equals(msg)?"text-success":"text-danger" %>"><%=msg%></p>
        <% } %>
        <table class="admin-table">
            <thead>
            <tr><th>ID</th><th>名称</th><th>价格</th><th>库存</th><th>描述</th><th>操作</th></tr>
            </thead>
            <tbody>
            <% for(Product p : products){ %>
            <tr>
                <td><%=p.id%></td>
                <td><%=p.name%></td>
                <td><%=ServiceLayer.formatPrice(p.price)%></td>
                <td><%=p.stock%></td>
                <td><%=p.description%></td>
                <td>
                    <form method="post" style="display:inline-block;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%=p.id%>">
                        <button type="submit" class="btn btn-danger btn-sm">删除</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <h2 class="mt-24">添加商品</h2>
        <form method="post" class="mb-24">
            <input type="hidden" name="action" value="add">
            <div class="form-group">
                <label class="form-label">名称</label>
                <input type="text" name="name" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">价格</label>
                <input type="text" name="price" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">库存</label>
                <input type="text" name="stock" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">描述</label>
                <textarea name="description" class="form-textarea"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">添加商品</button>
        </form>

        <h2>更新商品</h2>
        <form method="post">
            <input type="hidden" name="action" value="update">
            <div class="form-group">
                <label class="form-label">商品ID</label>
                <input type="text" name="id" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">名称</label>
                <input type="text" name="name" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">价格</label>
                <input type="text" name="price" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">库存</label>
                <input type="text" name="stock" class="form-input" required>
            </div>
            <div class="form-group">
                <label class="form-label">描述</label>
                <textarea name="description" class="form-textarea"></textarea>
            </div>
            <button type="submit" class="btn btn-secondary">更新商品</button>
        </form>
    </div>
</div>
</body>
</html>
