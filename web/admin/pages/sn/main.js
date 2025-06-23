// SN码管理页面JavaScript

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('SN码管理页面已加载');
});

// 清除搜索
function clearSearch() {
    document.getElementById('searchInput').value = '';
    document.getElementById('searchOrderId').value = '';
    document.getElementById('statusSelect').value = '';
    
    // 重新加载页面，清除所有搜索参数
    window.location.href = window.location.pathname;
}