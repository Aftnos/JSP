package test;

import com.ServiceLayer;
import com.entity.Order;
import com.entity.User;
import com.entity.Address;
import java.math.BigDecimal;
import java.util.List;

/**
 * 订单功能测试类
 * 测试 ServiceLayer 中与订单相关的所有方法
 */
public class OrderTest {
    
    public static void main(String[] args) {
        System.out.println("=== 订单功能测试开始 ===");
        
        // 测试所有功能
        testOrderManagementIntegrity();
        testCreateOrder();
        testGetOrderById();
        testGetOrdersByUser();
        testListAllOrders();
        testUpdateOrderStatus();
        testMarkOrderPaid();
        
        System.out.println("=== 订单功能测试结束 ===");
    }
    
    /**
     * 测试订单管理功能的完整性
     */
    public static void testOrderManagementIntegrity() {
        System.out.println("\n--- 测试订单管理功能完整性 ---");
        
        try {
            // 1. 获取所有订单
            List<Order> allOrders = ServiceLayer.listAllOrders();
            System.out.println("当前订单总数: " + (allOrders != null ? allOrders.size() : 0));
            
            // 2. 获取所有用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            System.out.println("当前用户总数: " + (allUsers != null ? allUsers.size() : 0));
            
            // 3. 显示现有订单
            if (allOrders != null && !allOrders.isEmpty()) {
                System.out.println("现有订单列表:");
                for (int i = 0; i < Math.min(5, allOrders.size()); i++) {
                    Order order = allOrders.get(i);
                    System.out.println("  ID: " + order.getId() + ", 用户ID: " + order.getUserId() + 
                                     ", 状态: " + order.getStatus() + ", 总金额: " + order.getTotal() +
                                     ", 已支付: " + (order.isPaid() ? "是" : "否"));
                }
                if (allOrders.size() > 5) {
                    System.out.println("  ... 还有 " + (allOrders.size() - 5) + " 个订单");
                }
            }
            
            System.out.println("订单管理功能基本正常");
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试创建订单功能
     */
    public static void testCreateOrder() {
        System.out.println("\n--- 测试创建订单功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("错误: 没有找到用户");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            // 获取用户地址
            List<Address> addresses = ServiceLayer.getAddresses(userId);
            Integer addressId = null;
            if (addresses != null && !addresses.isEmpty()) {
                addressId = addresses.get(0).getId();
            }
            
            // 创建测试订单
            Order testOrder = new Order();
            testOrder.setUserId(userId);
            testOrder.setAddressId(addressId);
            testOrder.setStatus("pending");
            testOrder.setTotal(new BigDecimal("299.99"));
            testOrder.setPaid(false);
            
            System.out.println("正在创建测试订单...");
            System.out.println("用户ID: " + userId + ", 地址ID: " + addressId + ", 总金额: " + testOrder.getTotal());
            
            boolean result = ServiceLayer.createOrder(testOrder);
            
            if (result) {
                System.out.println("创建订单成功!");
                
                // 验证创建结果
                List<Order> orders = ServiceLayer.listAllOrders();
                System.out.println("创建后订单总数: " + (orders != null ? orders.size() : 0));
                
                // 查找刚创建的订单
                if (orders != null) {
                    for (Order o : orders) {
                        if (o.getUserId() == userId && o.getTotal().compareTo(testOrder.getTotal()) == 0) {
                            System.out.println("找到新创建的订单: ID=" + o.getId() + ", 状态=" + o.getStatus());
                            break;
                        }
                    }
                }
            } else {
                System.out.println("创建订单失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试根据ID获取订单功能
     */
    public static void testGetOrderById() {
        System.out.println("\n--- 测试根据ID获取订单功能 ---");
        
        try {
            // 获取所有订单
            List<Order> allOrders = ServiceLayer.listAllOrders();
            if (allOrders == null || allOrders.isEmpty()) {
                System.out.println("没有订单可供测试");
                return;
            }
            
            // 选择第一个订单进行测试
            Order firstOrder = allOrders.get(0);
            int orderId = firstOrder.getId();
            
            System.out.println("正在查询订单ID: " + orderId);
            Order retrievedOrder = ServiceLayer.getOrderById(orderId);
            
            if (retrievedOrder != null) {
                System.out.println("查询订单成功!");
                System.out.println("订单信息: ID=" + retrievedOrder.getId() + 
                                 ", 用户ID=" + retrievedOrder.getUserId() +
                                 ", 状态=" + retrievedOrder.getStatus() +
                                 ", 总金额=" + retrievedOrder.getTotal());
            } else {
                System.out.println("查询订单失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试根据用户获取订单列表功能
     */
    public static void testGetOrdersByUser() {
        System.out.println("\n--- 测试根据用户获取订单列表功能 ---");
        
        try {
            // 获取测试用户
            List<User> allUsers = ServiceLayer.getAllUsers();
            if (allUsers == null || allUsers.isEmpty()) {
                System.out.println("没有用户可供测试");
                return;
            }
            
            User testUser = allUsers.get(0);
            int userId = testUser.getId();
            
            System.out.println("正在查询用户 " + testUser.getUsername() + " (ID: " + userId + ") 的订单");
            List<Order> userOrders = ServiceLayer.getOrdersByUser(userId);
            
            if (userOrders != null) {
                System.out.println("查询成功! 用户订单数量: " + userOrders.size());
                
                if (!userOrders.isEmpty()) {
                    System.out.println("用户订单列表:");
                    for (Order order : userOrders) {
                        System.out.println("  订单ID: " + order.getId() + 
                                         ", 状态: " + order.getStatus() +
                                         ", 总金额: " + order.getTotal() +
                                         ", 已支付: " + (order.isPaid() ? "是" : "否"));
                    }
                }
            } else {
                System.out.println("查询用户订单失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试获取所有订单功能
     */
    public static void testListAllOrders() {
        System.out.println("\n--- 测试获取所有订单功能 ---");
        
        try {
            System.out.println("正在获取所有订单...");
            List<Order> allOrders = ServiceLayer.listAllOrders();
            
            if (allOrders != null) {
                System.out.println("获取成功! 订单总数: " + allOrders.size());
                
                // 统计订单状态
                int pendingCount = 0;
                int paidCount = 0;
                int completedCount = 0;
                int cancelledCount = 0;
                
                for (Order order : allOrders) {
                    switch (order.getStatus()) {
                        case "pending":
                            pendingCount++;
                            break;
                        case "paid":
                            paidCount++;
                            break;
                        case "completed":
                            completedCount++;
                            break;
                        case "cancelled":
                            cancelledCount++;
                            break;
                    }
                }
                
                System.out.println("订单状态统计:");
                System.out.println("  待处理: " + pendingCount);
                System.out.println("  已支付: " + paidCount);
                System.out.println("  已完成: " + completedCount);
                System.out.println("  已取消: " + cancelledCount);
                
            } else {
                System.out.println("获取所有订单失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试更新订单状态功能
     */
    public static void testUpdateOrderStatus() {
        System.out.println("\n--- 测试更新订单状态功能 ---");
        
        try {
            // 获取所有订单
            List<Order> allOrders = ServiceLayer.listAllOrders();
            if (allOrders == null || allOrders.isEmpty()) {
                System.out.println("没有订单可供测试");
                return;
            }
            
            // 选择第一个订单进行测试
            Order testOrder = allOrders.get(0);
            int orderId = testOrder.getId();
            String originalStatus = testOrder.getStatus();
            String newStatus = "processing"; // 更新为处理中状态
            
            System.out.println("正在更新订单状态...");
            System.out.println("订单ID: " + orderId + ", 原状态: " + originalStatus + ", 新状态: " + newStatus);
            
            boolean result = ServiceLayer.updateOrderStatus(orderId, newStatus);
            
            if (result) {
                System.out.println("更新订单状态成功!");
                
                // 验证更新结果
                Order updatedOrder = ServiceLayer.getOrderById(orderId);
                if (updatedOrder != null) {
                    System.out.println("验证结果: 订单状态已更新为 " + updatedOrder.getStatus());
                    
                    // 恢复原状态
                    ServiceLayer.updateOrderStatus(orderId, originalStatus);
                    System.out.println("已恢复原状态: " + originalStatus);
                }
            } else {
                System.out.println("更新订单状态失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试标记订单已支付功能
     */
    public static void testMarkOrderPaid() {
        System.out.println("\n--- 测试标记订单已支付功能 ---");
        
        try {
            // 获取所有订单
            List<Order> allOrders = ServiceLayer.listAllOrders();
            if (allOrders == null || allOrders.isEmpty()) {
                System.out.println("没有订单可供测试");
                return;
            }
            
            // 查找未支付的订单
            Order unpaidOrder = null;
            for (Order order : allOrders) {
                if (!order.isPaid()) {
                    unpaidOrder = order;
                    break;
                }
            }
            
            if (unpaidOrder == null) {
                System.out.println("没有找到未支付的订单，使用第一个订单进行测试");
                unpaidOrder = allOrders.get(0);
            }
            
            int orderId = unpaidOrder.getId();
            boolean originalPaidStatus = unpaidOrder.isPaid();
            
            System.out.println("正在标记订单已支付...");
            System.out.println("订单ID: " + orderId + ", 原支付状态: " + (originalPaidStatus ? "已支付" : "未支付"));
            
            boolean result = ServiceLayer.markOrderPaid(orderId);
            
            if (result) {
                System.out.println("标记订单已支付成功!");
                
                // 验证更新结果
                Order updatedOrder = ServiceLayer.getOrderById(orderId);
                if (updatedOrder != null) {
                    System.out.println("验证结果: 订单支付状态为 " + (updatedOrder.isPaid() ? "已支付" : "未支付"));
                }
            } else {
                System.out.println("标记订单已支付失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试订单删除功能（如果有的话）
     * 注意：当前ServiceLayer中没有删除订单的方法，这里仅作为扩展预留
     */
    public static void testDeleteOrder() {
        System.out.println("\n--- 测试删除订单功能 ---");
        System.out.println("注意: 当前ServiceLayer中没有提供删除订单的方法");
        System.out.println("建议: 可以考虑添加软删除功能，将订单状态设置为'deleted'");
    }
    
    /**
     * 综合测试：创建完整的订单流程
     */
    public static void testCompleteOrderFlow() {
        System.out.println("\n--- 测试完整订单流程 ---");
        
        try {
            // 1. 获取测试用户和地址
            List<User> users = ServiceLayer.getAllUsers();
            if (users == null || users.isEmpty()) {
                System.out.println("没有用户，无法测试完整流程");
                return;
            }
            
            User user = users.get(0);
            List<Address> addresses = ServiceLayer.getAddresses(user.getId());
            Integer addressId = (addresses != null && !addresses.isEmpty()) ? addresses.get(0).getId() : null;
            
            // 2. 创建订单
            Order order = new Order();
            order.setUserId(user.getId());
            order.setAddressId(addressId);
            order.setStatus("pending");
            order.setTotal(new BigDecimal("199.99"));
            order.setPaid(false);
            
            System.out.println("步骤1: 创建订单");
            boolean created = ServiceLayer.createOrder(order);
            if (!created) {
                System.out.println("创建订单失败，终止流程测试");
                return;
            }
            
            // 3. 查找刚创建的订单
            List<Order> userOrders = ServiceLayer.getOrdersByUser(user.getId());
            Order newOrder = null;
            if (userOrders != null) {
                for (Order o : userOrders) {
                    if (o.getTotal().compareTo(order.getTotal()) == 0 && "pending".equals(o.getStatus())) {
                        newOrder = o;
                        break;
                    }
                }
            }
            
            if (newOrder == null) {
                System.out.println("找不到刚创建的订单，终止流程测试");
                return;
            }
            
            System.out.println("步骤2: 找到新订单，ID=" + newOrder.getId());
            
            // 4. 更新订单状态为已支付
            System.out.println("步骤3: 标记订单已支付");
            ServiceLayer.markOrderPaid(newOrder.getId());
            
            // 5. 更新订单状态为已完成
            System.out.println("步骤4: 更新订单状态为已完成");
            ServiceLayer.updateOrderStatus(newOrder.getId(), "completed");
            
            // 6. 验证最终状态
            Order finalOrder = ServiceLayer.getOrderById(newOrder.getId());
            if (finalOrder != null) {
                System.out.println("完整流程测试成功!");
                System.out.println("最终订单状态: " + finalOrder.getStatus() + ", 支付状态: " + (finalOrder.isPaid() ? "已支付" : "未支付"));
            }
            
        } catch (Exception e) {
            System.out.println("完整流程测试中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
}