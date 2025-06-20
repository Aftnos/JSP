
/**
 * 演示性 Model 测试类，用于简单验证各模块接口是否能够正常工作。
 *
 * <p>执行前请确保已导入 {@code ProjectData/sql/schema.sql} 的表结构并在
 * {@code src/db.properties} 中配置好数据库连接信息。</p>
 */
public class ModelTest {

    public static void main(String[] args) throws Exception {
        // -------- 用户相关 --------
        com.entity.User user = new com.entity.User();
        user.setUsername("test_user");
        user.setPassword("123456");
        user.setEmail("test@example.com");

        int userRows = com.Model.register(user);
        System.out.println("register user rows: " + userRows);

        // -------- 商品相关 --------
        java.math.BigDecimal price = new java.math.BigDecimal("9.99");
        com.entity.Product product = new com.entity.Product();
        product.setName("demo product");
        product.setPrice(price);
        product.setStock(50);
        product.setDescription("for test");

        int productRows = com.Model.addProduct(product);
        System.out.println("insert product rows: " + productRows);

        // -------- 购物车相关 --------
        com.entity.CartItem item = new com.entity.CartItem();
        item.setUserId(user.getId());
        item.setProductId(product.getId());
        item.setQuantity(2);

        int cartRows = com.Model.addToCart(item);
        System.out.println("add cart item rows: " + cartRows);

        com.Model.updateCartItem(item.getId(), 3);
        java.util.List<com.entity.CartItem> items = com.Model.getCartItems(user.getId());
        System.out.println("cart size: " + items.size());

        com.Model.removeCartItem(item.getId());
        com.Model.deleteProduct(product.getId());
    }
}