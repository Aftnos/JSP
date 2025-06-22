package test;

import com.ServiceLayer;
import com.entity.Address;
import com.entity.User;
import java.util.List;

/**
 * 收货地址功能测试类
 * 测试 ServiceLayer 中与收货地址相关的所有方法
 */
public class AddressTest {
    
    public static void main(String[] args) {
        System.out.println("=== 收货地址功能测试开始 ===");
        
        // 测试所有功能
        testAddressManagementIntegrity();
        testAddAddress();
        testGetAddresses();
        testUpdateAddress();
        testSetDefaultAddress();
        testDeleteAddress();
        
        System.out.println("=== 收货地址功能测试结束 ===");
    }
    
    /**
     * 测试收货地址管理功能的完整性
     */
    public static void testAddressManagementIntegrity() {
        System.out.println("\n--- 测试收货地址管理功能完整性 ---");
        
        try {
            // 1. 获取所有用户，选择第一个用户进行测试
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户，无法进行地址测试");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            System.out.println("使用测试用户: " + testUser.getUsername() + " (ID: " + userId + ")");
            
            // 2. 获取用户当前地址列表
            List<Address> addresses = ServiceLayer.getAddresses(userId);
            System.out.println("用户当前地址数量: " + (addresses != null ? addresses.size() : 0));
            
            // 3. 显示现有地址
            if (addresses != null && !addresses.isEmpty()) {
                System.out.println("现有地址列表:");
                for (Address addr : addresses) {
                    System.out.println("  ID: " + addr.getId() + ", 地址: " + addr.getDetail() + 
                                     ", 默认: " + (addr.isDefault() ? "是" : "否"));
                }
            }
            
            System.out.println("收货地址管理功能基本正常");
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试添加收货地址功能
     */
    public static void testAddAddress() {
        System.out.println("\n--- 测试添加收货地址功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            // 创建测试地址
            Address testAddress = new Address();
            testAddress.setUserId(userId);
            testAddress.setReceiver("测试收货人");
            testAddress.setPhone("13800138000");
            testAddress.setDetail("北京市朝阳区测试街道123号");
            testAddress.setDefault(false);
            
            System.out.println("正在添加测试地址...");
            boolean result = ServiceLayer.addAddress(testAddress);
            
            if (result) {
                System.out.println("添加地址成功!");
                
                // 验证添加结果
                List<Address> addresses = ServiceLayer.getAddresses(userId);
                System.out.println("添加后用户地址数量: " + (addresses != null ? addresses.size() : 0));
            } else {
                System.out.println("添加地址失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试添加地址时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试获取用户地址列表功能
     */
    public static void testGetAddresses() {
        System.out.println("\n--- 测试获取用户地址列表功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            System.out.println("正在获取用户 " + userId + " 的地址列表...");
            List<Address> addresses = ServiceLayer.getAddresses(userId);
            
            if (addresses != null) {
                System.out.println("成功获取地址列表，数量: " + addresses.size());
                
                for (int i = 0; i < addresses.size(); i++) {
                    Address addr = addresses.get(i);
                    System.out.println("地址 " + (i + 1) + ":");
                    System.out.println("  ID: " + addr.getId());
                    System.out.println("  收货人: " + addr.getReceiver());
                    System.out.println("  电话: " + addr.getPhone());
                    System.out.println("  地址: " + addr.getDetail());
                    System.out.println("  是否默认: " + (addr.isDefault() ? "是" : "否"));
                }
            } else {
                System.out.println("获取地址列表失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试获取地址列表时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试更新收货地址功能
     */
    public static void testUpdateAddress() {
        System.out.println("\n--- 测试更新收货地址功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            // 获取用户的地址列表
            List<Address> addresses = ServiceLayer.getAddresses(userId);
            if (addresses == null || addresses.isEmpty()) {
                System.out.println("用户没有地址，无法测试更新功能");
                return;
            }
            
            // 选择第一个地址进行更新测试
            Address addressToUpdate = addresses.get(0);
            System.out.println("正在更新地址 ID: " + addressToUpdate.getId());
            
            // 修改地址信息
            addressToUpdate.setReceiver("更新后的收货人");
            addressToUpdate.setPhone("13900139000");
            addressToUpdate.setDetail("更新后的详细地址");
            
            boolean result = ServiceLayer.updateAddress(addressToUpdate);
            
            if (result) {
                System.out.println("更新地址成功!");
                
                // 验证更新结果
                List<Address> updatedAddresses = ServiceLayer.getAddresses(userId);
                if (updatedAddresses != null) {
                    for (Address addr : updatedAddresses) {
                        if (addr.getId() == addressToUpdate.getId()) {
                            System.out.println("验证更新结果:");
                            System.out.println("  收货人: " + addr.getReceiver());
                            System.out.println("  电话: " + addr.getPhone());
                            System.out.println("  详细地址: " + addr.getDetail());
                            break;
                        }
                    }
                }
            } else {
                System.out.println("更新地址失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试更新地址时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试设置默认地址功能
     */
    public static void testSetDefaultAddress() {
        System.out.println("\n--- 测试设置默认地址功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            // 获取用户的地址列表
            List<Address> addresses = ServiceLayer.getAddresses(userId);
            if (addresses == null || addresses.isEmpty()) {
                System.out.println("用户没有地址，无法测试设置默认地址功能");
                return;
            }
            
            // 选择第一个地址设置为默认
            Address addressToSetDefault = addresses.get(0);
            System.out.println("正在设置地址 ID: " + addressToSetDefault.getId() + " 为默认地址");
            
            ServiceLayer.setDefaultAddress(userId, addressToSetDefault.getId());
            System.out.println("设置默认地址操作完成");
            
            // 验证设置结果
            List<Address> updatedAddresses = ServiceLayer.getAddresses(userId);
            if (updatedAddresses != null) {
                System.out.println("验证默认地址设置结果:");
                for (Address addr : updatedAddresses) {
                    System.out.println("  地址 ID: " + addr.getId() + ", 默认: " + (addr.isDefault() ? "是" : "否"));
                }
            }
            
        } catch (Exception e) {
            System.out.println("测试设置默认地址时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试删除收货地址功能
     */
    public static void testDeleteAddress() {
        System.out.println("\n--- 测试删除收货地址功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            // 获取用户的地址列表
            List<Address> addresses = ServiceLayer.getAddresses(userId);
            if (addresses == null || addresses.isEmpty()) {
                System.out.println("用户没有地址，无法测试删除功能");
                return;
            }
            
            // 选择最后一个地址进行删除测试（避免删除默认地址）
            Address addressToDelete = addresses.get(addresses.size() - 1);
            int addressId = addressToDelete.getId();
            
            System.out.println("正在删除地址 ID: " + addressId);
            System.out.println("删除前地址数量: " + addresses.size());
            
            boolean result = ServiceLayer.deleteAddress(addressId);
            
            if (result) {
                System.out.println("删除地址成功!");
                
                // 验证删除结果
                List<Address> updatedAddresses = ServiceLayer.getAddresses(userId);
                System.out.println("删除后地址数量: " + (updatedAddresses != null ? updatedAddresses.size() : 0));
                
                // 检查被删除的地址是否还存在
                boolean stillExists = false;
                if (updatedAddresses != null) {
                    for (Address addr : updatedAddresses) {
                        if (addr.getId() == addressId) {
                            stillExists = true;
                            break;
                        }
                    }
                }
                
                if (!stillExists) {
                    System.out.println("验证通过: 地址已被成功删除");
                } else {
                    System.out.println("警告: 删除操作返回成功，但地址仍然存在");
                }
            } else {
                System.out.println("删除地址失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试删除地址时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
}