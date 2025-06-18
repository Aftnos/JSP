package com;

import java.util.*;
import java.sql.Timestamp;
import com.entity.*;

/**
 * 业务服务层 - 为JSP前端页面提供简单易用的接口
 * 封装Model.java的数据库操作，提供统一的业务逻辑处理
 * 
 * 使用规范：
 * 1. 所有方法都有详细的参数说明和返回值说明
 * 2. 统一的错误处理和返回格式
 * 3. 简化的接口调用，隐藏复杂的数据库操作
 * 4. 适合在JSP页面中直接调用
 * 
 * @author 系统开发者
 * @version 1.0
 */
public class ServiceLayer {
    
    // ==================== 用户相关服务 ====================
    
    /**
     * 用户登录验证服务
     * 
     * 使用方法：
     * <%
     *     boolean loginSuccess = com.ServiceLayer.userLogin("用户名", "密码");
     *     if (loginSuccess) {
     *         // 登录成功，设置session
     *         session.setAttribute("username", username);
     *     } else {
     *         // 登录失败，显示错误信息
     *     }
     * %>
     * 
     * @param username 用户名（不能为空）
     * @param password 密码（不能为空）
     * @return true-登录成功，false-登录失败
     * 
     * 注意事项：
     * - 用户名和密码不能为null或空字符串
     * - 登录成功后建议在session中保存用户信息
     */
    public static boolean userLogin(String username, String password) {
        // 参数验证
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            return false;
        }
        
