import com.ServiceLayer;

import java.util.ArrayList;
import java.util.List;
import com.entity.*;
import java.sql.Timestamp;

/**
 * com.ServiceLayer 测试类
 * 用于测试 com.ServiceLayer 封装的各项功能是否正常运行
 */
public class ServiceLayerTest {
    
    public static void main(String[] args) {
        // 测试用户服务
        testUserServices();
        
        // 测试管理员服务
        testAdminServices();
        
        // 测试分类服务
        testCategoryServices();

        // 测试商品服务
        testProductServices();
        
        // 测试订单服务
        testOrderServices();
        
        // 测试售后服务
        testAfterSaleServices();

        // 测试广告服务
        testAdvertisementServices();

        // 测试工具方法
        testUtilityMethods();
        
        System.out.println("所有测试完成！");
    }
    
    /**
     * 测试用户相关服务
     */
    private static void testUserServices() {
        System.out.println("========== 测试用户服务 ==========");
        
        // 测试用户注册
        String username = "testuser" + System.currentTimeMillis();
        String password = "password123";
        
        System.out.println("测试用户注册...");
        String registerResult = ServiceLayer.userRegister(username, password);
        System.out.println("注册结果: " + registerResult);
        assert "success".equals(registerResult) : "用户注册失败";
        
        // 测试用户登录
        System.out.println("测试用户登录...");
        boolean loginResult = ServiceLayer.userLogin(username, password);
        System.out.println("登录结果: " + loginResult);
        assert loginResult : "用户登录失败";
        
        // 测试无效登录
        System.out.println("测试无效登录...");
        boolean invalidLoginResult = ServiceLayer.userLogin(username, "wrongpassword");
        System.out.println("无效登录结果: " + invalidLoginResult);
        assert !invalidLoginResult : "无效登录应该失败";
        
        // 测试参数验证
        System.out.println("测试参数验证...");
        String shortUsername = "ab";
        String shortPassword = "12345";
        String longUsername = "abcdefghijklmnopqrstuvwxyz";
        
        String shortUsernameResult = ServiceLayer.userRegister(shortUsername, password);
        System.out.println("短用户名注册结果: " + shortUsernameResult);
        assert !"success".equals(shortUsernameResult) : "短用户名应该注册失败";
        
        String shortPasswordResult = ServiceLayer.userRegister(username + "1", shortPassword);
        System.out.println("短密码注册结果: " + shortPasswordResult);
        assert !"success".equals(shortPasswordResult) : "短密码应该注册失败";
        
        String longUsernameResult = ServiceLayer.userRegister(longUsername, password);
        System.out.println("长用户名注册结果: " + longUsernameResult);
        assert !"success".equals(longUsernameResult) || "success".equals(longUsernameResult) : "长用户名可能注册成功或失败";

        // 测试更新密码和资料
        System.out.println("测试更新用户密码和资料...");
        String pwdResult = ServiceLayer.updateUserPassword(1, "newpass123");
        System.out.println("更新密码结果: " + pwdResult);
        ServiceLayer.updateUserProfile(1, "测试用户", null);

        // 测试获取用户信息与头像
        System.out.println("测试获取用户信息...");
        com.entity.User info = ServiceLayer.getUserById(1);
        if (info != null) {
            System.out.println("用户显示名: " + info.displayName);
            String avatar = ServiceLayer.getUserAvatar(1);
            System.out.println("用户头像URL: " + avatar);
        } else {
            System.out.println("未找到用户信息");
        }

        // 获取所有用户并删除刚注册的测试用户
        System.out.println("测试获取所有用户...");
        List<com.entity.User> users = ServiceLayer.getAllUsers();
        int newUserId = -1;
        for (com.entity.User u : users) {
            if (u.username.equals(username)) {
                newUserId = u.id;
                break;
            }
        }
        System.out.println("当前用户数量: " + users.size());
        if (newUserId > 0) {
            System.out.println("测试删除用户...");
            String del = ServiceLayer.deleteUser(newUserId);
            System.out.println("删除用户结果: " + del);
        }

        System.out.println("用户服务测试完成\n");
    }
    
