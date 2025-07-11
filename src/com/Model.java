package com;

import com.dao.*;
import com.entity.*;

import java.sql.SQLException;
import java.util.List;

/**
 * 数据库操作模型类，作为各个 DAO 的统一入口。
 */
public class Model {
    private static final UserDAO userDAO = new UserDAO();
    private static final ProductDAO productDAO = new ProductDAO();
    private static final ProductImageDAO productImageDAO = new ProductImageDAO();
    private static final ProductExtraImageDAO productExtraImageDAO = new ProductExtraImageDAO();
    private static final AddressDAO addressDAO = new AddressDAO();
    private static final CategoryDAO categoryDAO = new CategoryDAO();
    private static final CartDAO cartDAO = new CartDAO();
    private static final OrderDAO orderDAO = new OrderDAO();
    private static final OrderItemDAO orderItemDAO = new OrderItemDAO();
    private static final SNCodeDAO snCodeDAO = new SNCodeDAO();
    private static final BindingDAO bindingDAO = new BindingDAO();
    private static final AfterSaleDAO afterSaleDAO = new AfterSaleDAO();
    private static final NotificationDAO notificationDAO = new NotificationDAO();

    // User operations
    public static User login(String username, String password) throws SQLException {
        return userDAO.checkLogin(username, password);
    }

    public static int register(User user) throws SQLException {
        return userDAO.insert(user);
    }

    public static User getUserById(int id) throws SQLException {
        return userDAO.findById(id);
    }

    public static List<User> listAllUsers() throws SQLException {
        return userDAO.findAll();
    }

    public static List<User> searchUsers(String keyword) throws SQLException {
        return userDAO.searchUsers(keyword);
    }

    public static int updateUser(User user) throws SQLException {
        return userDAO.update(user);
    }

    public static int deleteUser(int id) throws SQLException {
        return userDAO.deleteById(id);
    }

    public static int batchDeleteUsers(int[] ids) throws SQLException {
        return userDAO.batchDelete(ids);
    }

    // Product operations
    public static List<Product> listProducts() throws SQLException {
        return productDAO.listAll();
    }

    public static List<Product> listProductsByCategory(int categoryId) throws SQLException {
        return productDAO.listByCategory(categoryId);
    }

    public static Product getProductById(int id) throws SQLException {
        return productDAO.findById(id);
    }

    public static int addProduct(Product p) throws SQLException {
        return productDAO.insert(p);
    }

    public static int updateProduct(Product p) throws SQLException {
        return productDAO.update(p);
    }

    public static int deleteProduct(int id) throws SQLException {
        return productDAO.delete(id);
    }

    // Product image operations
    public static List<ProductImage> listProductImages(int productId) throws SQLException {
        return productImageDAO.listByProduct(productId);
    }

    public static ProductImage getProductImageById(int id) throws SQLException {
        return productImageDAO.findById(id);
    }

    public static int addProductImage(ProductImage img) throws SQLException {
        return productImageDAO.insert(img);
    }

    public static int updateProductImage(ProductImage img) throws SQLException {
        return productImageDAO.update(img);
    }

    public static int deleteProductImage(int id) throws SQLException {
        return productImageDAO.delete(id);
    }

    // Product extra image operations
    public static List<ProductExtraImage> listProductExtraImages(int productId, String type) throws SQLException {
        return productExtraImageDAO.listByProductAndType(productId, type);
    }

    public static ProductExtraImage getProductExtraImageById(int id) throws SQLException {
        return productExtraImageDAO.findById(id);
    }

    public static int addProductExtraImage(ProductExtraImage img) throws SQLException {
        return productExtraImageDAO.insert(img);
    }

    public static int updateProductExtraImage(ProductExtraImage img) throws SQLException {
        return productExtraImageDAO.update(img);
    }

    public static int deleteProductExtraImage(int id) throws SQLException {
        return productExtraImageDAO.delete(id);
    }

    // Address operations
    public static List<Address> getAddresses(int userId) throws SQLException {
        return addressDAO.listByUser(userId);
    }

    public static int addAddress(Address a) throws SQLException {
        return addressDAO.insert(a);
    }

    public static int updateAddress(Address a) throws SQLException {
        return addressDAO.update(a);
    }

    public static int deleteAddress(int id) throws SQLException {
        return addressDAO.delete(id);
    }

    public static void setDefaultAddress(int userId, int addressId) throws SQLException {
        addressDAO.setDefault(userId, addressId);
    }

    // 新增：获取所有地址的方法
    public static List<Address> getAllAddresses() throws SQLException {
        return addressDAO.listAll();
    }

    // Check if an address is referenced by any order
    public static boolean addressHasOrders(int addressId) throws SQLException {
        return orderDAO.existsByAddressId(addressId);
    }

    // Category operations
    public static List<Category> listCategories() throws SQLException {
        return categoryDAO.listAll();
    }

    public static int addCategory(Category c) throws SQLException {
        return categoryDAO.insert(c);
    }

    public static int updateCategory(Category c) throws SQLException {
        return categoryDAO.update(c);
    }

