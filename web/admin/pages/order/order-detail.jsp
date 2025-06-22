<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Order" %>
<%@ page import="com.entity.OrderItem" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Address" %>
<%@ page import="com.entity.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String orderIdStr = request.getParameter("orderId");
    if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
        out.println("<div style='text-align: center; padding: 50px; color: red;'>订单ID不能为空</div>");
        return;
    }
    
    try {
        int orderId = Integer.parseInt(orderIdStr);
        Order order = ServiceLayer.getOrderById(orderId);
        
        if (order == null) {
            out.println("<div style='text-align: center; padding: 50px; color: red;'>订单不存在</div>");
            return;
        }
        
        // 获取用户信息
        User user = ServiceLayer.getUserById(order.getUserId());
        String username = (user != null) ? user.getUsername() : "用户" + order.getUserId();
        
        // 获取地址信息
        List<Address> allAddresses = ServiceLayer.getAllAddresses();
        String addressInfo = "地址" + order.getAddressId();
        if (allAddresses != null) {
            for (Address addr : allAddresses) {
                if (addr.getId() == order.getAddressId()) {
                    addressInfo = "";
                    if (addr.getReceiver() != null && !addr.getReceiver().trim().isEmpty()) {
                        addressInfo += "收货人: " + addr.getReceiver();
                    }
                    if (addr.getPhone() != null && !addr.getPhone().trim().isEmpty()) {
                        if (!addressInfo.isEmpty()) addressInfo += "<br>";
                        addressInfo += "联系电话: " + addr.getPhone();
                    }
                    if (addr.getDetail() != null && !addr.getDetail().trim().isEmpty()) {
                        if (!addressInfo.isEmpty()) addressInfo += "<br>";
                        addressInfo += "详细地址: " + addr.getDetail();
                    }
                    break;
                }
            }
        }
        
        // 订单状态显示
        String statusText = "未知";
        String statusClass = "";
        if (order.getStatus() != null) {
            switch (order.getStatus()) {
                case "pending":
                    statusText = "待付款";
                    statusClass = "status-pending";
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
                case "cancelled":
                    statusText = "已取消";
                    statusClass = "status-cancelled";
                    break;
            }
        }
        

        
        // 格式化日期
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String createdAtStr = (order.getCreatedAt() != null) ? sdf.format(order.getCreatedAt()) : "";
%>

<!-- 基本信息 -->
<div class="order-detail-section">
    <h4>基本信息</h4>
    <div class="detail-row">
        <div class="detail-label">订单编号:</div>
        <div class="detail-value"><%= order.getId() %></div>
    </div>
    <div class="detail-row">
        <div class="detail-label">用户名:</div>
        <div class="detail-value"><%= username %></div>
    </div>
    <div class="detail-row">
        <div class="detail-label">订单状态:</div>
        <div class="detail-value">
            <span class="status-badge-detail <%= statusClass %>"><%= statusText %></span>
        </div>
    </div>
    <div class="detail-row">
        <div class="detail-label">订单总金额:</div>
        <div class="detail-value">¥<%= order.getTotal() != null ? order.getTotal() : "0.00" %></div>
    </div>
    <div class="detail-row">
        <div class="detail-label">创建时间:</div>
        <div class="detail-value"><%= createdAtStr %></div>
    </div>
</div>

<!-- 收货信息 -->
<div class="order-detail-section">
    <h4>收货信息</h4>
    <div class="detail-row">
        <div class="detail-label">收货地址:</div>
        <div class="detail-value"><%= addressInfo %></div>
    </div>
</div>

<!-- 订单商品 -->
<div class="order-detail-section">
    <h4>订单商品</h4>
    <%
        List<OrderItem> orderItems = order.getItems();
        if (orderItems != null && !orderItems.isEmpty()) {
    %>
    <table class="order-items-table">
        <thead>
            <tr>
                <th>商品ID</th>
                <th>商品名称</th>
                <th>单价</th>
                <th>数量</th>
                <th>小计</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (OrderItem item : orderItems) {
                    // 获取商品信息
                    Product product = ServiceLayer.getProductById(item.getProductId());
                    String productName = (product != null) ? product.getName() : "商品" + item.getProductId();
                    
                    // 计算小计
                    java.math.BigDecimal subtotal = item.getPrice().multiply(new java.math.BigDecimal(item.getQuantity()));
            %>
            <tr>
                <td><%= item.getProductId() %></td>
                <td><%= productName %></td>
                <td>¥<%= item.getPrice() %></td>
                <td><%= item.getQuantity() %></td>
                <td>¥<%= subtotal %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <%
        } else {
    %>
    <div style="text-align: center; padding: 20px; color: #666;">该订单暂无商品信息</div>
    <%
        }
    %>
</div>

<!-- SN码列表 -->
<div class="order-detail-section">
    <h4>SN码列表</h4>
    <ul>
        <%
            java.util.List<com.entity.SNCode> snList = com.ServiceLayer.getSNCodesByOrder(order.getId());
            for(com.entity.SNCode sn : snList){
        %>
        <li><%= sn.getCode() %></li>
        <% } %>
    </ul>
</div>

<%
    } catch (NumberFormatException e) {
        out.println("<div style='text-align: center; padding: 50px; color: red;'>订单ID格式错误</div>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div style='text-align: center; padding: 50px; color: red;'>获取订单详情失败: " + e.getMessage() + "</div>");
    }
%>

<style>
    .status-pending { background-color: #fff3cd; color: #856404; }
    .status-paid { background-color: #d1ecf1; color: #0c5460; }
    .status-shipped { background-color: #d4edda; color: #155724; }
    .status-delivered { background-color: #cce5ff; color: #004085; }
    .status-completed { background-color: #d4edda; color: #155724; }
    .status-cancelled { background-color: #f8d7da; color: #721c24; }
</style>