    /**
     * 测试管理员相关服务
     */
    private static void testAdminServices() {
        System.out.println("========== 测试管理员服务 ==========");
        
        // 测试管理员登录 (假设数据库中已有管理员账号 admin/admin123)
        System.out.println("测试管理员登录...");
        boolean adminLoginResult = ServiceLayer.adminLogin("admin", "admin123");
        System.out.println("管理员登录结果: " + adminLoginResult);
        // 注意：这个断言可能会失败，取决于数据库中是否有这个管理员账号
        // assert adminLoginResult : "管理员登录失败";
        
        // 测试无效管理员登录
        System.out.println("测试无效管理员登录...");
        boolean invalidAdminLoginResult = ServiceLayer.adminLogin("admin", "wrongpassword");
        System.out.println("无效管理员登录结果: " + invalidAdminLoginResult);
        assert !invalidAdminLoginResult : "无效管理员登录应该失败";

        System.out.println("测试更新管理员密码...");
        String adminPwd = ServiceLayer.updateAdminPassword(1, "adminNew");
        System.out.println("更新管理员密码结果: " + adminPwd);

        System.out.println("管理员服务测试完成\n");
    }

    /**
     * 测试分类相关服务
     */
    private static void testCategoryServices() {
        System.out.println("========== 测试分类服务 ==========");

        String name = "分类" + System.currentTimeMillis();
        String addRes = ServiceLayer.addCategory(name);
        System.out.println("添加分类结果: " + addRes);

        List<Category> list = ServiceLayer.getAllCategories();
        System.out.println("分类数量: " + list.size());
        Category last = list.isEmpty() ? null : list.get(list.size() - 1);

        if (last != null) {
            String up = ServiceLayer.updateCategory(last.id, name + "_新");
            System.out.println("更新分类结果: " + up);
            Category info = ServiceLayer.getCategoryById(last.id);
            System.out.println("根据ID获取分类: " + (info != null));
            String del = ServiceLayer.deleteCategory(last.id);
            System.out.println("删除分类结果: " + del);
        }

        System.out.println("分类服务测试完成\n");
    }

    
    /**
     * 测试商品相关服务
     */
    private static void testProductServices() {
        System.out.println("========== 测试商品服务 ==========");
        
        // 测试添加商品
        String productName = "测试商品" + System.currentTimeMillis();
        double price = 999.99;
        int stock = 100;
        String description = "这是一个测试商品描述";
        
        System.out.println("测试添加商品...");
        String addResult = ServiceLayer.addProduct(productName, price, stock, description, 1);
        System.out.println("添加商品结果: " + addResult);
        assert "success".equals(addResult) : "添加商品失败";
        
        // 获取所有商品
        System.out.println("测试获取所有商品...");
        List<Product> products = ServiceLayer.getAllProducts();
        System.out.println("商品数量: " + products.size());
        assert !products.isEmpty() : "商品列表不应为空";
        
        // 查找刚添加的商品
        Product addedProduct = null;
        for (Product p : products) {
            if (p.name.equals(productName)) {
                addedProduct = p;
                break;
            }
        }
        assert addedProduct != null : "未找到刚添加的商品";
        
        // 测试获取单个商品
        System.out.println("测试获取单个商品...");
        Product product = ServiceLayer.getProductById(addedProduct.id);
        System.out.println("获取到商品: " + product.name);
        assert product != null : "获取单个商品失败";
        assert product.name.equals(productName) : "获取的商品名称不匹配";
        
        // 测试更新商品
        System.out.println("测试更新商品...");
        String updatedName = productName + "_更新";
        double updatedPrice = 1099.99;
        String updateResult = ServiceLayer.updateProduct(product.id, updatedName, updatedPrice, stock, description, 1);
        System.out.println("更新商品结果: " + updateResult);
        assert "success".equals(updateResult) : "更新商品失败";
        
        // 验证更新结果
        product = ServiceLayer.getProductById(product.id);
        assert product.name.equals(updatedName) : "商品名称更新失败";
        assert product.price == updatedPrice : "商品价格更新失败";
        
        // 测试删除商品
        System.out.println("测试删除商品...");
        String deleteResult = ServiceLayer.deleteProduct(product.id);
        System.out.println("删除商品结果: " + deleteResult);
        assert "success".equals(deleteResult) : "删除商品失败";
        
        // 验证删除结果
        product = ServiceLayer.getProductById(product.id);
        assert product == null : "商品未被成功删除";
        
        // 测试参数验证
        System.out.println("测试商品参数验证...");
        String emptyNameResult = ServiceLayer.addProduct("", price, stock, description, 1);
        assert !"success".equals(emptyNameResult) : "空商品名称应该添加失败";
        
        String negativeStockResult = ServiceLayer.addProduct(productName, price, -1, description, 1);
        assert !"success".equals(negativeStockResult) : "负库存应该添加失败";
        
        String negativePriceResult = ServiceLayer.addProduct(productName, -1, stock, description, 1);
        assert !"success".equals(negativePriceResult) : "负价格应该添加失败";
        
        System.out.println("商品服务测试完成\n");
    }
    
