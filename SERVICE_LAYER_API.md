# ServiceLayer 接口详解

本文档列出 `src/com/ServiceLayer.java` 中的公开静态方法，帮助 JSP 页面开发时快速寻找需要的接口。每个方法都带有简要的支持说明，更详细的使用示例可查看测试页面和源代码注释。

## 用户相关
### `boolean userLogin(String username, String password)`
验证用户用户名和密码，成功时返回 `true`，失败时返回 `false`。
- **username**: 用户名，不能为空
- **password**: 密码，不能为空

### `String userRegister(String username, String password)`
添加新用户。返回 "success" 表示注册成功，其他字符串表示错误信息。
- **username**: 3–20 个字符的用户名
- **password**: 6–20 个字符的密码

### `String updateUserPassword(int userId, String newPassword)`
修改指定用户的密码。返回 "success" 或错误提示。
- **userId**: 用户 ID
- **newPassword**: 新密码

### `String updateUserProfile(int userId, String displayName, String avatar)`
更新用户显示名和头像地址。返回 "success" 或错误提示。
- **userId**: 用户 ID
- **displayName**: 显示名，可以为空
- **avatar**: 头像图片 URL，可以为空

### `User getUserById(int userId)`
根据用户 ID 获取完整的用户信息对象，未找到时返回 `null`。
- **userId**: 用户 ID

### `String getUserAvatar(int userId)`
快捷获取用户头像地址，若不存在则返回 `null`。
- **userId**: 用户 ID

## 管理员相关
### `boolean adminLogin(String username, String password)`
根据管理员帐号验证登录，成功返回 `true`。
- **username**: 管理员用户名
- **password**: 管理员密码

### `String updateAdminPassword(int adminId, String newPassword)`
更新管理员密码。返回 "success" 或错误提示。
- **adminId**: 管理员 ID
- **newPassword**: 新密码

## 商品相关
### `List<Product> getAllProducts()`
获取所有商品列表，如果无数据返回空列表。

### `Product getProductById(int productId)`
根据 ID 查看單个商品。若未找到，返回 `null`。
- **productId**: 商品 ID

### `String addProduct(String name, double price, int stock, String description)`
新增商品，成功时返回 "success"。
- **name**: 商品名称
- **price**: 商品价格
- **stock**: 库存数量
- **description**: 描述，可以为空

### `String updateProduct(int productId, String name, double price, int stock, String description)`
修改已存在的商品信息，返回操作结果。
- **productId**: 商品 ID
- **name**: 新商品名称
- **price**: 新价格
- **stock**: 新库存
- **description**: 新描述

### `String deleteProduct(int productId)`
删除指定商品，返回 "success" 或错误信息。
- **productId**: 要删除的商品 ID

## 订单相关
### `String createOrder(int userId, List<CartItem> cartItems)`
根据购物车创建订单，返回 "success" 或错误提示。
- **userId**: 主义为所属用户 ID
- **cartItems**: 包含商品信息的列表

### `List<Order> getUserOrders(int userId)`
获取指定用户的所有订单。
- **userId**: 用户 ID

### `List<Order> getAllOrders()`
获取全部订单列表，限于管理员使用。

### `String updateOrderStatus(int orderId, String status)`
更新订单状态（例如“已发货”）。返回 "success" 或错误提示。
- **orderId**: 订单 ID
- **status**: 新状态字符串

## 售后相关
### `String bindUserProduct(int userId, int productId, String serialNumber)`
为用户绑定实际产品序列号，无错返回 "success"。
- **userId**: 用户 ID
- **productId**: 商品 ID
- **serialNumber**: 实物序列号

### `List<UserProduct> getUserProducts(int userId)`
获取用户绑定的所有产品信息。
- **userId**: 用户 ID

### `String applyAfterSale(int userProductId)`
提交品质或维修等售后申请，成功返回 "success"。
- **userProductId**: 用户产品绑定 ID

### `String updateAfterSaleStatus(int userProductId, String status)`
更新售后处理状态，返回工作结果。
- **userProductId**: 用户产品绑定 ID
- **status**: 新售后状态

## 广告相关
### `List<Advertisement> getAllAdvertisements()`
返回当前所有广告信息的列表，如无列表前置空列表。

### `String addAdvertisement(String title, String imagePath, String targetUrl, boolean enabled)`
新建一条广告，返回 "success"或错误提示。
- **title**: 标题
- **imagePath**: 图片地址
- **targetUrl**: 跳转地址
- **enabled**: 是否显示

### `String updateAdvertisement(int id, String title, String imagePath, String targetUrl, boolean enabled)`
修改现有广告信息，返回 "success"或错误。
- **id**: 广告 ID
- **title**: 标题
- **imagePath**: 图片地址
- **targetUrl**: 跳转地址
- **enabled**: 是否显示

### `String deleteAdvertisement(int id)`
删除指定广告。
- **id**: 广告 ID

## 工具方法
### `String formatPrice(double price)`
格式化价格，返回“¥xx.xx”字符串。

### `String formatDateTime(Timestamp timestamp)`
将 `Timestamp` 转成字符串 "yyyy-MM-dd HH:mm:ss" 格式。

### `boolean isEmpty(String str)`
判断字符串是否为空或 null。

### `int safeParseInt(String str, int defaultValue)`
将字符串安全转换为 int，失败时返回默认值。

### `double safeParseDouble(String str, double defaultValue)`
将字符串安全转换为 double，失败时返回默认值。
