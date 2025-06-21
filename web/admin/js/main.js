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

// ==================== 导航功能 ====================

// 导航功能
function navigateTo(page) {
    // 移除所有菜单项的活动状态（包括一级和二级菜单）
    const menuItems = document.querySelectorAll('.menu-item');
    const submenuItems = document.querySelectorAll('.submenu-item');
    
    menuItems.forEach(item => {
        item.classList.remove('active');
    });
    
    submenuItems.forEach(item => {
        item.classList.remove('active');
    });
    
    // 添加活动状态到当前项
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    }
    
    // 根据不同页面进行跳转
    console.log('导航到:', page);
    
    // 根据页面类型跳转到对应的JSP页面
    switch(page) {
        case 'user-profile-management':
            window.location.href = 'user/user-manage.jsp';
            break;
        case 'address-management':
            window.location.href = 'pages/user/address-manage.jsp';
            break;
        case 'category-management':
            window.location.href = 'pages/category-manage.jsp';
            break;
        case 'product-management':
            window.location.href = 'pages/product-manage.jsp';
            break;
        case 'order-global-query':
            window.location.href = 'pages/order/order-query.jsp';
            break;
        case 'order-status-control':
            window.location.href = 'pages/order/order-status.jsp';
            break;
        case 'sn-batch-generation':
            window.location.href = 'pages/sn/sn-generation.jsp';
            break;
        case 'sn-global-query':
            window.location.href = 'pages/sn/sn-query.jsp';
            break;
        case 'sn-status-change':
            window.location.href = 'pages/sn/sn-status.jsp';
            break;
        case 'sn-unsold-cleanup':
            window.location.href = 'pages/sn/sn-cleanup.jsp';
            break;
        case 'sn-forced-unbinding':
            window.location.href = 'pages/sn/sn-unbinding.jsp';
            break;
        case 'sn-binding-audit':
            window.location.href = 'pages/sn/sn-audit.jsp';
            break;
        case 'aftersales-workflow-control':
            window.location.href = 'pages/aftersales/workflow-control.jsp';
            break;
        case 'notification-resend':
            window.location.href = 'pages/notification/notification-resend.jsp';
            break;
        case 'message-center-maintenance':
            window.location.href = 'pages/message-center.jsp';
            break;
        default:
            // 对于未知页面，保持在当前页面或跳转到首页
            console.log('未知页面:', page);
    }
}



// ==================== 事件监听器 ====================

// 页面加载完成后的初始化
document.addEventListener('DOMContentLoaded', function() {
    // 初始化用户信息
    initializeUserInfo();
    
    // 设置当前页面的活动状态
    setActiveMenuItem();
    
    // 添加点击外部关闭用户菜单的事件
    document.addEventListener('click', function(event) {
        const userContainer = document.querySelector('.user-avatar-container');
        const dropdown = document.getElementById('userDropdown');
        
        if (userContainer && dropdown && !userContainer.contains(event.target)) {
            dropdown.style.display = 'none';
        }
    });
});

// 初始化用户信息
function initializeUserInfo() {
    // 从localStorage或sessionStorage获取用户信息
    const userInfo = localStorage.getItem('userInfo') || sessionStorage.getItem('userInfo');
    if (userInfo) {
        try {
            const user = JSON.parse(userInfo);
            if (user.username) {
                const usernameElement = document.getElementById('username');
                if (usernameElement) {
                    usernameElement.textContent = user.username;
                }
            }
            if (user.avatar) {
                const avatarElement = document.getElementById('userAvatar');
                if (avatarElement) {
                    avatarElement.src = user.avatar;
                }
            }
        } catch (e) {
            console.log('用户信息解析失败:', e);
        }
    }
}

// 设置当前页面的活动菜单项
function setActiveMenuItem() {
    const currentPage = window.location.pathname.split('/').pop();
    const menuItems = document.querySelectorAll('.menu-item');
    
    menuItems.forEach(item => {
        const onclick = item.getAttribute('onclick');
        if (onclick && onclick.includes(currentPage.replace('.jsp', ''))) {
            item.classList.add('active');
        }
    });
}