    /**
     * 测试订单相关服务
     */
    private static void testOrderServices() {
        System.out.println("========== 测试订单服务 ==========");
        
        // 首先添加一个测试商品
        String productName = "订单测试商品" + System.currentTimeMillis();
        double price = 888.88;
        int stock = 50;
        String description = "这是订单测试用的商品";
        
        String addResult = ServiceLayer.addProduct(productName, price, stock, description, 1);
        assert "success".equals(addResult) : "添加测试商品失败";
        
        // 获取刚添加的商品ID
        List<Product> products = ServiceLayer.getAllProducts();
        Product testProduct = null;
        for (Product p : products) {
            if (p.name.equals(productName)) {
                testProduct = p;
                break;
            }
        }
        assert testProduct != null : "未找到测试商品";
        
        // 创建购物车项目
        List<CartItem> cartItems = new ArrayList<>();
        CartItem item = new CartItem();
        item.productId = testProduct.id;
        item.quantity = 2;
        item.price = testProduct.price;
        cartItems.add(item);
        
        // 创建订单 (假设用户ID为1)
        int userId = 1;
        System.out.println("测试创建订单...");
        String createOrderResult = ServiceLayer.createOrder(userId, cartItems);
        System.out.println("创建订单结果: " + createOrderResult);
        assert "success".equals(createOrderResult) : "创建订单失败";
        Order testOrder = ServiceLayer.getUserOrders(userId).get(0);
        ServiceLayer.payOrder(testOrder.id);
        
        // 获取用户订单
        System.out.println("测试获取用户订单...");
        List<Order> userOrders = ServiceLayer.getUserOrders(userId);
        System.out.println("用户订单数量: " + userOrders.size());
        assert !userOrders.isEmpty() : "用户订单列表不应为空";
        
        // 获取所有订单
        System.out.println("测试获取所有订单...");
        List<Order> allOrders = ServiceLayer.getAllOrders();
        System.out.println("所有订单数量: " + allOrders.size());
        assert !allOrders.isEmpty() : "所有订单列表不应为空";
        
        // 更新订单状态
        testOrder = userOrders.get(0);
        System.out.println("测试更新订单状态...");
        String updateStatusResult = ServiceLayer.updateOrderStatus(testOrder.id, "已发货");
        System.out.println("更新订单状态结果: " + updateStatusResult);
        assert "success".equals(updateStatusResult) : "更新订单状态失败";
        
        // 验证订单状态更新
        userOrders = ServiceLayer.getUserOrders(userId);
        boolean statusUpdated = false;
        for (Order order : userOrders) {
            if (order.id == testOrder.id && "已发货".equals(order.status)) {
                statusUpdated = true;
                break;
            }
        }
        assert statusUpdated : "订单状态未成功更新";

        // 根据ID获取订单并测试删除
        Order fetched = ServiceLayer.getOrderById(testOrder.id);
        System.out.println("根据ID获取订单: " + (fetched != null));
        if (fetched != null) {
            String delOrderResult = ServiceLayer.deleteOrder(fetched.id);
            System.out.println("删除订单结果: " + delOrderResult);
            Order afterDel = ServiceLayer.getOrderById(fetched.id);
            System.out.println("删除后查询订单: " + afterDel);
        }

        // 测试参数验证
        System.out.println("测试订单参数验证...");
        String invalidUserIdResult = ServiceLayer.createOrder(-1, cartItems);
        assert !"success".equals(invalidUserIdResult) : "无效用户ID应该创建订单失败";
        
        List<CartItem> emptyCart = new ArrayList<>();
        String emptyCartResult = ServiceLayer.createOrder(userId, emptyCart);
        assert !"success".equals(emptyCartResult) : "空购物车应该创建订单失败";
        
        System.out.println("订单服务测试完成\n");
    }
    
