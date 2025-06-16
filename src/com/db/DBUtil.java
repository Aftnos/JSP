package com.db;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * 简单的数据库工具类，负责读取 <code>db.properties</code> 配置并提供数据库连接。
 */
public class DBUtil {
    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        try {
            Properties props = new Properties();
            try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (in != null) {
                    props.load(in);
                }
            }
            URL = props.getProperty("url");
            USER = props.getProperty("user");
            PASSWORD = props.getProperty("password");
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接。
     *
     * @return {@link Connection} 数据库连接对象
     * @throws java.sql.SQLException 获取连接失败时抛出
     */
    public static Connection getConnection() throws java.sql.SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
