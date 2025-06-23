<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.ProductImage" %>
<%@ page import="com.entity.CartItem" %>
<%@ page import="java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");
    String idStr = request.getParameter("id");
    if(idStr==null) { response.sendRedirect("index.jsp"); return; }
    int pid = Integer.parseInt(idStr);
    Product p = ServiceLayer.getProductById(pid);
    if(p==null){ response.sendRedirect("index.jsp"); return; }
    
    // 获取商品图片
    List<ProductImage> images = ServiceLayer.listProductImages(pid);
    String mainImageUrl = "static/image/default-product.jpg"; // 默认图片
    if(images != null && !images.isEmpty()) {
        mainImageUrl = images.get(0).getUrl();
    }
    
    // 截取商品描述前20字
    String shortDesc = p.getDescription();
    if(shortDesc != null && shortDesc.length() > 20) {
        shortDesc = shortDesc.substring(0, 20) + "...";
    }
    
    String msg=null;
    if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("addCart")!=null){
        Object obj=session.getAttribute("user");
        if(obj==null){response.sendRedirect("login.jsp"); return;}
        com.entity.User u=(com.entity.User)obj;
        CartItem item=new CartItem();
        item.setUserId(u.getId());
        item.setProductId(pid);
        item.setQuantity(1);
        if(ServiceLayer.addToCart(item)){
            msg="已加入购物车";
        }else{
            msg="加入购物车失败";
        }
    }
    // 立即购买
    if("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("buyNow")!=null){
        Object obj=session.getAttribute("user");
        if(obj==null){response.sendRedirect("login.jsp"); return;}
        com.entity.User u=(com.entity.User)obj;
        java.util.List<com.entity.Address> adds = ServiceLayer.getAddresses(u.getId());
        com.entity.Address addr = null;
        if(adds!=null){
            for(com.entity.Address a:adds){ if(a.isDefault()){ addr=a; break; } }
            if(addr==null && !adds.isEmpty()) addr = adds.get(0);
        }
        if(addr==null){
            msg="请先添加收货地址";
        }else{
            java.util.List<com.entity.OrderItem> ois=new java.util.ArrayList<>();
            com.entity.OrderItem oi=new com.entity.OrderItem();
            oi.setProductId(pid);
            oi.setQuantity(1);
            oi.setPrice(p.getPrice());
            ois.add(oi);
            com.entity.Order o=new com.entity.Order();
            o.setUserId(u.getId());
            o.setAddressId(addr.getId());
            o.setStatus("NEW");
            o.setTotal(p.getPrice());
            o.setPaid(false);
            o.setItems(ois);
            if(ServiceLayer.createOrder(o)){
                response.sendRedirect("payment.jsp?orderId="+o.getId());
                return;
            }else{
                msg="创建订单失败";
            }
        }
    }
%>
<html>
<head>
    <title><%= p.getName() %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/product.css"/>
</head>
<body>
<div class="product-container">
    <% if(msg!=null){ %><div class="message"><%= msg %></div><% } %>
    
    <!-- 产品头部 -->
    <div class="product-header">
        <button class="back-btn" onclick="history.back()">‹</button>
        <div class="product-title"><%= p.getName() %></div>
    </div>
    
    <!-- 产品图片 -->
    <div class="product-image-container">
        <img src="<%= mainImageUrl %>" alt="<%= p.getName() %>" class="product-image">
        <div class="page-indicator">2/8</div>
    </div>
    
    <!-- 产品信息 -->
    <div class="product-info">
        <div class="product-name"><%= p.getName() %></div>
        <div class="product-subtitle"><%= shortDesc %></div>
        <div class="product-price"><%= p.getPrice() %></div>
    </div>
    
    <!-- 底部操作按钮 -->
    <div class="product-actions">
        <form method="post" style="flex: 1; margin: 0;">
            <input type="hidden" name="addCart" value="1">
            <button type="submit" class="btn-cart">加入购物车</button>
        </form>
        <button class="btn-buy" onclick="buyNow(<%= p.getId() %>)">立即购买</button>
    </div>
</div>


<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
<script src="js/product.js"></script>
</body>
</html>
