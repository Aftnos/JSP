package com.dao;

import com.db.DBUtil;
import com.entity.Address;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {
    public List<Address> listByUser(int userId) throws SQLException {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public int insert(Address a) throws SQLException {
        String sql = "INSERT INTO addresses(user_id,receiver,phone,detail,is_default) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getUserId());
            ps.setString(2, a.getReceiver());
            ps.setString(3, a.getPhone());
            ps.setString(4, a.getDetail());
            ps.setBoolean(5, a.isDefault());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) a.setId(rs.getInt(1));
                }
            }
            return affected;
        }
    }

    public int update(Address a) throws SQLException {
        String sql = "UPDATE addresses SET receiver=?, phone=?, detail=?, is_default=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, a.getReceiver());
            ps.setString(2, a.getPhone());
            ps.setString(3, a.getDetail());
            ps.setBoolean(4, a.isDefault());
            ps.setInt(5, a.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        String sql = "DELETE FROM addresses WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    public void setDefault(int userId, int addressId) throws SQLException {
        String unset = "UPDATE addresses SET is_default=0 WHERE user_id=?";
        String set = "UPDATE addresses SET is_default=1 WHERE id=?";
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(unset)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(set)) {
                ps.setInt(1, addressId);
                ps.executeUpdate();
            }
        }
    }

    private Address map(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setReceiver(rs.getString("receiver"));
        a.setPhone(rs.getString("phone"));
        a.setDetail(rs.getString("detail"));
        a.setDefault(rs.getBoolean("is_default"));
        return a;
    }
}
