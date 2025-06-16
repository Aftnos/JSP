package com.dao;

import com.db.DBUtil;
import java.sql.*;

/**
 * 用户相关数据库操作。
 */
public class UserDAO {

    /**
     * 验证用户登录。
     *
     * @param username 用户名
     * @param password 密码
     * @return 验证成功返回 {@code true}
     */
    public static boolean validateUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username=? AND password=?";
        try (Connection conn = DBUtil.getConnection();
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

    /**
     * 新增用户。
     *
     * @param username 用户名
     * @param password 密码
     * @return 插入的行数
     */
    public static int addUser(String username, String password) {
        String sql = "INSERT INTO users(username, password) VALUES(?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
