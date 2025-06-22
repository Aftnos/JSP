<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    String paymentMessage = null;
    java.util.List<Address> addresses = ServiceLayer.getAddresses(u.getId());
    
    // 处理支付
    if("pay".equals(request.getParameter("action"))){
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        if(ServiceLayer.markOrderPaid(orderId)){
            paymentMessage = "支付成功！";
        }else{
            paymentMessage = "支付失败，请重试";
        }
    }
    
    // 创建订单
    if("create".equals(request.getParameter("action"))){
        int addrId = Integer.parseInt(request.getParameter("addressId"));
        java.util.List<CartItem> items = ServiceLayer.getCartItems(u.getId());
        java.util.List<Product> products = ServiceLayer.listProducts();
        java.math.BigDecimal total = new java.math.BigDecimal("0");
        for(CartItem c:items){
            Product p = products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p!=null){
                total = total.add(p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())));
            }
        }
        Order o = new Order();
        o.setUserId(u.getId());
        o.setAddressId(addrId);
        o.setStatus("NEW");
        o.setTotal(total);
        o.setPaid(false);
        if(ServiceLayer.createOrder(o)){
            message = "订单创建成功，ID="+o.getId();
        }else{
            message = "创建失败";
        }
    }
    
    java.util.List<Order> orders = ServiceLayer.getOrdersByUser(u.getId());
    java.util.List<CartItem> cartItems = ServiceLayer.getCartItems(u.getId());
    java.util.List<Product> products = ServiceLayer.listProducts();
%>
<html>
<head>
    <title>我的订单</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <style>
        .order-container {
            max-width: 400px;
            margin: 20px auto;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .order-header {
            background: linear-gradient(135deg, #ff6b35, #f7931e);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .order-header h2 {
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
        .order-details {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .order-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f5f5f5;
        }
        .order-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        .item-image {
            width: 50px;
            height: 50px;
            background: #f5f5f5;
            border-radius: 8px;
            margin-right: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #999;
        }
        .item-info {
            flex: 1;
        }
        .item-name {
            font-size: 14px;
            color: #333;
            margin-bottom: 4px;
        }
        .item-spec {
            font-size: 12px;
            color: #999;
        }
        .item-price {
            font-size: 14px;
            color: #333;
            font-weight: 500;
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
        .alipay { background: #1677ff; }
        .xiaomi { background: #ff6900; }
        .wechat { background: #07c160; }
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
        .credit4 { background: #722ed1; }
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
            margin: 20px;
            padding: 12px;
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
        .order-list {
            margin-top: 20px;
        }
        .order-card {
            background: white;
            border-radius: 12px;
            margin-bottom: 15px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .order-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .order-id {
            font-size: 14px;
            color: #666;
        }
        .order-status {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            background: #f0f0f0;
            color: #666;
        }
        .order-status.paid {
            background: #f6ffed;
            color: #52c41a;
        }
        .order-total {
            font-size: 18px;
            font-weight: 500;
            color: #333;
            margin: 8px 0;
        }
        .order-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .btn-pay {
            background: #ff6b35;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 12px;
            cursor: pointer;
        }
        .btn-pay:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<header>
    <div class="logo"><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div class="user">
        <% if(session.getAttribute("user")!=null){ %>
        欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" style="color:#fff;">退出</a>
        <% }else{ %>
        <a href="login.jsp" style="color:#fff;">登录</a> | <a href="register.jsp" style="color:#fff;">注册</a>
        <% } %>
    </div>
</header>

<div class="container">
    <% if(message!=null){ %>
    <div class="message success"><%= message %></div>
    <% } %>
    
    <% if(paymentMessage!=null){ %>
    <div class="message <%= paymentMessage.contains("成功") ? "success" : "error" %>"><%= paymentMessage %></div>
    <% } %>
    
    <!-- 创建订单区域 -->
    <% if(cartItems.size() > 0){ %>
    <div class="order-container">
        <div class="order-header">
            <h2>用户结算</h2>
        </div>
        
        <div class="order-info">
            <div class="order-number">订单编号：待生成</div>
            <div class="order-number">收货信息：<%= u.getUsername() %> <%= addresses.size() > 0 ? addresses.get(0).getDetail() : "请添加收货地址" %></div>
            <%
                java.math.BigDecimal total = new java.math.BigDecimal("0");
                for(CartItem c : cartItems){
                    Product p = products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
                    if(p!=null){
                        total = total.add(p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())));
                    }
                }
            %>
            <div class="order-amount"><span class="currency">¥</span><%= total %></div>
            <div class="order-time">支付剩余时间：00:29:17</div>
        </div>
        
        <div class="order-details">
            <% for(CartItem c : cartItems){ %>
                <% Product p = products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null); %>
                <% if(p!=null){ %>
                <div class="order-item">
                    <div class="item-image">图片</div>
                    <div class="item-info">
                        <div class="item-name"><%= p.getName() %></div>
                        <div class="item-spec"><%= c.getQuantity() %> x ¥<%= p.getPrice() %></div>
                    </div>
                    <div class="item-price">¥<%= p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())) %></div>
                </div>
                <% } %>
            <% } %>
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
        
        <% if(addresses.size() > 0){ %>
        <form method="post" id="createOrderForm">
            <input type="hidden" name="action" value="create"/>
            <input type="hidden" name="addressId" value="<%= addresses.get(0).getId() %>"/>
            <button type="submit" class="pay-button">确认支付 ¥<%= total %></button>
        </form>
        <% }else{ %>
        <button class="pay-button" disabled>请先添加收货地址</button>
        <% } %>
    </div>
    <% } %>
    
    <!-- 订单列表 -->
    <div class="order-list">
        <h3 style="margin: 20px 0; color: #333;">我的订单</h3>
        <% for(Order o:orders){ %>
        <div class="order-card">
            <div class="order-card-header">
                <div class="order-id">订单号：<%= o.getId() %></div>
                <div class="order-status <%= o.isPaid() ? "paid" : "" %>"><%= o.isPaid() ? "已付款" : "待付款" %></div>
            </div>
            <div class="order-total">¥<%= o.getTotal() %></div>
            <div style="font-size: 12px; color: #999; margin: 5px 0;">状态：<%= o.getStatus() %></div>
            <div class="order-actions">
                <% if(!o.isPaid()){ %>
                <form method="post" style="display: inline;">
                    <input type="hidden" name="action" value="pay"/>
                    <input type="hidden" name="orderId" value="<%= o.getId() %>"/>
                    <button type="submit" class="btn-pay">立即支付</button>
                </form>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
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

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
