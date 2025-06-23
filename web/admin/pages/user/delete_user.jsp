<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.Arrays" %>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    String action = request.getParameter("action");
    PrintWriter writer = response.getWriter();
    
    try {
        if ("single".equals(action)) {
            // 单个删除
            String userIdStr = request.getParameter("userId");
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                boolean success = ServiceLayer.deleteUserById(userId);
                
                if (success) {
                    writer.print("{\"success\": true, \"message\": \"用户删除成功\"}");
                } else {
                    writer.print("{\"success\": false, \"message\": \"用户删除失败\"}");
                }
            } else {
                writer.print("{\"success\": false, \"message\": \"用户ID不能为空\"}");
            }
        } else if ("batch".equals(action)) {
            // 批量删除
            String[] userIdStrs = request.getParameterValues("userIds[]");
            if (userIdStrs != null && userIdStrs.length > 0) {
                int[] userIds = new int[userIdStrs.length];
                for (int i = 0; i < userIdStrs.length; i++) {
                    userIds[i] = Integer.parseInt(userIdStrs[i]);
                }
                
                boolean success = ServiceLayer.batchDeleteUsers(userIds);
                
                if (success) {
                    writer.print("{\"success\": true, \"message\": \"批量删除成功，共删除 " + userIds.length + " 个用户\"}");
                } else {
                    writer.print("{\"success\": false, \"message\": \"批量删除失败\"}");
                }
            } else {
                writer.print("{\"success\": false, \"message\": \"请选择要删除的用户\"}");
            }
        } else {
            writer.print("{\"success\": false, \"message\": \"无效的操作类型\"}");
        }
    } catch (NumberFormatException e) {
        writer.print("{\"success\": false, \"message\": \"用户ID格式错误\"}");
    } catch (Exception e) {
        writer.print("{\"success\": false, \"message\": \"删除操作失败: " + e.getMessage() + "\"}");
    } finally {
        writer.flush();
        writer.close();
    }
%>