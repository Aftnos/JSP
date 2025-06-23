<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    
    String orderIdParam = request.getParameter("orderId");
    if(orderIdParam == null){
        response.sendRedirect("orders.jsp");
        return;
    }
    
    int orderId = Integer.parseInt(orderIdParam);
    Order order = ServiceLayer.getOrderById(orderId);
    if(order == null || order.getUserId() != u.getId()){
        response.sendRedirect("orders.jsp");
        return;
    }
    
    String paymentMessage = null;
    
    // 处理支付
    if("pay".equals(request.getParameter("action"))){
        if(ServiceLayer.markOrderPaid(orderId)){
            paymentMessage = "支付成功！";
            // 刷新订单信息
            order = ServiceLayer.getOrderById(orderId);
        }else{
            paymentMessage = "支付失败，请重试";
        }
    }
    
    java.util.List<Address> addresses = ServiceLayer.getAddresses(u.getId());
    Address orderAddress = null;
    if(addresses != null){
        for(Address addr : addresses){
            if(addr.getId() == order.getAddressId()){
                orderAddress = addr;
                break;
            }
        }
    }
%>
<html>
<head>
    <title>订单支付</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/payment.css"/>
</head>
<body>

<div class="payment-container">
    <% if(paymentMessage!=null){ %>
    <div class="message <%= paymentMessage.contains("成功") ? "success" : "error" %>"><%= paymentMessage %></div>
    <% } %>
    
    <% if(order.isPaid()){ %>
    <div class="paid-status">
        <h3>✓ 订单已支付</h3>
        <p>订单号：<%= order.getId() %></p>
        <p>支付金额：¥<%= order.getTotal() %></p>
        <a href="orders.jsp" class="back-link">← 返回订单列表</a>
    </div>
    <% }else{ %>
    
    <div class="payment-header">
        <h2>用户结算</h2>
    </div>
    
    <div class="order-info">
        <div class="order-number">订单编号：<%= order.getId() %></div>
        <div class="order-number">收货信息：<%= u.getUsername() %> <%= orderAddress != null ? orderAddress.getDetail() : "地址信息不可用" %></div>
        <div class="order-amount"><span class="currency">¥</span><%= order.getTotal() %></div>
        <div class="order-time">支付剩余时间：00:29:17</div>
    </div>
    
    <div class="payment-methods">
        <div class="payment-title">支付工具</div>
        <div class="payment-option" onclick="selectPayment('test')">
            <div class="payment-icon test-pay">测试</div>
            <div>
                <div class="payment-name">测试支付</div>
                <div class="payment-company">测试支付公司</div>
            </div>
            <div class="payment-radio" id="test-radio"></div>
        </div>
    </div>
    
    <div class="credit-options">
        <div class="credit-title">信贷产品</div>
        <div class="credit-option">
            <div class="credit-icon credit1">信用</div>
            <div>
                <div class="payment-name">信用卡分期</div>
                <div class="payment-company">白条金融服务</div>
            </div>
        </div>
        <div class="credit-option">
            <div class="credit-icon credit2">花呗</div>
            <div>
                <div class="payment-name">花呗分期</div>
                <div class="payment-company">重庆蚂蚁消费金融有限公司及合作金融机构</div>
            </div>
        </div>
        <div class="credit-option">
            <div class="credit-icon credit3">白条</div>
            <div>
                <div class="payment-name">白条分期</div>
                <div class="payment-company">重庆京东小额贷款有限公司及合作金融机构</div>
            </div>
        </div>
    </div>
    
    <form method="post">
        <input type="hidden" name="action" value="pay"/>
        <input type="hidden" name="orderId" value="<%= order.getId() %>"/>
        <button type="submit" class="pay-button">确认支付 ¥<%= order.getTotal() %></button>
    </form>
    
    <% } %>
    
    <a href="orders.jsp" class="back-link">← 返回订单列表</a>
</div>


<script src="js/payment.js"></script>
</body>
</html>