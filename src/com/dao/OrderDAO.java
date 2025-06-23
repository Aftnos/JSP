package com.dao;

import com.db.DBUtil;
import com.entity.Order;
import com.entity.OrderItem;

/** DAO for orders. Uses OrderItemDAO for item operations. */

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private final OrderItemDAO itemDAO = new OrderItemDAO();
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
                itemDAO.insertBatch(o.getId(), o.getItems());
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
                if (rs.next()) {
                    Order o = map(rs);
                    o.setItems(itemDAO.listByOrder(o.getId()));
                    return o;
                }
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
                while (rs.next()) {
                    Order o = map(rs);
                    o.setItems(itemDAO.listByOrder(o.getId()));
                    list.add(o);
                }
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
            while (rs.next()) {
                Order o = map(rs);
                o.setItems(itemDAO.listByOrder(o.getId()));
                list.add(o);
            }
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

    /**
     * Check whether there are any orders using the specified address.
     * This is used before deleting an address to prevent foreign key violations.
     */
    public boolean existsByAddressId(int addressId) throws SQLException {
        String sql = "SELECT 1 FROM orders WHERE address_id=? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Delete an order along with its items.
     */
    public int delete(int id) throws SQLException {
        // Remove order items first to satisfy foreign key constraints
        itemDAO.deleteByOrder(id);
        String sql = "DELETE FROM orders WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    /**
     * Delete all orders (and their items) for a specific user.
     */
    public int deleteByUser(int userId) throws SQLException {
        List<Order> list = listByUser(userId);
        int total = 0;
        for (Order o : list) {
            total += delete(o.getId());
        }
        return total;
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
