package com.dao;

import com.db.DBUtil;
import com.entity.ProductImage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDAO {
    public List<ProductImage> listByProduct(int productId) throws SQLException {
        List<ProductImage> list = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id=? ORDER BY id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public List<ProductImage> listByProductAndType(int productId, String type) throws SQLException {
        List<ProductImage> list = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id=? AND type=? ORDER BY id";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }
        return list;
    }

    public ProductImage findById(int id) throws SQLException {
        String sql = "SELECT * FROM product_images WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public int insert(ProductImage img) throws SQLException {
        String sql = "INSERT INTO product_images(product_id,url,type) VALUES(?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, img.getProductId());
            ps.setString(2, img.getUrl());
            ps.setString(3, img.getType());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) img.setId(rs.getInt(1));
                }
            }
            return affected;
        }
    }

    public int update(ProductImage img) throws SQLException {
        String sql = "UPDATE product_images SET product_id=?, url=?, type=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, img.getProductId());
            ps.setString(2, img.getUrl());
            ps.setString(3, img.getType());
            ps.setInt(4, img.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        String sql = "DELETE FROM product_images WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    private ProductImage map(ResultSet rs) throws SQLException {
        ProductImage img = new ProductImage();
        img.setId(rs.getInt("id"));
        img.setProductId(rs.getInt("product_id"));
        img.setUrl(rs.getString("url"));
        img.setType(rs.getString("type"));
        return img;
    }
}
