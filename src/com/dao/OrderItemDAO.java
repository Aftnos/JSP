package com.dao;

import com.db.DBUtil;
import com.entity.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO {
    public int insertBatch(int orderId, List<OrderItem> items) throws SQLException {
        if(items==null || items.isEmpty()) return 0;
        String sql = "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)";
        try(Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            for(OrderItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.addBatch();
            }
            int[] res = ps.executeBatch();
            return res.length;
        }
    }

    public List<OrderItem> listByOrder(int orderId) throws SQLException {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id=?";
        try(Connection conn = DBUtil.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try(ResultSet rs = ps.executeQuery()) {
                while(rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /**
     * Delete order items for a specific order.
     */
    public int deleteByOrder(int orderId) throws SQLException {
        String sql = "DELETE FROM order_items WHERE order_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate();
        }
    }

    private OrderItem map(ResultSet rs) throws SQLException {
        OrderItem oi = new OrderItem();
        oi.setId(rs.getInt("id"));
        oi.setOrderId(rs.getInt("order_id"));
        oi.setProductId(rs.getInt("product_id"));
        oi.setQuantity(rs.getInt("quantity"));
        oi.setPrice(rs.getBigDecimal("price"));
        return oi;
    }
}

