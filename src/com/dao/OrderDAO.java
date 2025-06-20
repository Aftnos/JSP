package com.dao;

import com.db.DBUtil;
import com.entity.CartItem;
import com.entity.Order;
import com.entity.OrderItem;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单相关数据库操作。
 */
public class OrderDAO {

    /**
     * 创建订单并写入订单项。
     *
     * @param userId 用户ID
     * @param items 购物车商品列表
     * @return 1 表示成功，0 表示失败
     */
    public static int createOrder(int userId, List<CartItem> items) {
        String orderSql = "INSERT INTO orders(order_no, user_id, order_date, status, total, pay_status) VALUES(?, ?, ?, '待支付', ?, '未支付')";
        String itemSql = "INSERT INTO order_items(order_id, product_id, quantity, price) VALUES(?, ?, ?, ?)";
        double total = 0;
        for (CartItem item : items) {
            total += item.price * item.quantity;
        }
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, generateOrderNo());
                ps.setInt(2, userId);
                ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                ps.setDouble(4, total);
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

    /**
     * 根据用户ID查询订单。
     *
     * @param userId 用户ID
     * @return 订单列表
     */
    public static List<Order> getOrdersByUser(int userId) {
        String sql = "SELECT * FROM orders WHERE user_id=? ORDER BY order_date DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.id = rs.getInt("id");
                    o.orderNo = rs.getString("order_no");
                    o.userId = rs.getInt("user_id");
                    o.orderDate = rs.getTimestamp("order_date");
                    o.status = rs.getString("status");
                    o.payStatus = rs.getString("pay_status");
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

    /**
     * 查询所有订单。
     *
     * @return 订单列表
     */
    public static List<Order> getAllOrders() {
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.id = rs.getInt("id");
                o.orderNo = rs.getString("order_no");
                o.userId = rs.getInt("user_id");
                o.orderDate = rs.getTimestamp("order_date");
                o.status = rs.getString("status");
                o.payStatus = rs.getString("pay_status");
                o.total = rs.getDouble("total");
                o.items = getOrderItems(o.id);
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 更新订单状态。
     *
     * @param orderId 订单ID
     * @param status 新状态
     * @return 影响的行数
     */
    public static int updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 根据ID获取订单 */
    public static Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.id = rs.getInt("id");
                    o.orderNo = rs.getString("order_no");
                    o.userId = rs.getInt("user_id");
                    o.orderDate = rs.getTimestamp("order_date");
                    o.status = rs.getString("status");
                    o.payStatus = rs.getString("pay_status");
                    o.total = rs.getDouble("total");
                    o.items = getOrderItems(o.id);
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 根据订单号获取订单 */
    public static Order getOrderByNo(String orderNo) {
        String sql = "SELECT * FROM orders WHERE order_no=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderNo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.id = rs.getInt("id");
                    o.orderNo = rs.getString("order_no");
                    o.userId = rs.getInt("user_id");
                    o.orderDate = rs.getTimestamp("order_date");
                    o.status = rs.getString("status");
                    o.payStatus = rs.getString("pay_status");
                    o.total = rs.getDouble("total");
                    o.items = getOrderItems(o.id);
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 删除订单及其订单项 */
    public static int deleteOrder(int orderId) {
        String delItems = "DELETE FROM order_items WHERE order_id=?";
        String delOrder = "DELETE FROM orders WHERE id=?";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement(delItems)) {
                ps1.setInt(1, orderId);
                ps1.executeUpdate();
            }
            int r;
            try (PreparedStatement ps2 = conn.prepareStatement(delOrder)) {
                ps2.setInt(1, orderId);
                r = ps2.executeUpdate();
            }
            conn.commit();
            return r;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 查询指定订单的所有订单项。
     *
     * @param orderId 订单ID
     * @return 订单项列表
     */
    private static List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id=?";
        try (Connection conn = DBUtil.getConnection();
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

    /** 生成8位16进制订单号 */
    private static String generateOrderNo() {
        String hex = Integer.toHexString((int) (System.currentTimeMillis() & 0xFFFFFFF));
        return String.format("%8s", hex).replace(' ', '0').toUpperCase();
    }

    /** 支付订单 */
    public static int payOrder(int orderId) {
        String sql = "UPDATE orders SET pay_status='已支付', status='待发货' WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
