<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.io.PrintWriter" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String userIdStr = request.getParameter("userId");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    PrintWriter out = response.getWriter();
    try {
        if (userIdStr != null && !userIdStr.trim().isEmpty() && username != null && !username.trim().isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            User user = ServiceLayer.getUserById(userId);
            if (user != null) {
                user.setUsername(username.trim());
                if (password != null && !password.trim().isEmpty()) {
                    user.setPassword(password.trim());
                }
                user.setEmail(email);
                user.setPhone(phone);
                boolean success = ServiceLayer.updateUser(user);
                if (success) {
                    out.print("{\"success\": true, \"message\": \"用户更新成功\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"用户更新失败\"}");
                }
            } else {
                out.print("{\"success\": false, \"message\": \"用户不存在\"}");
            }
        } else {
            out.print("{\"success\": false, \"message\": \"参数不完整\"}");
        }
    } catch (Exception e) {
        out.print("{\"success\": false, \"message\": \"更新用户时发生错误: " + e.getMessage() + "\"}");
    }
%>
