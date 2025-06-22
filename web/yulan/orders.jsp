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
%>
<html>
<head>
    <title>我的订单</title>
    <link rel="stylesheet" href="css/main.css"/>
</head>
<body>
<header>
    <div><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div>
        欢迎，<%= u.getUsername() %>
        | <a href="cart.jsp">购物车</a>
        | <a href="orders.jsp">订单</a>
        | <a href="categories.jsp">分类</a>
        | <a href="my.jsp">我的</a>
        | <a href="notifications.jsp">通知</a>
        | <a href="service.jsp">服务</a>
        | <a href="logout.jsp">退出</a>
    </div>
</header>
<div class="container">
    <h2>我的订单</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <h3>创建订单</h3>
    <form method="post">
        <input type="hidden" name="action" value="create"/>
        <label>收货地址:
            <select name="addressId">
                <% for(Address a:addresses){ %>
                <option value="<%= a.getId() %>"><%= a.getDetail() %></option>
                <% } %>
            </select>
        </label>
        <button type="submit">提交订单</button>
    </form>
    <h3>订单列表</h3>
    <table class="cart-table">
        <tr><th>ID</th><th>地址ID</th><th>状态</th><th>金额</th><th>已付款</th></tr>
        <% for(Order o:orders){ %>
        <tr>
            <td><%= o.getId() %></td>
            <td><%= o.getAddressId() %></td>
            <td><%= o.getStatus() %></td>
            <td><%= o.getTotal() %></td>
            <td><%= o.isPaid() %></td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
