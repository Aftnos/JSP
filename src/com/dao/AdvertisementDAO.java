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
                ad.imagePath = rs.getString("image_path");
                ad.targetUrl = rs.getString("target_url");
                ad.enabled = rs.getInt("enabled") == 1;
                list.add(ad);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** 新增广告 */
    public static int addAdvertisement(String title, String imagePath, String targetUrl, boolean enabled) {
        String sql = "INSERT INTO advertisements(title, image_path, target_url, enabled) VALUES(?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, imagePath);
            ps.setString(3, targetUrl);
            ps.setInt(4, enabled ? 1 : 0);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 更新广告 */
    public static int updateAdvertisement(int id, String title, String imagePath, String targetUrl, boolean enabled) {
        String sql = "UPDATE advertisements SET title=?, image_path=?, target_url=?, enabled=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, imagePath);
            ps.setString(3, targetUrl);
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

    /** 根据ID获取广告 */
    public static Advertisement getAdvertisementById(int id) {
        String sql = "SELECT * FROM advertisements WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Advertisement ad = new Advertisement();
                    ad.id = rs.getInt("id");
                    ad.title = rs.getString("title");
                    ad.imagePath = rs.getString("image_path");
                    ad.targetUrl = rs.getString("target_url");
                    ad.enabled = rs.getInt("enabled") == 1;
                    return ad;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
