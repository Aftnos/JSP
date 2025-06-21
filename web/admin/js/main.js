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
    
    // 根据不同页面进行跳转或加载内容
    console.log('导航到:', page);
    
    // 动态加载页面内容
    loadPageContent(page);
}

// 动态加载页面内容
function loadPageContent(page) {
    const pageContent = document.getElementById('pageContent');
    
    // 显示加载状态
    pageContent.innerHTML = '<div class="loading">加载中...</div>';
    
    // 根据页面类型加载不同内容
    setTimeout(() => {
        switch(page) {
            case 'user-profile-management':
                pageContent.innerHTML = generateUserManagementPage();
                break;
            case 'address-management':
                pageContent.innerHTML = generateAddressManagementPage();
                break;
            case 'category-management':
                pageContent.innerHTML = generateCategoryManagementPage();
                break;
            case 'product-management':
                pageContent.innerHTML = generateProductManagementPage();
                break;
            case 'order-global-query':
                pageContent.innerHTML = generateOrderQueryPage();
                break;
            case 'order-status-control':
                pageContent.innerHTML = generateOrderStatusPage();
                break;
            case 'sn-batch-generation':
                pageContent.innerHTML = generateSNGenerationPage();
                break;
            case 'sn-global-query':
                pageContent.innerHTML = generateSNQueryPage();
                break;
            case 'sn-status-change':
                pageContent.innerHTML = generateSNStatusPage();
                break;
            case 'sn-unsold-cleanup':
                pageContent.innerHTML = generateSNCleanupPage();
                break;
            case 'sn-forced-unbinding':
                pageContent.innerHTML = generateSNUnbindingPage();
                break;
            case 'sn-binding-audit':
                pageContent.innerHTML = generateSNAuditPage();
                break;
            case 'aftersales-workflow-control':
                pageContent.innerHTML = generateAftersalesPage();
                break;
            case 'notification-resend':
                pageContent.innerHTML = generateNotificationPage();
                break;
            case 'message-center-maintenance':
                pageContent.innerHTML = generateMessageCenterPage();
                break;
            default:
                pageContent.innerHTML = generateDefaultPage();
        }
    }, 500);
}

// ==================== 页面内容生成函数 ====================

function generateUserManagementPage() {
    return `
        <div class="page-header">
            <h1>用户资料管理</h1>
            <p>管理系统中的用户基本信息和账户状态</p>
        </div>
        <div class="content-section">
            <div class="search-bar">
                <input type="text" placeholder="搜索用户..." class="search-input">
                <button class="search-btn">搜索</button>
            </div>
            <div class="table-container">
                <p>用户管理功能正在开发中...</p>
            </div>
        </div>
    `;
}

function generateAddressManagementPage() {
    return `
        <div class="page-header">
            <h1>收货地址管理</h1>
            <p>管理用户的收货地址信息</p>
        </div>
        <div class="content-section">
            <p>地址管理功能正在开发中...</p>
        </div>
    `;
}

function generateCategoryManagementPage() {
    return `
        <div class="page-header">
            <h1>分类管理</h1>
            <p>管理商品分类和层级结构</p>
        </div>
        <div class="content-section">
            <p>分类管理功能正在开发中...</p>
        </div>
    `;
}

function generateProductManagementPage() {
    return `
        <div class="page-header">
            <h1>商品管理</h1>
            <p>管理商品信息、库存和状态</p>
        </div>
        <div class="content-section">
            <p>商品管理功能正在开发中...</p>
        </div>
    `;
}

function generateOrderQueryPage() {
    return `
        <div class="page-header">
            <h1>订单全局查询</h1>
            <p>查询和管理所有订单信息</p>
        </div>
        <div class="content-section">
            <p>订单查询功能正在开发中...</p>
        </div>
    `;
}

function generateOrderStatusPage() {
    return `
        <div class="page-header">
            <h1>订单状态控制</h1>
            <p>管理订单状态和流程控制</p>
        </div>
        <div class="content-section">
            <p>订单状态控制功能正在开发中...</p>
        </div>
    `;
}

function generateSNGenerationPage() {
    return `
        <div class="page-header">
            <h1>SN码批量生成</h1>
            <p>批量生成产品序列号</p>
        </div>
        <div class="content-section">
            <p>SN码生成功能正在开发中...</p>
        </div>
    `;
}

function generateSNQueryPage() {
    return `
        <div class="page-header">
            <h1>SN码全局查询</h1>
            <p>查询SN码状态和绑定信息</p>
        </div>
        <div class="content-section">
            <p>SN码查询功能正在开发中...</p>
        </div>
    `;
}

function generateSNStatusPage() {
    return `
        <div class="page-header">
            <h1>SN码状态变更</h1>
            <p>管理SN码的状态变更</p>
        </div>
        <div class="content-section">
            <p>SN码状态变更功能正在开发中...</p>
        </div>
    `;
}

function generateSNCleanupPage() {
    return `
        <div class="page-header">
            <h1>未售SN清理</h1>
            <p>清理未售出的SN码</p>
        </div>
        <div class="content-section">
            <p>SN清理功能正在开发中...</p>
        </div>
    `;
}

function generateSNUnbindingPage() {
    return `
        <div class="page-header">
            <h1>SN强制解绑</h1>
            <p>强制解除SN码绑定关系</p>
        </div>
        <div class="content-section">
            <p>SN解绑功能正在开发中...</p>
        </div>
    `;
}

function generateSNAuditPage() {
    return `
        <div class="page-header">
            <h1>SN绑定记录审计</h1>
            <p>审计SN码绑定记录</p>
        </div>
        <div class="content-section">
            <p>绑定审计功能正在开发中...</p>
        </div>
    `;
}

function generateAftersalesPage() {
    return `
        <div class="page-header">
            <h1>售后工单全流程控制</h1>
            <p>管理售后服务工单流程</p>
        </div>
        <div class="content-section">
            <p>售后管理功能正在开发中...</p>
        </div>
    `;
}

function generateNotificationPage() {
    return `
        <div class="page-header">
            <h1>通知重发</h1>
            <p>重新发送系统通知</p>
        </div>
        <div class="content-section">
            <p>通知重发功能正在开发中...</p>
        </div>
    `;
}

function generateMessageCenterPage() {
    return `
        <div class="page-header">
            <h1>消息中心维护</h1>
            <p>维护系统消息中心</p>
        </div>
        <div class="content-section">
            <p>消息中心维护功能正在开发中...</p>
        </div>
    `;
}

function generateDefaultPage() {
    return `
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
    `;
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