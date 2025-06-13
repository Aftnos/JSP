# ServiceLayer 接口层使用说明

## 概述

`ServiceLayer.java` 是为JSP前端页面设计的业务服务层，封装了 `Model.java` 的数据库操作，提供简单易用、安全可靠的接口。

## 设计特点

### 1. 简单易用
- 统一的方法命名规范
- 清晰的参数和返回值
- 详细的使用示例和注释

### 2. 安全可靠
- 完整的参数验证
- 统一的错误处理
- 防止SQL注入和数据异常

### 3. 适合JSP
- 直接在JSP中调用
- 返回格式友好
- 提供格式化工具方法

## 接口分类

### 用户相关接口

#### `userLogin(String username, String password)`
**功能**：用户登录验证  
**参数**：
- `username`: 用户名（不能为空）
- `password`: 密码（不能为空）

**返回值**：`boolean`
- `true`: 登录成功
- `false`: 登录失败

**使用示例**：
```jsp
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    if (ServiceLayer.userLogin(username, password)) {
        session.setAttribute("username", username);
        response.sendRedirect("dashboard.jsp");
    } else {
        out.println("登录失败");
    }
%>
```

#### `userRegister(String username, String password)`
**功能**：用户注册  
**参数**：
- `username`: 用户名（3-20个字符）
- `password`: 密码（6-20个字符）

**返回值**：`String`
- `"success"`: 注册成功
- 其他: 错误信息

**使用示例**：
```jsp
<%
    String result = ServiceLayer.userRegister(username, password);
    if ("success".equals(result)) {
        out.println("注册成功");
    } else {
        out.println("注册失败：" + result);
    }
%>
```

### 管理员相关接口

#### `adminLogin(String username, String password)`
**功能**：管理员登录验证  
**使用方法**：与用户登录类似，但用于管理员身份验证

### 商品相关接口

#### `getAllProducts()`
**功能**：获取所有商品列表  
**返回值**：`List<Model.Product>`
- 永远不会返回null，最多返回空列表

**使用示例**：
```jsp
<%
    List<Model.Product> products = ServiceLayer.getAllProducts();
    for (Model.Product product : products) {
%>
    <div class="product">
        <h3><%= product.name %></h3>
        <p>价格：<%= ServiceLayer.formatPrice(product.price) %></p>
        <p>库存：<%= product.stock %></p>
        <p>描述：<%= product.description %></p>
    </div>
<%
    }
%>
```

#### `getProductById(int productId)`
**功能**：根据ID获取单个商品  
**参数**：
- `productId`: 商品ID（必须大于0）

**返回值**：`Model.Product`
- 商品对象或null（如果不存在）

#### `addProduct(String name, double price, int stock, String description)`
**功能**：添加新商品（管理员功能）  
**参数验证**：
- 商品名称：不能为空，最长50字符
- 价格：必须大于0
- 库存：必须大于等于0
- 描述：最长200字符

**返回值**：`String`
- `"success"`: 添加成功
- 其他: 错误信息

#### `updateProduct(int productId, String name, double price, int stock, String description)`
**功能**：更新商品信息（管理员功能）

#### `deleteProduct(int productId)`
**功能**：删除商品（管理员功能）  
**注意**：删除前请确认该商品没有关联订单

### 订单相关接口

#### `createOrder(int userId, List<Model.CartItem> cartItems)`
**功能**：创建订单  
**参数**：
- `userId`: 用户ID（必须大于0）
- `cartItems`: 购物车商品列表（不能为空）

**购物车商品验证**：
- 商品ID必须大于0
- 数量必须大于0
- 价格必须大于0

**使用示例**：
```jsp
<%
    List<Model.CartItem> cartItems = new ArrayList<>();
    
    // 添加商品到购物车
    Model.CartItem item = new Model.CartItem();
    item.productId = 1;
    item.quantity = 2;
    item.price = 2999.0;
    cartItems.add(item);
    
    // 创建订单
    int userId = (Integer) session.getAttribute("userId");
    String result = ServiceLayer.createOrder(userId, cartItems);
    
    if ("success".equals(result)) {
        out.println("订单创建成功");
    } else {
        out.println("创建失败：" + result);
    }
%>
```

#### `getUserOrders(int userId)`
**功能**：获取用户订单列表  
**返回值**：按时间倒序排列的订单列表

#### `getAllOrders()`
**功能**：获取所有订单列表（管理员功能）

#### `updateOrderStatus(int orderId, String status)`
**功能**：更新订单状态（管理员功能）  
**常用状态**：
- `"未发货"`: 订单已创建，等待发货
- `"已发货"`: 订单已发货，等待收货
- `"已完成"`: 订单已完成
- `"已取消"`: 订单已取消

### 售后相关接口

#### `bindUserProduct(int userId, int productId, String serialNumber)`
**功能**：绑定用户商品（用于售后管理）

#### `getUserProducts(int userId)`
**功能**：获取用户绑定的商品列表

#### `applyAfterSale(int userProductId)`
**功能**：申请售后服务

#### `updateAfterSaleStatus(int userProductId, String status)`
**功能**：更新售后状态（管理员功能）  
**常用状态**：
- `"申请中"`: 用户刚提交售后申请
- `"处理中"`: 管理员正在处理
- `"已处理"`: 售后已完成
- `"已拒绝"`: 售后申请被拒绝

### 工具方法

#### `formatPrice(double price)`
**功能**：格式化价格显示  
**示例**：`2999.0` → `"¥2,999.00"`

#### `formatDateTime(Timestamp timestamp)`
**功能**：格式化时间显示  
**示例**：去掉毫秒部分的时间字符串

