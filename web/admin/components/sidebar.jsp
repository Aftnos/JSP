<!-- 侧边栏组件 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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