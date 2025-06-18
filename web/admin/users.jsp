<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int uid = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
    User user = uid > 0 ? ServiceLayer.getUserById(uid) : null;

    String regMsg = null;
    String pwdMsg = null;
    String profileMsg = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            regMsg = ServiceLayer.userRegister(username, password);
        } else if ("updatePwd".equals(action)) {
            int id = ServiceLayer.safeParseInt(request.getParameter("uid"), 0);
            String np = request.getParameter("newPassword");
            pwdMsg = ServiceLayer.updateUserPassword(id, np);
        } else if ("updateProfile".equals(action)) {
            int id = ServiceLayer.safeParseInt(request.getParameter("uid"), 0);
            String dn = request.getParameter("displayName");
            String avatar = request.getParameter("avatar");
            profileMsg = ServiceLayer.updateUserProfile(id, dn, avatar);
        }
        if (uid > 0) user = ServiceLayer.getUserById(uid);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav>
        <a href="dashboard.jsp">返回控制台</a>
    </nav>

    <h2>新增用户</h2>
    <% if (regMsg != null) { %>
    <p class="message"><%= regMsg %></p>
    <% } %>
    <form method="post">
        <input type="hidden" name="action" value="register">
        <label>用户名:<input type="text" name="username"></label><br>
        <label>密码:<input type="password" name="password"></label><br>
        <button type="submit">注册</button>
    </form>

    <h2>编辑用户</h2>
    <form method="get" style="margin-bottom:10px;">
        <label>用户ID:<input type="number" name="id" value="<%= uid>0?uid:"" %>"></label>
        <button type="submit">查询</button>
    </form>
    <% if (user != null) { %>
        <p>用户名：<%= user.username %></p>
        <p>显示名：<%= user.displayName %></p>
        <p>头像：<%= user.avatar %></p>

        <h3>修改密码</h3>
        <% if (pwdMsg != null) { %><p class="message"><%= pwdMsg %></p><% } %>
        <form method="post">
            <input type="hidden" name="action" value="updatePwd">
            <input type="hidden" name="uid" value="<%= user.id %>">
            <label>新密码:<input type="password" name="newPassword"></label>
            <button type="submit">更新</button>
        </form>

        <h3>修改资料</h3>
        <% if (profileMsg != null) { %><p class="message"><%= profileMsg %></p><% } %>
        <form method="post">
            <input type="hidden" name="action" value="updateProfile">
            <input type="hidden" name="uid" value="<%= user.id %>">
            <label>显示名:<input type="text" name="displayName" value="<%= user.displayName %>"></label><br>
            <label>头像URL:<input type="text" name="avatar" value="<%= user.avatar %>"></label><br>
            <button type="submit">更新</button>
        </form>
    <% } else if (uid > 0) { %>
        <p class="message">未找到用户</p>
    <% } %>
</div>
</body>
</html>
