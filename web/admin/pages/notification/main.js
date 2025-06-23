// 消息中心维护页面JavaScript

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('消息中心维护页面已加载');
    initializeEventListeners();
});

// 初始化事件监听器
function initializeEventListeners() {
    // 点击模态框外部关闭
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) {
            closeModal(e.target.id);
        }
    });
    
    // ESC键关闭模态框
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeAllModals();
        }
    });
}

// 添加通知
function addNotification() {
    console.log('打开添加通知弹框');
    // 清空表单
    document.getElementById('addNotificationForm').reset();
    // 显示弹框
    showModal('addNotificationModal');
    // TODO: 加载用户列表到下拉框
    loadUsersToSelect('notificationUserId');
}

// 编辑通知
function editNotification(notificationId) {
    console.log('编辑通知:', notificationId);
    // TODO: 根据ID获取通知详情并填充表单
    // 暂时显示弹框
    showModal('editNotificationModal');
    document.getElementById('editNotificationId').value = notificationId;
    // TODO: 加载用户列表到下拉框
    loadUsersToSelect('editNotificationUserId');
    // TODO: 填充现有数据
    // loadNotificationData(notificationId);
}

// 查看通知详情
function viewNotification(notificationId) {
    console.log('查看通知详情:', notificationId);
    // TODO: 根据ID获取通知详情并显示
    // 暂时显示弹框
    showModal('viewNotificationModal');
    // TODO: 填充通知详情
    // loadNotificationDetail(notificationId);
    
    // 示例数据（实际应该从服务器获取）
    document.getElementById('viewNotificationId').textContent = notificationId;
    document.getElementById('viewNotificationUser').textContent = '示例用户';
    document.getElementById('viewNotificationContent').textContent = '这是一条示例通知内容...';
    document.getElementById('viewNotificationRead').textContent = '未读';
    document.getElementById('viewNotificationRead').className = 'status-badge status-unread';
    document.getElementById('viewNotificationCreatedAt').textContent = '2024-01-01 12:00:00';
}

// 删除通知
function deleteNotification(notificationId) {
    console.log('删除通知:', notificationId);
    if (confirm('确定要删除这条通知吗？')) {
        // TODO: 实现删除逻辑
        // 暂时显示提示
        alert('删除功能待实现，通知ID: ' + notificationId);
        // 实际实现时应该发送请求到服务器
        // window.location.href = '?action=deleteNotification&notificationId=' + notificationId;
    }
}

// 批量删除
function batchDelete() {
    console.log('批量删除通知');
    const selectedCheckboxes = document.querySelectorAll('.row-checkbox:checked');
    
    if (selectedCheckboxes.length === 0) {
        alert('请选择要删除的通知');
        return;
    }
    
    const notificationIds = Array.from(selectedCheckboxes).map(cb => cb.value);
    
    if (confirm(`确定要删除选中的 ${notificationIds.length} 条通知吗？`)) {
        // TODO: 实现批量删除逻辑
        // 暂时显示提示
        alert('批量删除功能待实现，选中的通知ID: ' + notificationIds.join(', '));
        // 实际实现时应该发送请求到服务器
        // const form = document.createElement('form');
        // form.method = 'post';
        // form.action = '';
        // const actionInput = document.createElement('input');
        // actionInput.type = 'hidden';
        // actionInput.name = 'action';
        // actionInput.value = 'batchDelete';
        // form.appendChild(actionInput);
        // notificationIds.forEach(id => {
        //     const idInput = document.createElement('input');
        //     idInput.type = 'hidden';
        //     idInput.name = 'notificationIds';
        //     idInput.value = id;
        //     form.appendChild(idInput);
        // });
        // document.body.appendChild(form);
        // form.submit();
    }
}

// 全选/取消全选
function toggleSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    
    rowCheckboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
    
    console.log('全选状态:', selectAllCheckbox.checked);
}

// 清除搜索
function clearSearch() {
    console.log('清除搜索条件');
    document.getElementById('searchInput').value = '';
    document.getElementById('readStatusSelect').value = '';
    // 重新加载页面
    window.location.href = window.location.pathname;
}

// 显示模态框
function showModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('show');
        modal.style.display = 'flex';
        // 聚焦到第一个输入框
        const firstInput = modal.querySelector('input, textarea, select');
        if (firstInput) {
            setTimeout(() => firstInput.focus(), 100);
        }
    }
}

// 关闭模态框
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('show');
        setTimeout(() => {
            modal.style.display = 'none';
        }, 300);
    }
}

// 关闭所有模态框
function closeAllModals() {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        modal.classList.remove('show');
        setTimeout(() => {
            modal.style.display = 'none';
        }, 300);
    });
}

