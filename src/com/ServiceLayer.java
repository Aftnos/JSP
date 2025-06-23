package com;

import com.entity.*;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

/**
 * 业务服务层 - 为 JSP 页面提供静态调用方式的接口
 */
public class ServiceLayer {

    // 用户登录
    public static User login(String username, String password) {
        try {
            return Model.login(username, password);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // 用户注册
    public static boolean register(User user) {
        try {
            return Model.register(user) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static User getUserById(int id) {
        try {
            return Model.getUserById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // 用户管理相关
    public static List<User> listAllUsers() {
        try {
            return Model.listAllUsers();
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // 新增：返回所有用户列表的别名方法，供 JSP 调用
    public static List<User> getAllUsers() {
        return listAllUsers();
    }

    public static List<User> searchUsers(String keyword) {
        try {
            return Model.searchUsers(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean updateUser(User user) {
        try {
            return Model.updateUser(user) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteUser(int id) {
        try {
            // Remove related bindings first to avoid foreign key violations
            Model.deleteBindingsByUser(id);
            return Model.deleteUser(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 新增：根据 ID 删除用户的别名方法，供 JSP 调用
    public static boolean deleteUserById(int id) {
        return deleteUser(id);
    }

    public static boolean batchDeleteUsers(int[] ids) {
        try {
            if (ids != null) {
                for (int id : ids) {
                    Model.deleteBindingsByUser(id);
                }
            }
            return Model.batchDeleteUsers(ids) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 商品相关
    public static List<Product> listProducts() {
        try {
            return Model.listProducts();
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static List<Product> listProductsByCategory(int categoryId) {
        try {
            return Model.listProductsByCategory(categoryId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static Product getProductById(int id) {
        try {
            return Model.getProductById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean addProduct(Product p) {
        try {
            return Model.addProduct(p) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateProduct(Product p) {
        try {
            return Model.updateProduct(p) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteProduct(int id) {
        try {
            return Model.deleteProduct(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Product images
    public static List<ProductImage> listProductImages(int productId) {
        try {
            return Model.listProductImages(productId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static ProductImage getProductImageById(int id) {
        try {
            return Model.getProductImageById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean addProductImage(ProductImage img) {
        try {
            return Model.addProductImage(img) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateProductImage(ProductImage img) {
        try {
            return Model.updateProductImage(img) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteProductImage(int id) {
        try {
            return Model.deleteProductImage(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Product extra images
    public static List<ProductExtraImage> listProductExtraImages(int productId, String type) {
        try {
            return Model.listProductExtraImages(productId, type);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static ProductExtraImage getProductExtraImageById(int id) {
        try {
            return Model.getProductExtraImageById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean addProductExtraImage(ProductExtraImage img) {
        try {
            return Model.addProductExtraImage(img) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateProductExtraImage(ProductExtraImage img) {
        try {
            return Model.updateProductExtraImage(img) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteProductExtraImage(int id) {
        try {
            return Model.deleteProductExtraImage(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Address
    public static List<Address> getAddresses(int userId) {
        try {
            return Model.getAddresses(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean addAddress(Address a) {
        try {
            return Model.addAddress(a) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateAddress(Address a) {
        try {
            return Model.updateAddress(a) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteAddress(int id) {
        try {
            // If the address is used by any order, do not attempt deletion
            if (Model.addressHasOrders(id)) {
                return false;
            }
            return Model.deleteAddress(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Determine whether an address can be safely deleted.
     * Returns true if any order references this address.
     */
    public static boolean addressHasOrders(int addressId) {
        try {
            return Model.addressHasOrders(addressId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void setDefaultAddress(int userId, int addressId) {
        try {
            Model.setDefaultAddress(userId, addressId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 新增：获取所有地址的方法，供订单查询页面使用
    public static List<Address> getAllAddresses() {
        try {
            return Model.getAllAddresses();
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // Categories
    public static List<Category> listCategories() {
        try {
            return Model.listCategories();
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean addCategory(Category c) {
        try {
            return Model.addCategory(c) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateCategory(Category c) {
        try {
            return Model.updateCategory(c) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteCategory(int id) {
        try {
            return Model.deleteCategory(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cart
    public static List<CartItem> getCartItems(int userId) {
        try {
            return Model.getCartItems(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean addToCart(CartItem item) {
        try {
            return Model.addToCart(item) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateCartItem(int id, int qty) {
        try {
            return Model.updateCartItem(id, qty) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean removeCartItem(int id) {
        try {
            return Model.removeCartItem(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Orders
    public static boolean createOrder(Order o) {
        try {
            return Model.createOrder(o) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static Order getOrderById(int id) {
        try {
            return Model.getOrderById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static List<Order> getOrdersByUser(int userId) {
        try {
            return Model.getOrdersByUser(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static List<Order> listAllOrders() {
        try {
            return Model.listAllOrders();
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean updateOrderStatus(int id, String status) {
        try {
            return Model.updateOrderStatus(id, status) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean markOrderPaid(int id) {
        try {
            boolean ok = Model.markOrderPaid(id) > 0;
            if (ok) {
                Order o = Model.getOrderById(id);
                if (o != null && o.getItems() != null) {
                    for (OrderItem item : o.getItems()) {
                        Model.generateSNCodes(item.getProductId(), item.getQuantity(), id, "sold");
                    }
                }
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean cancelOrder(int id) {
        try {
            return Model.cancelOrder(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Order items
    public static boolean addOrderItems(int orderId, List<OrderItem> items) {
        try {
            return Model.addOrderItems(orderId, items) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<OrderItem> getOrderItems(int orderId) {
        try {
            return Model.getOrderItems(orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    // SN codes
    public static void generateSNCodes(int productId, int size, int batchId) {
        try {
            Model.generateSNCodes(productId, size, batchId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static List<SNCode> listSNCodes(int productId, String status) {
        try {
            return Model.listSNCodes(productId, status);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static SNCode getSNCodeByCode(String code) {
        try {
            return Model.getSNCodeByCode(code);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Integer getProductIdBySN(String code) {
        SNCode sn = getSNCodeByCode(code);
        return sn != null ? sn.getProductId() : null;
    }

    public static List<SNCode> getSNCodesByOrder(int orderId) {
        try {
            // 注意：当前实现假设batch_id等于order_id
            // 在实际应用中，可能需要通过order_items表查找相关的SN码
            return Model.listSNCodesByBatch(orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean updateSNStatus(String code, String status) {
        try {
            return Model.updateSNStatus(code, status) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteSNCodes(int batchId) {
        try {
            return Model.deleteSNCodes(batchId) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Bindings
    public static boolean bindSN(int userId, String code) {
        try {
            return Model.bindSN(userId, code) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Binding> getBindingsByUser(int userId) {
        try {
            return Model.getBindingsByUser(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean adminUnbindSN(String code) {
        try {
            return Model.adminUnbindSN(code) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // After sale
    public static boolean applyAfterSale(AfterSale a) {
        // Ensure a default status to avoid null being persisted
        if (a.getStatus() == null || a.getStatus().trim().isEmpty()) {
            a.setStatus("待处理");
        }
        try {
            return Model.applyAfterSale(a) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<AfterSale> getAfterSalesByUser(int userId) {
        try {
            return Model.getAfterSalesByUser(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static List<AfterSale> listAllAfterSales() {
        try {
            return Model.listAllAfterSales();
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean updateAfterSaleStatus(int id, String status, String remark) {
        try {
            return Model.updateAfterSaleStatus(id, status, remark) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean closeAfterSale(int id) {
        try {
            return Model.closeAfterSale(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Notifications
    public static boolean sendNotification(Notification n) {
        try {
            return Model.sendNotification(n) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static List<Notification> getNotifications(int userId) {
        try {
            return Model.getNotifications(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public static boolean markNotificationRead(int id) {
        try {
            return Model.markNotificationRead(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean deleteNotification(int id) {
        try {
            return Model.deleteNotification(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========== 测试方法 ==========
    
    /**
     * 测试单个用户删除功能
     * @param userId 要删除的用户ID
     * @return 测试结果信息
     */
    public static String testDeleteUser(int userId) {
        StringBuilder result = new StringBuilder();
        result.append("=== 测试删除用户功能 ===").append("\n");
        result.append("用户ID: ").append(userId).append("\n");
        
        try {
            // 1. 检查用户是否存在
            User user = getUserById(userId);
            if (user == null) {
                result.append("错误: 用户不存在\n");
                return result.toString();
            }
            
            result.append("用户信息: ").append(user.getUsername()).append(" (").append(user.getEmail()).append(")\n");
            
            // 2. 执行删除操作
            result.append("正在执行删除操作...\n");
            boolean deleteResult = deleteUser(userId);
            
            if (deleteResult) {
                result.append("删除成功!\n");
                
                // 3. 验证删除结果
                User deletedUser = getUserById(userId);
                if (deletedUser == null) {
                    result.append("验证通过: 用户已被成功删除\n");
                } else {
                    result.append("警告: 删除操作返回成功，但用户仍然存在\n");
                }
            } else {
                result.append("删除失败!\n");
            }
            
        } catch (Exception e) {
            result.append("异常: ").append(e.getMessage()).append("\n");
            e.printStackTrace();
        }
        
        return result.toString();
    }
    
    /**
     * 测试批量用户删除功能
     * @param userIds 要删除的用户ID数组
     * @return 测试结果信息
     */
    public static String testBatchDeleteUsers(int[] userIds) {
        StringBuilder result = new StringBuilder();
        result.append("=== 测试批量删除用户功能 ===").append("\n");
        result.append("用户ID数组: ");
        for (int i = 0; i < userIds.length; i++) {
            result.append(userIds[i]);
            if (i < userIds.length - 1) result.append(", ");
        }
        result.append("\n");
        
        try {
            // 1. 检查所有用户是否存在
            result.append("检查用户存在性:\n");
            for (int userId : userIds) {
                User user = getUserById(userId);
                if (user != null) {
                    result.append("  用户 ").append(userId).append(": ").append(user.getUsername()).append(" 存在\n");
                } else {
                    result.append("  用户 ").append(userId).append(": 不存在\n");
                }
            }
            
            // 2. 执行批量删除操作
            result.append("正在执行批量删除操作...\n");
            boolean deleteResult = batchDeleteUsers(userIds);
            
            if (deleteResult) {
                result.append("批量删除成功!\n");
                
                // 3. 验证删除结果
                result.append("验证删除结果:\n");
                int deletedCount = 0;
                for (int userId : userIds) {
                    User deletedUser = getUserById(userId);
                    if (deletedUser == null) {
                        result.append("  用户 ").append(userId).append(": 已删除\n");
                        deletedCount++;
                    } else {
                        result.append("  用户 ").append(userId).append(": 仍然存在\n");
                    }
                }
                result.append("成功删除 ").append(deletedCount).append("/").append(userIds.length).append(" 个用户\n");
            } else {
                result.append("批量删除失败!\n");
            }
            
        } catch (Exception e) {
            result.append("异常: ").append(e.getMessage()).append("\n");
            e.printStackTrace();
        }
        
        return result.toString();
    }
    
    /**
     * 测试用户管理相关功能的完整性
     * @return 测试结果信息
     */
    public static String testUserManagementIntegrity() {
        StringBuilder result = new StringBuilder();
        result.append("=== 用户管理功能完整性测试 ===").append("\n");
        
        try {
            // 1. 测试获取所有用户
            result.append("1. 测试获取所有用户:\n");
            List<User> allUsers = getAllUsers();
            result.append("   当前用户总数: ").append(allUsers.size()).append("\n");
            
            // 2. 测试搜索功能
            result.append("2. 测试搜索功能:\n");
            List<User> searchResults = searchUsers("admin");
            result.append("   搜索'admin'结果数: ").append(searchResults.size()).append("\n");
            
            // 3. 测试获取单个用户
            result.append("3. 测试获取单个用户:\n");
            if (!allUsers.isEmpty()) {
                User firstUser = allUsers.get(0);
                User retrievedUser = getUserById(firstUser.getId());
                if (retrievedUser != null) {
                    result.append("   成功获取用户: ").append(retrievedUser.getUsername()).append("\n");
                } else {
                    result.append("   获取用户失败\n");
                }
            } else {
                result.append("   没有用户可供测试\n");
            }
            
            result.append("用户管理功能基本正常\n");
            
        } catch (Exception e) {
            result.append("测试过程中发生异常: ").append(e.getMessage()).append("\n");
            e.printStackTrace();
        }
        
        return result.toString();
    }
}
