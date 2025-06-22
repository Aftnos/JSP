<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    java.util.List<Address> addresses = ServiceLayer.getAddresses(u.getId());
    
    // 创建订单
    if("create".equals(request.getParameter("action"))){
        int addrId = Integer.parseInt(request.getParameter("addressId"));
        java.util.List<CartItem> items = ServiceLayer.getCartItems(u.getId());
        java.util.List<Product> products = ServiceLayer.listProducts();
        java.math.BigDecimal total = new java.math.BigDecimal("0");
        java.util.List<OrderItem> ois = new java.util.ArrayList<>();
        for(CartItem c:items){
            Product p = products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p!=null){
                total = total.add(p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())));
                OrderItem oi = new OrderItem();
                oi.setProductId(p.getId());
                oi.setQuantity(c.getQuantity());
                oi.setPrice(p.getPrice());
                ois.add(oi);
            }
        }
        Order o = new Order();
        o.setUserId(u.getId());
        o.setAddressId(addrId);
        o.setStatus("NEW");
        o.setTotal(total);
        o.setPaid(false);
        o.setItems(ois);
        if(ServiceLayer.createOrder(o)){
            for(CartItem c:items){ ServiceLayer.removeCartItem(c.getId()); }
            message = "订单创建成功，ID="+o.getId();
        }else{
            message = "创建失败";
        }
    }
    
    java.util.List<Order> orders = ServiceLayer.getOrdersByUser(u.getId());
    java.util.List<CartItem> cartItems = ServiceLayer.getCartItems(u.getId());
%>
<html>
<head>
    <title>我的订单</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/orders.css"/>
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
    
    <!-- 创建订单区域 -->
    <% if(cartItems.size() > 0){ %>
    <div class="create-order-section">
        <h3 style="margin: 20px 0; color: #333;">从购物车创建订单</h3>
        <div class="cart-summary">
            <p>购物车中有 <%= cartItems.size() %> 件商品</p>
            <% if(addresses.size() > 0){ %>
            <form method="post" style="margin-top: 15px;">
                <input type="hidden" name="action" value="create"/>
                <input type="hidden" name="addressId" value="<%= addresses.get(0).getId() %>"/>
                <button type="submit" class="create-order-btn">创建订单</button>
            </form>
            <% }else{ %>
            <p style="color: #ff4d4f;">请先添加收货地址</p>
            <% } %>
        </div>
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
                <a href="payment.jsp?orderId=<%= o.getId() %>" class="btn-pay">立即支付</a>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</div>



<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
