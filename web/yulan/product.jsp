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
%>
<html>
<head>
    <title><%= p.getName() %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #f5f5f5;
            padding-bottom: 140px; /* 为底部导航和按钮留出空间 */
        }
        .product-container {
            background: #f5f5f5;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        .product-header {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            background: #fff;
            position: sticky;
            top: 0;
            z-index: 50;
        }
        .back-btn {
            background: none;
            border: none;
            font-size: 20px;
            color: #333;
            cursor: pointer;
            margin-right: 12px;
            font-weight: bold;
        }
        .product-title {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            flex: 1;
            text-align: center;
            margin-right: 32px; /* 平衡返回按钮的空间 */
        }
        .product-image-container {
            background: #fff;
            position: relative;
            margin-bottom: 8px;
        }
        .product-image {
            width: 100%;
            height: 400px;
            object-fit: contain;
            background: #fff;
            display: block;
        }
        .product-info {
            background: #fff;
            padding: 20px 16px;
            margin-bottom: 8px;
        }
        .product-name {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            line-height: 1.3;
        }
        .product-subtitle {
            font-size: 14px;
            color: #999;
            margin-bottom: 16px;
            line-height: 1.4;
        }
        .product-price {
            font-size: 28px;
            font-weight: 600;
            color: #ff6700;
            margin-bottom: 0;
        }
        .product-price::before {
            content: '¥';
            font-size: 18px;
        }
        .product-actions {
            position: fixed;
            bottom: 70px; /* 在底部导航上方 */
            left: 0;
            right: 0;
            background: #fff;
            border-top: 1px solid #e0e0e0;
            padding: 12px 16px;
            display: flex;
            gap: 12px;
            z-index: 100;
        }
        .btn-cart {
            flex: 1;
            background: #ffa500;
            color: #fff;
            border: none;
            border-radius: 22px;
            padding: 14px 0;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
        }
        .btn-buy {
            flex: 1;
            background: #ff6700;
            color: #fff;
            border: none;
            border-radius: 22px;
            padding: 14px 0;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
        }
        .message {
            background: #4CAF50;
            color: white;
            padding: 10px 16px;
            text-align: center;
            font-size: 14px;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 200;
        }
        .page-indicator {
            position: absolute;
            bottom: 16px;
            right: 16px;
            background: rgba(0,0,0,0.6);
            color: white;
            padding: 6px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
        }
    </style>
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

<script>
function buyNow(productId) {
    // 检查用户是否登录
    <% if(session.getAttribute("user") == null) { %>
        window.location.href = 'login.jsp';
        return;
    <% } %>
    
    // 这里可以跳转到订单页面或支付页面
    alert('立即购买功能待实现');
}
</script>

<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
