public class ModelTest {
    public static void main(String[] args) {
        try {
        // 用户注册与查询
        com.entity.User user = new com.entity.User();
        user.setUsername("demo");
        user.setPassword("123456");
        user.setEmail("demo@example.com");
        com.Model.register(user);
        com.Model.login("demo", "123456");
        com.Model.getUserById(user.getId());

        // 分类与商品
        com.entity.Category cat = new com.entity.Category();
        cat.setName("Phone");
        com.Model.addCategory(cat);
        com.Model.listCategories();

        com.entity.Product p = new com.entity.Product();
        p.setName("Mi 14");
        p.setPrice(new java.math.BigDecimal("1"));
        p.setStock(10);
        p.setDescription("demo product");
        com.Model.addProduct(p);
        com.Model.listProducts();
        com.Model.getProductById(p.getId());

        // 地址
        com.entity.Address addr = new com.entity.Address();
        addr.setUserId(user.getId());
        addr.setReceiver("demo");
        addr.setPhone("123");
        addr.setDetail("demo street");
        addr.setDefault(true);
        com.Model.addAddress(addr);
        com.Model.getAddresses(user.getId());
        com.Model.setDefaultAddress(user.getId(), addr.getId());

        // 购物车和订单
        com.entity.CartItem cart = new com.entity.CartItem();
        cart.setUserId(user.getId());
        cart.setProductId(p.getId());
        cart.setQuantity(1);
        com.Model.addToCart(cart);
        com.Model.getCartItems(user.getId());
        com.Model.updateCartItem(cart.getId(), 2);

        com.entity.Order order = new com.entity.Order();
        order.setUserId(user.getId());
        order.setAddressId(addr.getId());
        order.setTotal(new java.math.BigDecimal("2"));
        order.setStatus("pending");
        com.Model.createOrder(order);
        com.Model.getOrderById(order.getId());
        com.Model.getOrdersByUser(user.getId());
        com.Model.listAllOrders();
        com.Model.updateOrderStatus(order.getId(), "paid");
        com.Model.markOrderPaid(order.getId());

        // SN 码
        com.Model.generateSNCodes(p.getId(), 1, 1);
        com.Model.listSNCodes(p.getId(), "unsold");
        com.Model.updateSNStatus("demo", "sold");
        com.Model.deleteSNCodes(1);

        // 绑定
        com.Model.bindSN(user.getId(), "demo");
        com.Model.getBindingsByUser(user.getId());
        com.Model.adminUnbindSN("demo");

        // 售后
        com.entity.AfterSale af = new com.entity.AfterSale();
        af.setUserId(user.getId());
        af.setSnCode("demo");
        af.setType("warranty");
        af.setReason("test");
        com.Model.applyAfterSale(af);
        com.Model.getAfterSalesByUser(user.getId());
        com.Model.listAllAfterSales();
        com.Model.updateAfterSaleStatus(af.getId(), "done", "ok");
        com.Model.closeAfterSale(af.getId());

        // 通知
        com.entity.Notification n = new com.entity.Notification();
        n.setUserId(user.getId());
        n.setContent("hello");
        com.Model.sendNotification(n);
        com.Model.getNotifications(user.getId());
        com.Model.markNotificationRead(n.getId());
        com.Model.deleteNotification(n.getId());
            System.out.println("\u6240\u6709 Model \u6a21\u5757\u6d4b\u8bd5\u901a\u8fc7");
        } catch (Exception e) {
            System.out.println("Model \u6d4b\u8bd5\u5931\u8d25: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
