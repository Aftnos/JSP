// 用户管理相关JavaScript函数

// 存储所有用户数据
let allUsersData = [];
let filteredUsersData = [];

// 搜索用户
function searchUsers() {
    const keyword = document.getElementById('searchInput').value.trim();
    console.log('搜索用户:', keyword);
    
    if (keyword === '') {
        // 如果搜索框为空，显示所有用户
        filteredUsersData = [...allUsersData];
    } else {
        // 根据用户ID和用户名进行搜索
        filteredUsersData = allUsersData.filter(user => {
            const userId = user.id.toString();
            const username = user.username.toLowerCase();
            const searchKeyword = keyword.toLowerCase();
            
            return userId.includes(searchKeyword) || username.includes(searchKeyword);
        });
    }
    
    // 渲染搜索结果
    renderUserTable(filteredUsersData);
    
    // 搜索后清空输入框
    document.getElementById('searchInput').value = '';
    
    // 更新分页信息
    updatePaginationInfo(filteredUsersData.length);
}

// 编辑用户
function editUser(userId) {
    console.log('编辑用户:', userId);
    
    // 从用户数据中找到对应的用户
    const user = allUsersData.find(u => u.id === userId);
    if (!user) {
        alert('未找到用户信息');
        return;
    }
    
    // 填充表单数据
    document.getElementById('editUserId').value = user.id;
    document.getElementById('editUsername').value = user.username;
    document.getElementById('editPassword').value = ''; // 密码字段留空，需要用户重新输入
    document.getElementById('editEmail').value = user.email || '';
    document.getElementById('editPhone').value = user.phone || '';
    
    // 清空错误信息
    clearErrorMessages();
    
    // 显示弹框
    document.getElementById('editUserModal').style.display = 'block';
}

// 查看用户
function viewUser(userId) {
    console.log('查看用户:', userId);
    // TODO: 实现查看用户逻辑
    alert('查看用户功能待实现: ' + userId);
}

// 删除用户（占位函数）
function deleteUser(userId) {
    console.log('删除用户按钮被点击:', userId);
    alert('删除功能暂未实现');
}

// 批量删除（占位函数）
function batchDelete() {
    console.log('批量删除按钮被点击');
    alert('批量删除功能暂未实现');
}

// 全选/取消全选
function toggleSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    
    rowCheckboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
}













// 搜索框回车事件
document.getElementById('searchInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        searchUsers();
    }
});

// 渲染用户表格
function renderUserTable(users) {
    const tbody = document.getElementById('userTableBody');
    tbody.innerHTML = '';
    
    if (users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; padding: 20px;">暂无用户数据</td></tr>';
        return;
    }
    
    users.forEach((user, index) => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>
                <input type="checkbox" class="checkbox row-checkbox" value="${user.id}">
            </td>
            <td>${index + 1}</td>
            <td>${user.id}</td>
            <td>${user.username}</td>
            <td>${user.email || ''}</td>
            <td>${user.phone || ''}</td>
            <td>
                <div class="table-actions">
                    <button class="btn btn-primary btn-sm" onclick="editUser(${user.id})">
                        编辑
                    </button>
                    <button class="btn btn-success btn-sm" onclick="viewUser(${user.id})">
                        查看
                    </button>
                    <button class="btn btn-danger btn-sm" onclick="deleteUser(${user.id})">
                        删除
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// 更新分页信息
function updatePaginationInfo(count) {
    const paginationInfo = document.querySelector('.pagination-info');
    paginationInfo.textContent = `显示第 1-${count} 条，共 ${count} 条记录`;
}

// 初始化用户数据
function initializeUserData() {
    // 从页面中提取用户数据
    const rows = document.querySelectorAll('#userTableBody tr');
    allUsersData = [];
    
    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        if (cells.length > 1) { // 确保不是"暂无数据"行
            const user = {
                id: parseInt(cells[2].textContent),
                username: cells[3].textContent,
                email: cells[4].textContent,
                phone: cells[5].textContent
            };
            allUsersData.push(user);
        }
    });
    
    filteredUsersData = [...allUsersData];
    console.log('初始化用户数据:', allUsersData);
}

// 关闭编辑弹框
function closeEditModal() {
    document.getElementById('editUserModal').style.display = 'none';
    clearErrorMessages();
}

