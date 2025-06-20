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

    // 商品相关
    public static List<Product> listProducts() {
        try {
            return Model.listProducts();
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
            return Model.deleteAddress(id) > 0;
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
            return Model.markOrderPaid(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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
}
