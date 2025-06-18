<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%
    String admin = (String) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int id = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
    if (id > 0) {
        ServiceLayer.deleteProduct(id);
    }
    response.sendRedirect("products.jsp");
%>
