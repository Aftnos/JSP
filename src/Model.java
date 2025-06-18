import java.io.InputStream;
import java.sql.*;
import java.util.*;
import model.*;

/**
 * 集中式数据库操作类，封装了简单的增删查改方法
 */
public class Model {
    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        try {
            Properties props = new Properties();
            InputStream in = Model.class.getClassLoader().getResourceAsStream("db.properties");
            if (in != null) {
                props.load(in);
                URL = props.getProperty("url");
                USER = props.getProperty("user");
                PASSWORD = props.getProperty("password");
            }
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** 获取数据库连接 */
    private static Connection getConn() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    //======================= 用户操作 =======================

    /** 新增用户 */
    public static int addUser(User user) {
        String sql = "INSERT INTO users(username,password) VALUES(?,?)";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 根据 id 删除用户 */
    public static int deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 更新用户信息 */
    public static int updateUser(User user) {
        String sql = "UPDATE users SET username=?,password=? WHERE id=?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setInt(3, user.getId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 查询单个用户 */
    public static User getUser(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 查询所有用户 */
    public static List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    //======================= 商品操作 =======================

    /** 新增商品 */
    public static int addProduct(Product p) {
        String sql = "INSERT INTO products(name,price,stock,description) VALUES(?,?,?,?)";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.setString(4, p.getDescription());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 删除商品 */
    public static int deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 更新商品 */
    public static int updateProduct(Product p) {
        String sql = "UPDATE products SET name=?,price=?,stock=?,description=? WHERE id=?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setDouble(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.setString(4, p.getDescription());
            ps.setInt(5, p.getId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** 查询单个商品 */
    public static Product getProduct(int id) {
        String sql = "SELECT * FROM products WHERE id=?";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setDescription(rs.getString("description"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 查询所有商品 */
    public static List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = getConn(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setDescription(rs.getString("description"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
