import com.Model;

import java.sql.*;
import java.util.*;
import com.entity.*;

/**
 * Model类的测试类
 * 测试数据库操作的各种功能
 */
public class ModelTest {
    
    public static void main(String[] args) {
        System.out.println("开始测试Model类...");
        
        // 首先检查MySQL驱动是否可用
        if (!checkMySQLDriver()) {
            System.out.println("\n❌ MySQL JDBC驱动未找到！");
            System.out.println("解决方案：");
            System.out.println("1. 运行 setup-mysql-driver.bat 自动下载驱动");
            System.out.println("2. 或手动下载 mysql-connector-java-8.0.33.jar 到 lib 目录");
            System.out.println("3. 然后使用以下命令运行：");
            System.out.println("   javac -cp \"lib\\mysql-connector-java-8.0.33.jar\" -d . src\\*.java");
            System.out.println("   java -cp \".;lib\\mysql-connector-java-8.0.33.jar\" ModelTest");
            return;
        }
        
        // 测试数据库连接
        testDatabaseConnection();
        
        // 测试用户相关功能
        testUserOperations();
        
        // 测试管理员相关功能
        testAdminOperations();
        
        // 测试商品相关功能
        testProductOperations();
        
        // 测试订单相关功能
        testOrderOperations();

        // 测试用户绑定商品及售后功能
        testUserProductOperations();

        // 测试广告功能
        testAdvertisementOperations();

        // 测试修改密码功能
        testPasswordUpdate();

        System.out.println("\n所有测试完成！");
    }
    
