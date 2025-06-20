package com.dao;

import com.db.DBUtil;
import com.entity.UserProduct;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户商品绑定及售后数据库操作。
 */
public class UserProductDAO {

    /**
     * 新增用户商品绑定记录。
     *
     * @param userId 用户ID
     * @param productId 商品ID
     * @param orderNo 订单编号
     * @return 插入的行数
     */
    public static int addUserProduct(int userId, int productId, String orderNo) {
        String sql = "INSERT INTO user_products(user_id, product_id, order_no) VALUES(?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setString(3, orderNo);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 检查指定订单号与商品ID组合是否已存在绑定记录。
     *
     * @param orderNo   订单号
     * @param productId 商品ID
     * @return true 表示已存在，false 表示不存在或查询失败
     */
    public static boolean existsByOrderAndProduct(String orderNo, int productId) {
        String sql = "SELECT 1 FROM user_products WHERE order_no=? AND product_id=? LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderNo);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 查询用户绑定的所有商品。
     *
     * @param userId 用户ID
     * @return 绑定商品列表
     */
    public static List<UserProduct> getUserProducts(int userId) {
        List<UserProduct> list = new ArrayList<>();
        String sql = "SELECT up.id, up.user_id, up.product_id, up.order_no, up.after_sale_status, p.name " +
                     "FROM user_products up JOIN products p ON up.product_id=p.id WHERE up.user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserProduct up = new UserProduct();
                    up.id = rs.getInt("id");
                    up.userId = rs.getInt("user_id");
                    up.productId = rs.getInt("product_id");
                    up.orderNo = rs.getString("order_no");
                    up.afterSaleStatus = rs.getString("after_sale_status");
                    up.productName = rs.getString("name");
                    list.add(up);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取所有用户商品绑定记录（管理员使用）。
     *
     * @return 绑定记录列表
     */
    public static List<UserProduct> getAllUserProducts() {
        List<UserProduct> list = new ArrayList<>();
        String sql = "SELECT up.id, up.user_id, up.product_id, up.order_no, up.after_sale_status, p.name " +
                     "FROM user_products up JOIN products p ON up.product_id=p.id ORDER BY up.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserProduct up = new UserProduct();
                up.id = rs.getInt("id");
                up.userId = rs.getInt("user_id");
                up.productId = rs.getInt("product_id");
                up.orderNo = rs.getString("order_no");
                up.afterSaleStatus = rs.getString("after_sale_status");
                up.productName = rs.getString("name");
                list.add(up);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 用户申请售后。
     *
     * @param userProductId 绑定记录ID
     * @return 更新行数
     */
    public static int applyAfterSale(int userProductId) {
        return updateAfterSaleStatus(userProductId, "申请中");
    }

    /**
     * 更新售后状态。
     *
     * @param userProductId 绑定记录ID
     * @param status 新的售后状态
     * @return 更新行数
     */
    public static int updateAfterSaleStatus(int userProductId, String status) {
        String sql = "UPDATE user_products SET after_sale_status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userProductId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 根据ID获取用户绑定商品 */
    public static UserProduct getUserProductById(int id) {
        String sql = "SELECT up.id, up.user_id, up.product_id, up.order_no, up.after_sale_status, p.name " +
                     "FROM user_products up JOIN products p ON up.product_id=p.id WHERE up.id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserProduct up = new UserProduct();
                    up.id = rs.getInt("id");
                    up.userId = rs.getInt("user_id");
                    up.productId = rs.getInt("product_id");
                    up.orderNo = rs.getString("order_no");
                    up.afterSaleStatus = rs.getString("after_sale_status");
                    up.productName = rs.getString("name");
                    return up;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 删除用户绑定商品 */
    public static int deleteUserProduct(int id) {
        String sql = "DELETE FROM user_products WHERE id=?";
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
