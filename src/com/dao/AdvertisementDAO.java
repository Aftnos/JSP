package com.dao;

import com.db.DBUtil;
import com.entity.Advertisement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 广告相关数据库操作。
 */
public class AdvertisementDAO {

    /** 获取所有广告 */
    public static List<Advertisement> getAllAdvertisements() {
        List<Advertisement> list = new ArrayList<>();
        String sql = "SELECT * FROM advertisements";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Advertisement ad = new Advertisement();
                ad.id = rs.getInt("id");
                ad.title = rs.getString("title");
                ad.imageUrl = rs.getString("image_url");
                ad.link = rs.getString("link");
                ad.enabled = rs.getInt("enabled") == 1;
                list.add(ad);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 新增广告 */
    public static int addAdvertisement(String title, String imageUrl, String link, boolean enabled) {
        String sql = "INSERT INTO advertisements(title, image_url, link, enabled) VALUES(?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, imageUrl);
            ps.setString(3, link);
            ps.setInt(4, enabled ? 1 : 0);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 更新广告 */
    public static int updateAdvertisement(int id, String title, String imageUrl, String link, boolean enabled) {
        String sql = "UPDATE advertisements SET title=?, image_url=?, link=?, enabled=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, imageUrl);
            ps.setString(3, link);
            ps.setInt(4, enabled ? 1 : 0);
            ps.setInt(5, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 删除广告 */
    public static int deleteAdvertisement(int id) {
        String sql = "DELETE FROM advertisements WHERE id=?";
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
