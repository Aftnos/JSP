<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.SNCode" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ include file="../checkAdmin.jsp" %>

<%
    // 获取所有商品和订单用于测试
    List<Product> allProducts = ServiceLayer.listProducts();
    List<Order> allOrders = ServiceLayer.listAllOrders();
    
    // 处理表单提交
    String action = request.getParameter("action");
    String message = "";
    List<SNCode> queryResults = null;
    
    if ("queryByProduct".equals(action)) {
        try {
            String productIdStr = request.getParameter("productId");
            String status = request.getParameter("status");
            
            if (productIdStr != null) {
                int productId = Integer.parseInt(productIdStr);
                
                // 如果状态为空字符串，设为null查询所有状态
                if (status != null && status.trim().isEmpty()) {
                    status = null;
                }
                
                queryResults = ServiceLayer.listSNCodes(productId, status);
                
                Product product = ServiceLayer.getProductById(productId);
                String productName = product != null ? product.getName() : "未知商品";
                String statusText = status != null ? status : "全部状态";
                
                message = "<div class='success'>查询完成！商品 " + productName + " (" + statusText + ") 共找到 " + 
                    (queryResults != null ? queryResults.size() : 0) + " 个SN码。</div>";
            } else {
                message = "<div class='error'>请选择商品！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>查询失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("queryByOrder".equals(action)) {
        try {
            String orderIdStr = request.getParameter("orderId");
            
            if (orderIdStr != null) {
                int orderId = Integer.parseInt(orderIdStr);
                
                queryResults = ServiceLayer.getSNCodesByOrder(orderId);
                
                message = "<div class='success'>查询完成！订单 " + orderId + " 共找到 " + 
                    (queryResults != null ? queryResults.size() : 0) + " 个SN码。</div>";
            } else {
                message = "<div class='error'>请选择订单！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>查询失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("testIntegrity".equals(action)) {
        try {
            StringBuilder testResult = new StringBuilder();
            testResult.append("<div class='success'><h4>SN码功能完整性测试结果：</h4>");
            
            // 测试商品SN码统计
            if (allProducts != null && !allProducts.isEmpty()) {
                testResult.append("<p><strong>商品SN码统计：</strong></p><ul>");
                for (int i = 0; i < Math.min(5, allProducts.size()); i++) {
                    Product product = allProducts.get(i);
                    List<SNCode> productSNCodes = ServiceLayer.listSNCodes(product.getId(), null);
                    testResult.append("<li>商品 ").append(product.getName())
                              .append(" (ID: ").append(product.getId()).append(")")
                              .append(": ").append(productSNCodes != null ? productSNCodes.size() : 0)
                              .append(" 个SN码</li>");
                }
                testResult.append("</ul>");
            }
            
            // 测试订单SN码统计
            if (allOrders != null && !allOrders.isEmpty()) {
                testResult.append("<p><strong>订单SN码统计：</strong></p><ul>");
                for (int i = 0; i < Math.min(5, allOrders.size()); i++) {
                    Order order = allOrders.get(i);
                    List<SNCode> orderSNCodes = ServiceLayer.getSNCodesByOrder(order.getId());
                    testResult.append("<li>订单 ").append(order.getId())
                              .append(": ").append(orderSNCodes != null ? orderSNCodes.size() : 0)
                              .append(" 个SN码</li>");
                }
                testResult.append("</ul>");
            }
            
            testResult.append("</div>");
            message = testResult.toString();
        } catch (Exception e) {
            message = "<div class='error'>完整性测试失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("generateSN".equals(action)) {
        try {
            String productIdStr = request.getParameter("genProductId");
            String sizeStr = request.getParameter("genSize");
            String batchIdStr = request.getParameter("genBatchId");
            
            if (productIdStr != null && sizeStr != null && batchIdStr != null) {
                int productId = Integer.parseInt(productIdStr);
                int size = Integer.parseInt(sizeStr);
                int batchId = Integer.parseInt(batchIdStr);
                
                ServiceLayer.generateSNCodes(productId, size, batchId);
                
                Product product = ServiceLayer.getProductById(productId);
                String productName = product != null ? product.getName() : "未知商品";
                
                message = "<div class='success'>SN码生成成功！为商品 " + productName + " 生成了 " + size + " 个SN码（批次：" + batchId + "）。</div>";
            } else {
                message = "<div class='error'>请填写完整的生成参数！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>生成SN码失败：" + e.getMessage() + "</div>";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SN码功能测试</title>
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
        .btn-success {
            background-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-warning:hover {
            background-color: #e0a800;
        }
        .success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .results-table th, .results-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .results-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .results-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        .status-available {
            color: #28a745;
            font-weight: bold;
        }
        .status-sold {
            color: #dc3545;
            font-weight: bold;
        }
        .status-bound {
            color: #007bff;
            font-weight: bold;
        }
        .status-invalid {
            color: #6c757d;
            font-weight: bold;
        }
        h1, h2 {
            color: #333;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="../index.jsp" class="back-link">← 返回管理后台</a>
        
        <h1>SN码功能测试</h1>
        
        <% if (!message.isEmpty()) { %>
            <%= message %>
        <% } %>
        
        <!-- 功能完整性测试 -->
        <div class="test-section">
            <h2>1. 功能完整性测试</h2>
            <p>测试SN码管理的基本功能，包括商品SN码统计和订单SN码统计。</p>
            <form method="post">
                <input type="hidden" name="action" value="testIntegrity">
                <button type="submit" class="btn-success">执行完整性测试</button>
            </form>
        </div>
        
        <!-- 按商品和状态查询SN列表 -->
        <div class="test-section">
            <h2>2. 按商品和状态查询SN列表</h2>
            <form method="post">
                <input type="hidden" name="action" value="queryByProduct">
                
                <div class="form-group">
                    <label for="productId">选择商品：</label>
                    <select name="productId" id="productId" required>
                        <option value="">请选择商品</option>
                        <% if (allProducts != null) {
                            for (Product product : allProducts) { %>
                                <option value="<%= product.getId() %>"><%= product.getName() %> (ID: <%= product.getId() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="status">SN码状态：</label>
                    <select name="status" id="status">
                        <option value="">全部状态</option>
                        <option value="available">可用</option>
                        <option value="sold">已售出</option>
                        <option value="bound">已绑定</option>
                        <option value="invalid">无效</option>
                    </select>
                </div>
                
                <button type="submit">查询SN码</button>
            </form>
        </div>
        
        <!-- 根据订单查询SN列表 -->
        <div class="test-section">
            <h2>3. 根据订单查询SN列表</h2>
            <form method="post">
                <input type="hidden" name="action" value="queryByOrder">
                
                <div class="form-group">
                    <label for="orderId">选择订单：</label>
                    <select name="orderId" id="orderId" required>
                        <option value="">请选择订单</option>
                        <% if (allOrders != null) {
                            for (Order order : allOrders) { %>
                                <option value="<%= order.getId() %>">订单 <%= order.getId() %> - <%= order.getStatus() %></option>
                        <%  }
                        } %>
                    </select>
                </div>
                
                <button type="submit">查询订单SN码</button>
            </form>
        </div>
        
        <!-- SN码生成测试 -->
        <div class="test-section">
            <h2>4. SN码生成测试</h2>
            <p>为指定商品生成测试SN码（仅用于测试目的）。</p>
            <form method="post">
                <input type="hidden" name="action" value="generateSN">
                
                <div class="form-group">
                    <label for="genProductId">选择商品：</label>
                    <select name="genProductId" id="genProductId" required>
                        <option value="">请选择商品</option>
                        <% if (allProducts != null) {
                            for (Product product : allProducts) { %>
                                <option value="<%= product.getId() %>"><%= product.getName() %> (ID: <%= product.getId() %>)</option>
                        <%  }
                        } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="genSize">生成数量：</label>
                    <input type="number" name="genSize" id="genSize" min="1" max="10" value="3" required>
                </div>
                
                <div class="form-group">
                    <label for="genBatchId">批次ID：</label>
                    <input type="number" name="genBatchId" id="genBatchId" value="<%= System.currentTimeMillis() / 1000 %>" required>
                </div>
                
                <button type="submit" class="btn-warning">生成测试SN码</button>
            </form>
        </div>
        
        <!-- 查询结果显示 -->
        <% if (queryResults != null) { %>
        <div class="test-section">
            <h2>查询结果</h2>
            <p>共找到 <%= queryResults.size() %> 个SN码：</p>
            
            <% if (!queryResults.isEmpty()) { %>
            <table class="results-table">
                <thead>
                    <tr>
                        <th>SN码</th>
                        <th>商品ID</th>
                        <th>状态</th>
                        <th>批次ID</th>
                        <th>批次信息</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (SNCode sn : queryResults) { %>
                    <tr>
                        <td><%= sn.getCode() %></td>
                        <td><%= sn.getProductId() %></td>
                        <td>
                            <span class="status-<%= sn.getStatus() %>">
                                <%= sn.getStatus() %>
                            </span>
                        </td>
                        <td><%= sn.getBatchId() %></td>
                        <td>批次: <%= sn.getBatchId() != null ? sn.getBatchId() : "未知" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p>没有找到符合条件的SN码。</p>
            <% } %>
        </div>
        <% } %>
        
        <!-- 系统信息 -->
        <div class="test-section">
            <h2>系统信息</h2>
            <p><strong>商品总数：</strong><%= allProducts != null ? allProducts.size() : 0 %></p>
            <p><strong>订单总数：</strong><%= allOrders != null ? allOrders.size() : 0 %></p>
            <p><strong>测试时间：</strong><%= new Date() %></p>
        </div>
    </div>
</body>
</html>