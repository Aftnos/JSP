<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>小米商城管理系统</title>
    <!-- 引入基础样式 -->
    <link rel="stylesheet" type="text/css" href="../static/css/admin-layout.css">
    <!-- 引入主样式 -->
    <link rel="stylesheet" type="text/css" href="./css/main.css">
</head>
<body>
    <!-- 后台管理系统容器 -->
    <div class="admin-container">
        <!-- 侧边栏 -->
        <div class="sidebar" id="sidebar">
            <!-- 侧边栏头部 -->
            <div class="sidebar-header">
                <div class="logo">小米商城管理系统</div>
                <button class="sidebar-toggle" onclick="toggleSidebar()">
                    <i class="icon">☰</i>
                </button>
            </div>

            <!-- 菜单容器 -->
            <div class="sidebar-menu">
                <!-- 用户管理 -->
                <div class="menu-item" onclick="toggleSubmenu('user-menu')">
                    <div class="icon">👥</div>
                    <span class="text">用户管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="user-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('user-profile-management')">
                        <span class="text">用户资料管理</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('address-management')">
                        <span class="text">收货地址管理</span>
                    </div>
                </div>

                <!-- 商品管理 -->
                <div class="menu-item" onclick="toggleSubmenu('product-menu')">
                    <div class="icon">📦</div>
                    <span class="text">商品管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="product-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('category-management')">
                        <span class="text">分类管理</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('product-management')">
                        <span class="text">商品管理</span>
                    </div>
                </div>

                <!-- 订单管理 -->
                <div class="menu-item" onclick="toggleSubmenu('order-menu')">
                    <div class="icon">📋</div>
                    <span class="text">订单管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="order-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('order-global-query')">
                        <span class="text">全局查询</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('order-status-control')">
                        <span class="text">状态控制</span>
                    </div>
                </div>

                <!-- SN码管理 -->
                <div class="menu-item" onclick="toggleSubmenu('sn-menu')">
                    <div class="icon">🔢</div>
                    <span class="text">SN码管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="sn-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('sn-batch-generation')">
                        <span class="text">批量生成</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('sn-global-query')">
                        <span class="text">全局查询</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('sn-status-change')">
                        <span class="text">状态变更</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('sn-unsold-cleanup')">
                        <span class="text">未售SN清理</span>
                    </div>
                </div>

                <!-- SN绑定管理 -->
                <div class="menu-item" onclick="toggleSubmenu('sn-binding-menu')">
                    <div class="icon">🔗</div>
                    <span class="text">SN绑定管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="sn-binding-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('sn-forced-unbinding')">
                        <span class="text">强制解绑</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('sn-binding-audit')">
                        <span class="text">绑定记录审计</span>
                    </div>
                </div>

                <!-- 售后管理 -->
                <div class="menu-item" onclick="toggleSubmenu('aftersales-menu')">
                    <div class="icon">🛠️</div>
                    <span class="text">售后管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="aftersales-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('aftersales-workflow-control')">
                        <span class="text">工单全流程控制</span>
                    </div>
                </div>

                <!-- 系统通知管理 -->
                <div class="menu-item" onclick="toggleSubmenu('notification-menu')">
                    <div class="icon">🔔</div>
                    <span class="text">系统通知管理</span>
                    <div class="submenu-arrow">▼</div>
                </div>
                <div class="submenu" id="notification-menu" style="display: none;">
                    <div class="submenu-item" onclick="navigateTo('notification-resend')">
                        <span class="text">通知重发</span>
                    </div>
                    <div class="submenu-item" onclick="navigateTo('message-center-maintenance')">
                        <span class="text">消息中心维护</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 主内容区域 -->
        <div class="main-content" id="mainContent">
            <!-- 顶部用户信息栏 -->
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
            
            <!-- 页面内容区域 -->
            <div class="page-content" id="pageContent">
                <div class="welcome-section">
                    <h1>欢迎使用小米商城管理系统</h1>
                    <p>请从左侧菜单选择功能模块进行操作。</p>
                    
                    <!-- 快捷操作卡片 -->
                    <div class="quick-actions">
                        <div class="action-card" onclick="navigateTo('user-profile-management')">
                            <div class="card-icon">👥</div>
                            <div class="card-title">用户管理</div>
                            <div class="card-desc">管理用户资料和地址信息</div>
                        </div>
                        <div class="action-card" onclick="navigateTo('product-management')">
                            <div class="card-icon">📦</div>
                            <div class="card-title">商品管理</div>
                            <div class="card-desc">管理商品分类和商品信息</div>
                        </div>
                        <div class="action-card" onclick="navigateTo('order-global-query')">
                            <div class="card-icon">📋</div>
                            <div class="card-title">订单管理</div>
                            <div class="card-desc">查询和管理订单状态</div>
                        </div>
                        <div class="action-card" onclick="navigateTo('sn-batch-generation')">
                            <div class="card-icon">🔢</div>
                            <div class="card-title">SN码管理</div>
                            <div class="card-desc">批量生成和管理SN码</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="./js/main.js"></script>
</body>
</html>