<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Binding" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../../checkAdmin.jsp" %>
<%
    // 获取搜索参数
    String searchKeyword = request.getParameter("searchKeyword");
    
    // 处理各种操作
    String action = request.getParameter("action");
    String operationResult = null;
    
    // 绑定记录列表
    List<Binding> displayBindings = new ArrayList<>();
    
    // 用户映射，方便显示用户名
    java.util.Map<Integer, String> userMap = new java.util.HashMap<>();
    
    try {
        // 获取所有用户用于显示用户名
        List<User> allUsers = ServiceLayer.getAllUsers();
        if (allUsers != null) {
            for (User user : allUsers) {
                userMap.put(user.getId(), user.getUsername());
            }
        }
        
        // 获取所有绑定记录
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // 根据用户名或SN码模糊搜索
            String keyword = searchKeyword.trim().toLowerCase();
            for (User user : allUsers) {
                List<Binding> userBindings = ServiceLayer.getBindingsByUser(user.getId());
                if (userBindings != null) {
                    for (Binding binding : userBindings) {
                        // 检查用户名或SN码是否包含关键词
                        boolean matchUser = user.getUsername().toLowerCase().contains(keyword);
                        boolean matchSN = binding.getSnCode() != null && binding.getSnCode().toLowerCase().contains(keyword);
                        if (matchUser || matchSN) {
                            displayBindings.add(binding);
                        }
                    }
                }
            }
        } else {
            // 如果没有搜索条件，显示所有绑定记录
            for (User user : allUsers) {
                List<Binding> userBindings = ServiceLayer.getBindingsByUser(user.getId());
                if (userBindings != null) {
                    displayBindings.addAll(userBindings);
                }
            }
        }
        
        // 按绑定时间倒序排列
        if (displayBindings != null && !displayBindings.isEmpty()) {
            displayBindings.sort((b1, b2) -> {
                if (b1.getBindTime() == null && b2.getBindTime() == null) return 0;
                if (b1.getBindTime() == null) return 1;
                if (b2.getBindTime() == null) return -1;
                return b2.getBindTime().compareTo(b1.getBindTime());
            });
        }
    } catch (Exception e) {
        operationResult = "查询失败：" + e.getMessage();
        displayBindings = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SN绑定管理 - 小米商城管理系统</title>
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
                        <img src="../../images/default.png" alt="用户头像" class="user-avatar" id="userAvatar" onclick="toggleUserMenu()" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNFNUU1RTUiLz4KPGNpcmNsZSBjeD0iMjAiIGN5PSIxNiIgcj0iNiIgZmlsbD0iIzk5OTk5OSIvPgo8cGF0aCBkPSJNMzAgMzJDMzAgMjYuNDc3MSAyNS41MjI5IDIyIDIwIDIyQzE0LjQ3NzEgMjIgMTAgMjYuNDc3MSAxMCAzMkgzMFoiIGZpbGw9IiM5OTk5OTkiLz4KPC9zdmc+'">
                        <!-- 用户下拉菜单 -->
                        <div class="user-dropdown" id="userDropdown">
                            <div class="dropdown-item" onclick="window.location.href='../../index.jsp'">
                                <i class="icon">🏠</i>
                                <span>返回用户端</span>
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
                    <h1 class="page-title">SN绑定管理</h1>
                    <p class="page-subtitle">查询和管理用户SN码绑定记录</p>
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
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                        int resultCount = (displayBindings != null) ? displayBindings.size() : 0;
                %>
                <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <strong>搜索结果:</strong> 关键词: "<%= searchKeyword %>" - 找到 <%= resultCount %> 个绑定记录
                    <button type="button" class="btn btn-sm btn-outline-secondary" onclick="clearSearch()" style="margin-left: 10px; font-size: 12px;">清除搜索</button>
                </div>
                <%
                    }
                %>
                
                <!-- 工具栏 -->
                <div class="toolbar">
                    <!-- 搜索区域 -->
                    <form method="get" action="" style="display: contents;">
                        <div class="search-section">
                            <input type="text" class="search-input" placeholder="搜索用户名或SN码..." id="searchInput" name="searchKeyword" value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                            
                            <button type="submit" class="btn btn-primary">
                                🔍 搜索
                            </button>
                            
                            <!-- 清除搜索按钮 -->
                            <button type="button" class="btn btn-secondary" onclick="clearSearch()">
                                🗑️ 清除
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- 数据表格 -->
                <div class="data-table">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th width="80">序号</th>
                                    <th width="150">用户名</th>
                                    <th width="220">SN码</th>
                                    <th width="180">绑定时间</th>
                                </tr>
                            </thead>
                            <tbody id="bindingTableBody">
                                <%
                                    if (displayBindings != null && !displayBindings.isEmpty()) {
                                        int index = 1;
                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                        for (Binding binding : displayBindings) {
                                            String username = "未知用户";
                                            if (userMap.containsKey(binding.getUserId())) {
                                                username = userMap.get(binding.getUserId());
                                            }
                                            
                                            String bindTimeStr = "";
                                            if (binding.getBindTime() != null) {
                                                bindTimeStr = sdf.format(binding.getBindTime());
                                            }
                                %>
                                <tr>
                                    <td><%= index++ %></td>
                                    <td><%= username %></td>
                                    <td><%= binding.getSnCode() != null ? binding.getSnCode() : "" %></td>
                                    <td><%= bindTimeStr %></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 20px;">暂无绑定记录数据</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入基础脚本 -->
    <script src="../../../static/js/admin-layout.js"></script>
    <!-- 引入主脚本 -->
    <script src="../../js/main.js"></script>
    <script src="./main.js"></script>
    
    <script>
        // 清除搜索
        function clearSearch() {
            window.location.href = window.location.pathname;
        }
        
        // 页面初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('SN绑定管理页面已加载');
        });
    </script>
</body>
</html>