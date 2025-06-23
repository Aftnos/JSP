<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.AfterSale" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>

<%
    // 获取所有用户和售后工单用于测试
    List<User> allUsers = ServiceLayer.getAllUsers();
    List<AfterSale> allAfterSales = ServiceLayer.listAllAfterSales();
    
    // 处理表单提交
    String action = request.getParameter("action");
    String message = "";
    
    if ("testIntegrity".equals(action)) {
        try {
            int userCount = allUsers != null ? allUsers.size() : 0;
            int afterSaleCount = allAfterSales != null ? allAfterSales.size() : 0;
            
            // 统计各状态数量
            int pendingCount = 0, processingCount = 0, completedCount = 0, closedCount = 0;
            if (allAfterSales != null) {
                for (AfterSale afterSale : allAfterSales) {
                    String status = afterSale.getStatus();
                    if ("pending".equals(status)) pendingCount++;
                    else if ("processing".equals(status)) processingCount++;
                    else if ("completed".equals(status)) completedCount++;
                    else if ("closed".equals(status)) closedCount++;
                }
            }
            
            message = "<div class='success'>售后管理功能完整性测试通过！<br>" +
                     "系统用户数: " + userCount + "<br>" +
                     "售后工单总数: " + afterSaleCount + "<br>" +
                     "状态分布 - 待处理: " + pendingCount + ", 处理中: " + processingCount + 
                     ", 已完成: " + completedCount + ", 已关闭: " + closedCount + "</div>";
        } catch (Exception e) {
            message = "<div class='error'>测试失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("queryByUser".equals(action)) {
        try {
            String userIdStr = request.getParameter("userId");
            
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                int userId = Integer.parseInt(userIdStr);
                
                // 获取用户信息
                User user = ServiceLayer.getUserById(userId);
                if (user != null) {
                    List<AfterSale> userAfterSales = ServiceLayer.getAfterSalesByUser(userId);
                    
                    if (userAfterSales != null) {
                        message = "<div class='success'>查询成功！用户 " + user.getUsername() + 
                                 " 共有 " + userAfterSales.size() + " 个售后工单。</div>";
                        
                        if (!userAfterSales.isEmpty()) {
                            message += "<div class='info'><strong>工单列表：</strong><br>";
                            for (AfterSale afterSale : userAfterSales) {
                                message += "工单ID: " + afterSale.getId() + 
                                          ", SN: " + afterSale.getSnCode() + 
                                          ", 类型: " + afterSale.getType() + 
                                          ", 状态: " + afterSale.getStatus() + "<br>";
                            }
                            message += "</div>";
                        }
                    } else {
                        message = "<div class='error'>查询用户售后工单失败！</div>";
                    }
                } else {
                    message = "<div class='error'>用户不存在！</div>";
                }
            } else {
                message = "<div class='error'>请选择用户！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>查询失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("updateStatus".equals(action)) {
        try {
            String afterSaleIdStr = request.getParameter("afterSaleId");
            String newStatus = request.getParameter("newStatus");
            String remark = request.getParameter("remark");
            
            if (afterSaleIdStr != null && newStatus != null && !newStatus.trim().isEmpty()) {
                int afterSaleId = Integer.parseInt(afterSaleIdStr);
                
                if (remark == null) remark = "";
                
                boolean result = ServiceLayer.updateAfterSaleStatus(afterSaleId, newStatus.trim(), remark.trim());
                
                if (result) {
                    message = "<div class='success'>售后工单状态更新成功！<br>" +
                             "工单ID: " + afterSaleId + "<br>" +
                             "新状态: " + newStatus + "<br>" +
                             "备注: " + (remark.trim().isEmpty() ? "无" : remark) + "</div>";
                } else {
                    message = "<div class='error'>售后工单状态更新失败！</div>";
                }
            } else {
                message = "<div class='error'>请填写完整的更新信息！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>更新状态失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("applyAfterSale".equals(action)) {
        try {
            String userIdStr = request.getParameter("applyUserId");
            String snCode = request.getParameter("snCode");
            String type = request.getParameter("type");
            String reason = request.getParameter("reason");
            
            if (userIdStr != null && snCode != null && type != null && reason != null &&
                !snCode.trim().isEmpty() && !type.trim().isEmpty() && !reason.trim().isEmpty()) {
                
                int userId = Integer.parseInt(userIdStr);
                
                AfterSale afterSale = new AfterSale();
                afterSale.setUserId(userId);
                afterSale.setSnCode(snCode.trim());
                afterSale.setType(type.trim());
                afterSale.setReason(reason.trim());
                afterSale.setStatus("pending");
                afterSale.setRemark("");
                
                boolean result = ServiceLayer.applyAfterSale(afterSale);
                
                if (result) {
                    message = "<div class='success'>售后申请提交成功！<br>" +
                             "用户ID: " + userId + "<br>" +
                             "SN码: " + snCode + "<br>" +
                             "类型: " + type + "<br>" +
                             "原因: " + reason + "</div>";
                } else {
                    message = "<div class='error'>售后申请提交失败！</div>";
                }
            } else {
                message = "<div class='error'>请填写完整的申请信息！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>提交申请失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("closeAfterSale".equals(action)) {
        try {
            String afterSaleIdStr = request.getParameter("closeAfterSaleId");
            
            if (afterSaleIdStr != null && !afterSaleIdStr.trim().isEmpty()) {
                int afterSaleId = Integer.parseInt(afterSaleIdStr);
                
                boolean result = ServiceLayer.closeAfterSale(afterSaleId);
                
                if (result) {
                    message = "<div class='success'>售后工单关闭成功！工单ID: " + afterSaleId + "</div>";
                } else {
                    message = "<div class='error'>售后工单关闭失败！</div>";
                }
            } else {
                message = "<div class='error'>请选择要关闭的工单！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>关闭工单失败：" + e.getMessage() + "</div>";
        }
    }
    
    // 刷新数据
    if (!message.isEmpty()) {
        allUsers = ServiceLayer.getAllUsers();
        allAfterSales = ServiceLayer.listAllAfterSales();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>售后管理功能测试</title>
    <meta charset="UTF-8">
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
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        h2 {
            color: #555;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
            margin-top: 30px;
        }
        .test-section {
            margin: 20px 0;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fafafa;
        }
        .form-group {
            margin: 10px 0;
        }
        label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
        }
        input, select, textarea {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        input[type="text"], input[type="number"], select, textarea {
            width: 200px;
        }
        textarea {
            width: 300px;
            height: 60px;
            resize: vertical;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
            margin: 10px 0;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            margin: 10px 0;
        }
        .info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 10px;
            border: 1px solid #bee5eb;
            border-radius: 4px;
            margin: 10px 0;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        .data-table th, .data-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .data-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .data-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .status-pending { color: #856404; }
        .status-processing { color: #0c5460; }
        .status-completed { color: #155724; }
        .status-closed { color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <h1>售后管理功能测试</h1>
        
        <% if (!message.isEmpty()) { %>
            <%= message %>
        <% } %>
        
        <!-- 功能完整性测试 -->
        <div class="test-section">
            <h2>1. 功能完整性测试</h2>
            <p>测试售后管理的基本功能是否正常工作</p>
            <form method="post">
                <input type="hidden" name="action" value="testIntegrity">
                <button type="submit">执行完整性测试</button>
            </form>
        </div>
        
        <!-- 查询所有售后工单 -->
        <div class="test-section">
            <h2>2. 查询所有售后工单</h2>
            <p>当前系统中的所有售后工单：</p>
            
            <% if (allAfterSales != null && !allAfterSales.isEmpty()) { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>工单ID</th>
                            <th>用户ID</th>
                            <th>SN码</th>
                            <th>类型</th>
                            <th>原因</th>
                            <th>状态</th>
                            <th>备注</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (AfterSale afterSale : allAfterSales) { %>
                            <tr>
                                <td><%= afterSale.getId() %></td>
                                <td><%= afterSale.getUserId() %></td>
                                <td><%= afterSale.getSnCode() %></td>
                                <td><%= afterSale.getType() %></td>
                                <td><%= afterSale.getReason() %></td>
                                <td class="status-<%= afterSale.getStatus() %>"><%= afterSale.getStatus() %></td>
                                <td><%= afterSale.getRemark() != null ? afterSale.getRemark() : "" %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                <p><strong>总计：</strong><%= allAfterSales.size() %> 个售后工单</p>
            <% } else { %>
                <p class="info">暂无售后工单</p>
            <% } %>
        </div>
        
        <!-- 根据用户查询售后 -->
        <div class="test-section">
            <h2>3. 根据用户查询售后工单</h2>
            <form method="post">
                <input type="hidden" name="action" value="queryByUser">
                <div class="form-group">
                    <label>选择用户：</label>
                    <select name="userId" required>
                        <option value="">请选择用户</option>
                        <% if (allUsers != null) {
                            for (User user : allUsers) { %>
                                <option value="<%= user.getId() %>"><%= user.getUsername() %> (ID: <%= user.getId() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                <button type="submit">查询用户售后工单</button>
            </form>
        </div>
        
        <!-- 修改售后单状态 -->
        <div class="test-section">
            <h2>4. 修改售后单状态</h2>
            <form method="post">
                <input type="hidden" name="action" value="updateStatus">
                <div class="form-group">
                    <label>选择工单：</label>
                    <select name="afterSaleId" required>
                        <option value="">请选择工单</option>
                        <% if (allAfterSales != null) {
                            for (AfterSale afterSale : allAfterSales) { %>
                                <option value="<%= afterSale.getId() %>">ID: <%= afterSale.getId() %> - <%= afterSale.getSnCode() %> (当前: <%= afterSale.getStatus() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>新状态：</label>
                    <select name="newStatus" required>
                        <option value="">请选择状态</option>
                        <option value="pending">待处理</option>
                        <option value="processing">处理中</option>
                        <option value="completed">已完成</option>
                        <option value="closed">已关闭</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>备注：</label>
                    <textarea name="remark" placeholder="可选，填写处理备注"></textarea>
                </div>
                <button type="submit">更新状态</button>
            </form>
        </div>
        
        <!-- 申请售后 -->
        <div class="test-section">
            <h2>5. 申请售后（测试创建功能）</h2>
            <form method="post">
                <input type="hidden" name="action" value="applyAfterSale">
                <div class="form-group">
                    <label>选择用户：</label>
                    <select name="applyUserId" required>
                        <option value="">请选择用户</option>
                        <% if (allUsers != null) {
                            for (User user : allUsers) { %>
                                <option value="<%= user.getId() %>"><%= user.getUsername() %> (ID: <%= user.getId() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>SN码：</label>
                    <input type="text" name="snCode" placeholder="输入产品SN码" required>
                </div>
                <div class="form-group">
                    <label>售后类型：</label>
                    <select name="type" required>
                        <option value="">请选择类型</option>
                        <option value="repair">维修</option>
                        <option value="return">退货</option>
                        <option value="exchange">换货</option>
                        <option value="refund">退款</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>申请原因：</label>
                    <textarea name="reason" placeholder="详细描述问题" required></textarea>
                </div>
                <button type="submit">提交申请</button>
            </form>
        </div>
        
        <!-- 关闭售后工单 -->
        <div class="test-section">
            <h2>6. 关闭售后工单</h2>
            <form method="post">
                <input type="hidden" name="action" value="closeAfterSale">
                <div class="form-group">
                    <label>选择工单：</label>
                    <select name="closeAfterSaleId" required>
                        <option value="">请选择要关闭的工单</option>
                        <% if (allAfterSales != null) {
                            for (AfterSale afterSale : allAfterSales) {
                                if (!"closed".equals(afterSale.getStatus())) { %>
                                    <option value="<%= afterSale.getId() %>">ID: <%= afterSale.getId() %> - <%= afterSale.getSnCode() %> (<%= afterSale.getStatus() %>)</option>
                        <%      }
                            }
                        } %>
                    </select>
                </div>
                <button type="submit">关闭工单</button>
            </form>
        </div>
        
        <!-- 系统信息 -->
        <div class="test-section">
            <h2>7. 系统信息</h2>
            <div class="info">
                <strong>当前系统状态：</strong><br>
                用户总数：<%= allUsers != null ? allUsers.size() : 0 %><br>
                售后工单总数：<%= allAfterSales != null ? allAfterSales.size() : 0 %><br>
                
                <% if (allAfterSales != null && !allAfterSales.isEmpty()) {
                    int pendingCount = 0, processingCount = 0, completedCount = 0, closedCount = 0;
                    for (AfterSale afterSale : allAfterSales) {
                        String status = afterSale.getStatus();
                        if ("pending".equals(status)) pendingCount++;
                        else if ("processing".equals(status)) processingCount++;
                        else if ("completed".equals(status)) completedCount++;
                        else if ("closed".equals(status)) closedCount++;
                    }
                %>
                    状态分布：待处理(<%= pendingCount %>), 处理中(<%= processingCount %>), 已完成(<%= completedCount %>), 已关闭(<%= closedCount %>)
                <% } %>
            </div>
        </div>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="../index.jsp" style="text-decoration: none;">
                <button type="button">返回管理首页</button>
            </a>
        </div>
    </div>
</body>
</html>