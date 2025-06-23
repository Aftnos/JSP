package com.dao;

import com.db.DBUtil;
import com.entity.AfterSale;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AfterSaleDAO {
    public int insert(AfterSale a) throws SQLException {
        String sql = "INSERT INTO after_sales(user_id,sn_code,type,reason,status,remark) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getUserId());
            ps.setString(2, a.getSnCode());
            ps.setString(3, a.getType());
            ps.setString(4, a.getReason());
            ps.setString(5, a.getStatus());
            ps.setString(6, a.getRemark());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) a.setId(rs.getInt(1)); }
            }
            return affected;
        }
    }

    public List<AfterSale> listByUser(int userId) throws SQLException {
        List<AfterSale> list = new ArrayList<>();
        String sql = "SELECT * FROM after_sales WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public List<AfterSale> listAll() throws SQLException {
        List<AfterSale> list = new ArrayList<>();
        String sql = "SELECT * FROM after_sales";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public int updateStatus(int id, String status, String remark) throws SQLException {
        String sql = "UPDATE after_sales SET status=?, remark=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remark);
            ps.setInt(3, id);
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        String sql = "DELETE FROM after_sales WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    /**
     * Delete all after-sale records for the specified user.
     */
    public int deleteByUserId(int userId) throws SQLException {
        String sql = "DELETE FROM after_sales WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        }
    }

    private AfterSale map(ResultSet rs) throws SQLException {
        AfterSale a = new AfterSale();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setSnCode(rs.getString("sn_code"));
        a.setType(rs.getString("type"));
        a.setReason(rs.getString("reason"));
        a.setStatus(rs.getString("status"));
        a.setRemark(rs.getString("remark"));
        return a;
    }
}
