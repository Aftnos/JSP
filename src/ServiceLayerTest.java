public class ServiceLayerTest {
    public static void main(String[] args) {
        try {
        // 用户注册和登录
        com.entity.User user = new com.entity.User();
        user.setUsername("svc_demo");
        user.setPassword("123456");
        user.setEmail("svc@example.com");
        com.ServiceLayer.register(user);
        com.ServiceLayer.login("svc_demo", "123456");
        com.ServiceLayer.getUserById(user.getId());

        // 分类和商品
        com.entity.Category cat = new com.entity.Category();
        cat.setName("Cat");
        com.ServiceLayer.addCategory(cat);
        com.ServiceLayer.listCategories();

        com.entity.Product prod = new com.entity.Product();
        prod.setName("Item");
        prod.setPrice(new java.math.BigDecimal("1"));
        prod.setStock(5);
        prod.setDescription("demo");
        com.ServiceLayer.addProduct(prod);
        com.ServiceLayer.listProducts();
        com.ServiceLayer.getProductById(prod.getId());

        // 地址
        com.entity.Address addr = new com.entity.Address();
        addr.setUserId(user.getId());
        addr.setReceiver("svc");
        addr.setPhone("123");
        addr.setDetail("street");
        com.ServiceLayer.addAddress(addr);
        com.ServiceLayer.getAddresses(user.getId());
        com.ServiceLayer.setDefaultAddress(user.getId(), addr.getId());

        // 购物车和订单
        com.entity.CartItem item = new com.entity.CartItem();
        item.setUserId(user.getId());
        item.setProductId(prod.getId());
        item.setQuantity(1);
        com.ServiceLayer.addToCart(item);
        com.ServiceLayer.getCartItems(user.getId());
        com.ServiceLayer.updateCartItem(item.getId(), 2);

        com.entity.Order order = new com.entity.Order();
        order.setUserId(user.getId());
        order.setAddressId(addr.getId());
        order.setTotal(new java.math.BigDecimal("2"));
        order.setStatus("pending");
        com.ServiceLayer.createOrder(order);
        com.ServiceLayer.getOrderById(order.getId());
        com.ServiceLayer.getOrdersByUser(user.getId());
        com.ServiceLayer.listAllOrders();
        com.ServiceLayer.updateOrderStatus(order.getId(), "shipped");
        com.ServiceLayer.markOrderPaid(order.getId());

        // SN 码和绑定
        com.ServiceLayer.generateSNCodes(prod.getId(), 1, 1);
        com.ServiceLayer.listSNCodes(prod.getId(), "unsold");
        com.ServiceLayer.updateSNStatus("demo", "sold");
        com.ServiceLayer.bindSN(user.getId(), "demo");
        com.ServiceLayer.getBindingsByUser(user.getId());
        com.ServiceLayer.adminUnbindSN("demo");
        com.ServiceLayer.deleteSNCodes(1);

        // 售后和通知
        com.entity.AfterSale as = new com.entity.AfterSale();
        as.setUserId(user.getId());
        as.setSnCode("demo");
        as.setType("refund");
        as.setReason("none");
        com.ServiceLayer.applyAfterSale(as);
        com.ServiceLayer.getAfterSalesByUser(user.getId());
        com.ServiceLayer.listAllAfterSales();
        com.ServiceLayer.updateAfterSaleStatus(as.getId(), "done", "ok");
        com.ServiceLayer.closeAfterSale(as.getId());

        com.entity.Notification n = new com.entity.Notification();
        n.setUserId(user.getId());
        n.setContent("notice");
        com.ServiceLayer.sendNotification(n);
        com.ServiceLayer.getNotifications(user.getId());
        com.ServiceLayer.markNotificationRead(n.getId());
        com.ServiceLayer.deleteNotification(n.getId());
            System.out.println("\u6240\u6709 ServiceLayer \u6d4b\u8bd5\u901a\u8fc7");
        } catch (Exception e) {
            System.out.println("ServiceLayer \u6d4b\u8bd5\u5931\u8d25: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
