package com.dao;

import com.db.DBUtil;
import com.entity.CartItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    public List<CartItem> listByUser(int userId) throws SQLException {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public int insert(CartItem item) throws SQLException {
        String sql = "INSERT INTO cart_items(user_id,product_id,quantity) VALUES(?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getUserId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) item.setId(rs.getInt(1)); }
            }
            return affected;
        }
    }

    public int updateQuantity(int id, int qty) throws SQLException {
        String sql = "UPDATE cart_items SET quantity=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, id);
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    /**
     * Delete all cart items for the specified user.
     */
    public int deleteByUserId(int userId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        }
    }

    private CartItem map(ResultSet rs) throws SQLException {
        CartItem c = new CartItem();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setProductId(rs.getInt("product_id"));
        c.setQuantity(rs.getInt("quantity"));
        return c;
    }
}
