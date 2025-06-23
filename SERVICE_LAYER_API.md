# ServiceLayer API 文档

`ServiceLayer` 位于 `src/com/ServiceLayer.java`，所有方法均为 `public static`，JSP 页面可以直接通过 `ServiceLayer.method(...)` 调用。该层负责在 JSP 与 `Model`/DAO 之间做隔离，捕获 `SQLException` 并返回简单的结果类型（对象、集合、布尔值或 `null`）。

下文按业务模块列出主要接口及说明。

## 用户相关

| 方法 | 说明 |
| --- | --- |
| `User login(String username, String password)` | 验证用户名和密码，成功返回 `User`，失败返回 `null` |
| `boolean register(User user)` | 新建用户，成功返回 `true` |
| `User getUserById(int id)` | 根据用户 ID 查询资料 |
| `List<User> listAllUsers()` | 列出所有用户（管理员功能） |
| `List<User> getAllUsers()` | `listAllUsers()` 的别名 |
| `List<User> searchUsers(String keyword)` | 按用户名关键字模糊搜索 |
| `boolean updateUser(User user)` | 更新用户信息 |
| `boolean deleteUser(int id)` | 删除指定用户 |
| `boolean deleteUserById(int id)` | `deleteUser` 的别名 |
| `boolean batchDeleteUsers(int[] ids)` | 批量删除用户 |

## 商品与分类

| 方法 | 说明 |
| --- | --- |
| `List<Product> listProducts()` | 获取所有商品 |
| `List<Product> listProductsByCategory(int categoryId)` | 按分类列出商品 |
| `Product getProductById(int id)` | 根据 ID 获取商品详情 |
| `boolean addProduct(Product p)` | 新增商品（管理员） |
| `boolean updateProduct(Product p)` | 更新商品信息（管理员） |
| `boolean deleteProduct(int id)` | 删除商品（管理员） |
| `List<ProductImage> listProductImages(int productId)` | 查询商品主图列表 |
| `ProductImage getProductImageById(int id)` | 获取单个商品图片 |
| `boolean addProductImage(ProductImage img)` | 新增商品主图 |
| `boolean updateProductImage(ProductImage img)` | 更新商品主图 |
| `boolean deleteProductImage(int id)` | 删除商品主图 |
| `List<ProductExtraImage> listProductExtraImages(int productId, String type)` | 获取商品附加图片（介绍图等） |
| `ProductExtraImage getProductExtraImageById(int id)` | 查询单个附加图片 |
| `boolean addProductExtraImage(ProductExtraImage img)` | 新增附加图片 |
| `boolean updateProductExtraImage(ProductExtraImage img)` | 更新附加图片 |
| `boolean deleteProductExtraImage(int id)` | 删除附加图片 |
| `List<Category> listCategories()` | 查询所有分类 |
| `boolean addCategory(Category c)` | 新建分类（管理员） |
| `boolean updateCategory(Category c)` | 更新分类（管理员） |
| `boolean deleteCategory(int id)` | 删除分类（管理员） |

## 地址与购物车

| 方法 | 说明 |
| --- | --- |
| `List<Address> getAddresses(int userId)` | 获取用户的所有地址 |
| `List<Address> getAllAddresses()` | 获取系统中全部地址 |
| `boolean addAddress(Address a)` | 新增地址 |
| `boolean updateAddress(Address a)` | 修改地址 |
| `boolean deleteAddress(int id)` | 删除地址（若被订单引用则返回 `false`） |
| `boolean addressHasOrders(int addressId)` | 检查地址是否被订单引用 |
| `void setDefaultAddress(int userId, int addressId)` | 设置默认收货地址 |
| `List<CartItem> getCartItems(int userId)` | 获取购物车列表 |
| `boolean addToCart(CartItem item)` | 加入购物车 |
| `boolean updateCartItem(int id, int qty)` | 修改购物车数量 |
| `boolean removeCartItem(int id)` | 移除购物车条目 |

## 订单与 SN 码

| 方法 | 说明 |
| --- | --- |
| `boolean createOrder(Order o)` | 创建订单并返回是否成功 |
| `Order getOrderById(int id)` | 根据 ID 查询订单 |
| `List<Order> getOrdersByUser(int userId)` | 查看用户自己的订单 |
| `List<Order> listAllOrders()` | 管理员查看全部订单 |
| `boolean updateOrderStatus(int id, String status)` | 修改订单状态 |
| `boolean markOrderPaid(int id)` | 标记订单已付款 |
| `boolean cancelOrder(int id)` | 取消订单（状态置为 `CANCELLED`） |
| `boolean addOrderItems(int orderId, List<OrderItem> items)` | 批量插入订单明细 |
| `List<OrderItem> getOrderItems(int orderId)` | 查询订单明细 |
| `void generateSNCodes(int productId, int size, int batchId)` | 批量生成 SN 码 |
| `List<SNCode> listSNCodes(int productId, String status)` | 根据商品和状态列出 SN |
| `SNCode getSNCodeByCode(String code)` | 按 SN 编码查询记录 |
| `Integer getProductIdBySN(String code)` | 根据 SN 查询关联商品 ID |
| `List<SNCode> getSNCodesByOrder(int orderId)` | 获取订单生成的 SN 码（假设批次号即订单号） |
| `boolean updateSNStatus(String code, String status)` | 修改 SN 状态 |
| `boolean deleteSNCodes(int batchId)` | 按批次删除 SN |

## SN 绑定与售后

| 方法 | 说明 |
| --- | --- |
| `boolean bindSN(int userId, String code)` | 用户绑定 SN |
| `List<Binding> getBindingsByUser(int userId)` | 查看用户所有绑定记录 |
| `boolean adminUnbindSN(String code)` | 管理员解除绑定 |
| `boolean applyAfterSale(AfterSale a)` | 发起售后申请 |
| `List<AfterSale> getAfterSalesByUser(int userId)` | 用户查看自己的售后记录 |
| `List<AfterSale> listAllAfterSales()` | 管理员查看所有售后单 |
| `boolean updateAfterSaleStatus(int id, String status, String remark)` | 更新售后状态并记录备注 |
| `boolean closeAfterSale(int id)` | 关闭售后单 |

## 通知

| 方法 | 说明 |
| --- | --- |
| `boolean sendNotification(Notification n)` | 发送站内通知 |
| `List<Notification> getNotifications(int userId)` | 获取用户通知列表 |
| `boolean markNotificationRead(int id)` | 标记通知为已读 |
| `boolean deleteNotification(int id)` | 删除通知 |

## 调试辅助方法

`ServiceLayer` 末尾还包含三个测试辅助方法，可用于演示或排查问题：

- `testDeleteUser(int userId)`
- `testBatchDeleteUsers(int[] userIds)`
- `testUserManagementIntegrity()`

