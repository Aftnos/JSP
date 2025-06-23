<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Order" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Address" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    // 处理状态更新请求
    String action = request.getParameter("action");
    String updateResult = "";
    
    if ("updateOrderStatus".equals(action)) {
        String orderIdStr = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");
        
        if (orderIdStr != null && !orderIdStr.trim().isEmpty() && 
            newStatus != null && !newStatus.trim().isEmpty()) {
            
            try {
                int orderId = Integer.parseInt(orderIdStr);
                
                // 获取当前订单信息进行状态验证
                Order currentOrder = ServiceLayer.getOrderById(orderId);
                if (currentOrder != null) {
                    String currentStatus = currentOrder.getStatus();
                    boolean canUpdate = false;
                    String errorMessage = "";
                    
                    // 状态变更规则验证
                    switch (newStatus) {
                        case "paid":
                            canUpdate = "pending".equals(currentStatus);
                            if (!canUpdate) errorMessage = "只有待付款订单才能标记为已付款";
                            break;
                        case "shipped":
                            canUpdate = "paid".equals(currentStatus);
                            if (!canUpdate) errorMessage = "只有已付款订单才能发货";
                            break;
                        case "delivered":
                            canUpdate = "shipped".equals(currentStatus);
                            if (!canUpdate) errorMessage = "只有已发货订单才能标记为已送达";
                            break;
                        case "completed":
                            canUpdate = "delivered".equals(currentStatus);
                            if (!canUpdate) errorMessage = "只有已送达订单才能标记为已完成";
                            break;
                        case "cancelled":
                            // 取消状态没有限制
                            canUpdate = true;
                            break;
                        default:
                            canUpdate = false;
                            errorMessage = "无效的状态";
                    }
                    
                    if (canUpdate) {
                        boolean success = ServiceLayer.updateOrderStatus(orderId, newStatus);
                        if (success) {
                            updateResult = "success:订单状态更新成功";
                        } else {
                            updateResult = "error:订单状态更新失败";
                        }
                    } else {
                        updateResult = "error:" + errorMessage;
                    }
                } else {
                    updateResult = "error:订单不存在";
                }
            } catch (NumberFormatException e) {
                updateResult = "error:订单ID格式错误";
            } catch (Exception e) {
                updateResult = "error:更新失败: " + e.getMessage();
            }
        } else {
            updateResult = "error:参数不完整";
        }
    }
    
    // 获取搜索参数
    String searchUsername = request.getParameter("searchUsername");
    String searchStatus = request.getParameter("searchStatus");
    
    // 获取所有订单
    List<Order> allOrders = ServiceLayer.listAllOrders();
    if (allOrders == null) {
        allOrders = new ArrayList<>();
    }
    
    // 获取所有用户，用于用户名映射
    List<User> allUsers = ServiceLayer.getAllUsers();
    Map<Integer, String> userMap = new HashMap<>();
    if (allUsers != null) {
        for (User user : allUsers) {
            userMap.put(user.getId(), user.getUsername());
        }
    }
    
    // 获取所有地址，用于地址映射
    List<Address> allAddresses = ServiceLayer.getAllAddresses();
    Map<Integer, String> addressMap = new HashMap<>();
    if (allAddresses != null) {
        for (Address address : allAddresses) {
            String fullAddress = "";
            // Address实体类只有detail字段，包含完整地址信息
            if (address.getDetail() != null && !address.getDetail().trim().isEmpty()) {
                fullAddress = address.getDetail();
            }
            // 如果地址为空，显示收货人信息作为标识
            if (fullAddress.isEmpty()) {
                if (address.getReceiver() != null && !address.getReceiver().trim().isEmpty()) {
                    fullAddress = address.getReceiver() + "的地址";
                } else {
                    fullAddress = "地址" + address.getId();
                }
            }
            addressMap.put(address.getId(), fullAddress);
        }
    }
    
    // 过滤订单
    List<Order> filteredOrders = new ArrayList<>();
    for (Order order : allOrders) {
        boolean matchUsername = true;
        boolean matchStatus = true;
        
        // 根据用户名过滤
        if (searchUsername != null && !searchUsername.trim().isEmpty()) {
            String username = userMap.get(order.getUserId());
            if (username == null || !username.toLowerCase().contains(searchUsername.toLowerCase())) {
                matchUsername = false;
            }
        }
        
        // 根据状态过滤
        if (searchStatus != null && !searchStatus.trim().isEmpty()) {
            if (!searchStatus.equals(order.getStatus())) {
                matchStatus = false;
            }
        }
        
        if (matchUsername && matchStatus) {
            filteredOrders.add(order);
        }
    }
    
    // 使用过滤后的订单列表
    List<Order> displayOrders = filteredOrders;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单全局查询 - 小米商城管理系统</title>
    <!-- 引入基础样式 -->
    <link rel="stylesheet" type="text/css" href="../../static/css/admin-layout.css">
    <!-- 引入主样式 -->
    <link rel="stylesheet" type="text/css" href="../../css/main.css">
    <link rel="stylesheet" href="./main.css">
    <style>
        /* 弹窗样式 */
        .modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 0;
            border: none;
            border-radius: 8px;
            width: 80%;
            max-width: 800px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }
        
        .modal-header {
            padding: 20px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            margin: 0;
            color: #333;
        }
        
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            line-height: 1;
        }
        
        .close:hover {
            color: #000;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 15px 20px;
            background-color: #f8f9fa;
            border-top: 1px solid #dee2e6;
            border-radius: 0 0 8px 8px;
            text-align: right;
        }
        
        .order-detail-section {
            margin-bottom: 25px;
        }
        
        .order-detail-section h4 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 8px;
            margin-bottom: 15px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .detail-label {
            font-weight: bold;
            width: 120px;
            color: #555;
        }
        
        .detail-value {
            flex: 1;
            color: #333;
        }
        
        .order-items-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            
            .order-items-table th,
            .order-items-table td {
                padding: 8px 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            
            .order-items-table th {
                background-color: #f8f9fa;
                font-weight: bold;
            }
            
            /* 订单详情弹窗中的状态标签样式 */
            .status-badge-detail {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                display: inline-block;
            }
            
            .status-pending { background-color: #fff3cd; color: #856404; }
            .status-paid { background-color: #d1ecf1; color: #0c5460; }
            .status-shipped { background-color: #d4edda; color: #155724; }
            .status-delivered { background-color: #cce5ff; color: #004085; }
            .status-completed { background-color: #d4edda; color: #155724; }
            .status-cancelled { background-color: #f8d7da; color: #721c24; }
        
        .status-badge-detail {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
    </style>
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
                    <h1 class="page-title">订单全局查询</h1>
                    <p class="page-subtitle">查询和管理所有订单信息</p>
                </div>
                
                <!-- 状态更新结果提示 -->
                <%
                    if (!updateResult.isEmpty()) {
                        String[] resultParts = updateResult.split(":", 2);
                        String resultType = resultParts[0];
                        String resultMessage = resultParts.length > 1 ? resultParts[1] : updateResult;
                        String alertClass = "success".equals(resultType) ? "alert-success" : "alert-danger";
                        String bgColor = "success".equals(resultType) ? "#d4edda" : "#f8d7da";
                        String borderColor = "success".equals(resultType) ? "#c3e6cb" : "#f5c6cb";
                %>
                <div class="alert <%= alertClass %>" style="margin-bottom: 20px; padding: 15px; background-color: <%= bgColor %>; border: 1px solid <%= borderColor %>; border-radius: 4px;">
                    <strong><%= "success".equals(resultType) ? "成功:" : "错误:" %></strong> <%= resultMessage %>
                </div>
                <%
                    }
                %>
                
                <!-- 搜索结果提示 -->
                <%
                    if ((searchUsername != null && !searchUsername.trim().isEmpty()) || (searchStatus != null && !searchStatus.trim().isEmpty())) {
                        String searchInfo = "";
                        if (searchUsername != null && !searchUsername.trim().isEmpty()) {
                            searchInfo += "用户名: \"" + searchUsername + "\"";
                        }
                        if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                            if (!searchInfo.isEmpty()) searchInfo += ", ";
                            searchInfo += "状态: \"" + searchStatus + "\"";
                        }
                        int resultCount = (displayOrders != null) ? displayOrders.size() : 0;
                %>
                <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <strong>搜索结果:</strong> <%= searchInfo %> - 找到 <%= resultCount %> 个订单
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
                            <input type="text" class="search-input" placeholder="搜索用户名..." id="searchInput" name="searchUsername" value="<%= (searchUsername != null) ? searchUsername : "" %>">
                            
                            <!-- 状态下拉框 -->
                            <select class="category-select" id="statusSelect" name="searchStatus">
                                <option value="">全部状态</option>
                                <option value="pending"<%= "pending".equals(searchStatus) ? " selected" : "" %>>待付款</option>
                                <option value="paid"<%= "paid".equals(searchStatus) ? " selected" : "" %>>已付款</option>
                                <option value="shipped"<%= "shipped".equals(searchStatus) ? " selected" : "" %>>已发货</option>
                                <option value="delivered"<%= "delivered".equals(searchStatus) ? " selected" : "" %>>已送达</option>
                                <option value="completed"<%= "completed".equals(searchStatus) ? " selected" : "" %>>已完成</option>
                                <option value="cancelled"<%= "cancelled".equals(searchStatus) ? " selected" : "" %>>已取消</option>
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
                </div>
                
                <!-- 数据表格 -->
                <div class="data-table">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th width="80">序号</th>
                                    <th width="120">用户名</th>
                                    <th width="200">收货地址</th>
                                    <th width="100">订单状态</th>
                                    <th width="120">订单总金额</th>
                                    <th width="150">创建时间</th>
                                    <th width="150">操作</th>
                                </tr>
                            </thead>
                            <tbody id="orderTableBody">
                                <%
                                    if (displayOrders != null && !displayOrders.isEmpty()) {
                                        int index = 1;
                                        for (Order order : displayOrders) {
                                            // 根据userId查询用户名
                                            String username = userMap.get(order.getUserId());
                                            if (username == null) {
                                                username = "用户" + order.getUserId();
                                            }
                                            
                                            // 根据addressId查询收货地址
                                            String address = addressMap.get(order.getAddressId());
                                            if (address == null) {
                                                address = "地址" + order.getAddressId();
                                            }
                                            
                                            // 订单状态显示
                                            String statusText = "未知";
                                            String statusClass = "";
                                            if (order.getStatus() != null) {
                                                boolean isPaid = order.isPaid();
                                                String str = isPaid ? "已付款" : "待付款";
                                                switch (order.getStatus()) {
                                                    case "pending":
                                                        if (isPaid) {
                                                            statusText = "已付款";
                                                            statusClass = "status-paid";
                                                        } else {
                                                            statusText = "待付款";
                                                            statusClass = "status-pending";
                                                        }
                                                        break;
                                                    case "paid":
                                                        statusText = "已付款";
                                                        statusClass = "status-paid";
                                                        break;
                                                    case "shipped":
                                                        statusText = "已发货";
                                                        statusClass = "status-shipped";
                                                        break;
                                                    case "delivered":
                                                        statusText = "已送达";
                                                        statusClass = "status-delivered";
                                                        break;
                                                    case "completed":
                                                        statusText = "已完成";
                                                        statusClass = "status-completed";
                                                        break;
                                                    case "CANCELLED":
                                                        statusText = "已取消";
                                                        statusClass = "status-cancelled";
                                                        break;
                                                    case "REFUNDED":
                                                        statusText = "已退款";
                                                        statusClass = "status-refunded";
                                                        break;
                                                }
                                            }
                                            
                                %>
                                <tr>
                                    <td><%= index++ %></td>
                                    <td><%= username %></td>
                                    <td><%= address %></td>
                                    <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                                    <td>¥<%= order.getTotal() != null ? order.getTotal() : "0.00" %></td>
                                    <td><%= order.getCreatedAt() != null ? order.getCreatedAt() : "" %></td>
                                    <td>
                                        <div class="table-actions">
                                            <button class="btn btn-primary btn-sm" onclick="viewOrderDetail(<%= order.getId() %>)">
                                                查看详情
                                            </button>
                                            <button class="btn btn-warning btn-sm" onclick="editOrderStatus(<%= order.getId() %>)">
                                                修改状态
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 20px;">暂无订单数据</td>
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
                                int totalOrders = (displayOrders != null) ? displayOrders.size() : 0;
                                if (totalOrders > 0) {
                            %>
                            显示第 1-<%= totalOrders %> 条，共 <%= totalOrders %> 条记录
                            <%
                                } else {
                            %>
                            暂无数据
                            <%
                                }
                            %>
                        </div>
                        
                        <div class="pagination-controls">
                            <!-- TODO: 实现分页控制 -->
                            <button class="btn btn-outline-secondary btn-sm" disabled>
                                上一页
                            </button>
                            <span class="page-info">第 1 页，共 1 页</span>
                            <button class="btn btn-outline-secondary btn-sm" disabled>
                                下一页
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 订单详情弹窗 -->
    <div id="orderDetailModal" class="modal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>订单详情</h3>
                <span class="close" onclick="closeOrderDetailModal()">&times;</span>
            </div>
            <div class="modal-body" id="orderDetailContent">
                <!-- 订单详情内容将通过JavaScript动态加载 -->
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeOrderDetailModal()">关闭</button>
            </div>
        </div>
    </div>
    
    <!-- 修改状态弹窗 -->
    <div id="editStatusModal" class="modal" style="display: none;">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3>修改订单状态</h3>
                <span class="close" onclick="closeEditStatusModal()">&times;</span>
            </div>
            <form method="post" action="">
                <input type="hidden" name="action" value="updateOrderStatus">
                <input type="hidden" name="orderId" id="editOrderId">
                <div class="modal-body">
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">当前状态:</label>
                        <span id="currentStatusText" style="padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: bold;"></span>
                    </div>
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label for="newStatus" style="display: block; margin-bottom: 5px; font-weight: bold;">新状态:</label>
                        <select name="newStatus" id="newStatus" required style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                            <option value="">请选择新状态</option>
                            <option value="paid">已付款</option>
                            <option value="shipped">已发货</option>
                            <option value="delivered">已送达</option>
                            <option value="completed">已完成</option>
                            <option value="cancelled">已取消</option>
                        </select>
                    </div>
                    <div class="status-rules" style="background-color: #f8f9fa; padding: 15px; border-radius: 4px; font-size: 14px;">
                        <strong>状态变更规则:</strong>
                        <ul style="margin: 10px 0; padding-left: 20px;">
                            <li>待付款 → 已付款</li>
                            <li>已付款 → 已发货</li>
                            <li>已发货 → 已送达</li>
                            <li>已送达 → 已完成</li>
                            <li>任何状态 → 已取消</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeEditStatusModal()">取消</button>
                    <button type="submit" class="btn btn-primary">确认修改</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 引入主脚本 -->
    <script src="../../js/main.js"></script>
    <script>
        // 清除搜索
        function clearSearch() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusSelect').value = '';
            window.location.href = window.location.pathname;
        }
        
        // 查看订单详情
        function viewOrderDetail(orderId) {
            // 显示加载状态
            document.getElementById('orderDetailContent').innerHTML = '<div style="text-align: center; padding: 50px;">加载中...</div>';
            document.getElementById('orderDetailModal').style.display = 'block';
            
            // 发送AJAX请求获取订单详情
            fetch('order-detail.jsp?orderId=' + orderId)
                .then(response => response.text())
                .then(data => {
                    document.getElementById('orderDetailContent').innerHTML = data;
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('orderDetailContent').innerHTML = '<div style="text-align: center; padding: 50px; color: red;">加载失败，请重试</div>';
                });
        }
        
        // 关闭订单详情弹窗
        function closeOrderDetailModal() {
            document.getElementById('orderDetailModal').style.display = 'none';
        }
        
        // 点击弹窗外部关闭
        window.onclick = function(event) {
            var orderDetailModal = document.getElementById('orderDetailModal');
            var editStatusModal = document.getElementById('editStatusModal');
            
            if (event.target == orderDetailModal) {
                orderDetailModal.style.display = 'none';
            }
            
            if (event.target == editStatusModal) {
                editStatusModal.style.display = 'none';
            }
        }
        
        // 修改订单状态
        function editOrderStatus(orderId) {
            // 获取订单信息
            fetch('order-detail.jsp?orderId=' + orderId + '&format=json')
                .then(response => response.text())
                .then(data => {
                    // 由于没有JSON格式的接口，我们需要从页面中获取订单信息
                    // 这里简化处理，直接从表格行中获取状态信息
                    const orderRows = document.querySelectorAll('#orderTableBody tr');
                    let currentStatus = '';
                    let currentStatusText = '';
                    
                    for (let row of orderRows) {
                        const cells = row.querySelectorAll('td');
                        if (cells.length > 0) {
                            // 检查是否是目标订单行（通过查看详情按钮的onclick属性）
                            const detailBtn = row.querySelector('button[onclick*="viewOrderDetail(' + orderId + ')"]');
                            if (detailBtn) {
                                const statusCell = cells[3]; // 状态列
                                const statusSpan = statusCell.querySelector('.status-badge');
                                if (statusSpan) {
                                    currentStatusText = statusSpan.textContent.trim();
                                    // 根据显示文本确定状态值
                                    switch (currentStatusText) {
                                        case '待付款': currentStatus = 'pending'; break;
                                        case '已付款': currentStatus = 'paid'; break;
                                        case '已发货': currentStatus = 'shipped'; break;
                                        case '已送达': currentStatus = 'delivered'; break;
                                        case '已完成': currentStatus = 'completed'; break;
                                        case '已取消': currentStatus = 'cancelled'; break;
                                    }
                                }
                                break;
                            }
                        }
                    }
                    
                    // 设置弹窗内容
                    document.getElementById('editOrderId').value = orderId;
                    const currentStatusElement = document.getElementById('currentStatusText');
                    currentStatusElement.textContent = currentStatusText;
                    
                    // 设置状态样式
                    currentStatusElement.className = 'status-badge-detail';
                    switch (currentStatus) {
                        case 'pending': currentStatusElement.classList.add('status-pending'); break;
                        case 'paid': currentStatusElement.classList.add('status-paid'); break;
                        case 'shipped': currentStatusElement.classList.add('status-shipped'); break;
                        case 'delivered': currentStatusElement.classList.add('status-delivered'); break;
                        case 'completed': currentStatusElement.classList.add('status-completed'); break;
                        case 'cancelled': currentStatusElement.classList.add('status-cancelled'); break;
                    }
                    
                    // 根据当前状态设置可选的下一状态
                    const newStatusSelect = document.getElementById('newStatus');
                    const options = newStatusSelect.querySelectorAll('option');
                    
                    // 重置所有选项
                    options.forEach(option => {
                        option.style.display = 'block';
                        option.disabled = false;
                    });
                    
                    // 根据当前状态限制可选项
                    switch (currentStatus) {
                        case 'pending':
                            // 待付款只能变为已付款或已取消
                            hideOption('shipped');
                            hideOption('delivered');
                            hideOption('completed');
                            break;
                        case 'paid':
                            // 已付款只能变为已发货或已取消
                            hideOption('paid');
                            hideOption('delivered');
                            hideOption('completed');
                            break;
                        case 'shipped':
                            // 已发货只能变为已送达或已取消
                            hideOption('paid');
                            hideOption('shipped');
                            hideOption('completed');
                            break;
                        case 'delivered':
                            // 已送达只能变为已完成或已取消
                            hideOption('paid');
                            hideOption('shipped');
                            hideOption('delivered');
                            break;
                        case 'completed':
                        case 'cancelled':
                            // 已完成和已取消的订单不能再修改状态
                            hideOption('paid');
                            hideOption('shipped');
                            hideOption('delivered');
                            hideOption('completed');
                            hideOption('cancelled');
                            break;
                    }
                    
                    function hideOption(value) {
                        const option = newStatusSelect.querySelector('option[value="' + value + '"]');
                        if (option) {
                            option.style.display = 'none';
                            option.disabled = true;
                        }
                    }
                    
                    // 重置选择
                    newStatusSelect.value = '';
                    
                    // 显示弹窗
                    document.getElementById('editStatusModal').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('获取订单信息失败，请重试');
                });
        }
        
        // 关闭修改状态弹窗
        function closeEditStatusModal() {
            document.getElementById('editStatusModal').style.display = 'none';
        }
    </script>
</body>
</html>