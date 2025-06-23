<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.AfterSale" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // 获取搜索参数
    String searchUsername = request.getParameter("searchUsername");
    
    // 处理各种操作
    String action = request.getParameter("action");
    String operationResult = null;
    
    if ("updateStatus".equals(action)) {
        // 更新状态
        String afterSaleIdStr = request.getParameter("afterSaleId");
        String newStatus = request.getParameter("newStatus");
        
        if (afterSaleIdStr != null && newStatus != null) {
            try {
                int afterSaleId = Integer.parseInt(afterSaleIdStr);
                String statusRemark = request.getParameter("statusRemark");
                if (statusRemark == null) statusRemark = "";
                
                // 调用ServiceLayer更新售后状态
                boolean result = ServiceLayer.updateAfterSaleStatus(afterSaleId, newStatus, statusRemark);
                operationResult = "更新状态结果: " + (result ? "成功" : "失败") + "\n";
                operationResult += "工单ID: " + afterSaleId + "\n";
                operationResult += "新状态: " + newStatus;
                if (result) {
                    response.sendRedirect(request.getRequestURI());
                    return;
                }
            } catch (Exception e) {
                operationResult = "更新状态失败: " + e.getMessage();
            }
        }
    } else if ("closeOrder".equals(action)) {
        // 关闭订单
        String afterSaleIdStr = request.getParameter("afterSaleId");
        
        if (afterSaleIdStr != null) {
            try {
                int afterSaleId = Integer.parseInt(afterSaleIdStr);
                // 调用ServiceLayer关闭售后订单
                boolean result = ServiceLayer.closeAfterSale(afterSaleId);
                operationResult = "关闭订单结果: " + (result ? "成功" : "失败") + "\n";
                operationResult += "工单ID: " + afterSaleId;
                if (result) {
                    response.sendRedirect(request.getRequestURI());
                    return;
                }
            } catch (Exception e) {
                operationResult = "关闭订单失败: " + e.getMessage();
            }
        }
    }
    
    // 获取所有售后数据
    List<AfterSale> allAfterSales = ServiceLayer.listAllAfterSales();
    
    // 如果没有数据，创建一些模拟数据用于测试UI
    if (allAfterSales == null) {
        allAfterSales = new ArrayList<>();
    }
    
    // 根据搜索条件过滤售后数据
    List<AfterSale> filteredAfterSales = new ArrayList<>();
    if (allAfterSales != null) {
        for (AfterSale afterSale : allAfterSales) {
            boolean matchUsername = true;
            
            // 检查用户名匹配
            if (searchUsername != null && !searchUsername.trim().isEmpty()) {
                String searchKeyword = searchUsername.trim().toLowerCase();
                matchUsername = false;
                
                // 通过userId获取用户名进行匹配
                if (afterSale.getUserId() > 0) {
                    User user = ServiceLayer.getUserById(afterSale.getUserId());
                    if (user != null && user.getUsername() != null) {
                        String afterSaleUsername = user.getUsername().toLowerCase();
                        matchUsername = afterSaleUsername.contains(searchKeyword);
                    }
                }
            }
            
            // 如果匹配则添加到结果列表
            if (matchUsername) {
                filteredAfterSales.add(afterSale);
            }
        }
    }
    
    // 使用过滤后的售后列表
    List<AfterSale> displayAfterSales = filteredAfterSales;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>售后管理 - 小米商城管理系统</title>
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
                <div class="submenu" id="aftersales-menu" style="display: block;">
                    <div class="submenu-item active" onclick="navigateTo('aftersales-workflow-control')">
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
                    <h1 class="page-title">售后管理 - 工单全流程控制</h1>
                    <p class="page-subtitle">管理售后工单的全流程状态和处理进度</p>
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
                    if (searchUsername != null && !searchUsername.trim().isEmpty()) {
                        int resultCount = (displayAfterSales != null) ? displayAfterSales.size() : 0;
                %>
                <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <strong>搜索结果:</strong> 用户名: "<%= searchUsername %>" - 找到 <%= resultCount %> 个工单
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
                        <button class="btn btn-info" onclick="refreshData()">
                            🔄 刷新数据
                        </button>
                    </div>
                </div>
                
                <!-- 数据表格 -->
                <div class="data-table">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th width="80">序号</th>
                                    <th width="120">用户名</th>
                                    <th width="150">SN码</th>
                                    <th width="100">类型</th>
                                    <th width="200">原因</th>
                                    <th width="100">状态</th>
                                    <th width="200">备注</th>
                                    <th width="200">操作</th>
                                </tr>
                            </thead>
                            <tbody id="aftersalesTableBody">
                                <%
                                    if (displayAfterSales != null && !displayAfterSales.isEmpty()) {
                                        int index = 1;
                                        for (AfterSale afterSale : displayAfterSales) {
                                %>
                                <tr onclick="showAfterSaleDetail(<%= afterSale.getId() %>)" style="cursor: pointer;">
                                    <td><%= index++ %></td>
                                    <td>
                                        <%
                                            String username = "";
                                            if (afterSale.getUserId() > 0) {
                                                User user = ServiceLayer.getUserById(afterSale.getUserId());
                                                if (user != null) {
                                                    username = user.getUsername();
                                                }
                                            }
                                        %>
                                        <%= username %>
                                    </td>
                                    <td><%= afterSale.getSnCode() != null ? afterSale.getSnCode() : "" %></td>
                                    <td><%= afterSale.getType() != null ? afterSale.getType() : "" %></td>
                                    <td>
                                        <div class="text-truncate" title="<%= afterSale.getReason() != null ? afterSale.getReason() : "" %>">
                                            <%= afterSale.getReason() != null ? (afterSale.getReason().length() > 20 ? afterSale.getReason().substring(0, 20) + "..." : afterSale.getReason()) : "" %>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="status-badge status-<%= afterSale.getStatus() != null ? afterSale.getStatus().toLowerCase() : "unknown" %>">
                                            <%= afterSale.getStatus() != null ? afterSale.getStatus() : "" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="text-truncate" title="<%= afterSale.getRemark() != null ? afterSale.getRemark() : "" %>">
                                            <%= afterSale.getRemark() != null ? (afterSale.getRemark().length() > 20 ? afterSale.getRemark().substring(0, 20) + "..." : afterSale.getRemark()) : "" %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="table-actions" onclick="event.stopPropagation();">
                                            <button class="btn btn-primary btn-sm" onclick="updateStatus(<%= afterSale.getId() %>)">
                                                更新状态
                                            </button>
                                            <button class="btn btn-danger btn-sm" onclick="closeOrder(<%= afterSale.getId() %>)">
                                                关闭订单
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 20px;">暂无售后工单数据</td>
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
                                int totalAfterSales = (displayAfterSales != null) ? displayAfterSales.size() : 0;
                                if (totalAfterSales > 0) {
                            %>
                            显示第 1-<%= totalAfterSales %> 条，共 <%= totalAfterSales %> 条记录
                            <%
                                } else {
                            %>
                            暂无记录
                            <%
                                }
                            %>
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
    
    <!-- 售后详情弹框 -->
    <div class="modal" id="afterSaleDetailModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>售后工单详情</h3>
                <span class="close" onclick="closeAfterSaleDetailModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="detail-form">
                    <div class="form-group">
                        <label>工单ID：</label>
                        <div class="detail-field" id="detailAfterSaleId"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>用户名：</label>
                        <div class="detail-field" id="detailUsername"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>SN码：</label>
                        <div class="detail-field" id="detailSnCode"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>类型：</label>
                        <div class="detail-field" id="detailType"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>状态：</label>
                        <div class="detail-field" id="detailStatus"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>申请原因：</label>
                        <div class="detail-field detail-text" id="detailReason"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>备注：</label>
                        <div class="detail-field detail-text" id="detailRemark"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>创建时间：</label>
                        <div class="detail-field" id="detailCreateTime"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>更新时间：</label>
                        <div class="detail-field" id="detailUpdateTime"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeAfterSaleDetailModal()">关闭</button>
                <button type="button" class="btn btn-primary" onclick="editAfterSale()">编辑工单</button>
            </div>
        </div>
    </div>
    
    <!-- 更新状态弹框 -->
    <div class="modal" id="updateStatusModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>更新工单状态</h3>
                <span class="close" onclick="closeUpdateStatusModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="updateStatusForm">
                    <input type="hidden" id="updateAfterSaleId" name="afterSaleId">
                    
                    <div class="form-group">
                        <label for="newStatus">新状态：</label>
                        <select id="newStatus" name="newStatus" class="form-control" required>
                            <option value="">请选择状态</option>
                            <option value="待处理">待处理</option>
                            <option value="处理中">处理中</option>
                            <option value="已完成">已完成</option>
                            <option value="已关闭">已关闭</option>
                            <option value="已拒绝">已拒绝</option>
                        </select>
                        <span class="error-message" id="statusError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="statusRemark">处理备注：</label>
                        <textarea id="statusRemark" name="statusRemark" class="form-control" rows="3" placeholder="请输入处理备注..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeUpdateStatusModal()">取消</button>
                <button type="button" class="btn btn-primary" onclick="saveStatusUpdate()">保存</button>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="../../static/js/admin-layout.js"></script>
    <script src="./main.js"></script>
</body>
</html>