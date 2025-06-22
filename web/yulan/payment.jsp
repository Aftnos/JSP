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
    <link rel="stylesheet" href="css/main.css"/>
    <style>
        .payment-container {
            max-width: 400px;
            margin: 20px auto;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .payment-header {
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .payment-header h2 {
            margin: 0;
            font-size: 18px;
            font-weight: 500;
        }
        .order-info {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .order-number {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }
        .order-amount {
            font-size: 32px;
            font-weight: 300;
            color: #ff6b35;
            margin: 10px 0;
        }
        .order-amount .currency {
            font-size: 20px;
            vertical-align: top;
        }
        .order-time {
            color: #999;
            font-size: 12px;
        }
        .payment-methods {
            padding: 20px;
        }
        .payment-title {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
        }
        .payment-option {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
            cursor: pointer;
        }
        .payment-option:last-child {
            border-bottom: none;
        }
        .payment-icon {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            margin-right: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: white;
        }
        .test-pay { background: #666; }
        .payment-name {
            flex: 1;
            font-size: 14px;
            color: #333;
        }
        .payment-company {
            font-size: 12px;
            color: #999;
        }
        .payment-radio {
            width: 20px;
            height: 20px;
            border: 2px solid #ddd;
            border-radius: 50%;
            position: relative;
        }
        .payment-radio.selected {
            border-color: #ff6b35;
        }
        .payment-radio.selected::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 10px;
            height: 10px;
            background: #ff6b35;
            border-radius: 50%;
        }
        .credit-options {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .credit-title {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
        }
        .credit-option {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .credit-option:last-child {
            border-bottom: none;
        }
        .credit-icon {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            margin-right: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: white;
        }
        .credit1 { background: #1677ff; }
        .credit2 { background: #52c41a; }
        .credit3 { background: #fa541c; }
        .pay-button {
            margin: 20px;
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            color: white;
            border: none;
            border-radius: 25px;
            padding: 15px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            width: calc(100% - 40px);
            transition: all 0.3s;
        }
        .pay-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }
        .pay-button:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .message {
            padding: 15px;
            margin: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .message.success {
            background: #f6ffed;
            color: #52c41a;
            border: 1px solid #b7eb8f;
        }
        .message.error {
            background: #fff2f0;
            color: #ff4d4f;
            border: 1px solid #ffccc7;
        }
        .back-link {
            display: inline-block;
            margin: 20px;
            color: #666;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover {
            color: #ff6b35;
        }
        .paid-status {
            text-align: center;
            padding: 40px 20px;
            color: #52c41a;
        }
        .paid-status h3 {
            margin: 0 0 10px 0;
            font-size: 18px;
        }
    </style>
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

<script>
function selectPayment(type) {
    // 清除所有选中状态
    document.querySelectorAll('.payment-radio').forEach(radio => {
        radio.classList.remove('selected');
    });
    // 选中当前支付方式
    document.getElementById(type + '-radio').classList.add('selected');
}

// 默认选中测试支付
selectPayment('test');
</script>

</body>
</html>