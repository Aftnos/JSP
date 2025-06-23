<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.SNCode" %>
<%@ page import="com.entity.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // 获取搜索参数
    String searchKeyword = request.getParameter("searchKeyword");
    String searchStatus = request.getParameter("searchStatus");
    String searchOrderId = request.getParameter("searchOrderId");
    
    // 处理各种操作
    String action = request.getParameter("action");
    String operationResult = null;
    
    // 获取所有商品用于显示商品名称
    List<Product> allProducts = ServiceLayer.listProducts();
    
    // 创建商品映射，方便显示商品名称
    java.util.Map<Integer, String> productMap = new java.util.HashMap<>();
    if (allProducts != null) {
        for (Product product : allProducts) {
            productMap.put(product.getId(), product.getName());
        }
    }
    
    // 根据搜索条件查询SN码
    List<SNCode> displaySNCodes = new ArrayList<>();
    
    try {
        // 如果有订单ID搜索，优先按订单查询
        if (searchOrderId != null && !searchOrderId.trim().isEmpty()) {
            int orderId = Integer.parseInt(searchOrderId.trim());
            displaySNCodes = ServiceLayer.getSNCodesByOrder(orderId);
        }
        // 如果有商品关键词搜索
        else if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // 先根据商品名称找到商品ID
            for (Product product : allProducts) {
                if (product.getName().toLowerCase().contains(searchKeyword.toLowerCase())) {
                    String status = (searchStatus != null && !searchStatus.trim().isEmpty()) ? searchStatus : null;
                    List<SNCode> productSNCodes = ServiceLayer.listSNCodes(product.getId(), status);
                    if (productSNCodes != null) {
                        displaySNCodes.addAll(productSNCodes);
                    }
                }
            }
            
            // 也搜索SN码本身
            // 这里简化处理，遍历所有商品的SN码进行匹配
            if (displaySNCodes.isEmpty()) {
                for (Product product : allProducts) {
                    String status = (searchStatus != null && !searchStatus.trim().isEmpty()) ? searchStatus : null;
                    List<SNCode> productSNCodes = ServiceLayer.listSNCodes(product.getId(), status);
                    if (productSNCodes != null) {
                        for (SNCode sn : productSNCodes) {
                            if (sn.getCode() != null && sn.getCode().toLowerCase().contains(searchKeyword.toLowerCase())) {
                                displaySNCodes.add(sn);
                            }
                        }
                    }
                }
            }
        }
        // 如果只有状态搜索
        else if (searchStatus != null && !searchStatus.trim().isEmpty()) {
            for (Product product : allProducts) {
                List<SNCode> productSNCodes = ServiceLayer.listSNCodes(product.getId(), searchStatus);
                if (productSNCodes != null) {
                    displaySNCodes.addAll(productSNCodes);
                }
            }
        }
        // 如果没有搜索条件，显示前50个SN码
        else {
            int count = 0;
            for (Product product : allProducts) {
                if (count >= 50) break;
                List<SNCode> productSNCodes = ServiceLayer.listSNCodes(product.getId(), null);
                if (productSNCodes != null) {
                    for (SNCode sn : productSNCodes) {
                        if (count >= 50) break;
                        displaySNCodes.add(sn);
                        count++;
                    }
                }
            }
        }
    } catch (Exception e) {
        operationResult = "查询失败：" + e.getMessage();
        displaySNCodes = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SN码管理 - 小米商城管理系统</title>
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
                    <h1 class="page-title">SN码管理</h1>
                    <p class="page-subtitle">查询和管理商品SN码信息</p>
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
                    if ((searchKeyword != null && !searchKeyword.trim().isEmpty()) || 
                        (searchStatus != null && !searchStatus.trim().isEmpty()) ||
                        (searchOrderId != null && !searchOrderId.trim().isEmpty())) {
                        String searchInfo = "";
                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            searchInfo += "关键词: \"" + searchKeyword + "\"";
                        }
                        if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                            if (!searchInfo.isEmpty()) searchInfo += ", ";
                            searchInfo += "状态: \"" + searchStatus + "\"";
                        }
                        if (searchOrderId != null && !searchOrderId.trim().isEmpty()) {
                            if (!searchInfo.isEmpty()) searchInfo += ", ";
                            searchInfo += "订单ID: \"" + searchOrderId + "\"";
                        }
                        int resultCount = (displaySNCodes != null) ? displaySNCodes.size() : 0;
                %>
                <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;">
                    <strong>搜索结果:</strong> <%= searchInfo %> - 找到 <%= resultCount %> 个SN码
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
                            <input type="text" class="search-input" placeholder="搜索商品名称或SN码..." id="searchInput" name="searchKeyword" value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                            
                            <!-- 订单ID输入框 -->
                            <input type="text" class="search-input" placeholder="订单ID" id="searchOrderId" name="searchOrderId" value="<%= (searchOrderId != null) ? searchOrderId : "" %>" style="width: 120px;">
                            
                            <!-- 状态下拉框 -->
                            <select class="category-select" id="statusSelect" name="searchStatus">
                                <option value="">全部状态</option>
                                <option value="available"<%= "available".equals(searchStatus) ? " selected" : "" %>>可用</option>
                                <option value="sold"<%= "sold".equals(searchStatus) ? " selected" : "" %>>已售出</option>
                                <option value="bound"<%= "bound".equals(searchStatus) ? " selected" : "" %>>已绑定</option>
                                <option value="invalid"<%= "invalid".equals(searchStatus) ? " selected" : "" %>>无效</option>
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
                                    <th width="200">商品名称</th>
                                    <th width="220">SN码</th>
                                    <th width="120">状态</th>
                                    <th width="140">批次ID</th>
                                </tr>
                            </thead>
                            <tbody id="snCodeTableBody">
                                <%
                                    if (displaySNCodes != null && !displaySNCodes.isEmpty()) {
                                        int index = 1;
                                        for (SNCode snCode : displaySNCodes) {
                                            String productName = "未知商品";
                                            if (productMap.containsKey(snCode.getProductId())) {
                                                productName = productMap.get(snCode.getProductId());
                                            }
                                            
                                            String statusText = "";
                                            String statusClass = "";
                                            if ("AVAILABLE".equals(snCode.getStatus())) {
                                                statusText = "可用";
                                                statusClass = "status-available";
                                            } else if ("SOLD".equals(snCode.getStatus())) {
                                                statusText = "已售";
                                                statusClass = "status-sold";
                                            } else if ("RESERVED".equals(snCode.getStatus())) {
                                                statusText = "预留";
                                                statusClass = "status-reserved";
                                            } else if ("DEFECTIVE".equals(snCode.getStatus())) {
                                                statusText = "缺陷";
                                                statusClass = "status-defective";
                                            }
                                %>
                                <tr>
                                    <td><%= index++ %></td>
                                    <td><%= productName %></td>
                                    <td><%= snCode.getCode() != null ? snCode.getCode() : "" %></td>
                                    <td>
                                        <span class="status-badge status-<%= snCode.getStatus() != null ? snCode.getStatus().toLowerCase() : "unknown" %>">
                                            <%= snCode.getStatus() != null ? 
                                                ("available".equals(snCode.getStatus()) ? "可用" :
                                                 "sold".equals(snCode.getStatus()) ? "已售出" :
                                                 "bound".equals(snCode.getStatus()) ? "已绑定" :
                                                 "invalid".equals(snCode.getStatus()) ? "无效" : snCode.getStatus()) 
                                                : "未知" %>
                                        </span>
                                    </td>
                                    <td><%= snCode.getBatchId() != null ? snCode.getBatchId() : "" %></td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 20px;">暂无SN码数据</td>
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
                                int totalSNCodes = (displaySNCodes != null) ? displaySNCodes.size() : 0;
                                if (totalSNCodes > 0) {
                            %>
                            显示第 1-<%= totalSNCodes %> 条，共 <%= totalSNCodes %> 条记录
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
    
    <!-- 生成SN码弹框 -->
    <div class="modal" id="generateModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>生成SN码</h3>
                <span class="close" onclick="closeGenerateModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="generateForm">
                    <div class="form-group">
                        <label for="productSelect">选择商品：</label>
                        <select id="productSelect" name="productId" class="form-control" required>
                            <option value="">请选择商品</option>
                            <!-- TODO: 后续从数据库加载商品列表 -->
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="generateCount">生成数量：</label>
                        <input type="number" id="generateCount" name="count" class="form-control" min="1" max="1000" value="1" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="batchId">批次ID：</label>
                        <input type="text" id="batchId" name="batchId" class="form-control" placeholder="留空自动生成">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeGenerateModal()">取消</button>
                <button type="button" class="btn btn-primary" onclick="confirmGenerate()">生成</button>
            </div>
        </div>
    </div>
    
    <!-- 状态变更弹框 -->
    <div class="modal" id="statusModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>状态变更</h3>
                <span class="close" onclick="closeStatusModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="statusForm">
                    <input type="hidden" id="statusSnCodeId" name="snCodeId">
                    
                    <div class="form-group">
                        <label for="newStatus">新状态：</label>
                        <select id="newStatus" name="status" class="form-control" required>
                            <option value="AVAILABLE">可用</option>
                            <option value="SOLD">已售</option>
                            <option value="RESERVED">预留</option>
                            <option value="DEFECTIVE">缺陷</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="statusReason">变更原因：</label>
                        <textarea id="statusReason" name="reason" class="form-control" rows="3" placeholder="请输入状态变更原因"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeStatusModal()">取消</button>
                <button type="button" class="btn btn-primary" onclick="confirmStatusChange()">确认变更</button>
            </div>
        </div>
    </div>

    <!-- 引入JavaScript -->
    <script src="../../js/admin-layout.js"></script>
    <script src="../../js/main.js"></script>
    <script src="./main.js"></script>
</body>
</html>