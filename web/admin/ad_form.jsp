<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Advertisement" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
    Advertisement ad = null;
    if (id > 0) ad = ServiceLayer.getAllAdvertisements().stream().filter(a -> a.id==id).findFirst().orElse(null);
    String msg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String title = request.getParameter("title");
        String image = request.getParameter("imagePath");
        String url = request.getParameter("targetUrl");
        boolean enabled = "on".equals(request.getParameter("enabled"));
        if (id > 0) {
            msg = ServiceLayer.updateAdvertisement(id, title, image, url, enabled);
        } else {
            msg = ServiceLayer.addAdvertisement(title, image, url, enabled);
        }
        if ("success".equals(msg)) {
            response.sendRedirect("ads.jsp");
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= id>0?"编辑":"添加" %>广告</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav><a href="ads.jsp">返回列表</a></nav>
    <h2><%= id>0?"编辑":"添加" %>广告</h2>
    <% if (msg != null && !"success".equals(msg)) { %>
    <p class="message"><%= msg %></p>
    <% } %>
    <form method="post">
        <label>标题:<input type="text" name="title" value="<%= ad!=null?ad.title:"" %>"></label><br>
        <label>图片URL:<input type="text" name="imagePath" value="<%= ad!=null?ad.imagePath:"" %>"></label><br>
        <label>跳转URL:<input type="text" name="targetUrl" value="<%= ad!=null?ad.targetUrl:"" %>"></label><br>
        <label>启用:<input type="checkbox" name="enabled" <%= ad!=null && ad.enabled?"checked":"" %> ></label><br>
        <button type="submit">提交</button>
    </form>
</div>
</body>
</html>
