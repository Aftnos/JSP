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

    /**
     * 更新用户密码。
     *
     * @param userId 用户ID
     * @param newPassword 新密码
     * @return 更新的行数
     */
    public static int updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 更新用户资料（头像和显示名称）。
     *
     * @param userId 用户ID
     * @param displayName 显示名称
     * @param avatar 头像URL
     * @return 更新的行数
     */
    public static int updateProfile(int userId, String displayName, String avatar) {
        String sql = "UPDATE users SET display_name=?, avatar=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, displayName);
            ps.setString(2, avatar);
            ps.setInt(3, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
