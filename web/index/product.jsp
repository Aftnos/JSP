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
    
    // 获取商品主图、副图和介绍图
    List<ProductImage> mainImgs = ServiceLayer.listProductImagesByType(pid, "main");
    List<ProductImage> subImgs = ServiceLayer.listProductImagesByType(pid, "sub");
    List<ProductImage> introImgs = ServiceLayer.listProductImagesByType(pid, "intro");
    String mainImageUrl = "static/image/default-product.jpg"; // 默认图片
    if(mainImgs != null && !mainImgs.isEmpty()) {
        mainImageUrl = mainImgs.get(0).getUrl();
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

    <% if(subImgs != null && !subImgs.isEmpty()) { %>
    <div class="sub-images">
        <% for(ProductImage img : subImgs) { %>
            <img src="<%= img.getUrl() %>" alt="<%= p.getName() %>">
        <% } %>
    </div>
    <% } %>
    
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

    <% if(introImgs != null && !introImgs.isEmpty()) { %>
    <div class="detail-images">
        <% for(ProductImage img : introImgs) { %>
            <img src="<%= img.getUrl() %>" alt="detail">
        <% } %>
    </div>
    <% } %>
</div>


<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
<script src="js/product.js"></script>
</body>
</html>