// 加载用户列表到下拉框
function loadUsersToSelect(selectId) {
    console.log('加载用户列表到:', selectId);
    // TODO: 从服务器获取用户列表
    // 暂时添加示例数据
    const select = document.getElementById(selectId);
    if (select) {
        // 清空现有选项（保留第一个默认选项）
        while (select.children.length > 1) {
            select.removeChild(select.lastChild);
        }
        
        // 添加示例用户（实际应该从服务器获取）
        const sampleUsers = [
            { id: 1, username: '用户1' },
            { id: 2, username: '用户2' },
            { id: 3, username: '用户3' }
        ];
        
        sampleUsers.forEach(user => {
            const option = document.createElement('option');
            option.value = user.id;
            option.textContent = user.username;
            select.appendChild(option);
        });
    }
}

// 加载通知详情数据
function loadNotificationData(notificationId) {
    console.log('加载通知数据:', notificationId);
    // TODO: 从服务器获取通知详情
    // 暂时使用示例数据
    const sampleData = {
        id: notificationId,
        userId: 1,
        content: '这是一条示例通知内容...',
        read: false
    };
    
    // 填充编辑表单
    document.getElementById('editNotificationUserId').value = sampleData.userId;
    document.getElementById('editNotificationContent').value = sampleData.content;
    document.getElementById('editNotificationRead').value = sampleData.read.toString();
}

// 加载通知详情
function loadNotificationDetail(notificationId) {
    console.log('加载通知详情:', notificationId);
    // TODO: 从服务器获取通知详情
    // 暂时使用示例数据
    const sampleData = {
        id: notificationId,
        username: '示例用户',
        content: '这是一条示例通知内容，可能会很长，需要适当的换行和显示处理。',
        read: false,
        createdAt: '2024-01-01 12:00:00'
    };
    
    // 填充查看详情
    document.getElementById('viewNotificationId').textContent = sampleData.id;
    document.getElementById('viewNotificationUser').textContent = sampleData.username;
    document.getElementById('viewNotificationContent').textContent = sampleData.content;
    
    const readBadge = document.getElementById('viewNotificationRead');
    readBadge.textContent = sampleData.read ? '已读' : '未读';
    readBadge.className = 'status-badge ' + (sampleData.read ? 'status-read' : 'status-unread');
    
    document.getElementById('viewNotificationCreatedAt').textContent = sampleData.createdAt;
}

// 表单验证
function validateForm(formId) {
    const form = document.getElementById(formId);
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        const formGroup = field.closest('.form-group');
        if (!field.value.trim()) {
            formGroup.classList.add('error');
            isValid = false;
        } else {
            formGroup.classList.remove('error');
        }
    });
    
    return isValid;
}

// 提交表单前验证
document.addEventListener('submit', function(e) {
    const form = e.target;
    if (form.id === 'addNotificationForm' || form.id === 'editNotificationForm') {
        if (!validateForm(form.id)) {
            e.preventDefault();
            alert('请填写所有必填字段');
        }
    }
});

// 导航功能（从admin-layout.js继承）
function navigateTo(page) {
    console.log('导航到:', page);
    // TODO: 实现页面导航逻辑
    switch(page) {
        case 'message-center-maintenance':
            window.location.href = '/admin/pages/notification/';
            break;
        case 'notification-resend':
            // TODO: 导航到通知重发页面
            alert('通知重发页面待实现');
            break;
        default:
            alert('页面导航功能待实现: ' + page);
    }
}

// 切换侧边栏
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    
    if (sidebar && mainContent) {
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    }
}

// 切换子菜单
function toggleSubmenu(menuId) {
    const submenu = document.getElementById(menuId);
    if (submenu) {
        const isVisible = submenu.style.display === 'block';
        submenu.style.display = isVisible ? 'none' : 'block';
        
        // 更新箭头方向
        const menuItem = submenu.previousElementSibling;
        const arrow = menuItem.querySelector('.submenu-arrow');
        if (arrow) {
            arrow.textContent = isVisible ? '▼' : '▲';
        }
    }
}

// 用户菜单相关功能
function toggleUserMenu() {
    const dropdown = document.getElementById('userDropdown');
    if (dropdown) {
        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
    }
}

function reLogin() {
    window.location.href = '../../index.jsp';
}

function logout() {
    console.log('退出登录');
    if (confirm('确定要退出登录吗？')) {
        // TODO: 实现退出登录逻辑
        alert('退出登录功能待实现');
        // window.location.href = '/logout';
    }
}

// 点击页面其他地方关闭用户下拉菜单
document.addEventListener('click', function(e) {
    const userAvatar = document.getElementById('userAvatar');
    const userDropdown = document.getElementById('userDropdown');
    
    if (userAvatar && userDropdown && !userAvatar.contains(e.target) && !userDropdown.contains(e.target)) {
        userDropdown.style.display = 'none';
    }
});

// 工具函数：格式化日期
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
}

// 工具函数：截断文本
function truncateText(text, maxLength) {
    if (text.length <= maxLength) {
        return text;
    }
    return text.substring(0, maxLength) + '...';
}

// 工具函数：显示加载状态
function showLoading(element) {
    if (element) {
        element.classList.add('loading');
    }
}

// 工具函数：隐藏加载状态
function hideLoading(element) {
    if (element) {
        element.classList.remove('loading');
    }
}