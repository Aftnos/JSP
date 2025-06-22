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
        java.util.List<OrderItem> ois=new java.util.ArrayList<>();
        for(CartItem c:its){
            Product p=ps.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p!=null){
                t=t.add(p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())));
                OrderItem oi=new OrderItem();
                oi.setProductId(p.getId());
                oi.setQuantity(c.getQuantity());
                oi.setPrice(p.getPrice());
                ois.add(oi);
            }
        }
        Order o=new Order();
        o.setUserId(u.getId());
        o.setAddressId(addrId);
        o.setStatus("NEW");
        o.setTotal(t);
        o.setPaid(false);
        o.setItems(ois);
        if(ServiceLayer.createOrder(o)){
            for(CartItem c:its){ServiceLayer.removeCartItem(c.getId());}
            message="订单已创建";
        }else message="创建失败";
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
    <link rel="stylesheet" href="css/cart.css"/>
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


<script src="js/cart.js"></script>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
