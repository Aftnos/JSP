<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String message = null;

    if ("save".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            boolean isAdmin = request.getParameter("isAdmin") != null;

            User u = new User();
            u.setId(id);
            u.setUsername(username);
            u.setPassword(password);
            u.setEmail(email);
            u.setPhone(phone);
            u.setAdmin(isAdmin);
            if (ServiceLayer.updateUser(u)) {
                message = "用户更新成功";
            } else {
                message = "用户更新失败";
            }
        } catch (Exception e) {
            message = "更新失败: " + e.getMessage();
        }
    } else if ("delete".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            message = ServiceLayer.deleteUserById(id) ? "用户删除成功" : "用户删除失败";
        } catch (Exception e) {
            message = "删除失败: " + e.getMessage();
        }
    } else if ("batchDelete".equals(action)) {
        String[] ids = request.getParameterValues("userIds");
        if (ids != null && ids.length > 0) {
            try {
                int[] intIds = new int[ids.length];
                for (int i = 0; i < ids.length; i++) {
                    intIds[i] = Integer.parseInt(ids[i]);
                }
                message = ServiceLayer.batchDeleteUsers(intIds) ? "批量删除成功" : "批量删除失败";
            } catch (Exception e) {
                message = "批量删除失败: " + e.getMessage();
            }
        }
    }

    User editUser = null;
    String editId = request.getParameter("editId");
    if (editId != null) {
        try {
            editUser = ServiceLayer.getUserById(Integer.parseInt(editId));
        } catch (Exception ignored) {}
    }

List<User> users = ServiceLayer.getAllUsers();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户资料管理 - 小米商城管理系统</title>
    <link rel="stylesheet" type="text/css" href="../../static/css/admin-layout.css">
    <link rel="stylesheet" type="text/css" href="../../css/main.css">
    <link rel="stylesheet" href="./main.css">
    <link rel="stylesheet" href="./modal.css">
