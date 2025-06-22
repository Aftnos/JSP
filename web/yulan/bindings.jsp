<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Binding" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    if("bind".equals(request.getParameter("action"))){
        String code = request.getParameter("code");
        if(ServiceLayer.bindSN(u.getId(), code)) message="绑定成功"; else message="绑定失败";
    }
    java.util.List<Binding> list = ServiceLayer.getBindingsByUser(u.getId());
%>
<html>
<head>
    <title>SN绑定</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
</head>
<body>
<header>
    <div class="logo"><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div class="user">
        <% if(session.getAttribute("user")!=null){ %>
        欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" style="color:#fff;">退出</a>
        <% }else{ %>
        <a href="login.jsp" style="color:#fff;">登录</a> | <a href="register.jsp" style="color:#fff;">注册</a>
        <% } %>
    </div>
</header>
<div class="container">
    <h2>SN绑定</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <input type="hidden" name="action" value="bind"/>
        <label>SN Code:<input type="text" name="code" required></label>
        <button type="submit">绑定</button>
    </form>
    <table class="cart-table">
        <tr><th>ID</th><th>SN码</th><th>绑定时间</th></tr>
        <% for(Binding b : list){ %>
        <tr>
            <td><%= b.getId() %></td>
            <td><%= b.getSnCode() %></td>
            <td><%= b.getBindTime() %></td>
        </tr>
        <% } %>
    </table>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
