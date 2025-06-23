// ==================== 侧边栏功能 ====================

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

    // 移除所有菜单项的expanded类
    const allMenuItems = document.querySelectorAll('.menu-item');
    allMenuItems.forEach(item => {
        item.classList.remove('expanded');
    });

    // 隐藏所有子菜单
    const allSubmenus = document.querySelectorAll('.submenu');
    allSubmenus.forEach(menu => {
        menu.style.display = 'none';
    });

    // 切换当前子菜单
    if (!isVisible) {
        submenu.style.display = 'block';
        // 找到对应的菜单项并添加expanded类
        const menuItem = document.querySelector(`[onclick="toggleSubmenu('${menuId}')"]`);
        if (menuItem) {
            menuItem.classList.add('expanded');
        }
    }
}

// ==================== 用户菜单功能 ====================

// 用户菜单切换功能
function toggleUserMenu() {
    const dropdown = document.getElementById('userDropdown');
    dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
}

// 重新登录功能
function reLogin() {
    if (confirm('确定要重新登录吗？')) {
        // 清除当前会话信息
        sessionStorage.clear();
        localStorage.removeItem('userInfo');

        // 先清除服务器端session，然后跳转到登录页面
        fetch('../logout-session.jsp', {
            method: 'POST'
        }).then(() => {
            window.location.href = '../login.jsp?relogin=true';
        }).catch(() => {
            // 如果请求失败，直接跳转并添加参数强制重新登录
            window.location.href = '../login.jsp?relogin=true';
        });
    }
}

// 退出登录功能
function logout() {
    if (confirm('确定要退出登录吗？')) {
        // 清除所有用户信息
        sessionStorage.clear();
        localStorage.clear();
        // 跳转到首页
        window.location.href = '../index.jsp';
    }
}

// ==================== 页面导航功能 ====================

// 页面导航功能
function navigateTo(page) {
    console.log('导航到页面:', page);

    // 获取当前页面的基础路径
    function getBasePath() {
        const currentPath = window.location.pathname;

        // 如果在admin主目录下（如 /admin/index.jsp）
        if (currentPath.includes('/admin/index.jsp') || currentPath.endsWith('/admin/')) {
            return './';
        }
        // 如果在admin的子目录下（如 /admin/pages/user/index.jsp）
        else if (currentPath.includes('/admin/pages/')) {
            return '../../';
        }
        // 默认情况
        else {
            return './';
        }
    }

    const basePath = getBasePath();

    // 定义页面路径映射（相对于admin目录）
    const pageRoutes = {
        // 用户管理
        'user-profile-management': 'pages/user/index.jsp',
        'address-management': 'pages/user/address.jsp',

        // 商品管理
        'product-management': 'pages/product/index.jsp',

        // 订单管理
        'order-global-query': 'pages/order/query.jsp',

        // SN码管理
        'sn-global-query': 'pages/sn/index.jsp',

        // SN绑定管理
        'sn-forced-unbinding': 'pages/sn-binding/index.jsp',

        // 工单全流程控制
        'aftersales-workflow-control': 'pages/aftersales/index.jsp',

        // 系统通知管理
        'message-center-maintenance': 'pages/notification/index.jsp'
    };

    // 获取目标页面路径
    const relativePath = pageRoutes[page];

    if (relativePath) {
        // 构建完整的目标路径
        const targetPath = basePath + relativePath;

        // 检查是否已经在目标页面
        const currentPath = window.location.pathname;

        if (!currentPath.includes(relativePath)) {
            // 跳转到目标页面
            window.location.href = targetPath;
        } else {
            console.log('已经在目标页面:', page);
        }
    } else {
        console.warn('未找到页面路径:', page);
        alert('该功能页面正在开发中，敬请期待！');
    }
}

// 更新菜单项的活跃状态
function updateActiveMenuItem(page) {
    // 移除所有活跃状态
    const allMenuItems = document.querySelectorAll('.submenu-item');
    allMenuItems.forEach(item => {
        item.classList.remove('active');
    });

    // 根据页面设置对应的菜单项为活跃状态
    const pageMenuMap = {
        'user-profile-management': 'user-profile-management',
        'address-management': 'address-management',
        'product-management': 'product-management',
        'order-global-query': 'order-global-query',
        'sn-global-query': 'sn-global-query',
        'sn-binding-global-query': 'sn-binding-global-query',
        'notification-management': 'notification-management',
        'aftersales-workflow-control': 'pages/aftersales/index.jsp',
    };

    const targetMenuItem = pageMenuMap[page];
    if (targetMenuItem) {
        const menuItem = document.querySelector(`[onclick="navigateTo('${targetMenuItem}')"]`);
        if (menuItem) {
            menuItem.classList.add('active');
        }
    }
}

// ==================== 页面初始化 ====================

// 页面加载完成后的初始化
document.addEventListener('DOMContentLoaded', function () {
    console.log('管理系统页面初始化完成');

    // 根据当前页面URL设置活跃菜单项
    initializeActiveMenuItem();

    // 点击页面其他地方关闭用户菜单
    document.addEventListener('click', function (e) {
        const userAvatar = document.getElementById('userAvatar');
        const userDropdown = document.getElementById('userDropdown');

        if (userAvatar && userDropdown &&
            !userAvatar.contains(e.target) && !userDropdown.contains(e.target)) {
            userDropdown.style.display = 'none';
        }
    });
});

// 根据当前页面初始化活跃菜单项
function initializeActiveMenuItem() {
    const currentPath = window.location.pathname;

    // 根据当前路径确定活跃的菜单项
    if (currentPath.includes('/pages/user/index.jsp')) {
        updateActiveMenuItem('user-profile-management');
        toggleSubmenu('user-menu'); // 展开用户管理菜单
    } else if (currentPath.includes('/pages/user/address.jsp')) {
        updateActiveMenuItem('address-management');
        toggleSubmenu('user-menu');
    } else if (currentPath.includes('/pages/product/index.jsp')) {
        updateActiveMenuItem('product-management');
        toggleSubmenu('product-menu');
    } else if (currentPath.includes('/pages/order/query.jsp')) {
        updateActiveMenuItem('order-global-query');
        toggleSubmenu('order-menu');
    } else if (currentPath.includes('/pages/sn/index.jsp')) {
        updateActiveMenuItem('sn-global-query');
        toggleSubmenu('sn-menu');
    } else if (currentPath.includes('/pages/sn-binding/index.jsp')) {
        updateActiveMenuItem('sn-binding-global-query');
        toggleSubmenu('sn-binding-menu');
    } else if (currentPath.includes('/pages/notification/index.jsp')) {
        updateActiveMenuItem('notification-management');
        toggleSubmenu('notification-menu');
    }
}