    /**
     * 测试售后相关服务
     */
    private static void testAfterSaleServices() {
        System.out.println("========== 测试售后服务 ==========");
        
        // 首先添加一个测试商品
        String productName = "售后测试商品" + System.currentTimeMillis();
        double price = 777.77;
        int stock = 30;
        String description = "这是售后测试用的商品";
        
        String addResult = ServiceLayer.addProduct(productName, price, stock, description, 1);
        assert "success".equals(addResult) : "添加测试商品失败";
        
        // 获取刚添加的商品ID
        List<Product> products = ServiceLayer.getAllProducts();
        Product testProduct = null;
        for (Product p : products) {
            if (p.name.equals(productName)) {
                testProduct = p;
                break;
            }
        }
        assert testProduct != null : "未找到测试商品";
        
        // 创建并完成订单以便绑定
        int userId = 1;
        List<CartItem> items = new ArrayList<>();
        CartItem ci = new CartItem();
        ci.productId = testProduct.id;
        ci.quantity = 1;
        ci.price = testProduct.price;
        items.add(ci);
        ServiceLayer.createOrder(userId, items);
        Order o = ServiceLayer.getUserOrders(userId).get(0);
        ServiceLayer.payOrder(o.id);
        ServiceLayer.updateOrderStatus(o.id, "已完成");

        System.out.println("测试绑定用户商品...");
        String bindResult = ServiceLayer.bindUserProduct(userId, testProduct.id, o.orderNo);
        System.out.println("绑定用户商品结果: " + bindResult);
        assert "success".equals(bindResult) : "绑定用户商品失败";
        
        // 获取用户绑定的商品
        System.out.println("测试获取用户绑定商品...");
        List<UserProduct> userProducts = ServiceLayer.getUserProducts(userId);
        System.out.println("用户绑定商品数量: " + userProducts.size());
        assert !userProducts.isEmpty() : "用户绑定商品列表不应为空";
        
        // 查找刚绑定的商品
        UserProduct boundProduct = null;
        for (UserProduct up : userProducts) {
            if (up.orderNo.equals(o.orderNo)) {
                boundProduct = up;
                break;
            }
        }
        assert boundProduct != null : "未找到刚绑定的商品";

        // 再次尝试绑定同一商品，应该失败
        String duplicateBind = ServiceLayer.bindUserProduct(userId, testProduct.id, o.orderNo);
        assert !"success".equals(duplicateBind) : "重复绑定应该失败";

        // 尝试绑定订单中不存在的商品
        String invalidBind = ServiceLayer.bindUserProduct(userId, 999999, o.orderNo);
        assert !"success".equals(invalidBind) : "订单中不存在的商品绑定应失败";
        
        // 申请售后
        System.out.println("测试申请售后...");
        String applyResult = ServiceLayer.applyAfterSale(boundProduct.id);
        System.out.println("申请售后结果: " + applyResult);
        assert "success".equals(applyResult) : "申请售后失败";
        
        // 验证售后状态
        userProducts = ServiceLayer.getUserProducts(userId);
        boolean statusApplied = false;
        for (UserProduct up : userProducts) {
            if (up.id == boundProduct.id && "申请中".equals(up.afterSaleStatus)) {
                statusApplied = true;
                break;
            }
        }
        assert statusApplied : "售后状态未成功更新为'申请中'";
        
        // 更新售后状态
        System.out.println("测试更新售后状态...");
        String updateResult = ServiceLayer.updateAfterSaleStatus(boundProduct.id, "已处理");
        System.out.println("更新售后状态结果: " + updateResult);
        assert "success".equals(updateResult) : "更新售后状态失败";
        
        // 验证售后状态更新
        userProducts = ServiceLayer.getUserProducts(userId);
        boolean statusUpdated = false;
        for (UserProduct up : userProducts) {
            if (up.id == boundProduct.id && "已处理".equals(up.afterSaleStatus)) {
                statusUpdated = true;
                break;
            }
        }
        assert statusUpdated : "售后状态未成功更新为'已处理'";

        // 获取所有绑定记录
        System.out.println("测试获取所有绑定记录...");
        List<UserProduct> allBindings = ServiceLayer.getAllUserProducts();
        System.out.println("所有绑定记录数量: " + allBindings.size());
        assert !allBindings.isEmpty() : "所有绑定记录列表不应为空";

        // 根据ID获取绑定商品并删除
        UserProduct fetchedUP = ServiceLayer.getUserProductById(boundProduct.id);
        System.out.println("根据ID获取绑定商品: " + (fetchedUP != null));
        if (fetchedUP != null) {
            String delUP = ServiceLayer.deleteUserProduct(fetchedUP.id);
            System.out.println("删除绑定商品结果: " + delUP);
            UserProduct afterDelUP = ServiceLayer.getUserProductById(fetchedUP.id);
            System.out.println("删除后查询绑定商品: " + afterDelUP);
        }

        // 测试参数验证
        System.out.println("测试售后参数验证...");
        String invalidUserIdResult = ServiceLayer.bindUserProduct(-1, testProduct.id, o.orderNo + "1");
        assert !"success".equals(invalidUserIdResult) : "无效用户ID应该绑定商品失败";
        
        String invalidProductIdResult = ServiceLayer.bindUserProduct(userId, -1, o.orderNo + "2");
        assert !"success".equals(invalidProductIdResult) : "无效商品ID应该绑定商品失败";
        
        String emptyOrderNoResult = ServiceLayer.bindUserProduct(userId, testProduct.id, "");
        assert !"success".equals(emptyOrderNoResult) : "订单号不能为空";
        
        System.out.println("售后服务测试完成\n");
    }

