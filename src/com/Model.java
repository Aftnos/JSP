package com;

import com.dao.*;
import com.db.DBUtil;
import com.entity.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

/**
 * 数据库操作模型类，作为各个 DAO 的统一入口。
 * 所有方法仅做简单转发，方便新手理解分层结构。
 */
public class Model {

    /** 获取数据库连接 */
    public static Connection getConnection() throws SQLException {
        return DBUtil.getConnection();
    }

    /** 验证普通用户登录 */
    public static boolean validateUser(String username, String password) {
        return UserDAO.validateUser(username, password);
    }

    /** 添加普通用户 */
    public static int addUser(String username, String password) {
        return UserDAO.addUser(username, password);
    }

    /** 更新用户密码 */
    public static int updateUserPassword(int userId, String newPassword) {
        return UserDAO.updatePassword(userId, newPassword);
    }

    /** 更新用户资料 */
    public static int updateUserProfile(int userId, String displayName, String avatar) {
        return UserDAO.updateProfile(userId, displayName, avatar);
    }

    /** 根据ID获取用户信息 */
    public static com.entity.User getUserById(int userId) {
        return UserDAO.getUserById(userId);
    }

    /** 获取所有用户 */
    public static List<com.entity.User> getAllUsers() {
        return UserDAO.getAllUsers();
    }

    /** 删除用户 */
    public static int deleteUser(int userId) {
        return UserDAO.deleteUser(userId);
    }

    /** 验证管理员登录 */
    public static boolean validateAdmin(String username, String password) {
        return AdminDAO.validateAdmin(username, password);
    }

    /** 更新管理员密码 */
    public static int updateAdminPassword(int adminId, String newPassword) {
        return AdminDAO.updatePassword(adminId, newPassword);
    }

    /** 获取所有商品 */
    public static List<Product> getAllProducts() {
        return ProductDAO.getAllProducts();
    }

    /** 根据ID获取商品 */
    public static Product getProductById(int id) {
        return ProductDAO.getProductById(id);
    }

    /** 新增商品 */
    public static int addProduct(String name, double price, int stock, String desc, int categoryId) {
        return ProductDAO.addProduct(name, price, stock, desc, categoryId);
    }

    /** 更新商品 */
    public static int updateProduct(int id, String name, double price, int stock, String desc, int categoryId) {
        return ProductDAO.updateProduct(id, name, price, stock, desc, categoryId);
    }

    /** 删除商品 */
    public static int deleteProduct(int id) {
        return ProductDAO.deleteProduct(id);
    }

    /** 创建订单，并写入订单项 */
    public static int createOrder(int userId, List<CartItem> items) {
        return OrderDAO.createOrder(userId, items);
    }

    /** 根据用户ID查询订单 */
    public static List<Order> getOrdersByUser(int userId) {
        return OrderDAO.getOrdersByUser(userId);
    }

    /** 查询所有订单 */
    public static List<Order> getAllOrders() {
        return OrderDAO.getAllOrders();
    }

    /** 根据ID获取订单 */
    public static Order getOrderById(int orderId) {
        return OrderDAO.getOrderById(orderId);
    }

    /** 根据订单号获取订单 */
    public static Order getOrderByNo(String orderNo) {
        return OrderDAO.getOrderByNo(orderNo);
    }

    /** 删除订单 */
    public static int deleteOrder(int orderId) {
        return OrderDAO.deleteOrder(orderId);
    }

    /** 更新订单状态 */
    public static int updateOrderStatus(int orderId, String status) {
        return OrderDAO.updateOrderStatus(orderId, status);
    }

    /** 支付订单 */
    public static int payOrder(int orderId) {
        return OrderDAO.payOrder(orderId);
    }

    /** 绑定用户商品 */
    public static int addUserProduct(int userId, int productId, String orderNo) {
        return UserProductDAO.addUserProduct(userId, productId, orderNo);
    }

    /**
     * 检查指定订单号与商品ID是否已有绑定记录。
     *
     * @param orderNo   订单号
     * @param productId 商品ID
     * @return true 已存在绑定，false 不存在
     */
    public static boolean userProductExists(String orderNo, int productId) {
        return UserProductDAO.existsByOrderAndProduct(orderNo, productId);
    }

    /** 查询用户绑定的商品 */
    public static List<UserProduct> getUserProducts(int userId) {
        return UserProductDAO.getUserProducts(userId);
    }

    /** 获取所有用户绑定商品（管理员） */
    public static List<UserProduct> getAllUserProducts() {
        return UserProductDAO.getAllUserProducts();
    }

    /** 用户申请售后 */
    public static int applyAfterSale(int userProductId) {
        return UserProductDAO.applyAfterSale(userProductId);
    }

    /** 更新售后状态（管理员） */
    public static int updateAfterSaleStatus(int userProductId, String status) {
        return UserProductDAO.updateAfterSaleStatus(userProductId, status);
    }

    /** 根据ID获取用户绑定商品 */
    public static UserProduct getUserProductById(int id) {
        return UserProductDAO.getUserProductById(id);
    }

    /** 删除用户绑定商品 */
    public static int deleteUserProduct(int id) {
        return UserProductDAO.deleteUserProduct(id);
    }

    /** 获取所有分类 */
    public static List<Category> getAllCategories() {
        return CategoryDAO.getAllCategories();
    }

    /** 新增分类 */
    public static int addCategory(String name) {
        return CategoryDAO.addCategory(name);
    }

    /** 更新分类 */
    public static int updateCategory(int id, String name) {
        return CategoryDAO.updateCategory(id, name);
    }

    /** 删除分类 */
    public static int deleteCategory(int id) {
        return CategoryDAO.deleteCategory(id);
    }

    /** 根据ID获取分类 */
    public static Category getCategoryById(int id) {
        return CategoryDAO.getCategoryById(id);
    }

    /** 获取所有广告 */
    public static List<Advertisement> getAllAdvertisements() {
        return AdvertisementDAO.getAllAdvertisements();
    }

    /** 新增广告 */
    public static int addAdvertisement(String title, String imagePath, String targetUrl, boolean enabled) {
        return AdvertisementDAO.addAdvertisement(title, imagePath, targetUrl, enabled);
    }

    /** 更新广告 */
    public static int updateAdvertisement(int id, String title, String imagePath, String targetUrl, boolean enabled) {
        return AdvertisementDAO.updateAdvertisement(id, title, imagePath, targetUrl, enabled);
    }

    /** 删除广告 */
    public static int deleteAdvertisement(int id) {
        return AdvertisementDAO.deleteAdvertisement(id);
    }

    /** 根据ID获取广告 */
    public static Advertisement getAdvertisementById(int id) {
        return AdvertisementDAO.getAdvertisementById(id);
    }
}
