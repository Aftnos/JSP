<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- 引入CSS样式 -->
<link rel="stylesheet" type="text/css" href="./css/admin-layout.css">
<!-- 侧边栏组件 -->
<div class="sidebar" id="sidebar">
    <!-- 侧边栏头部 -->
    <div class="sidebar-header">
        <div class="logo">BCReSafe</div>
        <button class="sidebar-toggle" onclick="toggleSidebar()">
            <i class="icon">☰</i>
        </button>
    </div>

    <!-- 菜单容器 -->
    <div class="sidebar-menu">
        <!-- 项目状态统计 -->
        <div class="menu-item active" onclick="navigateTo('dashboard')">
            <div class="icon">📊</div>
            <span class="text">项目状态统计</span>
        </div>

        <!-- 监测点分布 -->
        <div class="menu-item" onclick="navigateTo('monitoring-points')">
            <div class="icon">📍</div>
            <span class="text">监测点分布</span>
        </div>

        <!-- 数据分析 -->
        <div class="menu-item" onclick="navigateTo('data-analysis')">
            <div class="icon">📈</div>
            <span class="text">数据分析</span>
        </div>

        <!-- 用户管理 -->
        <div class="menu-item" onclick="navigateTo('user-management')">
            <div class="icon">👥</div>
            <span class="text">用户管理</span>
        </div>

        <!-- 商品管理 -->
        <div class="menu-item" onclick="toggleSubmenu('product-menu')">
            <div class="icon">📦</div>
            <span class="text">商品管理</span>
            <div class="submenu-arrow">▼</div>
        </div>
        <div class="submenu" id="product-menu">
            <div class="submenu-item" onclick="navigateTo('product-list')">
                <span class="text">商品列表</span>
            </div>
        </div>

        <!-- 订单管理 -->
        <div class="menu-item" onclick="navigateTo('order-management')">
            <div class="icon">📋</div>
            <span class="text">订单管理</span>
        </div>

        <!-- 售后管理 -->
        <div class="menu-item" onclick="navigateTo('after-sales')">
            <div class="icon">🔧</div>
            <span class="text">售后管理</span>
        </div>

        <!-- 数据管理 -->
        <div class="menu-item" onclick="toggleSubmenu('data-menu')">
            <div class="icon">💾</div>
            <span class="text">数据管理</span>
            <div class="submenu-arrow">▼</div>
        </div>
        <div class="submenu" id="data-menu" style="display: none;">
            <div class="submenu-item" onclick="navigateTo('data-backup')">
                <span class="text">数据备份</span>
            </div>
            <div class="submenu-item" onclick="navigateTo('data-import')">
                <span class="text">数据导入</span>
            </div>
        </div>

        <!-- 报警管理 -->
        <div class="menu-item" onclick="toggleSubmenu('alert-menu')">
            <div class="icon">🚨</div>
            <span class="text">报警管理</span>
            <div class="submenu-arrow">▼</div>
        </div>
        <div class="submenu" id="alert-menu" style="display: none;">
            <div class="submenu-item" onclick="navigateTo('alert-rules')">
                <span class="text">报警规则</span>
            </div>
            <div class="submenu-item" onclick="navigateTo('alert-history')">
                <span class="text">报警历史</span>
            </div>
        </div>

        <!-- 项目管理 -->
        <div class="menu-item" onclick="toggleSubmenu('project-menu')">
            <div class="icon">📁</div>
            <span class="text">项目管理</span>
            <div class="submenu-arrow">▼</div>
        </div>
        <div class="submenu" id="project-menu" style="display: none;">
            <div class="submenu-item" onclick="navigateTo('project-settings')">
                <span class="text">项目设置</span>
            </div>
            <div class="submenu-item" onclick="navigateTo('project-members')">
                <span class="text">项目成员</span>
            </div>
        </div>

        <!-- 系统管理 -->
        <div class="menu-item" onclick="toggleSubmenu('system-menu')">
            <div class="icon">⚙️</div>
            <span class="text">系统管理</span>
            <div class="submenu-arrow">▼</div>
        </div>
        <div class="submenu" id="system-menu" style="display: none;">
            <div class="submenu-item" onclick="navigateTo('system-settings')">
                <span class="text">系统设置</span>
            </div>
            <div class="submenu-item" onclick="navigateTo('system-logs')">
                <span class="text">系统日志</span>
            </div>
        </div>

        <!-- 系统工具 -->
        <div class="menu-item" onclick="navigateTo('system-tools')">
            <div class="icon">🔨</div>
            <span class="text">系统工具</span>
        </div>

        <!-- 系统信息 -->
        <div class="menu-item" onclick="navigateTo('system-info')">
            <div class="icon">ℹ️</div>
            <span class="text">系统信息</span>
        </div>
    </div>
