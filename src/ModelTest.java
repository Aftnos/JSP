
/**
 * Model类的测试类
 * 测试数据库操作的各种功能
 */
public class ModelTest {
    /**
     * 简单的演示性测试，向数据库中插入一条用户记录并再次查询。
     * 执行前请确保已导入 `ProjectData/sql/schema.sql` 中的表结构，
     * 并修改 `src/db.properties` 使其能够连接到本地 MySQL 数据库。
     */
    public static void main(String[] args) throws Exception {
        // 创建测试用户
        com.entity.User u = new com.entity.User();
        u.setUsername("test_user");
        u.setPassword("123456");
        u.setEmail("test@example.com");

        // 调用 Model 方法写入并再次读取
        int affected = com.Model.register(u);
        System.out.println("Insert affected rows: " + affected);
        if (affected > 0) {
            com.entity.User loaded = com.Model.getUserById(u.getId());
            System.out.println("Loaded user: " + loaded.getUsername());
        }
    }
}