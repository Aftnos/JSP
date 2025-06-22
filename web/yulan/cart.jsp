<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj=session.getAttribute("user");
    if(obj==null){response.sendRedirect("login.jsp"); return;}
    com.entity.User u=(com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message=null;
    String action=request.getParameter("action");
    if("update".equals(action)){
        int id=Integer.parseInt(request.getParameter("id"));
        int qty=Integer.parseInt(request.getParameter("qty"));
        if(ServiceLayer.updateCartItem(id,qty)) message="已更新"; else message="失败";
    }else if("delete".equals(action)){
        int id=Integer.parseInt(request.getParameter("id"));
        if(ServiceLayer.removeCartItem(id)) message="已删除"; else message="失败";
    }else if("order".equals(action)){
        int addrId=Integer.parseInt(request.getParameter("addressId"));
        java.math.BigDecimal t=new java.math.BigDecimal("0");
        java.util.List<Product> ps=ServiceLayer.listProducts();
        java.util.List<CartItem> its=ServiceLayer.getCartItems(u.getId());
        for(CartItem c:its){
            Product p=ps.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p!=null) t=t.add(p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())));
        }
        Order o=new Order();
        o.setUserId(u.getId());
        o.setAddressId(addrId);
        o.setStatus("NEW");
        o.setTotal(t);
        o.setPaid(false);
        if(ServiceLayer.createOrder(o)) message="订单已创建"; else message="创建失败";
    }
    java.util.List<CartItem> items=ServiceLayer.getCartItems(u.getId());
    java.util.List<Product> products=ServiceLayer.listProducts();
    java.util.List<Product> recommendedProducts=ServiceLayer.listProducts();
    java.math.BigDecimal total=new java.math.BigDecimal("0");
