<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.UserProduct" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = ServiceLayer.safeParseInt(request.getParameter("userId"), 0);
    List<UserProduct> list = userId > 0 ? ServiceLayer.getUserProducts(userId) : new ArrayList<>();

    String bindMsg = null;
    String updateMsg = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");
        if ("bind".equals(action)) {
            int uid = ServiceLayer.safeParseInt(request.getParameter("bindUserId"), 0);
            int pid = ServiceLayer.safeParseInt(request.getParameter("productId"), 0);
            String sn = request.getParameter("sn");
            bindMsg = ServiceLayer.bindUserProduct(uid, pid, sn);
            if ("success".equals(bindMsg)) {
                response.sendRedirect("after_sale.jsp?userId=" + uid);
                return;
            }
        } else if ("update".equals(action)) {
            int upid = ServiceLayer.safeParseInt(request.getParameter("upid"), 0);
            String status = request.getParameter("status");
            updateMsg = ServiceLayer.updateAfterSaleStatus(upid, status);
            if (userId > 0) list = ServiceLayer.getUserProducts(userId);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>售后管理</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
<div class="container">
    <nav><a href="dashboard.jsp">返回控制台</a></nav>

    <h2>绑定用户商品</h2>
    <% if (bindMsg != null) { %><p class="message"><%= bindMsg %></p><% } %>
    <form method="post">
        <input type="hidden" name="action" value="bind">
        <label>用户ID:<input type="number" name="bindUserId"></label>
        <label>商品ID:<input type="number" name="productId"></label>
        <label>序列号:<input type="text" name="sn"></label>
        <button type="submit">绑定</button>
    </form>

    <h2>查看用户售后</h2>
    <form method="get">
        <label>用户ID:<input type="number" name="userId" value="<%= userId>0?userId:"" %>"></label>
        <button type="submit">查询</button>
    </form>

    <% if (userId > 0) { %>
        <h3>用户ID: <%= userId %> 的商品</h3>
        <% if (list.isEmpty()) { %>
            <p class="message">没有记录</p>
        <% } else { %>
            <% if (updateMsg != null) { %><p class="message"><%= updateMsg %></p><% } %>
            <table>
                <tr><th>ID</th><th>商品ID</th><th>序列号</th><th>售后状态</th><th>更新状态</th></tr>
                <% for (UserProduct up : list) { %>
                <tr>
                    <td><%= up.id %></td>
                    <td><%= up.productId %></td>
                    <td><%= up.sn %></td>
                    <td><%= up.afterSaleStatus %></td>
                    <td>
                        <form method="post" style="display:inline-block;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="upid" value="<%= up.id %>">
                            <input type="text" name="status" value="<%= up.afterSaleStatus %>" size="8">
                            <button type="submit">更新</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        <% } %>
    <% } %>
</div>
</body>
</html>
