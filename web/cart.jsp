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
    }
    java.util.List<CartItem> items=ServiceLayer.getCartItems(u.getId());
    java.util.List<Product> products=ServiceLayer.listProducts();
    java.math.BigDecimal total=new java.math.BigDecimal("0");
%>
<html>
<head>
    <title>购物车</title>
    <link rel="stylesheet" href="css/main.css"/>
</head>
<body>
<header>
    <div><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div>欢迎，<%= u.getUsername() %> | <a href="logout.jsp">退出</a></div>
</header>
<div class="container">
    <h2>购物车</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <table class="cart-table">
        <tr><th>商品</th><th>价格</th><th>数量</th><th>小计</th><th>操作</th></tr>
        <% for(CartItem c:items){
            Product p=products.stream().filter(x->x.getId()==c.getProductId()).findFirst().orElse(null);
            if(p==null) continue;
            java.math.BigDecimal sub=p.getPrice().multiply(new java.math.BigDecimal(c.getQuantity()));
            total=total.add(sub);
        %>
        <tr>
            <td><a href="product.jsp?id=<%=p.getId()%>"><%=p.getName()%></a></td>
            <td>￥<%=p.getPrice()%></td>
            <td>
                <form method="post" style="display:inline">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=c.getId()%>"/>
                    <input type="number" name="qty" value="<%=c.getQuantity()%>" style="width:60px;"/>
                    <button type="submit">修改</button>
                </form>
            </td>
            <td>￥<%=sub%></td>
            <td>
                <form method="post" onsubmit="return confirm('确定删除?');" style="display:inline">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%=c.getId()%>"/>
                    <button type="submit">删除</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <p>总计：￥<%= total %></p>
</div>
</body>
</html>
