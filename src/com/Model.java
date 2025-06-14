package com;
import java.io.InputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * 数据库操作模型类，集中管理所有CRUD操作
 */
public class Model {
    private static String URL;
    private static String USER;
    private static String PASSWORD;

    // 读取配置并加载数据库驱动
    static {
        try {
            Properties props = new Properties();
            try (InputStream in = Model.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (in != null) {
                    props.load(in);
                }
            }
            URL = props.getProperty("url");
            USER = props.getProperty("user");
            PASSWORD = props.getProperty("password");
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** 获取数据库连接 */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /** 验证普通用户登录 */
    public static boolean validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username=? AND password=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 添加普通用户 */
    public static int addUser(String username, String password) {
        String sql = "INSERT INTO users(username, password) VALUES(?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 验证管理员登录 */
    public static boolean validateAdmin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username=? AND password=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /** 获取所有商品 */
    public static List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.id = rs.getInt("id");
                p.name = rs.getString("name");
                p.price = rs.getDouble("price");
                p.stock = rs.getInt("stock");
                p.description = rs.getString("description");
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 根据ID获取商品 */
    public static Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.id = rs.getInt("id");
                    p.name = rs.getString("name");
                    p.price = rs.getDouble("price");
                    p.stock = rs.getInt("stock");
                    p.description = rs.getString("description");
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 新增商品 */
    public static int addProduct(String name, double price, int stock, String desc) {
        String sql = "INSERT INTO products(name, price, stock, description) VALUES(?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, stock);
            ps.setString(4, desc);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 更新商品 */
    public static int updateProduct(int id, String name, double price, int stock, String desc) {
        String sql = "UPDATE products SET name=?, price=?, stock=?, description=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, stock);
            ps.setString(4, desc);
            ps.setInt(5, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 删除商品 */
    public static int deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 创建订单，并写入订单项 */
    public static int createOrder(int userId, List<CartItem> items) {
        String orderSql = "INSERT INTO orders(user_id, order_date, status, total) VALUES(?, ?, '未发货', ?)";
        String itemSql = "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES(?, ?, ?, ?)";
        double total = 0;
        for (CartItem item : items) {
            total += item.price * item.quantity;
        }
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setDouble(3, total);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        return 0;
                    }
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (CartItem item : items) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.productId);
                    ps.setInt(3, item.quantity);
                    ps.setDouble(4, item.price);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            conn.commit();
            return 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 根据用户ID查询订单 */
    public static List<Order> getOrdersByUser(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id=? ORDER BY order_date DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.id = rs.getInt("id");
                    o.userId = rs.getInt("user_id");
                    o.orderDate = rs.getTimestamp("order_date");
                    o.status = rs.getString("status");
                    o.total = rs.getDouble("total");
                    o.items = getOrderItems(o.id);
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 查询所有订单 */
    public static List<Order> getAllOrders() {
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.id = rs.getInt("id");
                o.userId = rs.getInt("user_id");
                o.orderDate = rs.getTimestamp("order_date");
                o.status = rs.getString("status");
                o.total = rs.getDouble("total");
                o.items = getOrderItems(o.id);
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 更新订单状态 */
    public static int updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 绑定用户商品 */
    public static int addUserProduct(int userId, int productId, String sn) {
        String sql = "INSERT INTO user_products(user_id, product_id, sn) VALUES(?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setString(3, sn);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 查询用户绑定的商品 */
    public static List<UserProduct> getUserProducts(int userId) {
        List<UserProduct> list = new ArrayList<>();
        String sql = "SELECT up.id, up.user_id, up.product_id, up.sn, up.after_sale_status, p.name " +
                     "FROM user_products up JOIN products p ON up.product_id=p.id WHERE up.user_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserProduct up = new UserProduct();
                    up.id = rs.getInt("id");
                    up.userId = rs.getInt("user_id");
                    up.productId = rs.getInt("product_id");
                    up.sn = rs.getString("sn");
                    up.afterSaleStatus = rs.getString("after_sale_status");
                    up.productName = rs.getString("name");
                    list.add(up);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 用户申请售后 */
    public static int applyAfterSale(int userProductId) {
        return updateAfterSaleStatus(userProductId, "申请中");
    }

    /** 更新售后状态（管理员） */
    public static int updateAfterSaleStatus(int userProductId, String status) {
        String sql = "UPDATE user_products SET after_sale_status=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userProductId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ------- 内部辅助方法 --------

    private static List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.id = rs.getInt("id");
                    item.orderId = rs.getInt("order_id");
                    item.productId = rs.getInt("product_id");
                    item.quantity = rs.getInt("quantity");
                    item.price = rs.getDouble("price");
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ----------- 数据实体类 -----------

    public static class Product {
        public int id;
        public String name;
        public double price;
        public int stock;
        public String description;
    }

    public static class CartItem {
        public int productId;
        public int quantity;
        public double price;
    }

    public static class OrderItem {
        public int id;
        public int orderId;
        public int productId;
        public int quantity;
        public double price;
    }

    public static class Order {
        public int id;
        public int userId;
        public Timestamp orderDate;
        public String status;
        public double total;
        public List<OrderItem> items;
    }

    public static class UserProduct {
        public int id;
        public int userId;
        public int productId;
        public String sn;
        public String afterSaleStatus;
        public String productName;
    }
}