#### `safeParseInt(String str, int defaultValue)`
**功能**：安全的字符串转整数  
**使用示例**：
```jsp
<%
    int productId = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
    if (productId > 0) {
        // 处理有效的商品ID
    }
%>
```

#### `safeParseDouble(String str, double defaultValue)`
**功能**：安全的字符串转双精度浮点数

#### `isEmpty(String str)`
**功能**：检查字符串是否为空或null

## 使用规范

### 1. 参数验证
```jsp
<%
    // 使用安全转换方法
    int id = ServiceLayer.safeParseInt(request.getParameter("id"), 0);
    if (id <= 0) {
        out.println("无效的ID");
        return;
    }
    
    // 检查字符串参数
    String name = request.getParameter("name");
    if (ServiceLayer.isEmpty(name)) {
        out.println("名称不能为空");
        return;
    }
%>
```

### 2. 错误处理
```jsp
<%
    try {
        String result = ServiceLayer.addProduct(name, price, stock, desc);
        if ("success".equals(result)) {
            out.println("操作成功");
        } else {
            out.println("操作失败：" + result);
        }
    } catch (Exception e) {
        out.println("系统错误：" + e.getMessage());
    }
%>
```

### 3. Session管理
```jsp
<%
    // 登录成功后保存用户信息
    if (ServiceLayer.userLogin(username, password)) {
        session.setAttribute("username", username);
        session.setAttribute("userId", userId); // 如果有用户ID
    }
    
    // 检查登录状态
    String currentUser = (String) session.getAttribute("username");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
```

### 4. 数据显示
```jsp
<%
    List<Model.Product> products = ServiceLayer.getAllProducts();
    if (products.isEmpty()) {
%>
    <p>暂无商品</p>
<%
    } else {
        for (Model.Product product : products) {
%>
    <div class="product-item">
        <h3><%= product.name %></h3>
        <p>价格：<%= ServiceLayer.formatPrice(product.price) %></p>
        <p>库存：<%= product.stock %></p>
    </div>
<%
        }
    }
%>
```

## 最佳实践

### 1. 统一错误处理模式
- 所有业务方法都返回统一格式
- 成功返回 `"success"`
- 失败返回具体错误信息
- 在JSP中统一检查返回值

### 2. 参数安全
- 使用 `safeParseInt` 和 `safeParseDouble` 转换数字
- 使用 `isEmpty` 检查字符串
- 在调用业务方法前进行基本验证

### 3. 用户体验
- 使用格式化方法美化显示
- 提供友好的错误提示
- 合理使用session保存状态

### 4. 性能考虑
- 避免在循环中调用数据库操作
- 合理使用缓存（如商品列表）
- 及时释放资源

## 完整示例

### 商品列表页面 (products.jsp)
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="Model.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品列表</title>
    <style>
        .product { border: 1px solid #ddd; margin: 10px; padding: 15px; }
        .price { color: #e74c3c; font-weight: bold; }
        .stock { color: #27ae60; }
    </style>
</head>
<body>
    <h1>商品列表</h1>
    
    <%
        try {
            List<Model.Product> products = ServiceLayer.getAllProducts();
            if (products.isEmpty()) {
    %>
                <p>暂无商品</p>
    <%
            } else {
                for (Model.Product product : products) {
    %>
                <div class="product">
                    <h3><%= product.name %></h3>
                    <p class="price">价格：<%= ServiceLayer.formatPrice(product.price) %></p>
                    <p class="stock">库存：<%= product.stock %></p>
                    <p>描述：<%= product.description != null ? product.description : "无描述" %></p>
                    <a href="product-detail.jsp?id=<%= product.id %>">查看详情</a>
                </div>
    <%
                }
            }
        } catch (Exception e) {
    %>
            <p style="color: red;">加载商品失败：<%= e.getMessage() %></p>
    <%
        }
    %>
</body>
</html>
```

### 用户登录页面 (login.jsp)
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>用户登录</title>
</head>
<body>
    <h1>用户登录</h1>
    
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String message = "";
        
        if (username != null && password != null) {
            if (ServiceLayer.userLogin(username, password)) {
                session.setAttribute("username", username);
                response.sendRedirect("products.jsp");
                return;
            } else {
                message = "用户名或密码错误";
            }
        }
    %>
    
    <% if (!message.isEmpty()) { %>
        <p style="color: red;"><%= message %></p>
    <% } %>
    
    <form method="post">
        <p>
            <label>用户名：</label>
            <input type="text" name="username" required>
        </p>
        <p>
            <label>密码：</label>
            <input type="password" name="password" required>
        </p>
        <p>
            <input type="submit" value="登录">
        </p>
    </form>
    
    <p><a href="register.jsp">还没有账号？点击注册</a></p>
</body>
</html>
```

## 注意事项

1. **数据库连接**：确保MySQL服务正在运行，数据库配置正确
2. **JDBC驱动**：确保项目中包含MySQL JDBC驱动
3. **异常处理**：所有数据库操作都有异常处理，但仍建议在JSP中添加try-catch
4. **安全性**：密码应该加密存储（当前版本为明文，生产环境需要改进）
5. **性能**：大量数据时考虑分页查询
6. **事务**：复杂操作时注意数据一致性

## 扩展建议

1. **添加日志**：记录重要操作和错误信息
2. **缓存机制**：对频繁查询的数据添加缓存
3. **分页支持**：为大数据量查询添加分页
4. **权限控制**：添加更细粒度的权限管理
5. **数据验证**：添加更严格的业务规则验证
6. **API文档**：生成详细的API文档

通过使用ServiceLayer，您可以快速开发出功能完整、安全可靠的JSP应用程序。