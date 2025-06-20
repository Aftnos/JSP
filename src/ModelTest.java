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

        test("登录", () -> com.Model.login("demo", "123"));

        test("注册", () -> {
            com.entity.User u = new com.entity.User();
            u.setUsername("demo");
            u.setPassword("123");
            u.setEmail("demo@test.com");
            return com.Model.register(u);
        });

        test("按ID查询用户", () -> com.Model.getUserById(1));

        test("列出商品", com.Model::listProducts);
        test("查询商品", () -> com.Model.getProductById(1));
        test("添加商品", () -> {
            com.entity.Product p = new com.entity.Product();
            p.setName("测试商品");
            p.setPrice(new java.math.BigDecimal("1"));
            p.setStock(10);
            p.setDescription("desc");
            return com.Model.addProduct(p);
        });
        test("更新商品", () -> {
            com.entity.Product p = new com.entity.Product();
            p.setId(1);
            p.setName("update");
            p.setPrice(new java.math.BigDecimal("2"));
            p.setStock(5);
            p.setDescription("update");
            return com.Model.updateProduct(p);
        });
        test("删除商品", () -> com.Model.deleteProduct(1));

        test("获取地址", () -> com.Model.getAddresses(1));
        test("添加地址", () -> {
            com.entity.Address a = new com.entity.Address();
            a.setUserId(1);
            a.setReceiver("张三");
            a.setPhone("123456");
            a.setDetail("addr");
            return com.Model.addAddress(a);
        });
        test("更新地址", () -> {
            com.entity.Address a = new com.entity.Address();
            a.setId(1);
            a.setUserId(1);
            a.setReceiver("张三");
            a.setPhone("123456");
            a.setDetail("addr");
            return com.Model.updateAddress(a);
        });
        test("删除地址", () -> com.Model.deleteAddress(1));
        test("设置默认地址", () -> { com.Model.setDefaultAddress(1,1); return null; });

        test("列出类别", com.Model::listCategories);
        test("添加类别", () -> {
            com.entity.Category c = new com.entity.Category();
            c.setName("cate");
            return com.Model.addCategory(c);
        });
        test("更新类别", () -> {
            com.entity.Category c = new com.entity.Category();
            c.setId(1);
            c.setName("cate2");
            return com.Model.updateCategory(c);
        });
        test("删除类别", () -> com.Model.deleteCategory(1));

        test("查看购物车", () -> com.Model.getCartItems(1));
        test("添加购物车", () -> {
            com.entity.CartItem item = new com.entity.CartItem();
            item.setUserId(1);
            item.setProductId(1);
            item.setQuantity(1);
            return com.Model.addToCart(item);
        });
        test("更新购物车", () -> com.Model.updateCartItem(1,1));
        test("移除购物车", () -> com.Model.removeCartItem(1));

        test("创建订单", () -> {
            com.entity.Order o = new com.entity.Order();
            o.setUserId(1);
            o.setAddressId(1);
            o.setStatus("NEW");
            return com.Model.createOrder(o);
        });
        test("查订单", () -> com.Model.getOrderById(1));
        test("获取用户订单", () -> com.Model.getOrdersByUser(1));
        test("列出所有订单", com.Model::listAllOrders);
        test("更新订单状态", () -> com.Model.updateOrderStatus(1,"NEW"));
        test("标记已付款", () -> com.Model.markOrderPaid(1));

        test("生成SN码", () -> { com.Model.generateSNCodes(1,1,1); return null; });
        test("查看SN列表", () -> com.Model.listSNCodes(1,null));
        test("更新SN状态", () -> com.Model.updateSNStatus("code","NEW"));
        test("删除SN码", () -> com.Model.deleteSNCodes(1));

        test("SN绑定", () -> com.Model.bindSN(1,"code"));
        test("查询绑定", () -> com.Model.getBindingsByUser(1));
        test("管理员解绑", () -> com.Model.adminUnbindSN("code"));

        test("申请售后", () -> {
            com.entity.AfterSale a = new com.entity.AfterSale();
            a.setUserId(1);
            a.setSnCode("code");
            a.setType("refund");
            a.setReason("reason");
            return com.Model.applyAfterSale(a);
        });
        test("查用户售后", () -> com.Model.getAfterSalesByUser(1));
        test("列出所有售后", com.Model::listAllAfterSales);
        test("更新售后状态", () -> com.Model.updateAfterSaleStatus(1,"NEW","remark"));
        test("关闭售后", () -> com.Model.closeAfterSale(1));

        test("发送通知", () -> {
            com.entity.Notification n = new com.entity.Notification();
            n.setUserId(1);
            n.setContent("hi");
            return com.Model.sendNotification(n);
        });
        test("获取通知", () -> com.Model.getNotifications(1));
        test("标记已读", () -> com.Model.markNotificationRead(1));
        test("删除通知", () -> com.Model.deleteNotification(1));
    }
}
