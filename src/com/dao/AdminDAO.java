package com.dao;

import com.db.DBUtil;
import java.sql.*;

/**
 * 管理员相关数据库操作。
 */
public class AdminDAO {

    /**
     * 验证管理员用户名和密码是否正确。
     *
     * @param username 管理员用户名
     * @param password 管理员密码
     * @return 如果验证通过返回 {@code true}，否则返回 {@code false}
     */
    public static boolean validateAdmin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username=? AND password=?";
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
}
