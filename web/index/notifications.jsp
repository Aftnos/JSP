<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Notification" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    String action = request.getParameter("action");
    if("read".equals(action)){
        int id = Integer.parseInt(request.getParameter("id"));
        if(ServiceLayer.markNotificationRead(id)) message="已标记已读"; else message="操作失败";
    }else if("delete".equals(action)){
        int id = Integer.parseInt(request.getParameter("id"));
        if(ServiceLayer.deleteNotification(id)) message="已删除"; else message="删除失败";
    }
    java.util.List<Notification> list = ServiceLayer.getNotifications(u.getId());
%>
<html>
<head>
    <title>系统消息</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <style>
        .notification-header {
            background: #fff;
            padding: 12px 16px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .back-btn {
            background: none;
            border: none;
            font-size: 18px;
            color: #333;
            cursor: pointer;
            margin-right: 12px;
            padding: 4px;
        }
        .header-title {
            font-size: 18px;
            font-weight: 500;
            color: #333;
        }
        .notification-container {
            background: #f5f5f5;
            min-height: calc(100vh - 120px);
            padding-bottom: 70px;
        }
        .notification-list {
            padding: 0;
        }
        .notification-item {
            background: #fff;
            margin-bottom: 8px;
            padding: 16px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            border-bottom: 1px solid #f0f0f0;
            position: relative;
        }
        .notification-item:last-child {
            margin-bottom: 0;
        }
        .notification-item.unread {
            background: #fff9f0;
        }
        .notification-item.unread::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 3px;
            background: #ff6700;
        }
        .notification-avatar {
            width: 40px;
            height: 40px;
            border-radius: 6px;
            background: #ff6700;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 14px;
            font-weight: 500;
            flex-shrink: 0;
        }
        .notification-content {
            flex: 1;
            min-width: 0;
        }
        .notification-header-info {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 4px;
        }
        .notification-sender {
            font-size: 16px;
            font-weight: 500;
            color: #333;
        }
        .notification-time {
            font-size: 12px;
            color: #999;
        }
        .notification-text {
            font-size: 14px;
            color: #666;
            line-height: 1.4;
            margin-bottom: 8px;
        }
        .notification-actions {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }
        .action-btn {
            padding: 6px 12px;
            border: 1px solid #e0e0e0;
            background: #fff;
            color: #666;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .action-btn:hover {
            background: #f5f5f5;
        }
        .action-btn.primary {
            background: #ff6700;
            color: #fff;
            border-color: #ff6700;
        }
        .action-btn.primary:hover {
            background: #e55a00;
        }
        .action-btn.danger {
            color: #ff4444;
            border-color: #ff4444;
        }
        .action-btn.danger:hover {
            background: #fff5f5;
        }
        .message-toast {
            background: #4CAF50;
            color: white;
            padding: 12px 16px;
            margin: 8px 16px;
            border-radius: 4px;
            font-size: 14px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-icon {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }
    </style>
</head>
<body>
<div class="notification-header">
    <button class="back-btn" onclick="history.back();">←</button>
    <div class="header-title">系统消息</div>
</div>

<div class="notification-container">
    <% if(message!=null){ %>
    <div class="message-toast"><%= message %></div>
    <% } %>
    
    <div class="notification-list">
        <% if(list != null && !list.isEmpty()) { %>
            <% for(Notification n : list){ %>
            <div class="notification-item <%= !n.isRead() ? "unread" : "" %>">
                <div class="notification-avatar">
                    系统
                </div>
                <div class="notification-content">
                    <div class="notification-header-info">
                        <div class="notification-sender">系统通知</div>
                        <div class="notification-time"><%= n.getCreatedAt() %></div>
                    </div>
                    <div class="notification-text">
                        <%= n.getContent() %>
                    </div>
                    <div class="notification-actions">
                        <% if(!n.isRead()){ %>
                        <form method="post" style="display:inline">
                            <input type="hidden" name="action" value="read"/>
                            <input type="hidden" name="id" value="<%= n.getId() %>"/>
                            <button type="submit" class="action-btn primary">标记已读</button>
                        </form>
                        <% } %>
                        <form method="post" style="display:inline" onsubmit="return confirm('确定删除这条通知吗?');">
                            <input type="hidden" name="action" value="delete"/>
                            <input type="hidden" name="id" value="<%= n.getId() %>"/>
                            <button type="submit" class="action-btn danger">删除</button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            <div>暂无通知消息</div>
        </div>
        <% } %>
    </div>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
