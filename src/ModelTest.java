/**
 * Model类的测试类。
 * 将会供完整测试各项 Model 方法的流程。
 */
public class ModelTest {
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
        System.out.println("==== Model 全量测试 ====");

        // 创建并注册一个唯一用户，随后使用其 ID 进行后续测试，避免与旧数据冲突
        com.entity.User u = new com.entity.User();
        String uname = "user" + System.currentTimeMillis();
        u.setUsername(uname);
        u.setPassword("123");
        u.setEmail(uname + "@test.com");
        test("注册", () -> com.Model.register(u));

        int userId = u.getId();

        test("登录", () -> com.Model.login(uname, "123"));

        test("按ID查询用户", () -> com.Model.getUserById(userId));

        test("列出商品", com.Model::listProducts);

        // 新建商品，用其生成的 ID 继续测试
        com.entity.Product product = new com.entity.Product();
        product.setName("测试商品");
        product.setPrice(new java.math.BigDecimal("1"));
        product.setStock(10);
        product.setDescription("desc");
        test("添加商品", () -> com.Model.addProduct(product));

        int productId = product.getId();

        test("查询商品", () -> com.Model.getProductById(productId));

        test("更新商品", () -> {
            product.setName("update");
            product.setPrice(new java.math.BigDecimal("2"));
            product.setStock(5);
            product.setDescription("update");
            return com.Model.updateProduct(product);
        });

        test("获取地址", () -> com.Model.getAddresses(userId));

        // 创建第一个地址供后续订单使用
        com.entity.Address addr1 = new com.entity.Address();
        addr1.setUserId(userId);
        addr1.setReceiver("张三");
        addr1.setPhone("123456");
        addr1.setDetail("addr");
        test("添加地址", () -> com.Model.addAddress(addr1));

        int addressId1 = addr1.getId();

        test("更新地址", () -> {
            addr1.setDetail("addr2");
            return com.Model.updateAddress(addr1);
        });

        // 再创建一个地址用于删除测试，避免与订单产生外键关系
        com.entity.Address addr2 = new com.entity.Address();
        addr2.setUserId(userId);
        addr2.setReceiver("李四");
        addr2.setPhone("654321");
        addr2.setDetail("addr3");
        test("添加地址", () -> com.Model.addAddress(addr2));

        int addressId2 = addr2.getId();

        test("设置默认地址", () -> { com.Model.setDefaultAddress(userId,addressId1); return null; });
        test("删除地址", () -> com.Model.deleteAddress(addressId2));

        test("列出类别", com.Model::listCategories);

        com.entity.Category category = new com.entity.Category();
        category.setName("cate");
        test("添加类别", () -> com.Model.addCategory(category));

        int categoryId = category.getId();

        test("更新类别", () -> {
            category.setName("cate2");
            return com.Model.updateCategory(category);
        });
        test("删除类别", () -> com.Model.deleteCategory(categoryId));

        test("查看购物车", () -> com.Model.getCartItems(userId));

        com.entity.CartItem cartItem = new com.entity.CartItem();
        cartItem.setUserId(userId);
        cartItem.setProductId(productId);
        cartItem.setQuantity(1);
        test("添加购物车", () -> com.Model.addToCart(cartItem));

        int cartId = cartItem.getId();

        test("更新购物车", () -> com.Model.updateCartItem(cartId,2));
        test("移除购物车", () -> com.Model.removeCartItem(cartId));

        com.entity.Order order = new com.entity.Order();
        order.setUserId(userId);
        order.setAddressId(addressId1);
        order.setStatus("NEW");
        order.setTotal(new java.math.BigDecimal("1"));
        order.setPaid(false);
        test("创建订单", () -> com.Model.createOrder(order));

        int orderId = order.getId();

        test("查订单", () -> com.Model.getOrderById(orderId));
        test("获取用户订单", () -> com.Model.getOrdersByUser(userId));
        test("列出所有订单", com.Model::listAllOrders);
        test("更新订单状态", () -> com.Model.updateOrderStatus(orderId,"NEW"));
        test("标记已付款", () -> com.Model.markOrderPaid(orderId));

        int batchId = 1;
        test("生成SN码", () -> { com.Model.generateSNCodes(productId,1,batchId); return null; });
        java.util.List<com.entity.SNCode> codes = new java.util.ArrayList<>();
        test("查看SN列表", () -> { codes.addAll(com.Model.listSNCodes(productId,null)); return codes; });
        String sn = codes.isEmpty() ? "" : codes.get(0).getCode();
        test("更新SN状态", () -> com.Model.updateSNStatus(sn,"NEW"));
        test("删除SN码", () -> com.Model.deleteSNCodes(batchId));

        test("SN绑定", () -> com.Model.bindSN(userId,sn));
        test("查询绑定", () -> com.Model.getBindingsByUser(userId));
        test("管理员解绑", () -> com.Model.adminUnbindSN(sn));

        com.entity.AfterSale as = new com.entity.AfterSale();
        as.setUserId(userId);
        as.setSnCode(sn);
        as.setType("refund");
        as.setReason("reason");
        test("申请售后", () -> com.Model.applyAfterSale(as));

        int asId = as.getId();

        test("查用户售后", () -> com.Model.getAfterSalesByUser(userId));
        test("列出所有售后", com.Model::listAllAfterSales);
        test("更新售后状态", () -> com.Model.updateAfterSaleStatus(asId,"NEW","remark"));
        test("关闭售后", () -> com.Model.closeAfterSale(asId));

        com.entity.Notification note = new com.entity.Notification();
        note.setUserId(userId);
        note.setContent("hi");
        test("发送通知", () -> com.Model.sendNotification(note));

        int noteId = note.getId();

        test("获取通知", () -> com.Model.getNotifications(userId));
        test("标记已读", () -> com.Model.markNotificationRead(noteId));
        test("删除通知", () -> com.Model.deleteNotification(noteId));

        // 测试流程结束
    }
}