</head>
<body>
<div class="admin-container">
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo">小米商城管理系统</div>
            <button class="sidebar-toggle" onclick="toggleSidebar()">
                <i class="icon">☰</i>
            </button>
        </div>
        <div class="sidebar-menu">
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
            <div class="menu-item" onclick="toggleSubmenu('product-menu')">
                <div class="icon">📦</div>
                <span class="text">商品管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="product-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('product-management')">
                    <span class="text">商品管理</span>
                </div>
            </div>
            <div class="menu-item" onclick="toggleSubmenu('order-menu')">
                <div class="icon">📋</div>
                <span class="text">订单管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="order-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('order-global-query')">
                    <span class="text">全局查询</span>
                </div>
            </div>
            <div class="menu-item" onclick="toggleSubmenu('sn-menu')">
                <div class="icon">🔢</div>
                <span class="text">SN码管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="sn-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('sn-global-query')">
                    <span class="text">全局查询</span>
                </div>
            </div>
            <div class="menu-item" onclick="toggleSubmenu('sn-binding-menu')">
                <div class="icon">🔗</div>
                <span class="text">SN绑定管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="sn-binding-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('sn-forced-unbinding')">
                    <span class="text">全局查询</span>
                </div>
            </div>
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
            <div class="menu-item" onclick="toggleSubmenu('notification-menu')">
                <div class="icon">🔔</div>
                <span class="text">系统通知管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="notification-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('message-center-maintenance')">
                    <span class="text">消息中心维护</span>
                </div>
            </div>
        </div>
    </div>
    <div class="main-content" id="mainContent">
        <div class="top-header">
            <div class="user-info">
                <div class="user-text">
                    <div class="greeting">Hi, <span id="username">小锦鲤</span></div>
                    <div class="welcome-text">欢迎进入小米商城管理系统</div>
                </div>
                <div class="user-avatar-container">
                    <img src="../../images/default-avatar.png" alt="用户头像" class="user-avatar" id="userAvatar" onclick="toggleUserMenu()" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNFNUU1RTUiLz4KPGNpcmNsZSBjeD0iMjAiIGN5PSIxNiIgcj0iNiIgZmlsbD0iIzk5OTk5OSIvPgo8cGF0aCBkPSJNMzAgMzJDMzAgMjYuNDc3MSAyNS41MjI5IDIyIDIwIDIyQzE0LjQ3NzEgMjIgMTAgMjYuNDc3MSAxMCAzMkgzMFoiIGZpbGw9IiM5OTk5OTkiLz4KPC9zdmc+'">
                    <div class="user-dropdown" id="userDropdown">
                        <div class="dropdown-item" onclick="reLogin()">
                            <i class="icon">🔄</i>
                            <span>重新登录</span>
                        </div>
                        <div class="dropdown-item" onclick="logout()">
                            <i class="icon">🚪</i>
                            <span>退出登录</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="page-content" id="pageContent">
            <div class="page-header">
                <h1 class="page-title">用户资料管理</h1>
                <p class="page-subtitle">管理系统用户的账号信息和权限</p>
            </div>
            <% if (message != null) { %>
            <div class="alert alert-info" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; font-family: monospace; white-space: pre-line;">
                <strong>操作结果:</strong><br>
                <%= message %>
            </div>
            <% } %>
            <div class="toolbar">
                <div class="search-section">
                    <input type="text" class="search-input" placeholder="搜索用户ID或用户名..." id="searchInput">
                    <button class="btn btn-primary" onclick="searchUsers()">🔍 搜索</button>
                </div>
                <div class="action-buttons">
                    <button class="btn btn-danger" onclick="batchDelete()">🗑️ 批量删除</button>
                </div>
            </div>
            <div class="data-table">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th width="50"><input type="checkbox" class="checkbox" id="selectAll" onchange="toggleSelectAll()"></th>
                                <th width="80">序号</th>
                                <th width="100">ID</th>
                                <th width="150">用户名</th>
                                <th width="200">邮箱</th>
                                <th width="150">电话</th>
                                <th width="100">管理员</th>
                                <th width="200">操作</th>
                            </tr>
                        </thead>
                        <tbody id="userTableBody">
                        <% if (users != null && !users.isEmpty()) { int idx=0; for (User u : users) { %>
                            <tr>
                                <td><input type="checkbox" class="checkbox row-checkbox" value="<%= u.getId() %>"></td>
                                <td><%= ++idx %></td>
                                <td><%= u.getId() %></td>
                                <td><%= u.getUsername() %></td>
                                <td><%= u.getEmail() == null ? "" : u.getEmail() %></td>
                                <td><%= u.getPhone() == null ? "" : u.getPhone() %></td>
                                <td><%= u.isAdmin() ? "是" : "否" %></td>
                                <td>
                                    <div class="table-actions">
                                        <button class="btn btn-primary btn-sm" onclick="editUser(<%= u.getId() %>)">编辑</button>
                                        <button class="btn btn-danger btn-sm" onclick="deleteUser(<%= u.getId() %>)">删除</button>
                                    </div>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="8" style="text-align: center; padding: 20px;">暂无用户数据</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <div class="pagination">
                    <div class="pagination-info">
                        显示第 1-<%= users != null ? users.size() : 0 %> 条，共 <%= users != null ? users.size() : 0 %> 条记录
                    </div>
                    <div class="pagination-controls">
                        <button class="page-btn" disabled>上一页</button>
                        <button class="page-btn active">1</button>
                        <button class="page-btn" disabled>下一页</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="editUserModal" style="display: none;">
    <div class="modal-content">
        <div class="modal-header">
            <h3>编辑用户信息</h3>
            <span class="close" onclick="closeEditModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form id="editUserForm">
                <input type="hidden" id="editUserId" name="userId">
                <div class="form-group">
                    <label for="editUsername">用户名：</label>
                    <input type="text" id="editUsername" name="username" class="form-control" required>
                    <span class="error-message" id="usernameError"></span>
                </div>
                <div class="form-group">
                    <label for="editPassword">密码：</label>
                    <input type="password" id="editPassword" name="password" class="form-control">
                    <span class="error-message" id="passwordError"></span>
                </div>
                <div class="form-group">
                    <label for="editEmail">邮箱：</label>
                    <input type="email" id="editEmail" name="email" class="form-control">
                    <span class="error-message" id="emailError"></span>
                </div>
                <div class="form-group">
                    <label for="editPhone">电话：</label>
                    <input type="text" id="editPhone" name="phone" class="form-control">
                    <span class="error-message" id="phoneError"></span>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeEditModal()">取消</button>
            <button type="button" class="btn btn-primary" onclick="saveUserChanges()">保存</button>
        </div>
    </div>
</div>

<script src="../../js/main.js"></script>
<script src="./main.js"></script>
</body>
</html>
