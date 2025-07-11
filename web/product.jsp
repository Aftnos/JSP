<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Product" %>
<%@ page import="com.entity.ProductImage" %>
<%@ page import="com.entity.ProductExtraImage" %>
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
    List<ProductExtraImage> secondaryImages = ServiceLayer.listProductExtraImages(pid, "secondary");
    List<ProductExtraImage> introImages = ServiceLayer.listProductExtraImages(pid, "intro");
    String mainImageUrl = "static/image/default-product.jpg"; // 默认图片
    if(images != null && !images.isEmpty()) {
        mainImageUrl = images.get(0).getUrl();
    }
    
    // 截取商品描述前20字
    String shortDesc = p.getDescription();
    if(shortDesc != null && shortDesc.length() > 50) {
        shortDesc = shortDesc.substring(0, 50) + "...";
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
        <div class="product-carousel" id="imgCarousel">
            <div class="carousel-images">
                <img src="<%= mainImageUrl %>" alt="<%= p.getName() %>" class="carousel-item"/>
                <% if(secondaryImages!=null){ for(ProductExtraImage s : secondaryImages){ %>
                <img src="<%= s.getUrl() %>" alt="<%= p.getName() %>" class="carousel-item"/>
                <% } } %>
            </div>
            <div class="carousel-arrow prev">‹</div>
            <div class="carousel-arrow next">›</div>
            <div class="page-indicator" id="carouselIndicator"></div>
        </div>
    </div>
    
    <!-- 产品信息 -->
    <div class="product-info">
        <div class="product-name"><%= p.getName() %></div>
        <div class="product-subtitle"><%= shortDesc %></div>
        <div class="product-price"><%= p.getPrice() %></div>
    </div>

    <!-- 商品介绍图 -->
    <div class="product-intro-images">
        <% if(introImages!=null){ for(ProductExtraImage d : introImages){ %>
            <img src="<%= d.getUrl() %>" alt="介绍图" class="intro-image"/>
        <% } } %>
    </div>

    <!-- 底部操作按钮 -->
    <div class="product-actions">
        <button class="btn-home" onclick="location.href='index.jsp'">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
            </svg>
        </button>
        <form method="post" style="flex: 1; margin: 0;">
            <input type="hidden" name="addCart" value="1">
            <button type="submit" class="btn-cart" onclick="buyNow(<%= p.getId() %>)">加入购物车</button>
        </form>
        <button class="btn-buy" onclick="buyNowAndRedirect(<%= p.getId() %>)">立即购买</button>
        <script>
            function buyNowAndRedirect(productId) {
                // 添加加载提示
                var button = event.target;
                button.disabled = true;
                button.textContent = '添加中...';
                
                // 使用AJAX提交请求
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'product.jsp?id=' + productId, true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            // 添加成功后跳转到购物车页面
                            window.location.href = 'cart.jsp';
                        } else {
                            // 恢复按钮状态
                            button.disabled = false;
                            button.textContent = '立即购买';
                            alert('添加到购物车失败，请重试');
                        }
                    }
                };
                
                // 发送请求
                xhr.send('addCart=1');
            }
        </script>
    </div>
</div>


<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
<script src="js/product.js"></script>
</body>
</html>
