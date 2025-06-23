<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entity.User" %>
<%
    Object obj=session.getAttribute("user");
    if(obj==null){ response.sendRedirect("login.jsp"); return; }
    User u=(User)obj;
%>
<html>
<head>
    <title>设置</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/settings.css"/>
</head>
<body>
<div class="notification-header">
    <button class="back-btn" onclick="history.back();">←</button>
    <div class="header-title">设置</div>
</div>

<div class="settings-container">
    <div class="settings-section">
        <div class="section-title">管理功能</div>
        <div class="settings-list">
            <a href="/admin/index.jsp" class="settings-item admin-item">
                <div class="settings-item-content">
                    <div class="settings-icon">⚙️</div>
                    <div class="settings-text">管理后台登录</div>
                </div>
                <span class="arrow">></span>
            </a>
        </div>
    </div>
    
    <div class="settings-section">
        <div class="section-title">账号管理</div>
        <div class="settings-list">
            <a href="logout.jsp?redirect=login.jsp" class="settings-item switch-item">
                <div class="settings-item-content">
                    <div class="settings-icon">🔄</div>
                    <div class="settings-text">切换账号</div>
                </div>
                <span class="arrow">></span>
            </a>
            <a href="logout.jsp" class="settings-item logout-item">
                <div class="settings-item-content">
                    <div class="settings-icon">🚪</div>
                    <div class="settings-text">退出登录</div>
                </div>
                <span class="arrow">></span>
            </a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
</body>
</html>
