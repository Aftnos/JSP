<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 清除服务器端session
    session.invalidate();
    
    // 返回成功响应
    response.setContentType("application/json");
    response.getWriter().write("{\"success\": true}");
%>