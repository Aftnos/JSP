<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Notification" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // 获取搜索参数
    String searchKeyword = request.getParameter("searchKeyword");
    String searchReadStatus = request.getParameter("searchReadStatus");
    
    // 获取分页参数
    String pageStr = request.getParameter("page");
    int currentPage = 1;
    int pageSize = 10; // 每页显示10条记录
    
    if (pageStr != null && !pageStr.trim().isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageStr);
            if (currentPage < 1) {
                currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    // 处理各种操作
    String action = request.getParameter("action");
    String operationResult = null;
    
    // 处理添加通知
    if ("add".equals(action)) {
        try {
            String userIdStr = request.getParameter("userId");
            String content = request.getParameter("content");
            
            if (userIdStr != null && content != null && !content.trim().isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                
                Notification notification = new Notification();
                notification.setUserId(userId);
                notification.setContent(content.trim());
                notification.setRead(false);
                notification.setCreatedAt(new java.util.Date());
                
                boolean result = ServiceLayer.sendNotification(notification);
                
                if (result) {
                    operationResult = "通知添加成功！";
                } else {
                    operationResult = "通知添加失败！";
                }
            } else {
                operationResult = "请填写完整的通知信息！";
            }
        } catch (Exception e) {
            operationResult = "添加通知失败：" + e.getMessage();
        }
    } else if ("deleteNotification".equals(action)) {
        // 删除通知
        try {
            String notificationIdStr = request.getParameter("notificationId");
            
            if (notificationIdStr != null) {
                int notificationId = Integer.parseInt(notificationIdStr);
                
                boolean result = ServiceLayer.deleteNotification(notificationId);
                
                if (result) {
                    operationResult = "通知删除成功！";
                } else {
                    operationResult = "通知删除失败！";
                }
            } else {
                operationResult = "请选择要删除的通知！";
            }
        } catch (Exception e) {
            operationResult = "删除通知失败：" + e.getMessage();
        }
    } else if ("batchDelete".equals(action)) {
        // 批量删除
        try {
            String[] notificationIds = request.getParameterValues("notificationIds");
            
            if (notificationIds != null && notificationIds.length > 0) {
                int successCount = 0;
                for (String idStr : notificationIds) {
                    try {
                        int notificationId = Integer.parseInt(idStr);
                        if (ServiceLayer.deleteNotification(notificationId)) {
                            successCount++;
                        }
                    } catch (Exception e) {
                        // 忽略单个删除失败
                    }
                }
                operationResult = "批量删除完成！成功删除 " + successCount + "/" + notificationIds.length + " 条通知。";
            } else {
                operationResult = "请选择要删除的通知！";
            }
        } catch (Exception e) {
            operationResult = "批量删除失败：" + e.getMessage();
        }
    }
    
    // 获取所有用户数据用于显示用户名和搜索
    List<User> allUsers = new ArrayList<>();
    try {
        allUsers = ServiceLayer.getAllUsers();
    } catch (Exception e) {
        // 处理异常
    }
    
    // 创建用户映射，方便显示用户名
    java.util.Map<Integer, String> userMap = new java.util.HashMap<>();
    if (allUsers != null) {
        for (User user : allUsers) {
            userMap.put(user.getId(), user.getUsername());
        }
    }
    
    // 获取所有通知数据
    List<Notification> allNotifications = new ArrayList<>();
    try {
        // 获取所有用户的通知
        if (allUsers != null) {
            for (User user : allUsers) {
                List<Notification> userNotifications = ServiceLayer.getNotifications(user.getId());
                if (userNotifications != null) {
                    allNotifications.addAll(userNotifications);
                }
            }
        }
    } catch (Exception e) {
        // 处理异常
    }
    
    // 根据搜索条件过滤通知
    List<Notification> filteredNotifications = new ArrayList<>();
    if (allNotifications != null) {
        for (Notification notification : allNotifications) {
            boolean matchKeyword = true;
            boolean matchStatus = true;
            
            // 关键词搜索（搜索通知内容和用户名）
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = searchKeyword.trim().toLowerCase();
                String content = notification.getContent() != null ? notification.getContent().toLowerCase() : "";
                String username = userMap.get(notification.getUserId());
                username = username != null ? username.toLowerCase() : "";
                
                matchKeyword = content.contains(keyword) || username.contains(keyword);
            }
            
            // 状态搜索
            if (searchReadStatus != null && !searchReadStatus.trim().isEmpty()) {
                if ("true".equals(searchReadStatus)) {
                    matchStatus = notification.isRead();
                } else if ("false".equals(searchReadStatus)) {
                    matchStatus = !notification.isRead();
                }
            }
            
            if (matchKeyword && matchStatus) {
                filteredNotifications.add(notification);
            }
        }
    }
    
    // 分页处理
    int totalNotifications = (filteredNotifications != null) ? filteredNotifications.size() : 0;
    int totalPages = (int) Math.ceil((double) totalNotifications / pageSize);
    
    // 确保当前页不超过总页数
    if (currentPage > totalPages && totalPages > 0) {
        currentPage = totalPages;
    }
    
    // 计算分页数据
    List<Notification> displayNotifications = new ArrayList<>();
    if (filteredNotifications != null && !filteredNotifications.isEmpty()) {
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalNotifications);
        
        if (startIndex < totalNotifications) {
            displayNotifications = filteredNotifications.subList(startIndex, endIndex);
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>消息中心维护 - 小米商城管理系统</title>
    <!-- 引入基础样式 -->
    <link rel="stylesheet" type="text/css" href="../../static/css/admin-layout.css">
    <!-- 引入主样式 -->
    <link rel="stylesheet" type="text/css" href="../../css/main.css">
    <link rel="stylesheet" href="./main.css">
    <!-- 引入弹框样式 -->
    <link rel="stylesheet" href="./modal.css">
</head>
<body>
   <!-- 后台管理系统容器 -->
   <div class="admin-container">
    <!-- 侧边栏 -->
    <div class="sidebar" id="sidebar">
        <!-- 侧边栏头部 -->
        <div class="sidebar-header">
            <div class="logo">小米商城管理系统</div>
            <button class="sidebar-toggle" onclick="toggleSidebar()">
                <i class="icon">☰</i>
            </button>
        </div>

        <!-- 菜单容器 -->
        <div class="sidebar-menu">
            <!-- 用户管理 -->
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

            <!-- 商品管理 -->
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

            <!-- 订单管理 -->
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

            <!-- SN码管理 -->
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

            <!-- SN绑定管理 -->
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

            <!-- 售后管理 -->
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

            <!-- 系统通知管理 -->
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
        
        <!-- 主内容区域 -->
        <div class="main-content" id="mainContent">
            <!-- 顶部用户信息栏 -->
            <div class="top-header">
                <div class="user-info">
                    <div class="user-text">
                        <div class="greeting">Hi, <span id="username">小锦鲤</span></div>
                        <div class="welcome-text">欢迎进入小米商城管理系统</div>
                    </div>
                    <div class="user-avatar-container">
                        <img src="../../images/default-avatar.png" alt="用户头像" class="user-avatar" id="userAvatar" onclick="toggleUserMenu()" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNFNUU1RTUiLz4KPGNpcmNsZSBjeD0iMjAiIGN5PSIxNiIgcj0iNiIgZmlsbD0iIzk5OTk5OSIvPgo8cGF0aCBkPSJNMzAgMzJDMzAgMjYuNDc3MSAyNS41MjI5IDIyIDIwIDIyQzE0LjQ3NzEgMjIgMTAgMjYuNDc3MSAxMCAzMkgzMFoiIGZpbGw9IiM5OTk5OTkiLz4KPC9zdmc+'">
                        <!-- 用户下拉菜单 -->
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
            
            <!-- 页面内容区域 -->
            <div class="page-content" id="pageContent">
                <!-- 页面标题 -->
                <div class="page-header">
                    <h1 class="page-title">消息中心维护</h1>
                    <p class="page-subtitle">管理系统通知消息，包括发送、查看和删除操作</p>
                </div>
                
                <!-- 操作结果显示 -->
                <%
                    if (operationResult != null) {
                %>
                <div class="alert alert-info" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; font-family: monospace; white-space: pre-line;">
                    <strong>操作结果:</strong><br>
                    <%= operationResult %>
                </div>
                <%
                    }
                %>
                
                <!-- 搜索结果提示 -->
                <%
                    if ((searchKeyword != null && !searchKeyword.trim().isEmpty()) || (searchReadStatus != null && !searchReadStatus.trim().isEmpty())) {
                        String searchInfo = "";
                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            searchInfo += "关键词: \"" + searchKeyword + "\"";
                        }
                        if (searchReadStatus != null && !searchReadStatus.trim().isEmpty()) {
                            if (!searchInfo.isEmpty()) searchInfo += ", ";
                            String statusName = "全部";
                            if ("true".equals(searchReadStatus)) {
                                statusName = "已读";
                            } else if ("false".equals(searchReadStatus)) {
                                statusName = "未读";
                            }
                            searchInfo += "状态: \"" + statusName + "\"";
                        }
                        int resultCount = (displayNotifications != null) ? displayNotifications.size() : 0;
                %>
                <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <strong>搜索结果:</strong> <%= searchInfo %> - 找到 <%= resultCount %> 条通知
                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearSearch()" style="margin-left: 10px; font-size: 12px;">清除搜索</button>
                </div>
                <%
                    }
                %>
                
                <!-- 工具栏 -->
                <div class="toolbar">
                    <!-- 搜索区域 -->
                    <form method="get" action="" style="display: contents;">
                        <!-- 搜索时重置到第一页 -->
                        <input type="hidden" name="page" value="1">
                        <div class="search-section">
                            <input type="text" class="search-input" placeholder="搜索通知内容..." id="searchInput" name="searchKeyword" value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                            
                            <!-- 已读状态下拉框 -->
                            <select class="category-select" id="readStatusSelect" name="searchReadStatus">
                                <option value="">全部状态</option>
                                <option value="false"<%= "false".equals(searchReadStatus) ? " selected" : "" %>>未读</option>
                                <option value="true"<%= "true".equals(searchReadStatus) ? " selected" : "" %>>已读</option>
                            </select>
                            
                            <button type="submit" class="btn btn-primary">
                                🔍 搜索
                            </button>
                            
                            <!-- 清除搜索按钮 -->
                            <button type="button" class="btn btn-secondary" onclick="clearSearch()">
                                🗑️ 清除
                            </button>
                        </div>
                    </form>
                    
                    <!-- 操作按钮 -->
                    <div class="action-buttons">
                        <button class="btn btn-success" onclick="addNotification()">
                            ➕ 添加通知
                        </button>
                        <button class="btn btn-danger" onclick="batchDelete()">
                            🗑️ 批量删除
                        </button>
                    </div>
                </div>
                
                <!-- 数据表格 -->
                <div class="data-table">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th width="50">
                                        <input type="checkbox" class="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                    </th>
                                    <th width="80">序号</th>
                                    <th width="120">用户名</th>
                                    <th width="300">通知内容</th>
                                    <th width="100">是否已读</th>
                                    <th width="150">创建时间</th>
                                    <th width="200">操作</th>
                                </tr>
                            </thead>
                            <tbody id="notificationTableBody">
                                <%
                                    if (displayNotifications != null && !displayNotifications.isEmpty()) {
                                        int index = (currentPage - 1) * pageSize + 1; // 计算正确的序号
                                        for (Notification notification : displayNotifications) {
                                            String username = "未知用户";
                                            if (userMap.containsKey(notification.getUserId())) {
                                                username = userMap.get(notification.getUserId());
                                            }
                                            String readStatus = notification.isRead() ? "已读" : "未读";
                                            String readStatusClass = notification.isRead() ? "status-read" : "status-unread";
                                %>
                                <tr>
                                    <td>
                                        <input type="checkbox" class="checkbox row-checkbox" value="<%= notification.getId() %>">
                                    </td>
                                    <td><%= index++ %></td>
                                    <td><%= username %></td>
                                    <td><%= notification.getContent() != null ? notification.getContent() : "" %></td>
                                    <td>
                                        <span class="status-badge <%= readStatusClass %>"><%= readStatus %></span>
                                    </td>
                                    <td><%= notification.getCreatedAt() != null ? notification.getCreatedAt().toString() : "" %></td>
                                    <td>
                                        <div class="table-actions">
                                            <button class="btn btn-success btn-sm" onclick="viewNotification(<%= notification.getId() %>, '<%= username %>', '<%= notification.getContent() != null ? notification.getContent().replace("'", "\\''") : "" %>', <%= notification.isRead() %>, '<%= notification.getCreatedAt() != null ? notification.getCreatedAt().toString() : "" %>')">
                                                查看
                                            </button>
                                            <button class="btn btn-danger btn-sm" onclick="deleteNotification(<%= notification.getId() %>)">
                                                删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 20px;">暂无通知数据</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- 分页 -->
                    <div class="pagination">
                        <div class="pagination-info">
                            <%
                                if (totalNotifications > 0) {
                                    int startRecord = (currentPage - 1) * pageSize + 1;
                                    int endRecord = Math.min(currentPage * pageSize, totalNotifications);
                            %>
                            显示第 <%= startRecord %>-<%= endRecord %> 条，共 <%= totalNotifications %> 条记录，第 <%= currentPage %>/<%= totalPages %> 页
                            <%
                                } else {
                            %>
                            暂无数据
                            <%
                                }
                            %>
                        </div>
                        <div class="pagination-controls">
                            <%
                                if (totalPages > 1) {
                                    // 构建分页URL参数
                                    String baseUrl = "?";
                                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                                        baseUrl += "searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") + "&";
                                    }
                                    if (searchReadStatus != null && !searchReadStatus.trim().isEmpty()) {
                                        baseUrl += "searchReadStatus=" + searchReadStatus + "&";
                                    }
                            %>
                            <!-- 首页 -->
                            <% if (currentPage > 1) { %>
                                <a href="<%= baseUrl %>page=1" class="pagination-btn">首页</a>
                                <a href="<%= baseUrl %>page=<%= currentPage - 1 %>" class="pagination-btn">上一页</a>
                            <% } else { %>
                                <span class="pagination-btn disabled">首页</span>
                                <span class="pagination-btn disabled">上一页</span>
                            <% } %>
                            
                            <!-- 页码 -->
                            <%
                                int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);
                                
                                for (int i = startPage; i <= endPage; i++) {
                                    if (i == currentPage) {
                            %>
                                <span class="pagination-btn current"><%= i %></span>
                            <%
                                    } else {
                            %>
                                <a href="<%= baseUrl %>page=<%= i %>" class="pagination-btn"><%= i %></a>
                            <%
                                    }
                                }
                            %>
                            
                            <!-- 尾页 -->
                            <% if (currentPage < totalPages) { %>
                                <a href="<%= baseUrl %>page=<%= currentPage + 1 %>" class="pagination-btn">下一页</a>
                                <a href="<%= baseUrl %>page=<%= totalPages %>" class="pagination-btn">尾页</a>
                            <% } else { %>
                                <span class="pagination-btn disabled">下一页</span>
                                <span class="pagination-btn disabled">尾页</span>
                            <% } %>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 添加通知弹框 -->
    <div class="modal" id="addNotificationModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>添加通知</h3>
                <button class="modal-close" onclick="closeModal('addNotificationModal')">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addNotificationForm" method="post" action="">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label for="notificationUserId">目标用户:</label>
                        <select id="notificationUserId" name="userId" class="form-control" required>
                            <option value="">请选择用户</option>
                            <% if (allUsers != null) {
                                for (User user : allUsers) { %>
                                    <option value="<%= user.getId() %>"><%= user.getUsername() %> (<%= user.getEmail() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="notificationContent">通知内容:</label>
                        <textarea id="notificationContent" name="content" class="form-control" rows="4" placeholder="请输入通知内容" required></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addNotificationModal')">取消</button>
                <button type="submit" form="addNotificationForm" class="btn btn-primary">添加</button>
            </div>
        </div>
    </div>

    <!-- 查看通知弹框 -->
    <div class="modal" id="viewNotificationModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>查看通知详情</h3>
                <button class="modal-close" onclick="closeModal('viewNotificationModal')">&times;</button>
            </div>
            <div class="modal-body">
                <div class="notification-detail">
                    <div class="detail-item">
                        <label>通知ID:</label>
                        <span id="viewNotificationId">-</span>
                    </div>
                    <div class="detail-item">
                        <label>目标用户:</label>
                        <span id="viewNotificationUser">-</span>
                    </div>
                    <div class="detail-item">
                        <label>通知内容:</label>
                        <div id="viewNotificationContent" class="content-text">-</div>
                    </div>
                    <div class="detail-item">
                        <label>已读状态:</label>
                        <span id="viewNotificationRead" class="status-badge">-</span>
                    </div>
                    <div class="detail-item">
                        <label>创建时间:</label>
                        <span id="viewNotificationCreatedAt">-</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeModal('viewNotificationModal')">关闭</button>
            </div>
        </div>
    </div>

    <!-- 引入JavaScript -->
    <script src="./main.js"></script>
    <script src="../../js/main.js"></script>
    <script>
        // 删除通知
        function deleteNotification(notificationId) {
            if (confirm('确定要删除这条通知吗？')) {
                // 创建表单并提交
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteNotification';
                form.appendChild(actionInput);
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'notificationId';
                idInput.value = notificationId;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 批量删除
        function batchDelete() {
            const selectedIds = getSelectedNotificationIds();
            
            if (selectedIds.length === 0) {
                alert('请选择要删除的通知！');
                return;
            }
            
            if (confirm(`确定要删除选中的 ${selectedIds.length} 条通知吗？`)) {
                // 创建表单并提交
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'batchDelete';
                form.appendChild(actionInput);
                
                // 添加所有选中的通知ID
                selectedIds.forEach(function(id) {
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'notificationIds';
                    idInput.value = id;
                    form.appendChild(idInput);
                });
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 获取选中的通知ID
         function getSelectedNotificationIds() {
             const checkboxes = document.querySelectorAll('.row-checkbox:checked');
             const ids = [];
             checkboxes.forEach(function(checkbox) {
                 ids.push(checkbox.value);
             });
             return ids;
         }
         
         // 添加通知
         function addNotification() {
             showModal('addNotificationModal');
         }
         
         // 提交添加通知表单
         function submitAddNotification() {
             const form = document.getElementById('addNotificationForm');
             
             // 验证表单
             const userId = form.userId.value;
             const content = form.content.value.trim();
             
             if (!userId) {
                 alert('请选择用户！');
                 return;
             }
             
             if (!content) {
                 alert('请输入通知内容！');
                 return;
             }
             
             // 添加action参数并提交表单
             const actionInput = document.createElement('input');
             actionInput.type = 'hidden';
             actionInput.name = 'action';
             actionInput.value = 'add';
             form.appendChild(actionInput);
             
             form.submit();
         }
         
         // 显示模态框
         function showModal(modalId) {
             document.getElementById(modalId).style.display = 'block';
         }
         
         // 关闭模态框
         function closeModal(modalId) {
             document.getElementById(modalId).style.display = 'none';
         }
         
         // 全选/取消全选
         function toggleSelectAll() {
             const selectAllCheckbox = document.getElementById('selectAll');
             const rowCheckboxes = document.querySelectorAll('.row-checkbox');
             
             rowCheckboxes.forEach(function(checkbox) {
                 checkbox.checked = selectAllCheckbox.checked;
             });
         }
         
         // 清除搜索
         function clearSearch() {
             window.location.href = window.location.pathname;
         }
         
         // 查看通知详情
         function viewNotification(notificationId, username, content, isRead, createdAt) {
             // 设置弹框内容
             document.getElementById('viewNotificationId').textContent = notificationId;
             document.getElementById('viewNotificationUser').textContent = username;
             document.getElementById('viewNotificationContent').textContent = content;
             
             // 设置已读状态
             const readStatusElement = document.getElementById('viewNotificationRead');
             if (isRead) {
                 readStatusElement.textContent = '已读';
                 readStatusElement.className = 'status-badge status-read';
             } else {
                 readStatusElement.textContent = '未读';
                 readStatusElement.className = 'status-badge status-unread';
             }
             
             document.getElementById('viewNotificationCreatedAt').textContent = createdAt;
             
             // 显示弹框
             showModal('viewNotificationModal');
         }
    </script>
</body>
</html>