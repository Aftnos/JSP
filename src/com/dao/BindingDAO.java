package com.dao;

import com.db.DBUtil;
import com.entity.Binding;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BindingDAO {
    public int bind(int userId, String snCode) throws SQLException {
        String sql = "INSERT INTO bindings(user_id,sn_code) VALUES(?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, snCode);
            return ps.executeUpdate();
        }
    }

    public List<Binding> listByUser(int userId) throws SQLException {
        List<Binding> list = new ArrayList<>();
        String sql = "SELECT * FROM bindings WHERE user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public int unbind(String code) throws SQLException {
        String sql = "DELETE FROM bindings WHERE sn_code=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            return ps.executeUpdate();
        }
    }

    private Binding map(ResultSet rs) throws SQLException {
        Binding b = new Binding();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setSnCode(rs.getString("sn_code"));
        b.setBindTime(rs.getTimestamp("bind_time"));
        return b;
    }
}
