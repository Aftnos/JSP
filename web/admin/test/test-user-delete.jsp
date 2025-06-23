<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ include file="../checkAdmin.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户删除功能测试</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .test-result {
            background-color: #f8f9fa;
            padding: 10px;
            border-left: 4px solid #007bff;
            margin-top: 10px;
            white-space: pre-line;
            font-family: monospace;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"] {
            width: 200px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .danger {
            background-color: #dc3545;
        }
        .danger:hover {
            background-color: #c82333;
        }
        .user-list {
            background-color: #e9ecef;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .user-item {
            padding: 5px;
            border-bottom: 1px solid #ccc;
        }
        .user-item:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>用户删除功能测试页面</h1>
        <p>此页面用于测试用户删除相关功能是否正常工作</p>
        
        <!-- 显示当前用户列表 -->
        <div class="test-section">
            <h2>当前用户列表</h2>
            <div class="user-list">
                <%
                    List<User> allUsers = ServiceLayer.getAllUsers();
                    if (allUsers != null && !allUsers.isEmpty()) {
                        for (User user : allUsers) {
                %>
                    <div class="user-item">
                        ID: <%= user.getId() %> | 用户名: <%= user.getUsername() %> | 邮箱: <%= user.getEmail() %>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="user-item">没有找到用户</div>
                <%
                    }
                %>
            </div>
        </div>
        
        <!-- 用户管理功能完整性测试 -->
        <div class="test-section">
            <h2>用户管理功能完整性测试</h2>
            <form method="post">
                <input type="hidden" name="action" value="testIntegrity">
                <button type="submit">运行完整性测试</button>
            </form>
            
            <%
                if ("testIntegrity".equals(request.getParameter("action"))) {
                    String testResult = ServiceLayer.testUserManagementIntegrity();
            %>
                <div class="test-result"><%= testResult %></div>
            <%
                }
            %>
        </div>
        
        <!-- 单个用户删除测试 -->
        <div class="test-section">
            <h2>单个用户删除测试</h2>
            <form method="post">
                <input type="hidden" name="action" value="testSingleDelete">
                <div class="form-group">
                    <label for="userId">用户ID:</label>
                    <input type="number" id="userId" name="userId" required>
                </div>
                <button type="submit" class="danger">测试删除用户</button>
            </form>
            
            <%
                if ("testSingleDelete".equals(request.getParameter("action"))) {
                    String userIdStr = request.getParameter("userId");
                    if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                        try {
                            int userId = Integer.parseInt(userIdStr);
                            String testResult = ServiceLayer.testDeleteUser(userId);
            %>
                <div class="test-result"><%= testResult %></div>
            <%
                        } catch (NumberFormatException e) {
            %>
                <div class="test-result">错误: 用户ID必须是数字</div>
            <%
                        }
                    }
                }
            %>
        </div>
        
        <!-- 批量用户删除测试 -->
        <div class="test-section">
            <h2>批量用户删除测试</h2>
            <form method="post">
                <input type="hidden" name="action" value="testBatchDelete">
                <div class="form-group">
                    <label for="userIds">用户ID列表 (用逗号分隔):</label>
                    <input type="text" id="userIds" name="userIds" placeholder="例如: 1,2,3" required>
                </div>
                <button type="submit" class="danger">测试批量删除用户</button>
            </form>
            
            <%
                if ("testBatchDelete".equals(request.getParameter("action"))) {
                    String userIdsStr = request.getParameter("userIds");
                    if (userIdsStr != null && !userIdsStr.trim().isEmpty()) {
                        try {
                            String[] userIdStrArray = userIdsStr.split(",");
                            int[] userIds = new int[userIdStrArray.length];
                            for (int i = 0; i < userIdStrArray.length; i++) {
                                userIds[i] = Integer.parseInt(userIdStrArray[i].trim());
                            }
                            String testResult = ServiceLayer.testBatchDeleteUsers(userIds);
            %>
                <div class="test-result"><%= testResult %></div>
            <%
                        } catch (NumberFormatException e) {
            %>
                <div class="test-result">错误: 用户ID列表格式不正确，请确保都是数字并用逗号分隔</div>
            <%
                        }
                    }
                }
            %>
        </div>
        
        <div style="margin-top: 30px; padding: 15px; background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 4px;">
            <strong>注意:</strong> 此页面仅用于测试目的。删除操作是真实的，请谨慎使用！建议在测试环境中使用。
        </div>
        
        <div style="margin-top: 20px;">
            <a href="pages/user/index.jsp" style="color: #007bff; text-decoration: none;">← 返回用户管理页面</a>
        </div>
    </div>
</body>
</html>