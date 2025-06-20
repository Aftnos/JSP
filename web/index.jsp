<%--
  Created by IntelliJ IDEA.
  User: alyfk
  Date: 2025/6/14
  Time: 23:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.Model" %>
<html>
  <head>
    <title>Title</title>
  </head>
  <body>
  <a href="test_all_functions.jsp">测试所有功能</a><br/>
  <a href="admin/login.jsp">进入后台管理</a>
  </body>
</html>
<%
  // 统一设置请求字符编码，解决POST提交中文乱码问题
  request.setCharacterEncoding("UTF-8");

  String action = request.getParameter("action");
  String result = "";
  String resultClass = "info";
%>