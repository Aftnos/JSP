package com.dao;

import com.db.DBUtil;
import com.entity.Order;
import com.entity.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    public int insert(Order o) throws SQLException {
        String sql = "INSERT INTO orders(user_id,address_id,status,total,paid) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, o.getUserId());
            ps.setInt(2, o.getAddressId());
            ps.setString(3, o.getStatus());
            ps.setBigDecimal(4, o.getTotal());
            ps.setBoolean(5, o.isPaid());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) o.setId(rs.getInt(1)); }
            }
            if (o.getItems() != null) {
                String itemSql = "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)";
                try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                    for (OrderItem item : o.getItems()) {
                        psItem.setInt(1, o.getId());
                        psItem.setInt(2, item.getProductId());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setBigDecimal(4, item.getPrice());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }
            }
            return affected;
        }
    }

    public Order findById(int id) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public List<Order> listByUser(int userId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<Order> listAll() throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public int updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE orders SET status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate();
        }
    }

    public int markPaid(int id) throws SQLException {
        String sql = "UPDATE orders SET paid=1 WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    private Order map(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setAddressId(rs.getInt("address_id"));
        o.setStatus(rs.getString("status"));
        o.setTotal(rs.getBigDecimal("total"));
        o.setPaid(rs.getBoolean("paid"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}
