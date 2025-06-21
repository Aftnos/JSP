<!-- 顶部用户信息栏组件 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="top-header">
    <div class="user-info">
        <div class="user-text">
            <div class="greeting">Hi, <span id="username">小锦鲤</span></div>
            <div class="welcome-text">欢迎进入小米商城管理系统</div>
        </div>
        <div class="user-avatar-container">
            <img src="../images/default-avatar.png" alt="用户头像" class="user-avatar" id="userAvatar" onclick="toggleUserMenu()" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNFNUU1RTUiLz4KPGNpcmNsZSBjeD0iMjAiIGN5PSIxNiIgcj0iNiIgZmlsbD0iIzk5OTk5OSIvPgo8cGF0aCBkPSJNMzAgMzJDMzAgMjYuNDc3MSAyNS41MjI5IDIyIDIwIDIyQzE0LjQ3NzEgMjIgMTAgMjYuNDc3MSAxMCAzMkgzMFoiIGZpbGw9IiM5OTk5OTkiLz4KPC9zdmc+'">
            <!-- 用户下拉菜单 -->
            <div class="user-dropdown" id="userDropdown">
                <div class="dropdown-item" onclick="reLogin()">
                    <i class="icon">🔄</i>
                    <span>重新登录</span>
                </div>
                <div class="dropdown-item" onclick="logout()">
                    <i class="icon">🚪</i>
                    <span>退出登录</span>
                </div>
            </div>
        </div>
    </div>
</div>