package com.dao;

import com.db.DBUtil;
import com.entity.Product;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    public List<Product> listAll() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public List<Product> listByCategory(int categoryId) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Product findById(int id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public int insert(Product p) throws SQLException {
        String sql = "INSERT INTO products(name,price,stock,category_id,description) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getName());
            ps.setBigDecimal(2, p.getPrice());
            ps.setInt(3, p.getStock());
            if(p.getCategoryId()==null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, p.getCategoryId());
            ps.setString(5, p.getDescription());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) p.setId(rs.getInt(1));
                }
            }
            return affected;
        }
    }

    public int update(Product p) throws SQLException {
        String sql = "UPDATE products SET name=?, price=?, stock=?, category_id=?, description=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setBigDecimal(2, p.getPrice());
            ps.setInt(3, p.getStock());
            if(p.getCategoryId()==null) ps.setNull(4, Types.INTEGER); else ps.setInt(4, p.getCategoryId());
            ps.setString(5, p.getDescription());
            ps.setInt(6, p.getId());
            return ps.executeUpdate();
        }
    }

    public int delete(int id) throws SQLException {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        }
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setStock(rs.getInt("stock"));
        int cid = rs.getInt("category_id");
        p.setCategoryId(rs.wasNull()?null:cid);
        p.setDescription(rs.getString("description"));
        return p;
    }
}
