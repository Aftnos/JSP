
/**
 * com.ServiceLayer 测试类
 * 用于测试 com.ServiceLayer 封装的各项功能是否正常运行
 */
public class ServiceLayerTest {
    /**
     * 示例性的 ServiceLayer 调用测试。
     * 需要先确保数据库可用，调用后会输出执行结果。
     */
    public static void main(String[] args) {
        com.entity.User user = new com.entity.User();
        user.setUsername("service_user");
        user.setPassword("123456");

        // 注册
        boolean reg = com.ServiceLayer.register(user);
        System.out.println("register result: " + reg);

        // 登录
        com.entity.User login = com.ServiceLayer.login("service_user", "123456");
        System.out.println("login success: " + (login != null));
    }
}