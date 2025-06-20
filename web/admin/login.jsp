<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        User admin = ServiceLayer.login(username, password);
        if (admin != null && admin.isAdmin()) {
            session.setAttribute("admin", admin);
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            message = "登录失败，或无管理员权限";
        }
    }
%>
<html>
<head>
    <title>管理员登录</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <h2>管理员登录</h2>
    <form method="post">
        <label>用户名: <input type="text" name="username" required></label><br/>
        <label>密码: <input type="password" name="password" required></label><br/>
        <button type="submit">登录</button>
    </form>
    <% if (message != null) { %>
    <div class="message"><%= message %></div>
    <% } %>
</div>
</body>
</html>
