package com.dao;

import com.db.DBUtil;
import com.entity.SNCode;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SNCodeDAO {
    public void generate(int productId, int batchSize, int batchId) throws SQLException {
        String sql = "INSERT INTO sn_codes(product_id,code,status,batch_id) VALUES(?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < batchSize; i++) {
                ps.setInt(1, productId);
                ps.setString(2, "SN" + System.currentTimeMillis() + i);
                ps.setString(3, "unsold");
                ps.setInt(4, batchId);
                ps.addBatch();
            }
            ps.executeBatch();
        }
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

    /** Fetch unsold codes for a product with limit */
    public List<SNCode> listAvailable(int productId, int limit) throws SQLException {
        List<SNCode> list = new ArrayList<>();
        String sql = "SELECT * FROM sn_codes WHERE product_id=? AND status='unsold' LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
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

    /** Mark codes as sold and associate with order */
    public void assignToOrder(int orderId, List<SNCode> codes) throws SQLException {
        if (codes == null || codes.isEmpty()) return;
        String updateSql = "UPDATE sn_codes SET status='sold' WHERE code=?";
        String insertSql = "INSERT INTO order_sn_codes(order_id,sn_code) VALUES(?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement up = conn.prepareStatement(updateSql);
             PreparedStatement ins = conn.prepareStatement(insertSql)) {
            conn.setAutoCommit(false);
            try {
                for (SNCode c : codes) {
                    up.setString(1, c.getCode());
                    up.addBatch();
                    ins.setInt(1, orderId);
                    ins.setString(2, c.getCode());
                    ins.addBatch();
                }
                up.executeBatch();
                ins.executeBatch();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /** List SN codes assigned to an order */
    public List<SNCode> listByOrder(int orderId) throws SQLException {
        List<SNCode> list = new ArrayList<>();
        String sql = "SELECT s.* FROM sn_codes s JOIN order_sn_codes o ON s.code=o.sn_code WHERE o.order_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
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