    public static int deleteCategory(int id) throws SQLException {
        return categoryDAO.delete(id);
    }

    // Cart operations
    public static List<CartItem> getCartItems(int userId) throws SQLException {
        return cartDAO.listByUser(userId);
    }

    public static int addToCart(CartItem item) throws SQLException {
        return cartDAO.insert(item);
    }

    public static int updateCartItem(int id, int qty) throws SQLException {
        return cartDAO.updateQuantity(id, qty);
    }

    public static int removeCartItem(int id) throws SQLException {
        return cartDAO.delete(id);
    }

    // Order operations
    public static int createOrder(Order o) throws SQLException {
        return orderDAO.insert(o);
    }

    public static Order getOrderById(int id) throws SQLException {
        return orderDAO.findById(id);
    }

    public static List<Order> getOrdersByUser(int userId) throws SQLException {
        return orderDAO.listByUser(userId);
    }

    public static List<Order> listAllOrders() throws SQLException {
        return orderDAO.listAll();
    }

    public static int updateOrderStatus(int id, String status) throws SQLException {
        return orderDAO.updateStatus(id, status);
    }

    public static int markOrderPaid(int id) throws SQLException {
        return orderDAO.markPaid(id);
    }

    public static int cancelOrder(int id) throws SQLException {
        return orderDAO.updateStatus(id, "CANCELLED");
    }

    public static int addOrderItems(int orderId, List<OrderItem> items) throws SQLException {
        return orderItemDAO.insertBatch(orderId, items);
    }

    public static List<OrderItem> getOrderItems(int orderId) throws SQLException {
        return orderItemDAO.listByOrder(orderId);
    }

    // SN code operations
    public static void generateSNCodes(int productId, int size, int batchId) throws SQLException {
        snCodeDAO.generate(productId, size, batchId);
    }

    public static void generateSNCodes(int productId, int size, int batchId, String status) throws SQLException {
        snCodeDAO.generate(productId, size, batchId, status);
    }

    public static List<SNCode> listSNCodes(int productId, String status) throws SQLException {
        return snCodeDAO.list(productId, status);
    }

    public static SNCode getSNCodeByCode(String code) throws SQLException {
        return snCodeDAO.findByCode(code);
    }

    public static List<SNCode> listSNCodesByBatch(int batchId) throws SQLException {
        return snCodeDAO.listByBatch(batchId);
    }

    public static int updateSNStatus(String code, String status) throws SQLException {
        return snCodeDAO.updateStatus(code, status);
    }

    public static int deleteSNCodes(int batchId) throws SQLException {
        return snCodeDAO.deleteByBatch(batchId);
    }

    // Bindings
    public static int bindSN(int userId, String code) throws SQLException {
        return bindingDAO.bind(userId, code);
    }

    public static List<Binding> getBindingsByUser(int userId) throws SQLException {
        return bindingDAO.listByUser(userId);
    }

    public static int adminUnbindSN(String code) throws SQLException {
        return bindingDAO.unbind(code);
    }

    /**
     * Remove all bindings for a specific user. Used prior to deleting a user.
     */
    public static int deleteBindingsByUser(int userId) throws SQLException {
        return bindingDAO.deleteByUserId(userId);
    }

    // Additional helpers for deleting data related to a user
    public static int deleteCartItemsByUser(int userId) throws SQLException {
        return cartDAO.deleteByUserId(userId);
    }

    public static int deleteAfterSalesByUser(int userId) throws SQLException {
        return afterSaleDAO.deleteByUserId(userId);
    }

    public static int deleteNotificationsByUser(int userId) throws SQLException {
        return notificationDAO.deleteByUserId(userId);
    }

    public static int deleteOrdersByUser(int userId) throws SQLException {
        return orderDAO.deleteByUser(userId);
    }

    public static int deleteAddressesByUser(int userId) throws SQLException {
        return addressDAO.deleteByUserId(userId);
    }

    // After sale
    public static int applyAfterSale(AfterSale a) throws SQLException {
        return afterSaleDAO.insert(a);
    }

    public static List<AfterSale> getAfterSalesByUser(int userId) throws SQLException {
        return afterSaleDAO.listByUser(userId);
    }

    public static List<AfterSale> listAllAfterSales() throws SQLException {
        return afterSaleDAO.listAll();
    }

    public static int updateAfterSaleStatus(int id, String status, String remark) throws SQLException {
        return afterSaleDAO.updateStatus(id, status, remark);
    }

    public static int closeAfterSale(int id) throws SQLException {
        return afterSaleDAO.delete(id);
    }

    // Notifications
    public static int sendNotification(Notification n) throws SQLException {
        return notificationDAO.send(n);
    }

    public static List<Notification> getNotifications(int userId) throws SQLException {
        return notificationDAO.listByUser(userId);
    }

    public static int markNotificationRead(int id) throws SQLException {
        return notificationDAO.markRead(id);
    }

    public static int deleteNotification(int id) throws SQLException {
        return notificationDAO.delete(id);
    }
}
