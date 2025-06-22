package com.dao;

import com.db.DBUtil;
import com.entity.SNCode;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SNCodeDAO {
    /**
     * Generate SN codes with custom status. Existing public API defaults to
     * generating codes in {@code unsold} status.
     */
    public void generate(int productId, int batchSize, int batchId, String status) throws SQLException {
        String sql = "INSERT INTO sn_codes(product_id,code,status,batch_id) VALUES(?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < batchSize; i++) {
                ps.setInt(1, productId);
                ps.setString(2, "SN" + System.currentTimeMillis() + i);
                ps.setString(3, status);
                ps.setInt(4, batchId);
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    /** Convenience method keeping backwards compatibility */
    public void generate(int productId, int batchSize, int batchId) throws SQLException {
        generate(productId, batchSize, batchId, "unsold");
    }

    public List<SNCode> list(int productId, String status) throws SQLException {
        List<SNCode> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder("SELECT * FROM sn_codes WHERE 1=1");
        if (productId > 0) sb.append(" AND product_id=" + productId);
        if (status != null) sb.append(" AND status='" + status + "'");
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    /**
     * Find SN code by exact code string.
     */
    public SNCode findByCode(String code) throws SQLException {
        String sql = "SELECT * FROM sn_codes WHERE code=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    public int updateStatus(String code, String status) throws SQLException {
        String sql = "UPDATE sn_codes SET status=? WHERE code=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, code);
            return ps.executeUpdate();
        }
    }

    public int deleteByBatch(int batchId) throws SQLException {
        String sql = "DELETE FROM sn_codes WHERE batch_id=? AND status='unsold'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, batchId);
            return ps.executeUpdate();
        }
    }

    /**
     * List SN codes by batch id (used here to associate codes with an order).
     */
    public List<SNCode> listByBatch(int batchId) throws SQLException {
        List<SNCode> list = new ArrayList<>();
        String sql = "SELECT * FROM sn_codes WHERE batch_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    private SNCode map(ResultSet rs) throws SQLException {
        SNCode s = new SNCode();
        s.setId(rs.getInt("id"));
        s.setProductId(rs.getInt("product_id"));
        s.setCode(rs.getString("code"));
        s.setStatus(rs.getString("status"));
        int b = rs.getInt("batch_id");
        s.setBatchId(rs.wasNull() ? null : b);
        return s;
    }
}
