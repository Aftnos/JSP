# 小米商城 JSP 项目

这是一个使用 **JSP + JDBC** 构建的简单商城示例，主要用于学习如何在不依赖框架的情况下搭建 Web 应用。本项目模仿小米商城的基本功能，推荐在如下环境下运行：

- **JDK 1.8_202**  
- **Tomcat 9.0.106**  
- **MySQL 8.x**

项目目录中提供了数据库建表脚本以及 Windows 版 Tomcat 压缩包，可直接用于本地开发。

---

## 一、功能结构设计

1. **用户模块**  
   - 注册／登录（手机号／邮箱／第三方）  
   - 用户资料管理（查看／修改用户名、头像、联系方式、密码）  
   - 收货地址管理（增／删／改／查，设置默认）  
   - 权限管理（普通用户 vs 管理员）

2. **商品模块**  
   - 分类管理（增／删／改／查分类树）  
   - 商品管理（增／删／改／查商品信息：名称、SKU、价格、库存、上下架、图片、描述）  
   - 商品浏览（分页／筛选／搜索列表，查看详情及可用 SN 数量）

3. **购物车 & 订单模块**  
   - 购物车操作：添加、修改数量、删除、查看列表  
   - 下单流程：选择地址、生成订单、锁定库存  
   - 支付回调：标记已支付，触发 SN 分配（为每件商品生成 SN 并记录到 `sn_codes`，批次号为订单ID）
   - 订单查询：用户查看自有订单，管理员分页／筛选查看全部  
   - 订单状态管理：用户取消、管理员发货／关闭等

4. **SN 码管理模块**  
   - 批量生成 SN（唯一、定长）  
   - SN 查询：按商品、状态、批次、日期筛选、分页  
   - SN 状态更新：批量或单条改为“已售出”“已绑定”“回收”  
   - SN 删除：仅限“未售出”状态可删

5. **SN 绑定模块**  
   - 查询订单 SN：支付后查看本单分配的 SN 列表  
   - 绑定 SN：扫码／输入，校验“已售出未绑定”后，新建 binding 并改“已绑定”  
   - 查询绑定记录：查看用户所有已绑定 SN 及绑定时间、商品信息  
   - 管理员强制解绑：特殊场景下恢复 SN 状态并记录日志

6. **售后／客服模块**  
   - 发起售后（退货/保修）：前提 SN 已绑定，填写原因、可上传图片，生成工单  
   - 用户查询与补充：按状态分页查看工单，审核中可补充资料  
   - 管理员工单管理：分页／筛选查看、审核（同意/拒绝/完成）、填写意见、关闭/删除

7. **通知模块**  
   - 系统自动：订单支付、发货、完成，SN 绑定成功，售后状态变更等  
   - 用户消息中心：查看列表、标记已读/未读、删除、看详情  
   - 管理员重发／批量清理通知

---

## 二、ServiceLayer.java 方法概览

所有方法均为 `public static`，JSP 中可直接通过 `ServiceLayer.method(...)` 调用。

### 1. 用户模块  
- `login(username, password)`  
- `register(user)`  
- `getUserById(userId)`  
- `updateUserProfile(user)`  
- `changePassword(userId, oldPwd, newPwd)`  
- `getAddresses(userId)`  
- `addAddress(address)`  
- `updateAddress(address)`  
- `deleteAddress(addressId)`  
- `setDefaultAddress(userId, addressId)`

### 2. 商品模块  
- `listProducts(page, pageSize, category, keyword)`  
- `getProductById(productId)`  
- `listCategories()`  
- **管理员**：`addProduct(product)`、`updateProduct(product)`、`deleteProduct(productId)`  
- **管理员**：`addCategory(category)`、`updateCategory(category)`、`deleteCategory(categoryId)`

### 3. 购物车 & 订单模块  
- `addToCart(userId, productId, quantity)`  
- `getCartItems(userId)`  
- `updateCartItem(cartItemId, quantity)`  
- `removeCartItem(cartItemId)`  
- `createOrder(userId, cartItems, addressId)`  
- `markOrderPaid(orderId)`  
- `getOrdersByUser(userId, status, page, pageSize)`  
- `getOrderById(orderId)`  
- **管理员**：`listAllOrders(page, pageSize, statusFilter)`  
- **管理员**：`updateOrderStatus(orderId, newStatus)`

### 4. SN 码管理模块  
- **管理员**：`generateSNCodes(productId, batchSize)`  
- **管理员**：`listSNCodes(productId, status, page, pageSize)`  
- **管理员**：`updateSNStatus(snCode, newStatus)`  
- **管理员**：`deleteSNCodes(batchId)`
- `getSNCodesByOrder(orderId)`

### 5. SN 绑定模块  
- `bindSN(userId, snCode)`  
- `getBindingsByUser(userId)`  
- **管理员**：`adminUnbindSN(snCode, reason)`

### 6. 售后／客服模块  
- `applyAfterSale(userId, snCode, type, reason)`  
- `getAfterSalesByUser(userId, status, page, pageSize)`  
- `getAfterSaleDetail(afterSaleId)`  
- `supplementAfterSale(afterSaleId, content)`  
- **管理员**：`listAllAfterSales(page, pageSize, filters)`  
- **管理员**：`updateAfterSaleStatus(afterSaleId, newStatus, remark)`  
- **管理员**：`closeAfterSale(afterSaleId)`

### 7. 通知模块  
- `getNotifications(userId, readStatus, page, pageSize)`  
- `markNotificationRead(notificationId)`  
- `deleteNotification(notificationId)`  
- **（内部，不供 JSP 调用）**：  
  - `sendOrderNotification(userId, orderId, status)`  
  - `sendSNBindNotification(userId, snCode)`  
  - `sendAfterSaleNotification(userId, afterSaleId, newStatus)`

---

## 三、快速开始

1. **导入数据库**  
   ```bash
   mysql -u root -p < ProjectData/sql/schema.sql
````

修改 `src/db.properties` 中的数据库连接信息。

2. **构建与部署**

    * 将 `web` 目录部署到 Tomcat 的 `webapps` 下，或在 IDE 中配置。
    * 确保 `web/WEB-INF/lib/mysql-connector-j-8.0.33.jar` 可被加载。

3. **访问应用**
   启动 Tomcat 后，访问 `http://localhost:8080/`；`test_all_functions.jsp` 中可快速验证各项功能。

---

## 四、项目结构

```
JSP/
├── ProjectData/
│   ├── sql/schema.sql
│   └── tomcat/
├── lib/
│   └── mysql-connector-j-8.0.33.jar
├── src/
│   ├── db.properties
│   ├── ModelTest.java
│   ├── ServiceLayerTest.java
│   └── com/
│       ├── db/DBUtil.java
│       ├── dao/
│       ├── entity/
│       ├── Model.java
│       └── ServiceLayer.java
├── web/
│   ├── index.jsp
│   ├── test_all_functions.jsp
│   ├── admin/
│   │   ├── sidebar.jsp
│   │   └── css/admin-layout.css
│   └── WEB-INF/
│       ├── web.xml
│       └── lib/
└── .idea/
```

---

## 五、运行测试

在 `src` 目录下执行编译：

```bash
javac -d out -cp lib/mysql-connector-j-8.0.33.jar $(find src -name "*.java")
```

编译成功后即可将 `web` 目录部署到 Tomcat。请确保 MySQL 已启动且连接信息正确。