    /**
     * 检查MySQL JDBC驱动是否可用
     */
    public static boolean checkMySQLDriver() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✓ MySQL JDBC驱动加载成功");
            return true;
        } catch (ClassNotFoundException e) {
            return false;
        }
    }
    
    /**
     * 测试数据库连接
     */
    public static void testDatabaseConnection() {
        System.out.println("\n=== 测试数据库连接 ===");
        try {
            Connection conn = Model.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✓ 数据库连接成功");
                
                // 测试数据库是否存在必要的表
                testDatabaseTables(conn);
                
                conn.close();
            } else {
                System.out.println("✗ 数据库连接失败");
            }
        } catch (SQLException e) {
            System.out.println("✗ 数据库连接异常: " + e.getMessage());
            if (e.getMessage().contains("Unknown database")) {
                System.out.println("提示：请确保MySQL数据库 'xiaomi_mall' 已创建");
                System.out.println("可以运行 sql/schema.sql 文件来创建数据库和表");
            } else if (e.getMessage().contains("Access denied")) {
                System.out.println("提示：请检查数据库用户名和密码是否正确");
            } else if (e.getMessage().contains("Connection refused")) {
                System.out.println("提示：请确保MySQL服务已启动");
            }
        }
    }
    
    /**
     * 测试数据库表是否存在
     */
    public static void testDatabaseTables(Connection conn) {
        String[] tables = {"users", "admins", "products", "orders", "order_items"};
        
        for (String table : tables) {
            try {
                PreparedStatement ps = conn.prepareStatement("SELECT 1 FROM " + table + " LIMIT 1");
                ps.executeQuery();
                ps.close();
                System.out.println("✓ 表 '" + table + "' 存在");
            } catch (SQLException e) {
                System.out.println("✗ 表 '" + table + "' 不存在或无法访问");
            }
        }
    }
    
    /**
     * 测试用户相关操作
     */
    public static void testUserOperations() {
        System.out.println("\n=== 测试用户操作 ===");
        
        try {
            // 测试添加用户
            String testUsername = "testuser_" + System.currentTimeMillis();
            String testPassword = "testpass123";
            
            int addResult = Model.addUser(testUsername, testPassword);
            if (addResult > 0) {
                System.out.println("✓ 添加用户成功: " + testUsername);
            } else {
                System.out.println("✗ 添加用户失败");
            }
            
            // 测试用户登录验证
            boolean loginResult = Model.validateUser(testUsername, testPassword);
            if (loginResult) {
                System.out.println("✓ 用户登录验证成功");
            } else {
                System.out.println("✗ 用户登录验证失败");
            }
            
            // 测试错误密码
            boolean wrongPasswordResult = Model.validateUser(testUsername, "wrongpassword");
            if (!wrongPasswordResult) {
                System.out.println("✓ 错误密码验证正确（返回false）");
            } else {
                System.out.println("✗ 错误密码验证失败（应该返回false）");
            }
            
            // 测试不存在的用户
            boolean nonExistentUserResult = Model.validateUser("nonexistentuser", "password");
            if (!nonExistentUserResult) {
                System.out.println("✓ 不存在用户验证正确（返回false）");
            } else {
                System.out.println("✗ 不存在用户验证失败（应该返回false）");
            }
        } catch (Exception e) {
            System.out.println("✗ 用户操作测试异常: " + e.getMessage());
        }
    }
    
    /**
     * 测试管理员相关操作
     */
    public static void testAdminOperations() {
        System.out.println("\n=== 测试管理员操作 ===");
        
        try {
            // 测试管理员登录（假设数据库中有默认管理员）
            boolean adminResult = Model.validateAdmin("admin", "admin123");
            if (adminResult) {
                System.out.println("✓ 管理员登录验证成功");
            } else {
                System.out.println("? 管理员登录验证失败（可能数据库中没有默认管理员）");
                System.out.println("  提示：可以手动在admins表中添加管理员账户");
            }
            
            // 测试错误的管理员凭据
            boolean wrongAdminResult = Model.validateAdmin("wrongadmin", "wrongpass");
            if (!wrongAdminResult) {
                System.out.println("✓ 错误管理员凭据验证正确（返回false）");
            } else {
                System.out.println("✗ 错误管理员凭据验证失败（应该返回false）");
            }
        } catch (Exception e) {
            System.out.println("✗ 管理员操作测试异常: " + e.getMessage());
        }
    }
    
    /**
     * 测试商品相关操作
     */
    public static void testProductOperations() {
        System.out.println("\n=== 测试商品操作 ===");
        
        try {
            // 测试添加商品
            String productName = "测试商品_" + System.currentTimeMillis();
            double productPrice = 99.99;
            int productStock = 100;
            String productDesc = "这是一个测试商品";
            
            int addProductResult = Model.addProduct(productName, productPrice, productStock, productDesc, 1);
            if (addProductResult > 0) {
                System.out.println("✓ 添加商品成功: " + productName);
            } else {
                System.out.println("✗ 添加商品失败");
            }
            
            // 测试获取所有商品
            List<Product> allProducts = Model.getAllProducts();
            System.out.println("✓ 获取到 " + allProducts.size() + " 个商品");
            
            // 如果有商品，测试根据ID获取商品
            if (!allProducts.isEmpty()) {
                Product firstProduct = allProducts.get(0);
                Product productById = Model.getProductById(firstProduct.id);
                if (productById != null && productById.id == firstProduct.id) {
                    System.out.println("✓ 根据ID获取商品成功: " + productById.name);
                } else {
                    System.out.println("✗ 根据ID获取商品失败");
                }
                
                // 测试更新商品
                String updatedName = "更新后的商品名_" + System.currentTimeMillis();
                int updateResult = Model.updateProduct(firstProduct.id, updatedName, 199.99, 50, "更新后的描述", 1);
                if (updateResult > 0) {
                    System.out.println("✓ 更新商品成功");
                } else {
                    System.out.println("✗ 更新商品失败");
                }
                
                // 验证更新是否生效
                Product updatedProduct = Model.getProductById(firstProduct.id);
                if (updatedProduct != null && updatedProduct.name.equals(updatedName)) {
                    System.out.println("✓ 商品更新验证成功");
                } else {
                    System.out.println("✗ 商品更新验证失败");
                }
            }
            
            // 测试获取不存在的商品
            Product nonExistentProduct = Model.getProductById(99999);
            if (nonExistentProduct == null) {
                System.out.println("✓ 获取不存在商品正确返回null");
            } else {
                System.out.println("✗ 获取不存在商品应该返回null");
            }
        } catch (Exception e) {
            System.out.println("✗ 商品操作测试异常: " + e.getMessage());
        }
    }
    
    /**
     * 测试订单相关操作
     */
    public static void testOrderOperations() {
        System.out.println("\n=== 测试订单操作 ===");
        
        try {
            // 获取商品列表用于创建订单
            List<Product> products = Model.getAllProducts();
            if (products.isEmpty()) {
                System.out.println("? 没有商品可用于测试订单功能");
                return;
            }
            
            // 创建测试订单项
            List<CartItem> cartItems = new ArrayList<>();
            CartItem item1 = new CartItem();
            item1.productId = products.get(0).id;
            item1.quantity = 2;
            item1.price = products.get(0).price;
            cartItems.add(item1);
            
            if (products.size() > 1) {
                CartItem item2 = new CartItem();
                item2.productId = products.get(1).id;
                item2.quantity = 1;
                item2.price = products.get(1).price;
                cartItems.add(item2);
            }
            
            // 测试创建订单（使用用户ID 1，假设存在）
            int createOrderResult = Model.createOrder(1, cartItems);
            if (createOrderResult > 0) {
                System.out.println("✓ 创建订单成功");
            } else {
                System.out.println("✗ 创建订单失败（可能用户ID 1不存在）");
            }
            
            // 测试获取用户订单
            List<Order> userOrders = Model.getOrdersByUser(1);
            System.out.println("✓ 用户1有 " + userOrders.size() + " 个订单");
            
            // 测试获取所有订单
            List<Order> allOrders = Model.getAllOrders();
            System.out.println("✓ 系统中共有 " + allOrders.size() + " 个订单");
            
            // 如果有订单，测试更新订单状态
            if (!allOrders.isEmpty()) {
                Order firstOrder = allOrders.get(0);
                int updateStatusResult = Model.updateOrderStatus(firstOrder.id, "已发货");
                if (updateStatusResult > 0) {
                    System.out.println("✓ 更新订单状态成功");
                } else {
                    System.out.println("✗ 更新订单状态失败");
                }
                
                // 验证订单状态更新
                List<Order> updatedOrders = Model.getAllOrders();
                Order updatedOrder = null;
                for (Order order : updatedOrders) {
                    if (order.id == firstOrder.id) {
                        updatedOrder = order;
                        break;
                    }
                }
                if (updatedOrder != null && "已发货".equals(updatedOrder.status)) {
                    System.out.println("✓ 订单状态更新验证成功");
                } else {
                    System.out.println("✗ 订单状态更新验证失败");
                }
            }
            
            // 测试获取不存在用户的订单
            List<Order> nonExistentUserOrders = Model.getOrdersByUser(99999);
            if (nonExistentUserOrders.isEmpty()) {
                System.out.println("✓ 不存在用户的订单列表为空");
            } else {
                System.out.println("✗ 不存在用户的订单列表应该为空");
            }
        } catch (Exception e) {
            System.out.println("✗ 订单操作测试异常: " + e.getMessage());
        }
    }

    /**
     * 测试用户绑定商品及售后操作
     */
    public static void testUserProductOperations() {
        System.out.println("\n=== 测试用户绑定商品及售后 ===");

        try {
            List<Product> products = Model.getAllProducts();
            if (products.isEmpty()) {
                System.out.println("? 没有商品可用于测试用户商品绑定");
                return;
            }

            int userId = 1; // 假设存在ID为1的用户
            int productId = products.get(0).id;
            String sn = "SN_" + System.currentTimeMillis();

            int addResult = Model.addUserProduct(userId, productId, sn);
            if (addResult > 0) {
                System.out.println("✓ 添加用户商品成功");
            } else {
                System.out.println("✗ 添加用户商品失败（可能用户或商品不存在）");
            }

            List<UserProduct> list = Model.getUserProducts(userId);
            System.out.println("✓ 用户已绑定 " + list.size() + " 个商品");

            if (!list.isEmpty()) {
                UserProduct up = list.get(0);
                int apply = Model.applyAfterSale(up.id);
                if (apply > 0) {
                    System.out.println("✓ 申请售后成功");
                } else {
                    System.out.println("✗ 申请售后失败");
                }

                int update = Model.updateAfterSaleStatus(up.id, "已完成");
                if (update > 0) {
                    System.out.println("✓ 管理员更新售后状态成功");
                } else {
                    System.out.println("✗ 管理员更新售后状态失败");
                }
            }
        } catch (Exception e) {
            System.out.println("✗ 用户商品操作测试异常: " + e.getMessage());
        }
    }

    /**
     * 测试广告相关操作
     */
    public static void testAdvertisementOperations() {
        System.out.println("\n=== 测试广告操作 ===");

        try {
            int add = Model.addAdvertisement("测试广告", "img.png", "http://example.com", true);
            System.out.println(add > 0 ? "✓ 添加广告成功" : "✗ 添加广告失败");

            List<Advertisement> ads = Model.getAllAdvertisements();
            System.out.println("✓ 当前广告数量: " + ads.size());

            if (!ads.isEmpty()) {
                Advertisement ad = ads.get(0);
                Model.updateAdvertisement(ad.id, ad.title, ad.imagePath, ad.targetUrl, ad.enabled);
                Model.deleteAdvertisement(ad.id);
            }
        } catch (Exception e) {
            System.out.println("✗ 广告操作测试异常: " + e.getMessage());
        }
    }

    /**
     * 测试修改密码功能
     */
    public static void testPasswordUpdate() {
        System.out.println("\n=== 测试密码修改 ===");
        try {
            Model.updateUserPassword(1, "newpass");
            Model.updateAdminPassword(1, "newadminpass");
            System.out.println("✓ 密码更新函数调用完成");
        } catch (Exception e) {
            System.out.println("✗ 密码修改测试异常: " + e.getMessage());
        }
    }
    
    /**
     * 辅助方法：打印商品信息
     */
    public static void printProduct(Product product) {
        if (product != null) {
            System.out.println("商品ID: " + product.id + ", 名称: " + product.name + 
                             ", 价格: " + product.price + ", 库存: " + product.stock);
        }
    }
    
    /**
     * 辅助方法：打印订单信息
     */
    public static void printOrder(Order order) {
        if (order != null) {
            System.out.println("订单ID: " + order.id + ", 用户ID: " + order.userId + 
                             ", 状态: " + order.status + ", 总金额: " + order.total + 
                             ", 订单项数量: " + (order.items != null ? order.items.size() : 0));
        }
    }
}