</div>

<script>
// 侧边栏切换功能
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.querySelector('.main-content');
    
    sidebar.classList.toggle('collapsed');
    if (mainContent) {
        mainContent.classList.toggle('expanded');
    }
}

// 子菜单切换功能
function toggleSubmenu(menuId) {
    const submenu = document.getElementById(menuId);
    const isVisible = submenu.style.display !== 'none';
    
    // 隐藏所有子菜单
    const allSubmenus = document.querySelectorAll('.submenu');
    allSubmenus.forEach(menu => {
        menu.style.display = 'none';
    });
    
    // 切换当前子菜单
    if (!isVisible) {
        submenu.style.display = 'block';
    }
}

// 导航功能
function navigateTo(page) {
    // 移除所有活动状态
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.classList.remove('active');
    });
    
    // 添加活动状态到当前项
    event.currentTarget.classList.add('active');
    
    // 这里可以添加页面跳转逻辑
    console.log('导航到:', page);
    
    // 示例：根据不同页面进行跳转
    switch(page) {
        case 'dashboard':
            window.location.href = 'dashboard.jsp';
            break;
        case 'user-management':
            window.location.href = 'user-management.jsp';
            break;
        case 'product-list':
            window.location.href = 'product-list.jsp';
            break;
        case 'order-management':
            window.location.href = 'order-management.jsp';
            break;
        case 'after-sales':
            window.location.href = 'after-sales.jsp';
            break;
        case 'system-tools':
            window.location.href = 'system-tools.jsp';
            break;
        case 'system-info':
            window.location.href = 'system-info.jsp';
            break;
        default:
            console.log('页面未定义:', page);
    }
}

// 页面加载时初始化
document.addEventListener('DOMContentLoaded', function() {
    // 根据当前页面设置活动菜单项
    const currentPage = window.location.pathname.split('/').pop();
    const menuItems = document.querySelectorAll('.menu-item');
    
    menuItems.forEach(item => {
        const onclick = item.getAttribute('onclick');
        if (onclick && onclick.includes(currentPage.replace('.jsp', ''))) {
            item.classList.add('active');
        }
    });
});
</script>

<style>
/* 子菜单样式扩展 */
.submenu {
    background-color: #1A1D23;
    border-left: 2px solid #2F80ED;
    margin-left: 16px;
    display: none;
}

.submenu-arrow {
    margin-left: auto;
    font-size: 12px;
    transition: transform 0.3s ease;
}

.menu-item:hover .submenu-arrow {
    transform: rotate(180deg);
}

/* 收缩状态下隐藏子菜单箭头 */
.sidebar.collapsed .submenu-arrow {
    display: none;
}

/* 收缩状态下的图标居中 */
.sidebar.collapsed .menu-item .icon {
    font-size: 18px;
}

/* 选中条目渐变背景色 */
/*.menu-item.active {
    background: linear-gradient(135deg, #1777d1 0%, #16497f 100%) !important;
    color: #FFFFFF !important;
}

.submenu-item.active {
    background: linear-gradient(135deg, #1777d1 0%, #16497f 100%) !important;
    color: #FFFFFF !important;
}*/

/* 侧边栏固定宽度，不受分辨率影响 */
.sidebar {
    width: 220px;
    min-width: 220px;
    max-width: 220px;
}

.sidebar.collapsed {
    width: 60px;
    min-width: 60px;
    max-width: 60px;
}
</style>