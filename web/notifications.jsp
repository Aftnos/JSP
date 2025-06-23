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
    <link rel="stylesheet" href="css/notifications.css"/>
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
