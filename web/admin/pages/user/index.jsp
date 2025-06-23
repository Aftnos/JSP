<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String message = null;

    if ("save".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            boolean isAdmin = request.getParameter("isAdmin") != null;

            User u = new User();
            u.setId(id);
            u.setUsername(username);
            u.setPassword(password);
            u.setEmail(email);
            u.setPhone(phone);
            u.setAdmin(isAdmin);
            if (ServiceLayer.updateUser(u)) {
                message = "用户更新成功";
            } else {
                message = "用户更新失败";
            }
        } catch (Exception e) {
            message = "更新失败: " + e.getMessage();
        }
    } else if ("delete".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            message = ServiceLayer.deleteUserById(id) ? "用户删除成功" : "用户删除失败";
        } catch (Exception e) {
            message = "删除失败: " + e.getMessage();
        }
    } else if ("batchDelete".equals(action)) {
        String[] ids = request.getParameterValues("userIds");
        if (ids != null && ids.length > 0) {
            try {
                int[] intIds = new int[ids.length];
                for (int i = 0; i < ids.length; i++) {
                    intIds[i] = Integer.parseInt(ids[i]);
                }
                message = ServiceLayer.batchDeleteUsers(intIds) ? "批量删除成功" : "批量删除失败";
            } catch (Exception e) {
                message = "批量删除失败: " + e.getMessage();
            }
        }
    }

    User editUser = null;
    String editId = request.getParameter("editId");
    if (editId != null) {
        try {
            editUser = ServiceLayer.getUserById(Integer.parseInt(editId));
        } catch (Exception ignored) {}
    }

    List<User> users = ServiceLayer.getAllUsers();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户资料管理</title>
    <link rel="stylesheet" type="text/css" href="../../static/css/admin-layout.css">
    <link rel="stylesheet" type="text/css" href="../../css/main.css">
    <style>
        table {width:100%;border-collapse:collapse;margin-top:20px;}
        th,td{border:1px solid #ddd;padding:8px;text-align:center;}
        .actions form{display:inline;}
        .message{margin:10px 0;color:red;}
    </style>
    <script>
        function toggleSelectAll(box){
            document.querySelectorAll('.row-check').forEach(function(c){c.checked=box.checked;});
        }
        function batchDelete(){
            var ids=[];
            document.querySelectorAll('.row-check:checked').forEach(function(c){ids.push(c.value);});
            if(ids.length===0){alert('请选择要删除的用户');return;}
            if(!confirm('确定要删除选中的 '+ids.length+' 个用户吗?')) return;
            var form=document.getElementById('batchForm');
            var container=document.getElementById('idsContainer');
            container.innerHTML='';
            ids.forEach(function(id){
                var input=document.createElement('input');
                input.type='hidden';
                input.name='userIds';
                input.value=id;
                container.appendChild(input);
            });
            form.submit();
        }
        function confirmDelete(id){
            return confirm('确定删除用户ID='+id+'?');
        }
    </script>
</head>
<body>
<div class="admin-container">
    <div class="main-content">
        <h2>用户资料管理</h2>
        <% if (message != null) { %>
        <div class="message"><%= message %></div>
        <% } %>

        <% if (editUser != null) { %>
        <div class="form-section">
            <h3>编辑用户</h3>
            <form method="post">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="id" value="<%= editUser.getId() %>">
                用户名:<input type="text" name="username" value="<%= editUser.getUsername() %>" required>
                密码:<input type="text" name="password" value="<%= editUser.getPassword() %>" required>
                邮箱:<input type="email" name="email" value="<%= editUser.getEmail() %>">
                电话:<input type="text" name="phone" value="<%= editUser.getPhone() %>">
                管理员:<input type="checkbox" name="isAdmin" <%= editUser.isAdmin() ? "checked" : "" %>>
                <button type="submit">保存</button>
                <a href="index.jsp">取消</a>
            </form>
        </div>
        <% } %>

        <form id="batchForm" method="post">
            <input type="hidden" name="action" value="batchDelete">
            <div id="idsContainer"></div>
        </form>

        <table>
            <thead>
            <tr>
                <th><input type="checkbox" onclick="toggleSelectAll(this)"></th>
                <th>ID</th>
                <th>用户名</th>
                <th>邮箱</th>
                <th>电话</th>
                <th>管理员</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <% if (users != null) { for (User u : users) { %>
            <tr>
                <td><input type="checkbox" class="row-check" value="<%= u.getId() %>"></td>
                <td><%= u.getId() %></td>
                <td><%= u.getUsername() %></td>
                <td><%= u.getEmail() == null ? "" : u.getEmail() %></td>
                <td><%= u.getPhone() == null ? "" : u.getPhone() %></td>
                <td><%= u.isAdmin() ? "是" : "否" %></td>
                <td class="actions">
                    <a href="index.jsp?editId=<%= u.getId() %>">编辑</a>
                    <form method="post" onsubmit="return confirmDelete(<%= u.getId() %>)">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="<%= u.getId() %>">
                        <button type="submit">删除</button>
                    </form>
                </td>
            </tr>
            <% }} %>
            </tbody>
        </table>
        <div style="margin-top:10px;">
            <button onclick="batchDelete()">批量删除</button>
        </div>
    </div>
</div>
</body>
</html>
