<%@ include file="check_admin.jspf" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Notification" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int uid = Integer.parseInt(request.getParameter("userId"));
        String content = request.getParameter("content");
        Notification n = new Notification();
        n.setUserId(uid);
        n.setContent(content);
        n.setRead(false);
        if (ServiceLayer.sendNotification(n)) message="发送成功"; else message="发送失败";
    }
%>
<html>
<head>
    <title>通知管理</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <div class="admin-wrapper">
        <%@ include file="sidebar.jsp" %>
        <div class="content">
            <h2>通知管理</h2>
            <% if (message != null) { %><div class="message"><%= message %></div><% } %>
            <form method="post">
                <label>用户ID:<input type="number" name="userId" required></label>
                <label>内容:<input type="text" name="content" required></label>
                <button type="submit">发送通知</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
