package com.dao;

import com.db.DBUtil;
import com.entity.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 商品相关数据库操作。
 */
public class ProductDAO {

    /**
     * 查询所有商品。
     *
     * @return 商品列表
     */
    public static List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.id = rs.getInt("id");
                p.name = rs.getString("name");
                p.price = rs.getDouble("price");
                p.stock = rs.getInt("stock");
                p.description = rs.getString("description");
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 根据ID获取商品。
     *
     * @param id 商品ID
     * @return 商品对象，不存在时返回 {@code null}
     */
    public static Product getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.id = rs.getInt("id");
                    p.name = rs.getString("name");
                    p.price = rs.getDouble("price");
                    p.stock = rs.getInt("stock");
                    p.description = rs.getString("description");
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 新增商品。
     *
     * @param name 名称
     * @param price 价格
     * @param stock 库存
     * @param desc 描述
     * @return 影响的行数
     */
    public static int addProduct(String name, double price, int stock, String desc) {
        String sql = "INSERT INTO products(name, price, stock, description) VALUES(?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, stock);
            ps.setString(4, desc);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 更新商品信息。
     *
     * @param id 商品ID
     * @param name 名称
     * @param price 价格
     * @param stock 库存
     * @param desc 描述
     * @return 影响的行数
     */
    public static int updateProduct(int id, String name, double price, int stock, String desc) {
        String sql = "UPDATE products SET name=?, price=?, stock=?, description=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, stock);
            ps.setString(4, desc);
            ps.setInt(5, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 删除商品。
     *
     * @param id 商品ID
     * @return 影响的行数
     */
    public static int deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
