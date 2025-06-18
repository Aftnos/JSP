<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (ServiceLayer.adminLogin(username, password)) {
            session.setAttribute("adminUser", username);
            response.sendRedirect("dashboard.jsp");
            return;
        } else {
            msg = "登录失败，用户名或密码错误";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员登录</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <h2>管理员登录</h2>
    <% if (msg != null) { %>
    <p class="message"><%= msg %></p>
    <% } %>
    <form method="post">
        <label>用户名: <input type="text" name="username"></label><br>
        <label>密码: <input type="password" name="password"></label><br>
        <button type="submit">登录</button>
    </form>
    <a href="../index.jsp">返回首页</a>
</div>
</body>
</html>
