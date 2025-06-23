<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    User u = (User)obj;
    request.setCharacterEncoding("UTF-8");

    String action = request.getParameter("action");
    String idStr = request.getParameter("id");
    Order order = null;
    java.util.List<Address> adds = ServiceLayer.getAddresses(u.getId());
    java.util.List<OrderItem> items = null;
    java.util.List<Product> products = ServiceLayer.listProducts();
    java.math.BigDecimal total = new java.math.BigDecimal("0");
    String message = null;
    java.util.List<SNCode> snList = null;

    if(idStr == null){
        // 从购物车创建订单
        java.util.List<CartItem> cartItems = ServiceLayer.getCartItems(u.getId());
        items = new java.util.ArrayList<>();
        for(CartItem c : cartItems){
            Product p = products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p!=null){
                OrderItem oi = new OrderItem();
                oi.setProductId(p.getId());
                oi.setQuantity(c.getQuantity());
                oi.setPrice(p.getPrice());
                items.add(oi);
                total = total.add(p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity())));
            }
        }
        if("create".equals(action)){
            int addrId = Integer.parseInt(request.getParameter("addressId"));
            Order o = new Order();
            o.setUserId(u.getId());
            o.setAddressId(addrId);
            o.setStatus("pending");
            o.setTotal(total);
            o.setPaid(false);
            o.setItems(items);
            if(ServiceLayer.createOrder(o)){
                for(CartItem c:cartItems){ ServiceLayer.removeCartItem(c.getId()); }
                response.sendRedirect("payment.jsp?orderId="+o.getId());
                return;
            }else{
                message = "创建订单失败";
            }
        }
    }else{
        int orderId = Integer.parseInt(idStr);
        order = ServiceLayer.getOrderById(orderId);
        if(order == null || order.getUserId() != u.getId()){ response.sendRedirect("orders.jsp"); return; }
        if("cancel".equals(action) && !order.isPaid()){
            ServiceLayer.cancelOrder(orderId);
            order = ServiceLayer.getOrderById(orderId);
        }
        items = order.getItems();
        total = order.getTotal();
        snList = ServiceLayer.getSNCodesByOrder(orderId);
    }

    Address address = null;
    if(order != null && adds != null){
        for(Address a : adds){ if(a.getId() == order.getAddressId()){ address = a; break; } }
    }
%>
<html>
<head>
    <title>订单详情</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/order-detail.css"/>
</head>
<body>
<div class="detail-header">
    <button class="back-btn" onclick="history.back();">←</button>
    <div class="header-title">订单详情</div>
</div>

<div class="detail-container">
<% if(idStr == null){ %>
    <% if(message!=null){ %><div class="message"><%=message%></div><% } %>
    <form method="post">
        <input type="hidden" name="action" value="create"/>
        <div class="order-info">
            <div>总金额：¥<%= total %></div>
        </div>
        <div class="address-info">
            <% if(adds == null || adds.isEmpty()){ %>
                <div class="no-address-warning">
                    <div class="warning-icon">⚠️</div>
                    <div class="warning-text">您还没有添加收货地址</div>
                    <a href="addresses.jsp?showForm=true" class="add-address-link">立即添加收货地址</a>
                </div>
            <% } else { %>
                <select name="addressId" class="address-select" required>
                    <% for(Address a:adds){ %>
                    <option value="<%=a.getId()%>"><%=a.getDetail()%></option>
                    <% } %>
                </select>
            <% } %>
        </div>
        <div class="items-section">
            <% for(OrderItem item : items){ Product p = products.stream().filter(x->x.getId()==item.getProductId()).findFirst().orElse(null); %>
            <div class="item-row">
                <div class="item-name"><%= p!=null ? p.getName() : ("商品"+item.getProductId()) %></div>
                <div class="item-qty">x<%= item.getQuantity() %></div>
                <div class="item-price">¥<%= item.getPrice() %></div>
            </div>
            <% } %>
        </div>
        <% if(adds != null && !adds.isEmpty()){ %>
            <button type="submit" class="pay-btn">立即支付</button>
        <% } %>
    </form>
<% }else{ %>
    <div class="order-info">
        <div>订单号：<%= order.getId() %></div>
        <div>状态：<%= order.getStatus() %></div>
        <div>总金额：¥<%= order.getTotal() %></div>
    </div>
    <% if(address != null){ %>
    <div class="address-info">
        <div><%= address.getReceiver() %> <%= address.getPhone() %></div>
        <div><%= address.getDetail() %></div>
    </div>
    <% } %>
    <div class="items-section">
        <% for(OrderItem item : items){ Product p = ServiceLayer.getProductById(item.getProductId()); %>
        <div class="item-row">
            <div class="item-name"><%= p!=null ? p.getName() : ("商品"+item.getProductId()) %></div>
            <div class="item-qty">x<%= item.getQuantity() %></div>
            <div class="item-price">¥<%= item.getPrice() %></div>
        </div>
        <% if(snList!=null && order.isPaid() && !"CANCELLED".equalsIgnoreCase(order.getStatus())){ for(SNCode sn : snList){ if(sn.getProductId()==item.getProductId()){ %>
        <div class="sn-row">SN: <%= sn.getCode() %></div>
        <% }} } %>
        <% } %>
    </div>
    <% if(!order.isPaid() && !"CANCELLED".equalsIgnoreCase(order.getStatus())){ %>
    <div class="order-actions" style="margin-top:15px;">
        <a href="payment.jsp?orderId=<%=order.getId()%>" class="pay-btn">立即支付</a>
        <form method="post" style="display:inline;" onsubmit="return confirm('确定取消订单?');">
            <input type="hidden" name="action" value="cancel"/>
            <input type="hidden" name="id" value="<%=order.getId()%>"/>
            <button type="submit" class="cancel-btn">取消订单</button>
        </form>
    </div>
    <% } %>
<% } %>
</div>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
