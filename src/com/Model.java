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
    public static int addProduct(String name, double price, int stock, String desc) {
        return ProductDAO.addProduct(name, price, stock, desc);
    }

    /** 更新商品 */
    public static int updateProduct(int id, String name, double price, int stock, String desc) {
        return ProductDAO.updateProduct(id, name, price, stock, desc);
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

    /** 更新订单状态 */
    public static int updateOrderStatus(int orderId, String status) {
        return OrderDAO.updateOrderStatus(orderId, status);
    }

    /** 绑定用户商品 */
    public static int addUserProduct(int userId, int productId, String sn) {
        return UserProductDAO.addUserProduct(userId, productId, sn);
    }

    /** 查询用户绑定的商品 */
    public static List<UserProduct> getUserProducts(int userId) {
        return UserProductDAO.getUserProducts(userId);
    }

    /** 用户申请售后 */
    public static int applyAfterSale(int userProductId) {
        return UserProductDAO.applyAfterSale(userProductId);
    }

    /** 更新售后状态（管理员） */
    public static int updateAfterSaleStatus(int userProductId, String status) {
        return UserProductDAO.updateAfterSaleStatus(userProductId, status);
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
}