// 清空错误信息
function clearErrorMessages() {
    const errorElements = document.querySelectorAll('.error-message');
    errorElements.forEach(element => {
        element.textContent = '';
    });
}

// 表单验证
function validateUserForm() {
    let isValid = true;
    clearErrorMessages();
    
    const username = document.getElementById('editUsername').value.trim();
    const password = document.getElementById('editPassword').value.trim();
    const email = document.getElementById('editEmail').value.trim();
    const phone = document.getElementById('editPhone').value.trim();
    
    // 用户名验证
    if (!username) {
        document.getElementById('usernameError').textContent = '用户名不能为空';
        isValid = false;
    } else if (username.length < 3 || username.length > 20) {
        document.getElementById('usernameError').textContent = '用户名长度应在3-20个字符之间';
        isValid = false;
    } else if (!/^[a-zA-Z0-9_]+$/.test(username)) {
        document.getElementById('usernameError').textContent = '用户名只能包含字母、数字和下划线';
        isValid = false;
    }
    
    // 密码验证（编辑时密码可以为空，表示不修改密码）
    if (password && password.length < 6) {
        document.getElementById('passwordError').textContent = '密码长度不能少于6位';
        isValid = false;
    }
    
    // 邮箱验证（如果填写了）
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        document.getElementById('emailError').textContent = '邮箱格式不正确';
        isValid = false;
    }
    
    // 电话号码验证（如果填写了）
    if (phone && !/^1[3-9]\d{9}$/.test(phone)) {
        document.getElementById('phoneError').textContent = '请输入正确的手机号码';
        isValid = false;
    }
    
    return isValid;
}

// 检查用户名是否已存在
function checkUsernameExists(username, currentUserId) {
    return allUsersData.some(user => user.username === username && user.id !== currentUserId);
}

// 保存用户更改
function saveUserChanges() {
    // 表单验证
    if (!validateUserForm()) {
        return;
    }
    
    const userId = parseInt(document.getElementById('editUserId').value);
    const username = document.getElementById('editUsername').value.trim();
    const password = document.getElementById('editPassword').value.trim();
    const email = document.getElementById('editEmail').value.trim();
    const phone = document.getElementById('editPhone').value.trim();
    
    // 检查用户名是否已存在
    if (checkUsernameExists(username, userId)) {
        document.getElementById('usernameError').textContent = '用户名已存在，请选择其他用户名';
        return;
    }
    
    // 构造用户数据
    const userData = {
        id: userId,
        username: username,
        password: password,
        email: email || null,
        phone: phone || null
    };
    
    // 调用后端API更新用户
    updateUserInDatabase(userData);
}

// 调用后端API更新用户
function updateUserInDatabase(userData) {
    // 创建表单数据
    const formData = new FormData();
    formData.append('action', 'updateUser');
    formData.append('userId', userData.id);
    formData.append('username', userData.username);
    formData.append('password', userData.password);
    formData.append('email', userData.email || '');
    formData.append('phone', userData.phone || '');
    
    // 发送AJAX请求
    console.log('发送用户更新请求:', userData);
    fetch('../api/user-management.jsp', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        console.log('响应状态:', response.status);
        if (!response.ok) {
            throw new Error('网络响应不正常: ' + response.status);
        }
        return response.text();
    })
    .then(text => {
        console.log('服务器响应:', text);
        try {
            const data = JSON.parse(text);
            if (data.success) {
                alert('用户信息更新成功！');
                closeEditModal();
                // 刷新页面数据
                location.reload();
            } else {
                alert('更新失败：' + (data.message || '未知错误'));
            }
        } catch (e) {
            console.error('解析JSON失败:', e);
            alert('服务器响应格式错误');
        }
    })
    .catch(error => {
        console.error('更新用户时发生错误:', error);
        alert('更新失败，请稍后重试: ' + error.message);
    });
}

// 页面加载完成后的初始化
document.addEventListener('DOMContentLoaded', function () {
    console.log('用户资料管理页面加载完成');
    // 初始化用户数据
    initializeUserData();
    
    // 点击弹框外部关闭弹框
    window.onclick = function(event) {
        const modal = document.getElementById('editUserModal');
        if (event.target === modal) {
            closeEditModal();
        }
    };
});