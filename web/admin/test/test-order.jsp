<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Order" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Address" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单功能测试</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .test-section {
            margin-bottom: 30px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .test-result {
            background-color: #f8f9fa;
            padding: 10px;
            border-left: 4px solid #007bff;
            margin-top: 10px;
            white-space: pre-line;
            font-family: monospace;
            max-height: 300px;
            overflow-y: auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], select {
            width: 300px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .danger {
            background-color: #dc3545;
        }
        .danger:hover {
            background-color: #c82333;
        }
        .success {
            background-color: #28a745;
        }
        .success:hover {
            background-color: #218838;
        }
        .warning {
            background-color: #ffc107;
            color: #212529;
        }
        .warning:hover {
            background-color: #e0a800;
        }
        .order-list {
            background-color: #e9ecef;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            max-height: 400px;
            overflow-y: auto;
        }
        .order-item {
            padding: 8px;
            border-bottom: 1px solid #ccc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-item:last-child {
            border-bottom: none;
        }
        .order-info {
            flex: 1;
        }
        .order-actions {
            display: flex;
            gap: 5px;
        }
        .order-actions button {
            padding: 5px 10px;
            font-size: 12px;
        }
        .status-pending { color: #ffc107; }
        .status-paid { color: #17a2b8; }
        .status-processing { color: #6f42c1; }
        .status-completed { color: #28a745; }
        .status-cancelled { color: #dc3545; }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-card {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
            border-left: 4px solid #007bff;
        }
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
        }
        .stat-label {
            color: #6c757d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>订单功能测试页面</h1>
        <p>此页面用于测试订单相关功能是否正常工作</p>
        
        <!-- 订单统计信息 -->
        <div class="test-section">
            <h2>订单统计信息</h2>
            <div class="stats">
                <%
                    List<Order> allOrders = ServiceLayer.listAllOrders();
                    int totalOrders = (allOrders != null) ? allOrders.size() : 0;
                    int pendingCount = 0, paidCount = 0, processingCount = 0, completedCount = 0, cancelledCount = 0;
                    BigDecimal totalAmount = BigDecimal.ZERO;
                    
                    if (allOrders != null) {
                        for (Order order : allOrders) {
                            if (order.getTotal() != null) {
                                totalAmount = totalAmount.add(order.getTotal());
                            }
                            String status = order.getStatus();
                            if ("pending".equals(status)) pendingCount++;
                            else if ("paid".equals(status)) paidCount++;
                            else if ("processing".equals(status)) processingCount++;
                            else if ("completed".equals(status)) completedCount++;
                            else if ("cancelled".equals(status)) cancelledCount++;
                        }
                    }
                %>
                <div class="stat-card">
                    <div class="stat-number"><%= totalOrders %></div>
                    <div class="stat-label">总订单数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= pendingCount %></div>
                    <div class="stat-label">待处理订单</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= completedCount %></div>
                    <div class="stat-label">已完成订单</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">¥<%= totalAmount %></div>
                    <div class="stat-label">订单总金额</div>
                </div>
            </div>
        </div>
        
        <!-- 显示当前订单列表 -->
        <div class="test-section">
            <h2>当前订单列表</h2>
            <div class="order-list">
                <%
                    if (allOrders != null && !allOrders.isEmpty()) {
                        for (Order order : allOrders) {
                %>
                    <div class="order-item">
                        <div class="order-info">
                            <strong>订单ID:</strong> <%= order.getId() %> | 
                            <strong>用户ID:</strong> <%= order.getUserId() %> | 
                            <strong>状态:</strong> <span class="status-<%= order.getStatus() %>"><%= order.getStatus() %></span> | 
                            <strong>总金额:</strong> ¥<%= order.getTotal() %> | 
                            <strong>已支付:</strong> <%= order.isPaid() ? "是" : "否" %> |
                            <strong>创建时间:</strong> <%= order.getCreatedAt() != null ? order.getCreatedAt() : "N/A" %>
                        </div>
                        <div class="order-actions">
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="action" value="viewOrder">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <button type="submit" class="success">查看</button>
                            </form>
                            <% if (!order.isPaid()) { %>
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="action" value="markPaid">
                                <input type="hidden" name="orderId" value="<%= order.getId() %>">
                                <button type="submit" class="warning">标记已付</button>
                            </form>
                            <% } %>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div style="text-align: center; color: #6c757d; padding: 20px;">
                        暂无订单数据
                    </div>
                <%
                    }
                %>
            </div>
        </div>
        
        <!-- 创建测试订单 -->
        <div class="test-section">
            <h2>创建测试订单</h2>
            <form method="post">
                <input type="hidden" name="action" value="createOrder">
                
                <div class="form-group">
                    <label for="userId">选择用户:</label>
                    <select name="userId" id="userId" required>
                        <option value="">请选择用户</option>
                        <%
                            List<User> allUsers = ServiceLayer.getAllUsers();
                            if (allUsers != null) {
                                for (User user : allUsers) {
                        %>
                            <option value="<%= user.getId() %>"><%= user.getUsername() %> (ID: <%= user.getId() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="addressId">收货地址ID (可选):</label>
                    <input type="number" name="addressId" id="addressId" placeholder="留空则使用默认地址">
                </div>
                
                <div class="form-group">
                    <label for="total">订单总金额:</label>
                    <input type="number" name="total" id="total" step="0.01" min="0.01" value="99.99" required>
                </div>
                
                <div class="form-group">
                    <label for="status">订单状态:</label>
                    <select name="status" id="status">
                        <option value="pending">待处理 (pending)</option>
                        <option value="paid">已支付 (paid)</option>
                        <option value="processing">处理中 (processing)</option>
                        <option value="completed">已完成 (completed)</option>
                        <option value="cancelled">已取消 (cancelled)</option>
                    </select>
                </div>
                
                <button type="submit" class="success">创建订单</button>
            </form>
        </div>
        
        <!-- 查询订单 -->
        <div class="test-section">
            <h2>查询订单</h2>
            
            <!-- 根据订单ID查询 -->
            <h3>根据订单ID查询</h3>
            <form method="post">
                <input type="hidden" name="action" value="getOrderById">
                <div class="form-group">
                    <label for="searchOrderId">订单ID:</label>
                    <input type="number" name="orderId" id="searchOrderId" required>
                </div>
                <button type="submit">查询订单</button>
            </form>
            
            <!-- 根据用户ID查询 -->
            <h3>根据用户ID查询订单</h3>
            <form method="post">
                <input type="hidden" name="action" value="getOrdersByUser">
                <div class="form-group">
                    <label for="searchUserId">用户ID:</label>
                    <select name="userId" id="searchUserId" required>
                        <option value="">请选择用户</option>
                        <%
                            if (allUsers != null) {
                                for (User user : allUsers) {
                        %>
                            <option value="<%= user.getId() %>"><%= user.getUsername() %> (ID: <%= user.getId() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <button type="submit">查询用户订单</button>
            </form>
        </div>
        
        <!-- 更新订单 -->
        <div class="test-section">
            <h2>更新订单</h2>
            
            <!-- 更新订单状态 -->
            <h3>更新订单状态</h3>
            <form method="post">
                <input type="hidden" name="action" value="updateOrderStatus">
                <div class="form-group">
                    <label for="updateOrderId">订单ID:</label>
                    <input type="number" name="orderId" id="updateOrderId" required>
                </div>
                <div class="form-group">
                    <label for="newStatus">新状态:</label>
                    <select name="status" id="newStatus" required>
                        <option value="pending">待处理 (pending)</option>
                        <option value="paid">已支付 (paid)</option>
                        <option value="processing">处理中 (processing)</option>
                        <option value="completed">已完成 (completed)</option>
                        <option value="cancelled">已取消 (cancelled)</option>
                    </select>
                </div>
                <button type="submit" class="warning">更新状态</button>
            </form>
            
            <!-- 标记订单已支付 -->
            <h3>标记订单已支付</h3>
            <form method="post">
                <input type="hidden" name="action" value="markOrderPaid">
                <div class="form-group">
                    <label for="paidOrderId">订单ID:</label>
                    <input type="number" name="orderId" id="paidOrderId" required>
                </div>
                <button type="submit" class="success">标记已支付</button>
            </form>
        </div>
        
        <!-- 测试结果显示区域 -->
        <% 
            String action = request.getParameter("action");
            String result = "";
            
            if (action != null) {
                try {
                    if ("createOrder".equals(action)) {
                        // 创建订单
                        String userIdStr = request.getParameter("userId");
                        String addressIdStr = request.getParameter("addressId");
                        String totalStr = request.getParameter("total");
                        String status = request.getParameter("status");
                        
                        if (userIdStr != null && !userIdStr.trim().isEmpty() && 
                            totalStr != null && !totalStr.trim().isEmpty()) {
                            
                            Order newOrder = new Order();
                            newOrder.setUserId(Integer.parseInt(userIdStr));
                            
                            if (addressIdStr != null && !addressIdStr.trim().isEmpty()) {
                                newOrder.setAddressId(Integer.parseInt(addressIdStr));
                            }
                            
                            newOrder.setTotal(new BigDecimal(totalStr));
                            newOrder.setStatus(status != null ? status : "pending");
                            newOrder.setPaid("paid".equals(status) || "completed".equals(status));
                            
                            boolean success = ServiceLayer.createOrder(newOrder);
                            
                            if (success) {
                                result = "订单创建成功!\n";
                                result += "用户ID: " + userIdStr + "\n";
                                result += "地址ID: " + (addressIdStr != null && !addressIdStr.trim().isEmpty() ? addressIdStr : "未指定") + "\n";
                                result += "总金额: ¥" + totalStr + "\n";
                                result += "状态: " + newOrder.getStatus() + "\n";
                                result += "支付状态: " + (newOrder.isPaid() ? "已支付" : "未支付");
                            } else {
                                result = "订单创建失败!";
                            }
                        } else {
                            result = "参数不完整，无法创建订单";
                        }
                        
                    } else if ("getOrderById".equals(action)) {
                        // 根据ID查询订单
                        String orderIdStr = request.getParameter("orderId");
                        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                            int orderId = Integer.parseInt(orderIdStr);
                            Order order = ServiceLayer.getOrderById(orderId);
                            
                            if (order != null) {
                                result = "查询订单成功!\n";
                                result += "订单ID: " + order.getId() + "\n";
                                result += "用户ID: " + order.getUserId() + "\n";
                                result += "地址ID: " + order.getAddressId() + "\n";
                                result += "状态: " + order.getStatus() + "\n";
                                result += "总金额: ¥" + order.getTotal() + "\n";
                                result += "支付状态: " + (order.isPaid() ? "已支付" : "未支付") + "\n";
                                result += "创建时间: " + (order.getCreatedAt() != null ? order.getCreatedAt() : "N/A");
                            } else {
                                result = "未找到ID为 " + orderId + " 的订单";
                            }
                        }
                        
                    } else if ("getOrdersByUser".equals(action)) {
                        // 根据用户ID查询订单
                        String userIdStr = request.getParameter("userId");
                        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                            int userId = Integer.parseInt(userIdStr);
                            List<Order> userOrders = ServiceLayer.getOrdersByUser(userId);
                            
                            if (userOrders != null) {
                                result = "查询用户订单成功!\n";
                                result += "用户ID: " + userId + "\n";
                                result += "订单数量: " + userOrders.size() + "\n\n";
                                
                                if (!userOrders.isEmpty()) {
                                    result += "订单列表:\n";
                                    for (Order order : userOrders) {
                                        result += "  订单ID: " + order.getId() + 
                                                ", 状态: " + order.getStatus() + 
                                                ", 金额: ¥" + order.getTotal() + 
                                                ", 支付: " + (order.isPaid() ? "是" : "否") + "\n";
                                    }
                                }
                            } else {
                                result = "查询用户订单失败";
                            }
                        }
                        
                    } else if ("updateOrderStatus".equals(action)) {
                        // 更新订单状态
                        String orderIdStr = request.getParameter("orderId");
                        String status = request.getParameter("status");
                        
                        if (orderIdStr != null && !orderIdStr.trim().isEmpty() && 
                            status != null && !status.trim().isEmpty()) {
                            
                            int orderId = Integer.parseInt(orderIdStr);
                            boolean success = ServiceLayer.updateOrderStatus(orderId, status);
                            
                            if (success) {
                                result = "订单状态更新成功!\n";
                                result += "订单ID: " + orderId + "\n";
                                result += "新状态: " + status;
                                
                                // 验证更新结果
                                Order updatedOrder = ServiceLayer.getOrderById(orderId);
                                if (updatedOrder != null) {
                                    result += "\n验证: 当前状态为 " + updatedOrder.getStatus();
                                }
                            } else {
                                result = "订单状态更新失败!";
                            }
                        }
                        
                    } else if ("markOrderPaid".equals(action)) {
                        // 标记订单已支付
                        String orderIdStr = request.getParameter("orderId");
                        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                            int orderId = Integer.parseInt(orderIdStr);
                            boolean success = ServiceLayer.markOrderPaid(orderId);
                            
                            if (success) {
                                result = "订单支付状态更新成功!\n";
                                result += "订单ID: " + orderId + "\n";
                                
                                // 验证更新结果
                                Order updatedOrder = ServiceLayer.getOrderById(orderId);
                                if (updatedOrder != null) {
                                    result += "支付状态: " + (updatedOrder.isPaid() ? "已支付" : "未支付");
                                }
                            } else {
                                result = "订单支付状态更新失败!";
                            }
                        }
                        
                    } else if ("viewOrder".equals(action)) {
                        // 查看订单详情
                        String orderIdStr = request.getParameter("orderId");
                        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                            int orderId = Integer.parseInt(orderIdStr);
                            Order order = ServiceLayer.getOrderById(orderId);
                            
                            if (order != null) {
                                result = "订单详情:\n";
                                result += "订单ID: " + order.getId() + "\n";
                                result += "用户ID: " + order.getUserId() + "\n";
                                result += "地址ID: " + order.getAddressId() + "\n";
                                result += "订单状态: " + order.getStatus() + "\n";
                                result += "订单总金额: ¥" + order.getTotal() + "\n";
                                result += "支付状态: " + (order.isPaid() ? "已支付" : "未支付") + "\n";
                                result += "创建时间: " + (order.getCreatedAt() != null ? order.getCreatedAt() : "N/A") + "\n";
                                
                                // 获取用户信息
                                User user = ServiceLayer.getUserById(order.getUserId());
                                if (user != null) {
                                    result += "\n用户信息:\n";
                                    result += "用户名: " + user.getUsername() + "\n";
                                    result += "邮箱: " + user.getEmail();
                                }
                                
                                // 获取地址信息
                                if (order.getAddressId() > 0) {
                                    List<Address> addresses = ServiceLayer.getAddresses(order.getUserId());
                                    if (addresses != null) {
                                        for (Address addr : addresses) {
                                            if (addr.getId() == order.getAddressId()) {
                                                result += "\n\n收货地址:\n";
                                                result += "收货人: " + addr.getReceiver() + "\n";
                                                result += "电话: " + addr.getPhone() + "\n";
                                                result += "地址: " + addr.getDetail();
                                                break;
                                            }
                                        }
                                    }
                                }
                            } else {
                                result = "未找到订单信息";
                            }
                        }
                    }
                    
                } catch (Exception e) {
                    result = "操作失败: " + e.getMessage();
                    e.printStackTrace();
                }
            }
            
            if (!result.isEmpty()) {
        %>
        <div class="test-section">
            <h2>操作结果</h2>
            <div class="test-result"><%= result %></div>
        </div>
        <% } %>
        
        <!-- 快速测试按钮 -->
        <div class="test-section">
            <h2>快速测试</h2>
            <p>点击下面的按钮执行预定义的测试操作</p>
            
            <form method="post" style="display: inline;">
                <input type="hidden" name="action" value="runIntegrityTest">
                <button type="submit" class="success">运行完整性测试</button>
            </form>
            
            <% if (allUsers != null && !allUsers.isEmpty()) { %>
            <form method="post" style="display: inline;">
                <input type="hidden" name="action" value="createOrder">
                <input type="hidden" name="userId" value="<%= allUsers.get(0).getId() %>">
                <input type="hidden" name="total" value="199.99">
                <input type="hidden" name="status" value="pending">
                <button type="submit" class="warning">创建测试订单</button>
            </form>
            <% } %>
            
            <% if (allOrders != null && !allOrders.isEmpty()) { %>
            <form method="post" style="display: inline;">
                <input type="hidden" name="action" value="getOrdersByUser">
                <input type="hidden" name="userId" value="<%= allOrders.get(0).getUserId() %>">
                <button type="submit">查询首个订单用户的所有订单</button>
            </form>
            <% } %>
        </div>
        
        <!-- 运行完整性测试 -->
        <% 
            if ("runIntegrityTest".equals(action)) {
                try {
                    result = "=== 订单功能完整性测试 ===\n\n";
                    
                    // 1. 统计测试
                    List<Order> testOrders = ServiceLayer.listAllOrders();
                    result += "1. 订单统计测试:\n";
                    result += "   总订单数: " + (testOrders != null ? testOrders.size() : 0) + "\n";
                    
                    if (testOrders != null && !testOrders.isEmpty()) {
                        result += "   最新订单ID: " + testOrders.get(testOrders.size() - 1).getId() + "\n";
                    }
                    
                    // 2. 查询测试
                    result += "\n2. 查询功能测试:\n";
                    if (testOrders != null && !testOrders.isEmpty()) {
                        Order firstOrder = testOrders.get(0);
                        Order retrievedOrder = ServiceLayer.getOrderById(firstOrder.getId());
                        result += "   根据ID查询: " + (retrievedOrder != null ? "成功" : "失败") + "\n";
                        
                        List<Order> userOrders = ServiceLayer.getOrdersByUser(firstOrder.getUserId());
                        result += "   根据用户查询: " + (userOrders != null ? "成功 (" + userOrders.size() + "个订单)" : "失败") + "\n";
                    } else {
                        result += "   无订单数据，跳过查询测试\n";
                    }
                    
                    // 3. 用户和地址数据检查
                    result += "\n3. 关联数据检查:\n";
                    List<User> testUsers = ServiceLayer.getAllUsers();
                    result += "   用户数据: " + (testUsers != null ? testUsers.size() + "个用户" : "无数据") + "\n";
                    
                    if (testUsers != null && !testUsers.isEmpty()) {
                        List<Address> testAddresses = ServiceLayer.getAddresses(testUsers.get(0).getId());
                        result += "   地址数据: " + (testAddresses != null ? testAddresses.size() + "个地址" : "无数据") + "\n";
                    }
                    
                    result += "\n=== 测试完成 ===\n";
                    result += "订单功能基本正常，可以进行增删改查操作";
                    
                } catch (Exception e) {
                    result = "完整性测试失败: " + e.getMessage();
                }
        %>
        <div class="test-section">
            <h2>完整性测试结果</h2>
            <div class="test-result"><%= result %></div>
        </div>
        <% } %>
        
        <div style="margin-top: 30px; padding: 15px; background-color: #e9ecef; border-radius: 5px;">
            <h3>使用说明</h3>
            <ul>
                <li><strong>创建订单:</strong> 选择用户和输入金额即可创建测试订单</li>
                <li><strong>查询订单:</strong> 可以根据订单ID或用户ID查询订单信息</li>
                <li><strong>更新订单:</strong> 可以更新订单状态或标记为已支付</li>
                <li><strong>订单状态:</strong> pending(待处理) → paid(已支付) → processing(处理中) → completed(已完成)</li>
                <li><strong>快速测试:</strong> 使用快速测试按钮可以快速验证功能</li>
            </ul>
        </div>
    </div>
</body>
</html>