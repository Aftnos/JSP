<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Notification" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>

<%
    // 获取所有用户用于测试
    List<User> allUsers = ServiceLayer.getAllUsers();
    
    // 处理表单提交
    String action = request.getParameter("action");
    String message = "";
    
    if ("testIntegrity".equals(action)) {
        try {
            if (allUsers != null && !allUsers.isEmpty()) {
                User testUser = allUsers.get(0);
                List<Notification> notifications = ServiceLayer.getNotifications(testUser.getId());
                message = "<div class='success'>通知功能完整性测试通过！用户 " + testUser.getUsername() + " 当前有 " + (notifications != null ? notifications.size() : 0) + " 条通知。</div>";
            } else {
                message = "<div class='error'>没有找到用户，无法进行测试！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>测试失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("sendNotification".equals(action)) {
        try {
            String userIdStr = request.getParameter("userId");
            String content = request.getParameter("content");
            
            if (userIdStr != null && content != null && !content.trim().isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                
                Notification notification = new Notification();
                notification.setUserId(userId);
                notification.setContent(content.trim());
                notification.setRead(false);
                notification.setCreatedAt(new Date());
                
                boolean result = ServiceLayer.sendNotification(notification);
                
                if (result) {
                    message = "<div class='success'>通知发送成功！</div>";
                } else {
                    message = "<div class='error'>通知发送失败！</div>";
                }
            } else {
                message = "<div class='error'>请填写完整的通知信息！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>发送通知失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("markRead".equals(action)) {
        try {
            String notificationIdStr = request.getParameter("notificationId");
            
            if (notificationIdStr != null) {
                int notificationId = Integer.parseInt(notificationIdStr);
                
                boolean result = ServiceLayer.markNotificationRead(notificationId);
                
                if (result) {
                    message = "<div class='success'>通知标记已读成功！</div>";
                } else {
                    message = "<div class='error'>通知标记已读失败！</div>";
                }
            } else {
                message = "<div class='error'>请选择要标记的通知！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>标记通知已读失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("deleteNotification".equals(action)) {
        try {
            String notificationIdStr = request.getParameter("notificationId");
            
            if (notificationIdStr != null) {
                int notificationId = Integer.parseInt(notificationIdStr);
                
                boolean result = ServiceLayer.deleteNotification(notificationId);
                
                if (result) {
                    message = "<div class='success'>通知删除成功！</div>";
                } else {
                    message = "<div class='error'>通知删除失败！</div>";
                }
            } else {
                message = "<div class='error'>请选择要删除的通知！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>删除通知失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("batchSend".equals(action)) {
        try {
            String userIdStr = request.getParameter("batchUserId");
            String countStr = request.getParameter("batchCount");
            
            if (userIdStr != null && countStr != null) {
                int userId = Integer.parseInt(userIdStr);
                int count = Integer.parseInt(countStr);
                
                int successCount = 0;
                for (int i = 1; i <= count; i++) {
                    Notification notification = new Notification();
                    notification.setUserId(userId);
                    notification.setContent("批量测试通知 #" + i + " - " + new Date());
                    notification.setRead(false);
                    notification.setCreatedAt(new Date());
                    
                    if (ServiceLayer.sendNotification(notification)) {
                        successCount++;
                    }
                }
                
                message = "<div class='success'>批量发送完成！成功发送 " + successCount + "/" + count + " 条通知。</div>";
            } else {
                message = "<div class='error'>请填写批量发送参数！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>批量发送失败：" + e.getMessage() + "</div>";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>通知功能测试</title>
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
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], select, textarea {
            width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        textarea {
            height: 80px;
            resize: vertical;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .notification-list {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
        }
        .notification-item {
            padding: 10px;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
        }
        .notification-item:last-child {
            border-bottom: none;
        }
        .notification-unread {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        .notification-read {
            background-color: #f8f9fa;
            border-left: 4px solid #6c757d;
        }
        .notification-meta {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }
        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-item {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            flex: 1;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
        }
        .stat-label {
            font-size: 14px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>通知功能测试</h1>
        
        <% if (!message.isEmpty()) { %>
            <%= message %>
        <% } %>
        
        <!-- 功能完整性测试 -->
        <div class="test-section">
            <h2>1. 功能完整性测试</h2>
            <p>测试通知系统的基本功能是否正常工作。</p>
            <form method="post">
                <input type="hidden" name="action" value="testIntegrity">
                <button type="submit">运行完整性测试</button>
            </form>
        </div>
        
        <!-- 发送通知测试 -->
        <div class="test-section">
            <h2>2. 发送通知测试</h2>
            <form method="post">
                <input type="hidden" name="action" value="sendNotification">
                
                <div class="form-group">
                    <label for="userId">选择用户:</label>
                    <select name="userId" id="userId" required>
                        <option value="">请选择用户</option>
                        <% if (allUsers != null) {
                            for (User user : allUsers) { %>
                                <option value="<%= user.getId() %>"><%= user.getUsername() %> (<%= user.getEmail() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="content">通知内容:</label>
                    <textarea name="content" id="content" placeholder="请输入通知内容..." required></textarea>
                </div>
                
                <button type="submit">发送通知</button>
            </form>
        </div>
        
        <!-- 批量发送测试 -->
        <div class="test-section">
            <h2>3. 批量发送测试</h2>
            <form method="post">
                <input type="hidden" name="action" value="batchSend">
                
                <div class="form-group">
                    <label for="batchUserId">选择用户:</label>
                    <select name="batchUserId" id="batchUserId" required>
                        <option value="">请选择用户</option>
                        <% if (allUsers != null) {
                            for (User user : allUsers) { %>
                                <option value="<%= user.getId() %>"><%= user.getUsername() %> (<%= user.getEmail() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="batchCount">发送数量:</label>
                    <input type="number" name="batchCount" id="batchCount" min="1" max="10" value="3" required>
                </div>
                
                <button type="submit">批量发送</button>
            </form>
        </div>
        
        <!-- 通知列表和管理 -->
        <div class="test-section">
            <h2>4. 通知列表和管理</h2>
            
            <% if (allUsers != null && !allUsers.isEmpty()) {
                // 显示每个用户的通知统计
            %>
                <div class="stats">
                    <% for (int i = 0; i < Math.min(3, allUsers.size()); i++) {
                        User user = allUsers.get(i);
                        List<Notification> userNotifications = ServiceLayer.getNotifications(user.getId());
                        int totalCount = userNotifications != null ? userNotifications.size() : 0;
                        int unreadCount = 0;
                        if (userNotifications != null) {
                            for (Notification n : userNotifications) {
                                if (!n.isRead()) unreadCount++;
                            }
                        }
                    %>
                        <div class="stat-item">
                            <div class="stat-number"><%= totalCount %></div>
                            <div class="stat-label"><%= user.getUsername() %> 总通知</div>
                            <div style="color: #ffc107; font-weight: bold;"><%= unreadCount %> 未读</div>
                        </div>
                    <% } %>
                </div>
                
                <% for (int i = 0; i < Math.min(2, allUsers.size()); i++) {
                    User user = allUsers.get(i);
                    List<Notification> userNotifications = ServiceLayer.getNotifications(user.getId());
                %>
                    <h3><%= user.getUsername() %> 的通知列表</h3>
                    
                    <% if (userNotifications != null && !userNotifications.isEmpty()) { %>
                        <div class="notification-list">
                            <% for (Notification notification : userNotifications) { %>
                                <div class="notification-item <%= notification.isRead() ? "notification-read" : "notification-unread" %>">
                                    <div><strong>ID:</strong> <%= notification.getId() %></div>
                                    <div><strong>内容:</strong> <%= notification.getContent() %></div>
                                    <div class="notification-meta">
                                        <strong>状态:</strong> <%= notification.isRead() ? "已读" : "未读" %> | 
                                        <strong>时间:</strong> <%= notification.getCreatedAt() %>
                                    </div>
                                    <div style="margin-top: 10px;">
                                        <% if (!notification.isRead()) { %>
                                            <form method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="markRead">
                                                <input type="hidden" name="notificationId" value="<%= notification.getId() %>">
                                                <button type="submit" class="btn-warning">标记已读</button>
                                            </form>
                                        <% } %>
                                        <form method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteNotification">
                                            <input type="hidden" name="notificationId" value="<%= notification.getId() %>">
                                            <button type="submit" class="btn-danger" onclick="return confirm('确定要删除这条通知吗？')">删除</button>
                                        </form>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p>该用户暂无通知。</p>
                    <% } %>
                    
                    <hr style="margin: 20px 0;">
                <% } %>
            <% } else { %>
                <p>没有找到用户数据。</p>
            <% } %>
        </div>
        
        <!-- 快速操作 -->
        <div class="test-section">
            <h2>5. 快速操作</h2>
            <p>一些常用的测试操作快捷方式。</p>
            
            <% if (allUsers != null && !allUsers.isEmpty()) {
                User firstUser = allUsers.get(0);
            %>
                <form method="post" style="display: inline;">
                    <input type="hidden" name="action" value="sendNotification">
                    <input type="hidden" name="userId" value="<%= firstUser.getId() %>">
                    <input type="hidden" name="content" value="系统测试通知 - <%= new Date() %>">
                    <button type="submit">给 <%= firstUser.getUsername() %> 发送测试通知</button>
                </form>
                
                <form method="post" style="display: inline;">
                    <input type="hidden" name="action" value="batchSend">
                    <input type="hidden" name="batchUserId" value="<%= firstUser.getId() %>">
                    <input type="hidden" name="batchCount" value="5">
                    <button type="submit">给 <%= firstUser.getUsername() %> 批量发送5条通知</button>
                </form>
            <% } %>
        </div>
        
        <!-- 返回链接 -->
        <div style="margin-top: 30px; text-align: center;">
            <a href="../index.jsp" style="color: #007bff; text-decoration: none;">← 返回管理后台</a>
        </div>
    </div>
    
    <script>
        // 自动刷新页面以显示最新的通知状态
        function autoRefresh() {
            if (window.location.search.indexOf('action=') === -1) {
                setTimeout(function() {
                    window.location.reload();
                }, 30000); // 30秒后刷新
            }
        }
        
        // 页面加载完成后启动自动刷新
        window.onload = function() {
            autoRefresh();
        };
        
        // 表单提交确认
        document.querySelectorAll('form').forEach(function(form) {
            form.addEventListener('submit', function(e) {
                const action = form.querySelector('input[name="action"]').value;
                if (action === 'batchSend') {
                    const count = form.querySelector('input[name="batchCount"]').value;
                    if (!confirm('确定要批量发送 ' + count + ' 条通知吗？')) {
                        e.preventDefault();
                    }
                }
            });
        });
    </script>
</body>
</html>