%>
<html>
<head>
    <title>购物车</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <style>
        .cart-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .cart-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fff;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .cart-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }
        .cart-items {
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .cart-item {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            position: relative;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .item-checkbox {
            margin-right: 15px;
            width: 18px;
            height: 18px;
            accent-color: #ff6700;
        }
        .item-image {
            width: 80px;
            height: 80px;
            background: #f5f5f5;
            border-radius: 8px;
            margin-right: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 12px;
        }
        .item-info {
            flex: 1;
            margin-right: 15px;
        }
        .item-name {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
            text-decoration: none;
        }
        .item-spec {
            font-size: 14px;
            color: #999;
            margin-bottom: 5px;
        }
        .item-price {
            font-size: 16px;
            color: #ff6700;
            font-weight: 600;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            margin-right: 20px;
        }
        .qty-btn {
            width: 32px;
            height: 32px;
            border: 1px solid #ddd;
            background: #fff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: #666;
        }
        .qty-btn:hover {
            background: #f5f5f5;
        }
        .qty-btn:disabled {
            background: #f5f5f5;
            color: #ccc;
            cursor: not-allowed;
        }
        .qty-input {
            width: 50px;
            height: 32px;
            border: 1px solid #ddd;
            border-left: none;
            border-right: none;
            text-align: center;
            font-size: 14px;
        }
        .item-total {
            font-size: 16px;
            color: #333;
            font-weight: 600;
            min-width: 80px;
            text-align: right;
        }
        .delete-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 16px;
        }
        .delete-btn:hover {
            color: #ff4444;
        }
        .cart-summary {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
            color: #666;
        }
        .summary-total {
            display: flex;
            justify-content: space-between;
            font-size: 18px;
            font-weight: 600;
            color: #333;
            padding-top: 10px;
            border-top: 1px solid #f0f0f0;
        }
        .total-price {
            color: #ff6700;
        }
        .checkout-section {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .address-select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: #ff6700;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }
        .checkout-btn:hover {
            background: #e55a00;
        }
        .checkout-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .recommended-section {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
        }
        .recommended-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .recommended-item {
            border: 1px solid #f0f0f0;
            border-radius: 8px;
            overflow: hidden;
            transition: box-shadow 0.2s;
        }
        .recommended-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .recommended-image {
            width: 100%;
            height: 150px;
            background: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 12px;
        }
        .recommended-info {
            padding: 15px;
        }
        .recommended-name {
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
            text-decoration: none;
            display: block;
        }
        .recommended-price {
            font-size: 16px;
            color: #ff6700;
            font-weight: 600;
        }
        .original-price {
            font-size: 12px;
            color: #999;
            text-decoration: line-through;
            margin-left: 8px;
        }
        .message {
            background: #e8f5e8;
            color: #2d7d2d;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
        }
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-cart-icon {
            font-size: 48px;
            margin-bottom: 20px;
        }
        .continue-shopping {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: #ff6700;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
        }
    </style>
</head>
<body>
<header class="header">
    <div class="header-top">
        <div class="logo"><a href="index.jsp" style="color:#ff6700;text-decoration:none;">小米商城</a></div>
        <div class="user-info">
            <% if(session.getAttribute("user")!=null){ %>
            欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" class="logout-btn">退出</a>
            <% }else{ %>
            <a href="login.jsp" class="login-btn">登录</a> | <a href="register.jsp" class="login-btn">注册</a>
            <% } %>
        </div>
    </div>
</header>

<div class="cart-container">
    <div class="cart-header">
        <div class="cart-title">购物车</div>
    </div>
    
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    
    <% if(items.isEmpty()){ %>
    <div class="empty-cart">
        <div class="empty-cart-icon">🛒</div>
        <div>购物车是空的</div>
        <a href="index.jsp" class="continue-shopping">继续购物</a>
    </div>
    <% }else{ %>
    
    <div class="cart-items">
        <% for(CartItem c:items){
            Product p=products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p==null) continue;
            java.math.BigDecimal sub=p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity()));
            total=total.add(sub);
        %>
        <div class="cart-item">
            <input type="checkbox" class="item-checkbox" checked>
            <div class="item-image">商品图片</div>
            <div class="item-info">
                <a href="product.jsp?id=<%=p.getId()%>" class="item-name"><%=p.getName()%></a>
                <div class="item-spec">白色</div>
                <div class="item-price">￥<%=p.getPrice()%></div>
            </div>
            <div class="quantity-control">
                <form method="post" style="display:flex;align-items:center;">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=c.getId()%>"/>
                    <button type="button" class="qty-btn" onclick="decreaseQty(this)">-</button>
                    <input type="number" name="qty" value="<%=c.getQuantity()%>" class="qty-input" min="1" onchange="this.form.submit()">
                    <button type="button" class="qty-btn" onclick="increaseQty(this)">+</button>
                </form>
            </div>
            <div class="item-total">￥<%=sub%></div>
            <form method="post" onsubmit="return confirm('确定删除?');" style="display:inline">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="id" value="<%=c.getId()%>"/>
                <button type="submit" class="delete-btn">×</button>
            </form>
        </div>
        <% } %>
    </div>
    
    <div class="cart-summary">
        <div class="summary-row">
            <span>商品总价</span>
            <span>￥<%= total %></span>
        </div>
        <div class="summary-row">
            <span>运费</span>
            <span>免运费</span>
        </div>
        <div class="summary-total">
            <span>合计</span>
            <span class="total-price">￥<%= total %></span>
        </div>
    </div>
    
    <div class="checkout-section">
        <form method="post">
            <input type="hidden" name="action" value="order"/>
            <select name="addressId" class="address-select">
                <option value="">选择收货地址</option>
                <% for(Address a : ServiceLayer.getAddresses(u.getId())){ %>
                <option value="<%= a.getId() %>"><%= a.getDetail() %></option>
                <% } %>
            </select>
            <button type="submit" class="checkout-btn">结算(<%=items.size()%>)</button>
        </form>
    </div>
    
    <% } %>
    
    <div class="recommended-section">
        <div class="section-title">精选好物</div>
        <div class="recommended-grid">
            <% 
            int count = 0;
            for(Product rp : recommendedProducts){
                if(count >= 4) break;
                count++;
            %>
            <div class="recommended-item">
                <div class="recommended-image">商品图片</div>
                <div class="recommended-info">
                    <a href="product.jsp?id=<%=rp.getId()%>" class="recommended-name"><%=rp.getName()%></a>
                    <div class="recommended-price">
                        ￥<%=rp.getPrice()%>
                        <% if(Math.random() > 0.5){ %>
                        <span class="original-price">￥<%=rp.getPrice().multiply(new java.math.BigDecimal("1.2"))%></span>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
function increaseQty(btn) {
    const input = btn.previousElementSibling;
    input.value = parseInt(input.value) + 1;
    input.form.submit();
}

function decreaseQty(btn) {
    const input = btn.nextElementSibling;
    if(parseInt(input.value) > 1) {
        input.value = parseInt(input.value) - 1;
        input.form.submit();
    }
}
</script>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
