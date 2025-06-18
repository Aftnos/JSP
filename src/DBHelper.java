import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

/**
 * 简单的数据库连接帮助类
 */
public class DBHelper {
    private static String URL;
    private static String USER;
    private static String PASS;

    static {
        try {
            Properties props = new Properties();
            InputStream in = DBHelper.class.getClassLoader().getResourceAsStream("db.properties");
            if (in != null) {
                props.load(in);
                URL = props.getProperty("url");
                USER = props.getProperty("user");
                PASS = props.getProperty("password");
            }
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** 获取数据库连接 */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
