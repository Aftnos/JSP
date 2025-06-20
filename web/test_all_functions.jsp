<%--
  Created by IntelliJ IDEA.
  User: alyfk
  Date: 2025/6/14
  Time: 23:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.*" %>
<%! 
    interface Action { Object run() throws Exception; }
    void test(javax.servlet.jsp.JspWriter out, String name, Action a) throws java.io.IOException {
        out.print("<b>" + name + "</b> -> ");
        try {
            Object res = a.run();
            if (res instanceof java.util.Collection) {
                out.println("返回集合大小=" + ((java.util.Collection<?>)res).size() + "<br/>");
            } else if (res != null) {
                out.println("返回值=" + res + "<br/>");
            } else {
                out.println("完成<br/>");
            }
        } catch (Exception e) {
            out.println("<span style='color:red'>异常 - " + e.getMessage() + "</span><br/>");
        }
    }
%>
<html>
<head>
    <title>ServiceLayer Test</title>
    <style>
        body {font-family: Arial, sans-serif; padding:20px;}
    </style>
</head>
<body>
<div>
<h2>ServiceLayer 全量测试</h2>
<%
    request.setCharacterEncoding("UTF-8");

    User u = new User();
    String uname = "user" + System.currentTimeMillis();
    u.setUsername(uname);
    u.setPassword("123");
    u.setEmail(uname + "@test.com");
    test(out, "注册", () -> ServiceLayer.register(u));

    int userId = u.getId();

    test(out, "登录", () -> ServiceLayer.login(uname, "123"));
    test(out, "按ID查询用户", () -> ServiceLayer.getUserById(userId));

    test(out, "列出商品", ServiceLayer::listProducts);

    Product product = new Product();
    product.setName("测试商品");
    product.setPrice(new java.math.BigDecimal("1"));
    product.setStock(10);
    product.setDescription("desc");
    test(out, "添加商品", () -> ServiceLayer.addProduct(product));

    int productId = product.getId();

    test(out, "查询商品", () -> ServiceLayer.getProductById(productId));

    test(out, "更新商品", () -> {
        product.setName("update");
        product.setPrice(new java.math.BigDecimal("2"));
        product.setStock(5);
        product.setDescription("update");
        return ServiceLayer.updateProduct(product);
    });

    test(out, "获取地址", () -> ServiceLayer.getAddresses(userId));

    Address addr1 = new Address();
    addr1.setUserId(userId);
    addr1.setReceiver("张三");
    addr1.setPhone("123456");
    addr1.setDetail("addr");
    test(out, "添加地址", () -> ServiceLayer.addAddress(addr1));

    int addressId1 = addr1.getId();

    test(out, "更新地址", () -> {
        addr1.setDetail("addr2");
        return ServiceLayer.updateAddress(addr1);
    });

    Address addr2 = new Address();
    addr2.setUserId(userId);
    addr2.setReceiver("李四");
    addr2.setPhone("654321");
    addr2.setDetail("addr3");
    test(out, "添加地址", () -> ServiceLayer.addAddress(addr2));

    int addressId2 = addr2.getId();

    test(out, "设置默认地址", () -> { ServiceLayer.setDefaultAddress(userId, addressId1); return null; });
    test(out, "删除地址", () -> ServiceLayer.deleteAddress(addressId2));

    test(out, "列出类别", ServiceLayer::listCategories);

    Category category = new Category();
    category.setName("cate");
    test(out, "添加类别", () -> ServiceLayer.addCategory(category));

    int categoryId = category.getId();

    test(out, "更新类别", () -> { category.setName("cate2"); return ServiceLayer.updateCategory(category); });
    test(out, "删除类别", () -> ServiceLayer.deleteCategory(categoryId));

    test(out, "查看购物车", () -> ServiceLayer.getCartItems(userId));

    CartItem cartItem = new CartItem();
    cartItem.setUserId(userId);
    cartItem.setProductId(productId);
    cartItem.setQuantity(1);
    test(out, "添加购物车", () -> ServiceLayer.addToCart(cartItem));

    int cartId = cartItem.getId();

    test(out, "更新购物车", () -> ServiceLayer.updateCartItem(cartId, 2));
    test(out, "移除购物车", () -> ServiceLayer.removeCartItem(cartId));

    Order order = new Order();
    order.setUserId(userId);
    order.setAddressId(addressId1);
    order.setStatus("NEW");
    order.setTotal(new java.math.BigDecimal("1"));
    order.setPaid(false);
    test(out, "创建订单", () -> ServiceLayer.createOrder(order));

    int orderId = order.getId();

    test(out, "查订单", () -> ServiceLayer.getOrderById(orderId));
    test(out, "获取用户订单", () -> ServiceLayer.getOrdersByUser(userId));
    test(out, "列出所有订单", ServiceLayer::listAllOrders);
    test(out, "更新订单状态", () -> ServiceLayer.updateOrderStatus(orderId, "NEW"));
    test(out, "标记已付款", () -> ServiceLayer.markOrderPaid(orderId));

    int batchId = 1;
    test(out, "生成SN码", () -> { ServiceLayer.generateSNCodes(productId, 1, batchId); return null; });

    java.util.List<SNCode> codes = new java.util.ArrayList<>();
    test(out, "查看SN列表", () -> { codes.addAll(ServiceLayer.listSNCodes(productId, null)); return codes; });
    String sn = codes.isEmpty() ? "" : codes.get(0).getCode();
    test(out, "更新SN状态", () -> ServiceLayer.updateSNStatus(sn, "NEW"));
    test(out, "删除SN码", () -> ServiceLayer.deleteSNCodes(batchId));

    test(out, "SN绑定", () -> ServiceLayer.bindSN(userId, sn));
    test(out, "查询绑定", () -> ServiceLayer.getBindingsByUser(userId));
    test(out, "管理员解绑", () -> ServiceLayer.adminUnbindSN(sn));

    AfterSale as = new AfterSale();
    as.setUserId(userId);
    as.setSnCode(sn);
    as.setType("refund");
    as.setReason("reason");
    test(out, "申请售后", () -> ServiceLayer.applyAfterSale(as));

    int asId = as.getId();

    test(out, "查用户售后", () -> ServiceLayer.getAfterSalesByUser(userId));
    test(out, "列出所有售后", ServiceLayer::listAllAfterSales);
    test(out, "更新售后状态", () -> ServiceLayer.updateAfterSaleStatus(asId, "NEW", "remark"));
    test(out, "关闭售后", () -> ServiceLayer.closeAfterSale(asId));

    Notification n = new Notification();
    n.setUserId(userId);
    n.setContent("hi");
    test(out, "发送通知", () -> ServiceLayer.sendNotification(n));

    int noteId = n.getId();

    test(out, "获取通知", () -> ServiceLayer.getNotifications(userId));
    test(out, "标记已读", () -> ServiceLayer.markNotificationRead(noteId));
    test(out, "删除通知", () -> ServiceLayer.deleteNotification(noteId));
%>
</div>
</body>
</html>
