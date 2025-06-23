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
    const user = allUsersData.find(u => u.id === userId);
    if (!user) {
        alert('未找到用户信息！');
        return;
    }
    document.getElementById('editUserId').value = user.id;
    document.getElementById('editUsername').value = user.username;
    document.getElementById('editPassword').value = '';
    document.getElementById('editEmail').value = user.email || '';
    document.getElementById('editPhone').value = user.phone || '';
    clearErrorMessages();
    document.getElementById('editUserModal').style.display = 'block';
}

// 查看用户
function viewUser(userId) {
    console.log('查看用户:', userId);
    // TODO: 实现查看用户逻辑
    alert('查看用户功能待实现: ' + userId);
}

// 删除用户
function deleteUser(userId) {
    console.log('删除用户按钮被点击:', userId);
    console.log("----------------------------------------------------------------------");
    
    if (confirm('确定要删除这个用户吗？删除后无法恢复！')) {
        // 发送删除请求
        fetch('./delete_user.jsp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=single&userId=${userId}`
        })
        .then(resp => resp.text())
        .then(text => {
            let data;
            try { data = JSON.parse(text); } catch (e) {
                throw new Error('Invalid JSON: ' + text);
            }
            if (data.success) {
                alert(data.message);
                // 刷新页面重新加载数据
                window.location.reload();
            } else {
                alert('删除失败: ' + data.message);
            }
        })
        .catch(error => {
            console.error('删除用户时发生错误:', error);
            alert('删除用户时发生错误，请稍后重试');
        });
    }
}

// 批量删除
function batchDelete() {
    console.log('批量删除按钮被点击');
    
    // 获取所有选中的用户ID
    const selectedCheckboxes = document.querySelectorAll('.row-checkbox:checked');
    
    if (selectedCheckboxes.length === 0) {
        alert('请先选择要删除的用户');
        return;
    }
    
    const selectedUserIds = Array.from(selectedCheckboxes).map(checkbox => checkbox.value);
    
    if (confirm(`确定要删除选中的 ${selectedUserIds.length} 个用户吗？删除后无法恢复！`)) {
        // 构建请求参数
        const formData = new FormData();
        formData.append('action', 'batch');
        selectedUserIds.forEach(userId => {
            formData.append('userIds[]', userId);
        });
        
        // 发送批量删除请求
        fetch('./delete_user.jsp', {
            method: 'POST',
            body: formData
        })
        .then(resp => resp.text())
        .then(text => {
            let data;
            try { data = JSON.parse(text); } catch (e) {
                throw new Error('Invalid JSON: ' + text);
            }
            if (data.success) {
                alert(data.message);
                // 刷新页面重新加载数据
                window.location.reload();
            } else {
                alert('批量删除失败: ' + data.message);
            }
        })
        .catch(error => {
            console.error('批量删除时发生错误:', error);
            alert('批量删除时发生错误，请稍后重试');
        });
    }
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
    const userId = parseInt(document.getElementById('editUserId').value);

    if (!validateUserForm()) {
        return;
    }

    const username = document.getElementById('editUsername').value.trim();
    const password = document.getElementById('editPassword').value.trim();
    const email = document.getElementById('editEmail').value.trim();
    const phone = document.getElementById('editPhone').value.trim();

    if (checkUsernameExists(username, userId)) {
        document.getElementById('usernameError').textContent = '用户名已存在';
        return;
    }

    const params = new URLSearchParams();
    params.append('userId', userId);
    params.append('username', username);
    params.append('password', password);
    params.append('email', email);
    params.append('phone', phone);

    fetch('./update_user.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
        .then(resp => resp.text())
        .then(text => {
            let data;
            try { data = JSON.parse(text); } catch (e) {
                throw new Error('Invalid JSON: ' + text);
            }
            if (data.success) {
                alert(data.message);
                window.location.reload();
            } else {
                alert('编辑失败: ' + data.message);
            }
        })
        .catch(error => {
            console.error('更新用户时发生错误:', error);
            alert('更新用户时发生错误，请稍后重试');
        });
}

// 调用后端API更新用户

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