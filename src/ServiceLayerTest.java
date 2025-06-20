/**
 * ServiceLayer 测试类。
 * 调用 ServiceLayer 的所有方法并输出结果。
 */
public class ServiceLayerTest {
    @FunctionalInterface
    interface Action {
        Object run() throws Exception;
    }

    private static void test(String name, Action a) {
        System.out.print(name + " -> ");
        try {
            Object res = a.run();
            if (res instanceof java.util.Collection) {
                System.out.println("返回集合大小=" + ((java.util.Collection<?>) res).size());
            } else if (res != null) {
                System.out.println("返回值=" + res);
            } else {
                System.out.println("完成");
            }
        } catch (Exception e) {
            System.out.println("异常 - " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        System.out.println("==== ServiceLayer 全量测试 ====");

        // 创建并注册一个唯一用户，随后使用其 ID 进行后续测试，避免与旧数据冲突
        com.entity.User u = new com.entity.User();
        String uname = "user" + System.currentTimeMillis();
        u.setUsername(uname);
        u.setPassword("123");
        u.setEmail(uname + "@test.com");
        test("注册", () -> com.ServiceLayer.register(u));

        int userId = u.getId();

        test("登录", () -> com.ServiceLayer.login(uname, "123"));
        test("按ID查询用户", () -> com.ServiceLayer.getUserById(userId));

        test("列出商品", com.ServiceLayer::listProducts);

        // 新建商品，用其生成的 ID 继续测试
        com.entity.Product product = new com.entity.Product();
        product.setName("测试商品");
        product.setPrice(new java.math.BigDecimal("1"));
        product.setStock(10);
        product.setDescription("desc");
        test("添加商品", () -> com.ServiceLayer.addProduct(product));

        int productId = product.getId();

        test("查询商品", () -> com.ServiceLayer.getProductById(productId));

        test("更新商品", () -> {
            product.setName("update");
            product.setPrice(new java.math.BigDecimal("2"));
            product.setStock(5);
            product.setDescription("update");
            return com.ServiceLayer.updateProduct(product);
        });

        test("获取地址", () -> com.ServiceLayer.getAddresses(userId));

        // 创建第一个地址供后续订单使用
        com.entity.Address addr1 = new com.entity.Address();
        addr1.setUserId(userId);
        addr1.setReceiver("张三");
        addr1.setPhone("123456");
        addr1.setDetail("addr");
        test("添加地址", () -> com.ServiceLayer.addAddress(addr1));

        int addressId1 = addr1.getId();

        test("更新地址", () -> {
            addr1.setDetail("addr2");
            return com.ServiceLayer.updateAddress(addr1);
        });

        // 再创建一个地址用于删除测试，避免与订单产生外键关系
        com.entity.Address addr2 = new com.entity.Address();
        addr2.setUserId(userId);
        addr2.setReceiver("李四");
        addr2.setPhone("654321");
        addr2.setDetail("addr3");
        test("添加地址", () -> com.ServiceLayer.addAddress(addr2));

        int addressId2 = addr2.getId();

        test("设置默认地址", () -> { com.ServiceLayer.setDefaultAddress(userId,addressId1); return null; });
        test("删除地址", () -> com.ServiceLayer.deleteAddress(addressId2));

        test("列出类别", com.ServiceLayer::listCategories);

        com.entity.Category category = new com.entity.Category();
        category.setName("cate");
        test("添加类别", () -> com.ServiceLayer.addCategory(category));

        int categoryId = category.getId();

        test("更新类别", () -> {
            category.setName("cate2");
            return com.ServiceLayer.updateCategory(category);
        });
        test("删除类别", () -> com.ServiceLayer.deleteCategory(categoryId));

        test("查看购物车", () -> com.ServiceLayer.getCartItems(userId));

        com.entity.CartItem cartItem = new com.entity.CartItem();
        cartItem.setUserId(userId);
        cartItem.setProductId(productId);
        cartItem.setQuantity(1);
        test("添加购物车", () -> com.ServiceLayer.addToCart(cartItem));

        int cartId = cartItem.getId();

        test("更新购物车", () -> com.ServiceLayer.updateCartItem(cartId,2));
        test("移除购物车", () -> com.ServiceLayer.removeCartItem(cartId));

        com.entity.Order order = new com.entity.Order();
        order.setUserId(userId);
        order.setAddressId(addressId1);
        order.setStatus("NEW");
        order.setTotal(new java.math.BigDecimal("1"));
        order.setPaid(false);
        test("创建订单", () -> com.ServiceLayer.createOrder(order));

        int orderId = order.getId();

        test("查订单", () -> com.ServiceLayer.getOrderById(orderId));
        test("获取用户订单", () -> com.ServiceLayer.getOrdersByUser(userId));
        test("列出所有订单", com.ServiceLayer::listAllOrders);
        test("更新订单状态", () -> com.ServiceLayer.updateOrderStatus(orderId,"NEW"));
        test("标记已付款", () -> com.ServiceLayer.markOrderPaid(orderId));

        int batchId = 1;
        test("生成SN码", () -> { com.ServiceLayer.generateSNCodes(productId,1,batchId); return null; });
        java.util.List<com.entity.SNCode> codes = new java.util.ArrayList<>();
        test("查看SN列表", () -> { codes.addAll(com.ServiceLayer.listSNCodes(productId,null)); return codes; });
        String sn = codes.isEmpty() ? "" : codes.get(0).getCode();
        test("更新SN状态", () -> com.ServiceLayer.updateSNStatus(sn,"NEW"));
        test("删除SN码", () -> com.ServiceLayer.deleteSNCodes(batchId));

        test("SN绑定", () -> com.ServiceLayer.bindSN(userId,sn));
        test("查询绑定", () -> com.ServiceLayer.getBindingsByUser(userId));
        test("管理员解绑", () -> com.ServiceLayer.adminUnbindSN(sn));

        com.entity.AfterSale as = new com.entity.AfterSale();
        as.setUserId(userId);
        as.setSnCode(sn);
        as.setType("refund");
        as.setReason("reason");
        test("申请售后", () -> com.ServiceLayer.applyAfterSale(as));

        int asId = as.getId();

        test("查用户售后", () -> com.ServiceLayer.getAfterSalesByUser(userId));
        test("列出所有售后", com.ServiceLayer::listAllAfterSales);
        test("更新售后状态", () -> com.ServiceLayer.updateAfterSaleStatus(asId,"NEW","remark"));
        test("关闭售后", () -> com.ServiceLayer.closeAfterSale(asId));

        com.entity.Notification n = new com.entity.Notification();
        n.setUserId(userId);
        n.setContent("hi");
        test("发送通知", () -> com.ServiceLayer.sendNotification(n));

        int noteId = n.getId();

        test("获取通知", () -> com.ServiceLayer.getNotifications(userId));
        test("标记已读", () -> com.ServiceLayer.markNotificationRead(noteId));
        test("删除通知", () -> com.ServiceLayer.deleteNotification(noteId));
    }
}
