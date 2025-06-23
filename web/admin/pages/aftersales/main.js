// 售后管理页面JavaScript

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('售后管理页面加载完成');
    initializePage();
});

// 初始化页面
function initializePage() {
    // 设置当前菜单项为激活状态
    setActiveMenuItem();
    
    // 绑定事件监听器
    bindEventListeners();
    
    // 初始化表格
    initializeTable();
}

// 设置当前菜单项为激活状态
function setActiveMenuItem() {
    // 展开售后管理菜单
    const aftersalesMenu = document.getElementById('aftersales-menu');
    if (aftersalesMenu) {
        aftersalesMenu.style.display = 'block';
    }
    
    // 设置当前页面为激活状态
    const menuItems = document.querySelectorAll('.submenu-item');
    menuItems.forEach(item => {
        if (item.textContent.includes('工单全流程控制')) {
            item.classList.add('active');
        }
    });
}

// 绑定事件监听器
function bindEventListeners() {
    // 绑定模态框关闭事件
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal')) {
            closeAllModals();
        }
    });
    
    // 绑定ESC键关闭模态框
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeAllModals();
        }
    });
}

// 初始化表格
function initializeTable() {
    // 添加表格行点击事件
    const tableRows = document.querySelectorAll('#aftersalesTableBody tr');
    tableRows.forEach(row => {
        if (!row.querySelector('td[colspan]')) { // 排除空数据行
            row.addEventListener('click', function(e) {
                // 如果点击的是操作按钮，不触发行点击事件
                if (e.target.closest('.table-actions')) {
                    return;
                }
                
                // 获取工单ID并显示详情
                const firstCell = row.querySelector('td:first-child');
                if (firstCell) {
                    // 这里需要根据实际数据结构获取工单ID
                    // 临时使用行索引作为ID
                    const rowIndex = Array.from(row.parentNode.children).indexOf(row) + 1;
                    showAfterSaleDetail(rowIndex);
                }
            });
        }
    });
}

// 清除搜索
function clearSearch() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.value = '';
    }
    
    // 重新加载页面以清除搜索结果
    window.location.href = window.location.pathname;
}

// 刷新数据
function refreshData() {
    // 显示加载提示
    showLoadingMessage('正在刷新数据...');
    
    // 重新加载页面
    setTimeout(() => {
        window.location.reload();
    }, 500);
}

// 显示售后详情
function showAfterSaleDetail(afterSaleId) {
    console.log('显示售后详情，ID:', afterSaleId);
    
    // 模拟获取售后详情数据
    const mockData = {
        id: afterSaleId,
        username: '测试用户' + afterSaleId,
        snCode: 'SN' + String(afterSaleId).padStart(8, '0'),
        type: '退货申请',
        status: '待处理',
        reason: '商品质量问题，收到商品后发现有明显瑕疵，不符合商品描述，希望能够退货处理。',
        remark: '用户反馈商品包装完好，但商品本身存在质量问题，已拍照留证。',
        createTime: '2024-01-15 10:30:00',
        updateTime: '2024-01-15 10:30:00'
    };
    
    // 填充详情数据
    document.getElementById('detailAfterSaleId').textContent = mockData.id;
    document.getElementById('detailUsername').textContent = mockData.username;
    document.getElementById('detailSnCode').textContent = mockData.snCode;
    document.getElementById('detailType').textContent = mockData.type;
    document.getElementById('detailStatus').innerHTML = `<span class="status-badge status-${mockData.status}">${mockData.status}</span>`;
    document.getElementById('detailReason').textContent = mockData.reason;
    document.getElementById('detailRemark').textContent = mockData.remark;
    document.getElementById('detailCreateTime').textContent = mockData.createTime;
    document.getElementById('detailUpdateTime').textContent = mockData.updateTime;
    
    // 显示详情弹框
    const modal = document.getElementById('afterSaleDetailModal');
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
}

