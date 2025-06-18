<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%
request.setCharacterEncoding("UTF-8");
String msg = null;
if("POST".equalsIgnoreCase(request.getMethod())){
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    if(ServiceLayer.adminLogin(username, password)){
        session.setAttribute("admin", username);
        response.sendRedirect("dashboard.jsp");
        return;
    } else {
        msg = "登录失败";
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员登录</title>
    <link rel="stylesheet" type="text/css" href="./css/admin-layout.css">
</head>
<body>
<div class="content-container" style="max-width:400px;margin:80px auto;">
    <h2 class="mb-16">管理员登录</h2>
    <% if(msg != null){ %>
        <p class="text-danger mb-16"><%=msg%></p>
    <% } %>
    <form method="post">
        <div class="form-group">
            <label class="form-label">用户名</label>
            <input type="text" name="username" class="form-input" required>
        </div>
        <div class="form-group">
            <label class="form-label">密码</label>
            <input type="password" name="password" class="form-input" required>
        </div>
        <button type="submit" class="btn btn-primary mt-16">登录</button>
    </form>
</div>
</body>
</html>
