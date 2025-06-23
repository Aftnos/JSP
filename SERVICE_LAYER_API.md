# ServiceLayer API 手册

`ServiceLayer` 类位于 `src/com/ServiceLayer.java`，其所有方法均为 `public static`，JSP 页面可以直接通过 `ServiceLayer.method(...)` 调用。这些方法在内部调用 `Model` 层并捕获 `SQLException`，失败时通常返回 `null`、`false` 或空集合。

## 用户相关
- **`User login(String username, String password)`**：根据用户名和密码登录，成功返回 `User` 对象，失败返回 `null`。
- **`boolean register(User user)`**：注册新用户，成功返回 `true`。
- **`User getUserById(int id)`**：按 ID 查询用户信息。
- **`List<User> getAllUsers()`**：获取所有用户列表。
- **`boolean deleteUserById(int id)`**：删除指定 ID 的用户。

## 商品相关
- **`List<Product> listProducts()`**：获取所有商品列表。
- **`Product getProductById(int id)`**：按 ID 查询商品。
- **`boolean addProduct(Product p)`**：新增商品。
- **`boolean updateProduct(Product p)`**：更新商品信息。
- **`boolean deleteProduct(int id)`**：删除指定商品。
- **`List<ProductImage> listProductImages(int productId)`**：获取商品的图片列表。
- **`ProductImage getProductImageById(int id)`**：按 ID 查询商品图片。
- **`boolean addProductImage(ProductImage img)`**：新增商品图片。
- **`boolean updateProductImage(ProductImage img)`**：更新商品图片信息。
- **`boolean deleteProductImage(int id)`**：删除指定商品图片。

## 收货地址相关
- **`List<Address> getAddresses(int userId)`**：列出用户的全部地址。
- **`boolean addAddress(Address a)`**：新增收货地址。
- **`boolean updateAddress(Address a)`**：更新收货地址。
- **`boolean deleteAddress(int id)`**：删除地址。
- **`void setDefaultAddress(int userId, int addressId)`**：设置默认地址。

## 分类相关
- **`List<Category> listCategories()`**：获取所有商品分类。
- **`boolean addCategory(Category c)`**：新增分类。
- **`boolean updateCategory(Category c)`**：更新分类。
- **`boolean deleteCategory(int id)`**：删除分类。

## 购物车相关
- **`List<CartItem> getCartItems(int userId)`**：获取用户购物车列表。
- **`boolean addToCart(CartItem item)`**：向购物车添加商品。
- **`boolean updateCartItem(int id, int qty)`**：修改购物车商品数量。
- **`boolean removeCartItem(int id)`**：从购物车移除条目。

## 订单相关
- **`boolean createOrder(Order o)`**：创建订单。
- **`Order getOrderById(int id)`**：按 ID 查询订单。
- **`List<Order> getOrdersByUser(int userId)`**：获取用户的订单列表。
- **`List<Order> listAllOrders()`**：获取全部订单（管理员）。
- **`boolean updateOrderStatus(int id, String status)`**：更新订单状态。
- **`boolean markOrderPaid(int id)`**：标记订单已付款。
- **`boolean cancelOrder(int id)`**：取消订单（将状态设为CANCELLED）。
- **`boolean addOrderItems(int orderId, List<OrderItem> items)`**：为指定订单批量添加条目。
- **`List<OrderItem> getOrderItems(int orderId)`**：获取订单的商品明细列表。

## SN 码相关
- **`void generateSNCodes(int productId, int size, int batchId)`**：批量生成 SN 码。
- **`List<SNCode> listSNCodes(int productId, String status)`**：按商品和状态查询 SN 列表。
- **`List<SNCode> getSNCodesByOrder(int orderId)`**：获取指定订单生成的 SN 列表。
- **`boolean updateSNStatus(String code, String status)`**：更新单个 SN 的状态。
- **`boolean deleteSNCodes(int batchId)`**：按批次删除 SN 码。

## 绑定记录相关
- **`boolean bindSN(int userId, String code)`**：用户绑定 SN 码。
- **`List<Binding> getBindingsByUser(int userId)`**：查询用户的绑定记录。
- **`boolean adminUnbindSN(String code)`**：管理员解绑指定 SN。

## 售后相关
- **`boolean applyAfterSale(AfterSale a)`**：提交售后申请。
- **`List<AfterSale> getAfterSalesByUser(int userId)`**：查询用户的售后记录。
- **`List<AfterSale> listAllAfterSales()`**：获取全部售后工单（管理员）。
- **`boolean updateAfterSaleStatus(int id, String status, String remark)`**：修改售后单状态并备注。
- **`boolean closeAfterSale(int id)`**：关闭售后工单。

## 通知相关
- **`boolean sendNotification(Notification n)`**：发送通知。
- **`List<Notification> getNotifications(int userId)`**：获取用户通知列表。
- **`boolean markNotificationRead(int id)`**：标记通知为已读。
- **`boolean deleteNotification(int id)`**：删除通知。