// 关闭售后详情弹框
function closeAfterSaleDetailModal() {
    const modal = document.getElementById('afterSaleDetailModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

// 编辑售后工单
function editAfterSale() {
    // 关闭详情弹框
    closeAfterSaleDetailModal();
    
    // 获取当前工单ID
    const afterSaleId = document.getElementById('detailAfterSaleId').textContent;
    
    // 显示更新状态弹框
    updateStatus(afterSaleId);
}

// 更新状态
function updateStatus(afterSaleId) {
    console.log('更新状态，ID:', afterSaleId);
    
    // 设置工单ID
    document.getElementById('updateAfterSaleId').value = afterSaleId;
    
    // 清空表单
    document.getElementById('newStatus').value = '';
    document.getElementById('statusRemark').value = '';
    
    // 清空错误信息
    document.getElementById('statusError').textContent = '';
    
    // 显示更新状态弹框
    const modal = document.getElementById('updateStatusModal');
    if (modal) {
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
}

// 关闭更新状态弹框
function closeUpdateStatusModal() {
    const modal = document.getElementById('updateStatusModal');
    if (modal) {
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

// 保存状态更新
function saveStatusUpdate() {
    // 获取表单数据
    const afterSaleId = document.getElementById('updateAfterSaleId').value;
    const newStatus = document.getElementById('newStatus').value;
    const statusRemark = document.getElementById('statusRemark').value;
    
    // 验证表单
    if (!newStatus) {
        document.getElementById('statusError').textContent = '请选择新状态';
        return;
    }
    
    // 清空错误信息
    document.getElementById('statusError').textContent = '';
    
    // 显示加载状态
    showLoadingMessage('正在更新状态...');
    
    // 模拟提交表单
    setTimeout(() => {
        // 创建表单并提交
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '';
        
        // 添加表单字段
        const fields = {
            'action': 'updateStatus',
            'afterSaleId': afterSaleId,
            'newStatus': newStatus,
            'statusRemark': statusRemark
        };
        
        for (const [key, value] of Object.entries(fields)) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = value;
            form.appendChild(input);
        }
        
        document.body.appendChild(form);
        form.submit();
    }, 1000);
}

// 关闭订单
function closeOrder(afterSaleId) {
    console.log('关闭订单，ID:', afterSaleId);
    
    // 确认对话框
    if (confirm('确定要关闭这个售后工单吗？关闭后将无法再次处理。')) {
        // 显示加载状态
        showLoadingMessage('正在关闭订单...');
        
        // 模拟提交表单
        setTimeout(() => {
            // 创建表单并提交
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '';
            
            // 添加表单字段
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'closeOrder';
            form.appendChild(actionInput);
            
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'afterSaleId';
            idInput.value = afterSaleId;
            form.appendChild(idInput);
            
            document.body.appendChild(form);
            form.submit();
        }, 1000);
    }
}

// 关闭所有模态框
function closeAllModals() {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        modal.style.display = 'none';
    });
    document.body.style.overflow = 'auto';
}

// 显示加载消息
function showLoadingMessage(message) {
    // 创建加载提示
    const loadingDiv = document.createElement('div');
    loadingDiv.id = 'loadingMessage';
    loadingDiv.style.cssText = `
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0, 0, 0, 0.8);
        color: white;
        padding: 20px 30px;
        border-radius: 8px;
        z-index: 9999;
        font-size: 16px;
        text-align: center;
    `;
    loadingDiv.innerHTML = `
        <div style="margin-bottom: 10px;">⏳</div>
        <div>${message}</div>
    `;
    
    // 移除已存在的加载提示
    const existingLoading = document.getElementById('loadingMessage');
    if (existingLoading) {
        existingLoading.remove();
    }
    
    document.body.appendChild(loadingDiv);
}

// 隐藏加载消息
function hideLoadingMessage() {
    const loadingDiv = document.getElementById('loadingMessage');
    if (loadingDiv) {
        loadingDiv.remove();
    }
}

// 导航到指定页面
function navigateTo(page) {
    console.log('导航到页面:', page);
    
    // 根据页面名称导航到对应页面
    const pageMap = {
        'user-profile-management': '../user/index.jsp',
        'address-management': '../user/address.jsp',
        'product-management': '../product/index.jsp',
        'order-global-query': '../order/query.jsp',
        'sn-global-query': '../sn/index.jsp',
        'sn-forced-unbinding': '../sn-binding/index.jsp',
        'aftersales-workflow-control': './index.jsp',
        'message-center-maintenance': '../notification/index.jsp'
    };
    
    const url = pageMap[page];
    if (url) {
        window.location.href = url;
    } else {
        console.warn('未找到页面:', page);
        alert('页面正在开发中...');
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
        if (menuItem) {
            const arrow = menuItem.querySelector('.submenu-arrow');
            if (arrow) {
                arrow.textContent = isVisible ? '▼' : '▲';
            }
        }
    }
}

// 切换用户菜单
function toggleUserMenu() {
    const dropdown = document.getElementById('userDropdown');
    if (dropdown) {
        const isVisible = dropdown.style.display === 'block';
        dropdown.style.display = isVisible ? 'none' : 'block';
    }
}

// 重新登录
function reLogin() {
    if (confirm('确定要重新登录吗？')) {
        window.location.href = '../../index.jsp';
    }
}

// 退出登录
function logout() {
    if (confirm('确定要退出登录吗？')) {
        window.location.href = '../../../index/logout.jsp';
    }
}

// 工具函数：格式化日期
function formatDate(dateString) {
    if (!dateString) return '';
    
    const date = new Date(dateString);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

// 工具函数：截断文本
function truncateText(text, maxLength) {
    if (!text) return '';
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
}

// 工具函数：获取状态样式类
function getStatusClass(status) {
    const statusMap = {
        '待处理': 'status-待处理',
        '处理中': 'status-处理中',
        '已完成': 'status-已完成',
        '已关闭': 'status-已关闭',
        '已拒绝': 'status-已拒绝'
    };
    
    return statusMap[status] || 'status-unknown';
}

// 工具函数：显示提示消息
function showMessage(message, type = 'info') {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type}`;
    alertDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        padding: 15px;
        border-radius: 4px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    `;
    alertDiv.textContent = message;
    
    document.body.appendChild(alertDiv);
    
    // 3秒后自动移除
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.parentNode.removeChild(alertDiv);
        }
    }, 3000);
}

// 错误处理
window.addEventListener('error', function(e) {
    console.error('页面错误:', e.error);
    hideLoadingMessage();
});

// 页面卸载时清理
window.addEventListener('beforeunload', function() {
    hideLoadingMessage();
    closeAllModals();
});