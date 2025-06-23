<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entity.User" %>
<%
    Object obj = session.getAttribute("user");
    if (obj == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    User adminUser = (User) obj;
    if (!adminUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

