<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    User u = (User)obj;
    request.setCharacterEncoding("UTF-8");

    String idStr = request.getParameter("id");
    if(idStr == null){ response.sendRedirect("orders.jsp"); return; }
    int orderId = Integer.parseInt(idStr);
    Order order = ServiceLayer.getOrderById(orderId);
    if(order == null || order.getUserId() != u.getId()){ response.sendRedirect("orders.jsp"); return; }

    String action = request.getParameter("action");
    String message = null;
    if("updateAddr".equals(action)){
        int addrId = Integer.parseInt(request.getParameter("addressId"));
        if(ServiceLayer.updateOrderAddress(orderId, addrId)){
            message = "地址已更新";
            order = ServiceLayer.getOrderById(orderId);
        }else{
            message = "更新地址失败";
        }
    }else if("cancel".equals(action)){
        if(ServiceLayer.updateOrderStatus(orderId, "CANCELLED")){
            message = "订单已取消";
            order = ServiceLayer.getOrderById(orderId);
        }else{
            message = "取消失败";
        }
    }

    java.util.List<OrderItem> items = order.getItems();
    java.util.List<SNCode> snList = ServiceLayer.getSNCodesByOrder(orderId);
    Address address = null;
    java.util.List<Address> adds = ServiceLayer.getAddresses(u.getId());
    if(adds != null){
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
    <% if(message != null){ %>
    <div class="message"><%= message %></div>
    <% } %>
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
        <% if(!order.isPaid()){ %>
        <form method="post" class="address-form">
            <input type="hidden" name="action" value="updateAddr"/>
            <input type="hidden" name="id" value="<%= order.getId() %>"/>
            <select name="addressId">
                <% for(Address a : adds){ %>
                <option value="<%= a.getId() %>" <%= a.getId()==order.getAddressId()?"selected":"" %>><%= a.getDetail() %></option>
                <% } %>
            </select>
            <button type="submit">更新地址</button>
        </form>
        <% } %>
    <% } %>
    <div class="items-section">
        <% for(OrderItem item : items){ Product p = ServiceLayer.getProductById(item.getProductId()); %>
        <div class="item-row">
            <div class="item-name"><%= p!=null ? p.getName() : ("商品"+item.getProductId()) %></div>
            <div class="item-qty">x<%= item.getQuantity() %></div>
            <div class="item-price">¥<%= item.getPrice() %></div>
        </div>
        <% for(SNCode sn : snList){ if(sn.getProductId()==item.getProductId()){ %>
        <div class="sn-row">SN: <%= sn.getCode() %></div>
        <% }} %>
        <% } %>
    </div>

    <% if(!order.isPaid()){ %>
    <div class="order-actions">
        <form method="post" style="display:inline;">
            <input type="hidden" name="action" value="cancel"/>
            <input type="hidden" name="id" value="<%= order.getId() %>"/>
            <button type="submit" onclick="return confirm('确定取消订单?');">取消订单</button>
        </form>
        <a href="payment.jsp?orderId=<%= order.getId() %>" class="pay-btn">立即支付</a>
    </div>
    <% } %>
</div>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