        try {
            return Model.validateUser(username.trim(), password);
        } catch (Exception e) {
            System.err.println("用户登录验证失败: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * 用户注册服务
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.userRegister("新用户名", "密码");
     *     if ("success".equals(result)) {
     *         // 注册成功
     *     } else {
     *         // 注册失败，result包含错误信息
     *         out.println("注册失败：" + result);
     *     }
     * %>
     * 
     * @param username 用户名（3-20个字符，不能为空）
     * @param password 密码（6-20个字符，不能为空）
     * @return "success"-注册成功，其他-错误信息
     * 
     * 注意事项：
     * - 用户名长度限制：3-20个字符
     * - 密码长度限制：6-20个字符
     * - 用户名不能重复（数据库会自动检查）
     */
    public static String userRegister(String username, String password) {
        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            return "用户名不能为空";
        }
        if (password == null || password.trim().isEmpty()) {
            return "密码不能为空";
        }
        
        username = username.trim();
        if (username.length() < 3 || username.length() > 20) {
            return "用户名长度必须在3-20个字符之间";
        }
        if (password.length() < 6 || password.length() > 20) {
            return "密码长度必须在6-20个字符之间";
        }
        
        try {
            int result = Model.addUser(username, password);
            if (result > 0) {
                return "success";
            } else {
                return "注册失败，用户名可能已存在";
            }
        } catch (Exception e) {
            System.err.println("用户注册失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }

    /**
     * 更新用户密码
     *
     * @param userId 用户ID
     * @param newPassword 新密码
     * @return "success" 或错误信息
     */
    public static String updateUserPassword(int userId, String newPassword) {
        if (userId <= 0) {
            return "用户ID无效";
        }
        if (isEmpty(newPassword)) {
            return "新密码不能为空";
        }
        try {
            int result = Model.updateUserPassword(userId, newPassword);
            return result > 0 ? "success" : "更新失败";
        } catch (Exception e) {
            System.err.println("更新用户密码失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }

    /**
     * 更新用户资料
     */
    public static String updateUserProfile(int userId, String displayName, String avatar) {
        if (userId <= 0) {
            return "用户ID无效";
        }
        try {
            int result = Model.updateUserProfile(userId, displayName, avatar);
            return result > 0 ? "success" : "更新失败";
        } catch (Exception e) {
            System.err.println("更新用户资料失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    // ==================== 管理员相关服务 ====================
    
    /**
     * 管理员登录验证服务
     * 
     * 使用方法：
     * <%
     *     boolean adminLogin = com.ServiceLayer.adminLogin("管理员用户名", "密码");
     *     if (adminLogin) {
     *         session.setAttribute("admin", username);
     *         response.sendRedirect("admin/dashboard.jsp");
     *     } else {
     *         out.println("管理员登录失败");
     *     }
     * %>
     * 
     * @param username 管理员用户名
     * @param password 管理员密码
     * @return true-登录成功，false-登录失败
     */
    public static boolean adminLogin(String username, String password) {
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            return false;
        }
        
        try {
            return Model.validateAdmin(username.trim(), password);
        } catch (Exception e) {
            System.err.println("管理员登录验证失败: " + e.getMessage());
            return false;
        }
    }

    /**
     * 更新管理员密码
     */
    public static String updateAdminPassword(int adminId, String newPassword) {
        if (adminId <= 0) {
            return "管理员ID无效";
        }
        if (isEmpty(newPassword)) {
            return "新密码不能为空";
        }
        try {
            int result = Model.updateAdminPassword(adminId, newPassword);
            return result > 0 ? "success" : "更新失败";
        } catch (Exception e) {
            System.err.println("更新管理员密码失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    // ==================== 商品相关服务 ====================
    
    /**
     * 获取所有商品列表服务
     * 
     * 使用方法：
     * <%
     *     List<com.Product> products = com.ServiceLayer.getAllProducts();
     *     for (com.Product product : products) {
     *         out.println("商品名：" + product.name);
     *         out.println("价格：" + product.price);
     *         out.println("库存：" + product.stock);
     *     }
     * %>
     * 
     * @return 商品列表，如果没有商品或出错则返回空列表
     * 
     * 注意事项：
     * - 返回的列表永远不会为null，最多是空列表
     * - 商品按照数据库中的顺序返回
     */
    public static List<Product> getAllProducts() {
        try {
            List<Product> products = Model.getAllProducts();
            return products != null ? products : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("获取商品列表失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * 根据ID获取单个商品服务
     * 
     * 使用方法：
     * <%
     *     int productId = Integer.parseInt(request.getParameter("id"));
     *     com.Product product = com.ServiceLayer.getProductById(productId);
     *     if (product != null) {
     *         out.println("商品详情：" + product.name);
     *     } else {
     *         out.println("商品不存在");
     *     }
     * %>
     * 
     * @param productId 商品ID（必须大于0）
     * @return 商品对象，如果不存在则返回null
     */
    public static Product getProductById(int productId) {
        if (productId <= 0) {
            return null;
        }
        
        try {
            return Model.getProductById(productId);
        } catch (Exception e) {
            System.err.println("获取商品详情失败: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * 添加新商品服务（管理员功能）
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.addProduct("小米手机", 2999.0, 100, "高性能智能手机");
     *     if ("success".equals(result)) {
     *         out.println("商品添加成功");
     *     } else {
     *         out.println("添加失败：" + result);
     *     }
     * %>
     * 
     * @param name 商品名称（不能为空，最长50字符）
     * @param price 商品价格（必须大于0）
     * @param stock 库存数量（必须大于等于0）
     * @param description 商品描述（可以为空，最长200字符）
     * @return "success"-添加成功，其他-错误信息
     */
    public static String addProduct(String name, double price, int stock, String description) {
        // 参数验证
        if (name == null || name.trim().isEmpty()) {
            return "商品名称不能为空";
        }
        if (name.trim().length() > 50) {
            return "商品名称不能超过50个字符";
        }
        if (price <= 0) {
            return "商品价格必须大于0";
        }
        if (stock < 0) {
            return "库存数量不能为负数";
        }
        if (description != null && description.length() > 200) {
            return "商品描述不能超过200个字符";
        }
        
        try {
            int result = Model.addProduct(name.trim(), price, stock, description);
            if (result > 0) {
                return "success";
            } else {
                return "添加商品失败";
            }
        } catch (Exception e) {
            System.err.println("添加商品失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    /**
     * 更新商品信息服务（管理员功能）
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.updateProduct(1, "小米手机Pro", 3299.0, 50, "升级版智能手机");
     *     if ("success".equals(result)) {
     *         out.println("商品更新成功");
     *     } else {
     *         out.println("更新失败：" + result);
     *     }
     * %>
     * 
     * @param productId 商品ID（必须大于0）
     * @param name 新的商品名称
     * @param price 新的商品价格
     * @param stock 新的库存数量
     * @param description 新的商品描述
     * @return "success"-更新成功，其他-错误信息
     */
    public static String updateProduct(int productId, String name, double price, int stock, String description) {
        if (productId <= 0) {
            return "商品ID无效";
        }
        
        // 复用添加商品的验证逻辑
        String validation = addProduct(name, price, stock, description);
        if (!"success".equals(validation)) {
            return validation;
        }
        
        try {
            int result = Model.updateProduct(productId, name.trim(), price, stock, description);
            if (result > 0) {
                return "success";
            } else {
                return "商品不存在或更新失败";
            }
        } catch (Exception e) {
            System.err.println("更新商品失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    /**
     * 删除商品服务（管理员功能）
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.deleteProduct(1);
     *     if ("success".equals(result)) {
     *         out.println("商品删除成功");
     *     } else {
     *         out.println("删除失败：" + result);
     *     }
     * %>
     * 
     * @param productId 要删除的商品ID
     * @return "success"-删除成功，其他-错误信息
     * 
     * 注意事项：
     * - 删除商品前请确认该商品没有关联的订单
     * - 删除操作不可恢复
     */
    public static String deleteProduct(int productId) {
        if (productId <= 0) {
            return "商品ID无效";
        }
        
        try {
            int result = Model.deleteProduct(productId);
            if (result > 0) {
                return "success";
            } else {
                return "商品不存在或删除失败";
            }
        } catch (Exception e) {
            System.err.println("删除商品失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    // ==================== 订单相关服务 ====================
    
    /**
     * 创建订单服务
     * 
     * 使用方法：
     * <%
     *     List<com.CartItem> cartItems = new ArrayList<>();
     *     com.CartItem item = new com.CartItem();
     *     item.productId = 1;
     *     item.quantity = 2;
     *     item.price = 2999.0;
     *     cartItems.add(item);
     *     
     *     String result = com.ServiceLayer.createOrder(userId, cartItems);
     *     if ("success".equals(result)) {
     *         out.println("订单创建成功");
     *     } else {
     *         out.println("创建失败：" + result);
     *     }
     * %>
     * 
     * @param userId 用户ID（必须大于0）
     * @param cartItems 购物车商品列表（不能为空）
     * @return "success"-创建成功，其他-错误信息
     * 
     * 注意事项：
     * - 购物车不能为空
     * - 每个商品的数量必须大于0
     * - 商品价格必须大于0
     */
    public static String createOrder(int userId, List<CartItem> cartItems) {
        if (userId <= 0) {
            return "用户ID无效";
        }
        if (cartItems == null || cartItems.isEmpty()) {
            return "购物车不能为空";
        }
        
        // 验证购物车商品
        for (CartItem item : cartItems) {
            if (item.productId <= 0) {
                return "商品ID无效";
            }
            if (item.quantity <= 0) {
                return "商品数量必须大于0";
            }
            if (item.price <= 0) {
                return "商品价格必须大于0";
            }
        }
        
        try {
            int result = Model.createOrder(userId, cartItems);
            if (result > 0) {
                return "success";
            } else {
                return "创建订单失败";
            }
        } catch (Exception e) {
            System.err.println("创建订单失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    /**
     * 获取用户订单列表服务
     * 
     * 使用方法：
     * <%
     *     int userId = (Integer) session.getAttribute("userId");
     *     List<com.Order> orders = com.ServiceLayer.getUserOrders(userId);
     *     for (com.Order order : orders) {
     *         out.println("订单号：" + order.id);
     *         out.println("订单状态：" + order.status);
     *         out.println("订单总额：" + order.total);
     *     }
     * %>
     * 
     * @param userId 用户ID
     * @return 用户的订单列表，按时间倒序排列
     */
    public static List<Order> getUserOrders(int userId) {
        if (userId <= 0) {
            return new ArrayList<>();
        }
        
        try {
            List<Order> orders = Model.getOrdersByUser(userId);
            return orders != null ? orders : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("获取用户订单失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * 获取所有订单列表服务（管理员功能）
     * 
     * 使用方法：
     * <%
     *     List<com.Order> allOrders = com.ServiceLayer.getAllOrders();
     *     for (com.Order order : allOrders) {
     *         out.println("用户ID：" + order.userId);
     *         out.println("订单状态：" + order.status);
     *     }
     * %>
     * 
     * @return 所有订单列表，按时间倒序排列
     */
    public static List<Order> getAllOrders() {
        try {
            List<Order> orders = Model.getAllOrders();
            return orders != null ? orders : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("获取所有订单失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * 更新订单状态服务（管理员功能）
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.updateOrderStatus(orderId, "已发货");
     *     if ("success".equals(result)) {
     *         out.println("订单状态更新成功");
     *     } else {
     *         out.println("更新失败：" + result);
     *     }
     * %>
     * 
     * @param orderId 订单ID
     * @param status 新的订单状态（如："未发货"、"已发货"、"已完成"、"已取消"）
     * @return "success"-更新成功，其他-错误信息
     * 
     * 常用订单状态：
     * - "未发货" - 订单已创建，等待发货
     * - "已发货" - 订单已发货，等待收货
     * - "已完成" - 订单已完成
     * - "已取消" - 订单已取消
     */
    public static String updateOrderStatus(int orderId, String status) {
        if (orderId <= 0) {
            return "订单ID无效";
        }
        if (status == null || status.trim().isEmpty()) {
            return "订单状态不能为空";
        }
        
        try {
            int result = Model.updateOrderStatus(orderId, status.trim());
            if (result > 0) {
                return "success";
            } else {
                return "订单不存在或更新失败";
            }
        } catch (Exception e) {
            System.err.println("更新订单状态失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    // ==================== 售后相关服务 ====================
    
    /**
     * 绑定用户商品服务（用于售后管理）
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.bindUserProduct(userId, productId, "SN123456789");
     *     if ("success".equals(result)) {
     *         out.println("商品绑定成功");
     *     } else {
     *         out.println("绑定失败：" + result);
     *     }
     * %>
     * 
     * @param userId 用户ID
     * @param productId 商品ID
     * @param serialNumber 商品序列号
     * @return "success"-绑定成功，其他-错误信息
     */
    public static String bindUserProduct(int userId, int productId, String serialNumber) {
        if (userId <= 0) {
            return "用户ID无效";
        }
        if (productId <= 0) {
            return "商品ID无效";
        }
        if (serialNumber == null || serialNumber.trim().isEmpty()) {
            return "商品序列号不能为空";
        }
        
        try {
            int result = Model.addUserProduct(userId, productId, serialNumber.trim());
            if (result > 0) {
                return "success";
            } else {
                return "绑定商品失败";
            }
        } catch (Exception e) {
            System.err.println("绑定用户商品失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    /**
     * 获取用户绑定的商品列表服务
     * 
     * 使用方法：
     * <%
     *     List<com.UserProduct> userProducts = com.ServiceLayer.getUserProducts(userId);
     *     for (com.UserProduct up : userProducts) {
     *         out.println("商品名：" + up.productName);
     *         out.println("序列号：" + up.sn);
     *         out.println("售后状态：" + up.afterSaleStatus);
     *     }
     * %>
     * 
     * @param userId 用户ID
     * @return 用户绑定的商品列表
     */
    public static List<UserProduct> getUserProducts(int userId) {
        if (userId <= 0) {
            return new ArrayList<>();
        }
        
        try {
            List<UserProduct> products = Model.getUserProducts(userId);
            return products != null ? products : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("获取用户商品失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * 申请售后服务
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.applyAfterSale(userProductId);
     *     if ("success".equals(result)) {
     *         out.println("售后申请提交成功");
     *     } else {
     *         out.println("申请失败：" + result);
     *     }
     * %>
     * 
     * @param userProductId 用户商品绑定ID
     * @return "success"-申请成功，其他-错误信息
     */
    public static String applyAfterSale(int userProductId) {
        if (userProductId <= 0) {
            return "商品绑定ID无效";
        }
        
        try {
            int result = Model.applyAfterSale(userProductId);
            if (result > 0) {
                return "success";
            } else {
                return "售后申请失败";
            }
        } catch (Exception e) {
            System.err.println("申请售后失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    /**
     * 更新售后状态服务（管理员功能）
     * 
     * 使用方法：
     * <%
     *     String result = com.ServiceLayer.updateAfterSaleStatus(userProductId, "已处理");
     *     if ("success".equals(result)) {
     *         out.println("售后状态更新成功");
     *     } else {
     *         out.println("更新失败：" + result);
     *     }
     * %>
     * 
     * @param userProductId 用户商品绑定ID
     * @param status 新的售后状态（如："申请中"、"处理中"、"已处理"、"已拒绝"）
     * @return "success"-更新成功，其他-错误信息
     * 
     * 常用售后状态：
     * - "申请中" - 用户刚提交售后申请
     * - "处理中" - 管理员正在处理
     * - "已处理" - 售后已完成
     * - "已拒绝" - 售后申请被拒绝
     */
    public static String updateAfterSaleStatus(int userProductId, String status) {
        if (userProductId <= 0) {
            return "商品绑定ID无效";
        }
        if (status == null || status.trim().isEmpty()) {
            return "售后状态不能为空";
        }
        
        try {
            int result = Model.updateAfterSaleStatus(userProductId, status.trim());
            if (result > 0) {
                return "success";
            } else {
                return "更新售后状态失败";
            }
        } catch (Exception e) {
            System.err.println("更新售后状态失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }

    // ==================== 广告相关服务 ====================

    /** 获取所有广告 */
    public static List<Advertisement> getAllAdvertisements() {
        try {
            List<Advertisement> ads = Model.getAllAdvertisements();
            return ads != null ? ads : new ArrayList<>();
        } catch (Exception e) {
            System.err.println("获取广告列表失败: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /** 新增广告 */
    public static String addAdvertisement(String title, String imagePath, String targetUrl, boolean enabled) {
        if (isEmpty(title)) {
            return "标题不能为空";
        }
        try {
            int r = Model.addAdvertisement(title, imagePath, targetUrl, enabled);
            return r > 0 ? "success" : "添加失败";
        } catch (Exception e) {
            System.err.println("添加广告失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }

    /** 更新广告 */
    public static String updateAdvertisement(int id, String title, String imagePath, String targetUrl, boolean enabled) {
        if (id <= 0) {
            return "广告ID无效";
        }
        if (isEmpty(title)) {
            return "标题不能为空";
        }
        try {
            int r = Model.updateAdvertisement(id, title, imagePath, targetUrl, enabled);
            return r > 0 ? "success" : "更新失败";
        } catch (Exception e) {
            System.err.println("更新广告失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }

    /** 删除广告 */
    public static String deleteAdvertisement(int id) {
        if (id <= 0) {
            return "广告ID无效";
        }
        try {
            int r = Model.deleteAdvertisement(id);
            return r > 0 ? "success" : "删除失败";
        } catch (Exception e) {
            System.err.println("删除广告失败: " + e.getMessage());
            return "系统错误，请稍后重试";
        }
    }
    
    // ==================== 工具方法 ====================
    
    /**
     * 格式化价格显示
     * 
     * 使用方法：
     * <%
     *     String formattedPrice = com.ServiceLayer.formatPrice(2999.0);
     *     out.println("价格：" + formattedPrice); // 输出：价格：¥2,999.00
     * %>
     * 
     * @param price 价格
     * @return 格式化后的价格字符串
     */
    public static String formatPrice(double price) {
        return String.format("¥%.2f", price);
    }
    
    /**
     * 格式化时间显示
     * 
     * 使用方法：
     * <%
     *     String formattedTime = com.ServiceLayer.formatDateTime(order.orderDate);
     *     out.println("下单时间：" + formattedTime);
     * %>
     * 
     * @param timestamp 时间戳
     * @return 格式化后的时间字符串
     */
    public static String formatDateTime(Timestamp timestamp) {
        if (timestamp == null) {
            return "未知时间";
        }
        return timestamp.toString().substring(0, 19); // 去掉毫秒部分
    }
    
    /**
     * 检查字符串是否为空或null
     * 
     * @param str 要检查的字符串
     * @return true-为空，false-不为空
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * 安全的字符串转整数
     * 
     * 使用方法：
     * <%
     *     int productId = com.ServiceLayer.safeParseInt(request.getParameter("id"), 0);
     *     if (productId > 0) {
     *         // 处理商品ID
     *     }
     * %>
     * 
     * @param str 要转换的字符串
     * @param defaultValue 转换失败时的默认值
     * @return 转换后的整数或默认值
     */
    public static int safeParseInt(String str, int defaultValue) {
        if (str == null || str.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * 安全的字符串转双精度浮点数
     * 
     * @param str 要转换的字符串
     * @param defaultValue 转换失败时的默认值
     * @return 转换后的双精度浮点数或默认值
     */
    public static double safeParseDouble(String str, double defaultValue) {
        if (str == null || str.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}