<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Address" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    java.util.List<Address> list = ServiceLayer.getAddresses(u.getId());
%>
<html>
<head>
    <title>我的</title>
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
    <h2>个人信息</h2>
    <p>用户名：<%= u.getUsername() %></p>
    <p>邮箱：<%= u.getEmail() == null ? "" : u.getEmail() %></p>
    <p>电话：<%= u.getPhone() == null ? "" : u.getPhone() %></p>
    <h3>收货地址</h3>
    <ul>
        <% for(Address a : list){ %>
        <li><%= a.getDetail() %> (<%= a.getReceiver() %> <%= a.getPhone() %>)<% if(a.isDefault()){ %> [默认]<% } %></li>
        <% } %>
    </ul>
    <p><a href="addresses.jsp">管理地址</a></p>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
