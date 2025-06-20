
/**
 * 对 {@link com.ServiceLayer} 的简要测试，确保核心接口可以正常访问。
 *
 * <p>执行前请确认数据库已准备就绪。</p>
 */
public class ServiceLayerTest {

    public static void main(String[] args) {
        // -------- 注册与登录 --------
        com.entity.User user = new com.entity.User();
        user.setUsername("service_user");
        user.setPassword("123456");

        boolean reg = com.ServiceLayer.register(user);
        System.out.println("register result: " + reg);

        com.entity.User login = com.ServiceLayer.login("service_user", "123456");
        System.out.println("login success: " + (login != null));

        // -------- 商品与购物车 --------
        com.entity.Product p = new com.entity.Product();
        p.setName("service product");
        p.setPrice(new java.math.BigDecimal("19.99"));
        p.setStock(20);
        p.setDescription("for service test");
        com.ServiceLayer.addProduct(p);

        com.entity.CartItem cart = new com.entity.CartItem();
        cart.setUserId(user.getId());
        cart.setProductId(p.getId());
        cart.setQuantity(1);
        com.ServiceLayer.addToCart(cart);

        java.util.List<com.entity.CartItem> list = com.ServiceLayer.getCartItems(user.getId());
        System.out.println("cart list size: " + list.size());

        com.ServiceLayer.removeCartItem(cart.getId());
        com.ServiceLayer.deleteProduct(p.getId());
    }
}