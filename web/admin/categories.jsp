<%@ include file="check_admin.jspf" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Category" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("add".equals(action)) {
            Category c = new Category();
            c.setName(request.getParameter("name"));
            String pid = request.getParameter("parentId");
            if (pid != null && !pid.isEmpty()) c.setParentId(Integer.parseInt(pid));
            if (ServiceLayer.addCategory(c)) message = "添加成功"; else message = "添加失败";
        } else if ("update".equals(action)) {
            Category c = new Category();
            c.setId(Integer.parseInt(request.getParameter("id")));
            c.setName(request.getParameter("name"));
            String pid = request.getParameter("parentId");
            if (pid != null && !pid.isEmpty()) c.setParentId(Integer.parseInt(pid)); else c.setParentId(null);
            if (ServiceLayer.updateCategory(c)) message = "更新成功"; else message = "更新失败";
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (ServiceLayer.deleteCategory(id)) message = "删除成功"; else message = "删除失败";
        }
    }
    java.util.List<Category> list = ServiceLayer.listCategories();
    Category edit = null;
    String editIdStr = request.getParameter("editId");
    if (editIdStr != null) edit = list.stream().filter(c->c.getId()==Integer.parseInt(editIdStr)).findFirst().orElse(null);
%>
<html>
<head>
    <title>分类管理</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <div class="admin-wrapper">
        <%@ include file="sidebar.jsp" %>
        <div class="content">
    <h2>分类管理</h2>
    <% if (message != null) { %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <input type="hidden" name="action" value="<%= (edit!=null)?"update":"add" %>"/>
        <% if (edit != null) { %><input type="hidden" name="id" value="<%= edit.getId() %>"/><% } %>
        <label>名称:<input type="text" name="name" value="<%= edit!=null?edit.getName():"" %>" required/></label>
        <label>父ID:<input type="text" name="parentId" value="<%= edit!=null&&edit.getParentId()!=null?edit.getParentId():"" %>"/></label>
        <button type="submit"><%= (edit!=null)?"更新":"添加" %></button>
        <% if (edit != null) { %><a href="categories.jsp">取消编辑</a><% } %>
    </form>
    <table>
        <tr><th>ID</th><th>名称</th><th>父ID</th><th>操作</th></tr>
        <% for (Category c : list) { %>
        <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getName() %></td>
            <td><%= c.getParentId() %></td>
            <td>
                <a href="categories.jsp?editId=<%= c.getId() %>">编辑</a>
                <form method="post" style="display:inline" onsubmit="return confirm('确定删除?');">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%= c.getId() %>"/>
                    <button type="submit">删除</button>
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
