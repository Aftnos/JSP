package com.dao;

import com.db.DBUtil;
import com.entity.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 商品分类相关数据库操作。
 */
public class CategoryDAO {

    /** 获取所有分类 */
    public static List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.id = rs.getInt("id");
                c.name = rs.getString("name");
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 新增分类 */
    public static int addCategory(String name) {
        String sql = "INSERT INTO categories(name) VALUES(?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 更新分类 */
    public static int updateCategory(int id, String name) {
        String sql = "UPDATE categories SET name=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 删除分类 */
    public static int deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 根据ID获取分类 */
    public static Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.id = rs.getInt("id");
                    c.name = rs.getString("name");
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