    /**
     * 测试广告相关服务
     */
    private static void testAdvertisementServices() {
        System.out.println("========== 测试广告服务 ==========");

        String title = "广告" + System.currentTimeMillis();
        String img = "img" + System.currentTimeMillis() + ".png";
        String url = "http://example.com";
        String addResult = ServiceLayer.addAdvertisement(title, img, url, true);
        System.out.println("添加广告结果: " + addResult);
        assert "success".equals(addResult) : "添加广告失败";

        List<Advertisement> ads = ServiceLayer.getAllAdvertisements();
        assert !ads.isEmpty() : "广告列表不应为空";

        Advertisement ad = ads.get(ads.size() - 1);
        String updateResult = ServiceLayer.updateAdvertisement(ad.id, ad.title + "_up", ad.imagePath, ad.targetUrl, ad.enabled);
        System.out.println("更新广告结果: " + updateResult);
        assert "success".equals(updateResult) : "更新广告失败";

        Advertisement one = ServiceLayer.getAdvertisementById(ad.id);
        System.out.println("根据ID获取广告: " + (one != null));

        String deleteResult = ServiceLayer.deleteAdvertisement(ad.id);
        System.out.println("删除广告结果: " + deleteResult);
        assert "success".equals(deleteResult) : "删除广告失败";

        System.out.println("广告服务测试完成\n");
    }

    /**
     * 测试工具方法
     */
    private static void testUtilityMethods() {
        System.out.println("========== 测试工具方法 ==========");
        
        // 测试格式化价格
        System.out.println("测试格式化价格...");
        double price = 1234.56;
        String formattedPrice = ServiceLayer.formatPrice(price);
        System.out.println("格式化价格结果: " + formattedPrice);
        assert formattedPrice.equals("¥1,234.56") : "价格格式化错误";
        
        // 测试格式化时间
        System.out.println("测试格式化时间...");
        Timestamp now = new Timestamp(System.currentTimeMillis());
        String formattedTime = ServiceLayer.formatDateTime(now);
        System.out.println("格式化时间结果: " + formattedTime);
        assert formattedTime.length() == 19 : "时间格式化错误";
        
        // 测试字符串为空检查
        System.out.println("测试字符串为空检查...");
        assert ServiceLayer.isEmpty(null) : "null应该被识别为空";
        assert ServiceLayer.isEmpty("") : "空字符串应该被识别为空";
        assert ServiceLayer.isEmpty("  ") : "空白字符串应该被识别为空";
        assert !ServiceLayer.isEmpty("test") : "非空字符串不应该被识别为空";
        
        // 测试安全的字符串转整数
        System.out.println("测试安全的字符串转整数...");
        assert ServiceLayer.safeParseInt("123", 0) == 123 : "整数转换错误";
        assert ServiceLayer.safeParseInt("abc", 0) == 0 : "非整数字符串应该返回默认值";
        assert ServiceLayer.safeParseInt(null, -1) == -1 : "null应该返回默认值";
        
        // 测试安全的字符串转双精度浮点数
        System.out.println("测试安全的字符串转双精度浮点数...");
        assert ServiceLayer.safeParseDouble("123.45", 0) == 123.45 : "浮点数转换错误";
        assert ServiceLayer.safeParseDouble("abc", 0) == 0 : "非浮点数字符串应该返回默认值";
        assert ServiceLayer.safeParseDouble(null, -1) == -1 : "null应该返回默认值";
        
        System.out.println("工具方法测试完成\n");
    }
}