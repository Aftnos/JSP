<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="com.entity.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>com.ServiceLayer 功能测试页面</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fafafa;
        }

        .section h2 {
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 200px;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        .form-group textarea {
            width: 300px;
            height: 60px;
        }

        .btn {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        .btn-danger {
            background-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .result {
            margin-top: 10px;
            padding: 10px;
            border-radius: 3px;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .nav {
            background-color: #007bff;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .nav a {
            color: white;
            text-decoration: none;
            margin-right: 20px;
            padding: 5px 10px;
            border-radius: 3px;
        }

        .nav a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }
    </style>
</head>
<body>
<div class="container">
    <h1>com.ServiceLayer 功能测试页面</h1>
    <p>所有ServiceLayer的方法功能封装测试</p>

    <!-- 导航菜单 -->
    <div class="nav">
        <a href="#user-section">用户功能</a>
        <a href="#admin-section">管理员功能</a>
        <a href="#product-section">商品管理</a>
        <a href="#order-section">订单管理</a>
        <a href="#aftersale-section">售后管理</a>
        <a href="#ad-section">广告管理</a>
        <a href="#utility-section">工具方法</a>
    </div>

    <%
        // 统一设置请求字符编码，解决POST提交中文乱码问题
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String result = "";
        String resultClass = "info";
    %>

    <!-- 用户功能测试 -->
    <div id="user-section" class="section">
        <h2>1. 用户功能测试</h2>

        <!-- 用户注册 -->
        <h3>用户注册</h3>
        <form method="post">
            <input type="hidden" name="action" value="userRegister">
            <div class="form-group">
                <label>用户名:</label>
                <input type="text" name="username" placeholder="3-20个字符" required>
            </div>
            <div class="form-group">
                <label>密码:</label>
                <input type="password" name="password" placeholder="6-20个字符" required>
            </div>
            <button type="submit" class="btn">注册用户</button>
        </form>

        <%
            if ("userRegister".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                result = ServiceLayer.userRegister(username, password);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            注册结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 用户登录 -->
        <h3>用户登录</h3>
        <form method="post">
            <input type="hidden" name="action" value="userLogin">
            <div class="form-group">
                <label>用户名:</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>密码:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">用户登录</button>
        </form>

        <%
            if ("userLogin".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                boolean loginSuccess = ServiceLayer.userLogin(username, password);
                result = loginSuccess ? "登录成功" : "登录失败";
                resultClass = loginSuccess ? "success" : "error";
                if (loginSuccess) {
                    session.setAttribute("username", username);
                    session.setAttribute("userId", 1); // 模拟用户ID
                }
        %>
        <div class="result <%=resultClass%>">
            登录结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 修改用户密码 -->
        <h3>修改用户密码</h3>
        <form method="post">
            <input type="hidden" name="action" value="updateUserPassword">
            <div class="form-group">
                <label>用户ID:</label>
                <input type="number" name="updateUserId" value="1" required>
            </div>
            <div class="form-group">
                <label>新密码:</label>
                <input type="password" name="newUserPassword" required>
            </div>
            <button type="submit" class="btn">修改密码</button>
        </form>

        <%
            if ("updateUserPassword".equals(action)) {
                int uid = ServiceLayer.safeParseInt(request.getParameter("updateUserId"), 0);
                String np = request.getParameter("newUserPassword");
                result = ServiceLayer.updateUserPassword(uid, np);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            修改密码结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 更新用户资料 -->
        <h3>更新用户资料</h3>
        <form method="post">
            <input type="hidden" name="action" value="updateUserProfile">
            <div class="form-group">
                <label>用户ID:</label>
                <input type="number" name="profileUserId" value="1" required>
            </div>
            <div class="form-group">
                <label>显示名称:</label>
                <input type="text" name="displayName">
            </div>
            <div class="form-group">
                <label>头像URL:</label>
                <input type="text" name="avatar">
            </div>
            <button type="submit" class="btn">更新资料</button>
        </form>

        <%
            if ("updateUserProfile".equals(action)) {
                int uid = ServiceLayer.safeParseInt(request.getParameter("profileUserId"), 0);
                String dn = request.getParameter("displayName");
                String av = request.getParameter("avatar");
                result = ServiceLayer.updateUserProfile(uid, dn, av);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            更新资料结果: <%=result%>
        </div>
        <%
            }
        %>
    </div>

    <!-- 管理员功能测试 -->
    <div id="admin-section" class="section">
        <h2>2. 管理员功能测试</h2>

        <h3>管理员登录</h3>
        <form method="post">
            <input type="hidden" name="action" value="adminLogin">
            <div class="form-group">
                <label>管理员用户名:</label>
                <input type="text" name="adminUsername" required>
            </div>
            <div class="form-group">
                <label>管理员密码:</label>
                <input type="password" name="adminPassword" required>
            </div>
            <button type="submit" class="btn">管理员登录</button>
        </form>

        <%
            if ("adminLogin".equals(action)) {
                String adminUsername = request.getParameter("adminUsername");
                String adminPassword = request.getParameter("adminPassword");
                boolean adminLoginSuccess = ServiceLayer.adminLogin(adminUsername, adminPassword);
                result = adminLoginSuccess ? "管理员登录成功" : "管理员登录失败";
                resultClass = adminLoginSuccess ? "success" : "error";
                if (adminLoginSuccess) {
                    session.setAttribute("admin", adminUsername);
                }
        %>
        <div class="result <%=resultClass%>">
            登录结果: <%=result%>
        </div>
        <%
            }
        %>
    </div>

    <!-- 商品管理测试 -->
    <div id="product-section" class="section">
        <h2>3. 商品管理测试</h2>

        <!-- 添加商品 -->
        <h3>添加商品</h3>
        <form method="post">
            <input type="hidden" name="action" value="addProduct">
            <div class="form-group">
                <label>商品名称:</label>
                <input type="text" name="productName" placeholder="最长50字符" required>
            </div>
            <div class="form-group">
                <label>商品价格:</label>
                <input type="number" name="productPrice" step="0.01" min="0.01" required>
            </div>
            <div class="form-group">
                <label>库存数量:</label>
                <input type="number" name="productStock" min="0" required>
            </div>
            <div class="form-group">
                <label>商品描述:</label>
                <textarea name="productDescription" placeholder="最长200字符"></textarea>
            </div>
            <button type="submit" class="btn">添加商品</button>
        </form>

        <%
            if ("addProduct".equals(action)) {
                String productName = request.getParameter("productName");
                double productPrice = ServiceLayer.safeParseDouble(request.getParameter("productPrice"), 0);
                int productStock = ServiceLayer.safeParseInt(request.getParameter("productStock"), 0);
                String productDescription = request.getParameter("productDescription");
                result = ServiceLayer.addProduct(productName, productPrice, productStock, productDescription);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            添加商品结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 更新商品 -->
        <h3>更新商品</h3>
        <form method="post">
            <input type="hidden" name="action" value="updateProduct">
            <div class="form-group">
                <label>商品ID:</label>
                <input type="number" name="updateProductId" min="1" required>
            </div>
            <div class="form-group">
                <label>商品名称:</label>
                <input type="text" name="updateProductName" required>
            </div>
            <div class="form-group">
                <label>商品价格:</label>
                <input type="number" name="updateProductPrice" step="0.01" min="0.01" required>
            </div>
            <div class="form-group">
                <label>库存数量:</label>
                <input type="number" name="updateProductStock" min="0" required>
            </div>
            <div class="form-group">
                <label>商品描述:</label>
                <textarea name="updateProductDescription"></textarea>
            </div>
            <button type="submit" class="btn">更新商品</button>
        </form>

        <%
            if ("updateProduct".equals(action)) {
                int updateProductId = ServiceLayer.safeParseInt(request.getParameter("updateProductId"), 0);
                String updateProductName = request.getParameter("updateProductName");
                double updateProductPrice = ServiceLayer.safeParseDouble(request.getParameter("updateProductPrice"), 0);
                int updateProductStock = ServiceLayer.safeParseInt(request.getParameter("updateProductStock"), 0);
                String updateProductDescription = request.getParameter("updateProductDescription");
                result = ServiceLayer.updateProduct(updateProductId, updateProductName, updateProductPrice, updateProductStock, updateProductDescription);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            更新商品结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 删除商品 -->
        <h3>删除商品</h3>
        <form method="post">
            <input type="hidden" name="action" value="deleteProduct">
            <div class="form-group">
                <label>商品ID:</label>
                <input type="number" name="deleteProductId" min="1" required>
            </div>
            <button type="submit" class="btn btn-danger">删除商品</button>
        </form>

        <%
            if ("deleteProduct".equals(action)) {
                int deleteProductId = ServiceLayer.safeParseInt(request.getParameter("deleteProductId"), 0);
                result = ServiceLayer.deleteProduct(deleteProductId);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            删除商品结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 查看所有商品 -->
        <h3>所有商品列表</h3>
        <form method="post">
            <input type="hidden" name="action" value="getAllProducts">
            <button type="submit" class="btn">获取所有商品</button>
        </form>

        <%
            if ("getAllProducts".equals(action)) {
                List<Product> products = ServiceLayer.getAllProducts();
        %>
        <div class="result info">
            <h4>商品列表 (共<%=products.size()%>个商品):</h4>
            <% if (products.size() > 0) { %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>名称</th>
                    <th>价格</th>
                    <th>库存</th>
                    <th>描述</th>
                </tr>
                <% for (Product product : products) { %>
                <tr>
                    <td><%=product.id%>
                    </td>
                    <td><%=product.name%>
                    </td>
                    <td><%=ServiceLayer.formatPrice(product.price)%>
                    </td>
                    <td><%=product.stock%>
                    </td>
                    <td><%=product.description != null ? product.description : "无描述"%>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p>暂无商品</p>
            <% } %>
        </div>
        <%
            }
        %>

        <!-- 根据ID获取商品 -->
        <h3>根据ID获取商品</h3>
        <form method="post">
            <input type="hidden" name="action" value="getProductById">
            <div class="form-group">
                <label>商品ID:</label>
                <input type="number" name="getProductId" min="1" required>
            </div>
            <button type="submit" class="btn">获取商品详情</button>
        </form>

        <%
            if ("getProductById".equals(action)) {
                int getProductId = ServiceLayer.safeParseInt(request.getParameter("getProductId"), 0);
                Product product = ServiceLayer.getProductById(getProductId);
        %>
        <div class="result info">
            <% if (product != null) { %>
            <h4>商品详情:</h4>
            <p><strong>ID:</strong> <%=product.id%>
            </p>
            <p><strong>名称:</strong> <%=product.name%>
            </p>
            <p><strong>价格:</strong> <%=ServiceLayer.formatPrice(product.price)%>
            </p>
            <p><strong>库存:</strong> <%=product.stock%>
            </p>
            <p><strong>描述:</strong> <%=product.description != null ? product.description : "无描述"%>
            </p>
            <% } else { %>
            <p>商品不存在</p>
            <% } %>
        </div>
        <%
            }
        %>
    </div>

    <!-- 订单管理测试 -->
    <div id="order-section" class="section">
        <h2>4. 订单管理测试</h2>

        <!-- 创建订单 -->
        <h3>创建订单</h3>
        <form method="post">
            <input type="hidden" name="action" value="createOrder">
            <div class="form-group">
                <label>用户ID:</label>
                <input type="number" name="orderUserId" min="1" value="1" required>
            </div>
            <div class="form-group">
                <label>商品ID:</label>
                <input type="number" name="orderProductId" min="1" required>
            </div>
            <div class="form-group">
                <label>商品数量:</label>
                <input type="number" name="orderQuantity" min="1" required>
            </div>
            <div class="form-group">
                <label>商品价格:</label>
                <input type="number" name="orderPrice" step="0.01" min="0.01" required>
            </div>
            <button type="submit" class="btn">创建订单</button>
        </form>

        <%
            if ("createOrder".equals(action)) {
                int orderUserId = ServiceLayer.safeParseInt(request.getParameter("orderUserId"), 0);
                int orderProductId = ServiceLayer.safeParseInt(request.getParameter("orderProductId"), 0);
                int orderQuantity = ServiceLayer.safeParseInt(request.getParameter("orderQuantity"), 0);
                double orderPrice = ServiceLayer.safeParseDouble(request.getParameter("orderPrice"), 0);

                List<CartItem> cartItems = new ArrayList<>();
                CartItem item = new CartItem();
                item.productId = orderProductId;
                item.quantity = orderQuantity;
                item.price = orderPrice;
                cartItems.add(item);

                result = ServiceLayer.createOrder(orderUserId, cartItems);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            创建订单结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 获取用户订单 -->
        <h3>获取用户订单</h3>
        <form method="post">
            <input type="hidden" name="action" value="getUserOrders">
            <div class="form-group">
                <label>用户ID:</label>
                <input type="number" name="getUserOrdersId" min="1" value="1" required>
            </div>
            <button type="submit" class="btn">获取用户订单</button>
        </form>

        <%
            if ("getUserOrders".equals(action)) {
                int getUserOrdersId = ServiceLayer.safeParseInt(request.getParameter("getUserOrdersId"), 0);
                List<Order> userOrders = ServiceLayer.getUserOrders(getUserOrdersId);
        %>
        <div class="result info">
            <h4>用户订单列表 (共<%=userOrders.size()%>个订单):</h4>
            <% if (userOrders.size() > 0) { %>
            <table>
                <tr>
                    <th>订单ID</th>
                    <th>用户ID</th>
                    <th>订单时间</th>
                    <th>状态</th>
                    <th>总金额</th>
                </tr>
                <% for (Order order : userOrders) { %>
                <tr>
                    <td><%=order.id%>
                    </td>
                    <td><%=order.userId%>
                    </td>
                    <td><%=ServiceLayer.formatDateTime(order.orderDate)%>
                    </td>
                    <td><%=order.status%>
                    </td>
                    <td><%=ServiceLayer.formatPrice(order.total)%>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p>该用户暂无订单</p>
            <% } %>
        </div>
        <%
            }
        %>

        <!-- 获取所有订单 -->
        <h3>获取所有订单（管理员功能）</h3>
        <form method="post">
            <input type="hidden" name="action" value="getAllOrders">
            <button type="submit" class="btn">获取所有订单</button>
        </form>

        <%
            if ("getAllOrders".equals(action)) {
                List<Order> allOrders = ServiceLayer.getAllOrders();
        %>
        <div class="result info">
            <h4>所有订单列表 (共<%=allOrders.size()%>个订单):</h4>
            <% if (allOrders.size() > 0) { %>
            <table>
                <tr>
                    <th>订单ID</th>
                    <th>用户ID</th>
                    <th>订单时间</th>
                    <th>状态</th>
                    <th>总金额</th>
                </tr>
                <% for (Order order : allOrders) { %>
                <tr>
                    <td><%=order.id%>
                    </td>
                    <td><%=order.userId%>
                    </td>
                    <td><%=ServiceLayer.formatDateTime(order.orderDate)%>
                    </td>
                    <td><%=order.status%>
                    </td>
                    <td><%=ServiceLayer.formatPrice(order.total)%>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p>暂无订单</p>
            <% } %>
        </div>
        <%
            }
        %>

        <!-- 更新订单状态 -->
        <h3>更新订单状态（管理员功能）</h3>
        <form method="post">
            <input type="hidden" name="action" value="updateOrderStatus">
            <div class="form-group">
                <label>订单ID:</label>
                <input type="number" name="updateOrderId" min="1" required>
            </div>
            <div class="form-group">
                <label>新状态:</label>
                <select name="updateOrderStatus" required>
                    <option value="未发货">未发货</option>
                    <option value="已发货">已发货</option>
                    <option value="已完成">已完成</option>
                    <option value="已取消">已取消</option>
                </select>
            </div>
            <button type="submit" class="btn">更新订单状态</button>
        </form>

        <%
            if ("updateOrderStatus".equals(action)) {
                int updateOrderId = ServiceLayer.safeParseInt(request.getParameter("updateOrderId"), 0);
                String updateOrderStatus = request.getParameter("updateOrderStatus");
                result = ServiceLayer.updateOrderStatus(updateOrderId, updateOrderStatus);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            更新订单状态结果: <%=result%>
        </div>
        <%
            }
        %>
    </div>

    <!-- 售后管理测试 -->
    <div id="aftersale-section" class="section">
        <h2>5. 售后管理测试</h2>

        <!-- 绑定用户商品 -->
        <h3>绑定用户商品</h3>
        <form method="post">
            <input type="hidden" name="action" value="bindUserProduct">
            <div class="form-group">
                <label>用户ID:</label>
                <input type="number" name="bindUserId" min="1" value="1" required>
            </div>
            <div class="form-group">
                <label>商品ID:</label>
                <input type="number" name="bindProductId" min="1" required>
            </div>
            <div class="form-group">
                <label>序列号:</label>
                <input type="text" name="bindSerialNumber" placeholder="商品序列号" required>
            </div>
            <button type="submit" class="btn">绑定商品</button>
        </form>

        <%
            if ("bindUserProduct".equals(action)) {
                int bindUserId = ServiceLayer.safeParseInt(request.getParameter("bindUserId"), 0);
                int bindProductId = ServiceLayer.safeParseInt(request.getParameter("bindProductId"), 0);
                String bindSerialNumber = request.getParameter("bindSerialNumber");
                result = ServiceLayer.bindUserProduct(bindUserId, bindProductId, bindSerialNumber);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            绑定商品结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 获取用户绑定商品 -->
        <h3>获取用户绑定商品</h3>
        <form method="post">
            <input type="hidden" name="action" value="getUserProducts">
            <div class="form-group">
                <label>用户ID:</label>
                <input type="number" name="getUserProductsId" min="1" value="1" required>
            </div>
            <button type="submit" class="btn">获取绑定商品</button>
        </form>

        <%
            if ("getUserProducts".equals(action)) {
                int getUserProductsId = ServiceLayer.safeParseInt(request.getParameter("getUserProductsId"), 0);
                List<UserProduct> userProducts = ServiceLayer.getUserProducts(getUserProductsId);
        %>
        <div class="result info">
            <h4>用户绑定商品列表 (共<%=userProducts.size()%>个商品):</h4>
            <% if (userProducts.size() > 0) { %>
            <table>
                <tr>
                    <th>绑定ID</th>
                    <th>商品名称</th>
                    <th>序列号</th>
                    <th>售后状态</th>
                </tr>
                <% for (UserProduct up : userProducts) { %>
                <tr>
                    <td><%=up.id%>
                    </td>
                    <td><%=up.productName%>
                    </td>
                    <td><%=up.sn%>
                    </td>
                    <td><%=up.afterSaleStatus != null ? up.afterSaleStatus : "正常"%>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p>该用户暂无绑定商品</p>
            <% } %>
        </div>
        <%
            }
        %>

        <!-- 申请售后 -->
        <h3>申请售后</h3>
        <form method="post">
            <input type="hidden" name="action" value="applyAfterSale">
            <div class="form-group">
                <label>用户商品绑定ID:</label>
                <input type="number" name="applyUserProductId" min="1" required>
            </div>
            <button type="submit" class="btn">申请售后</button>
        </form>

        <%
            if ("applyAfterSale".equals(action)) {
                int applyUserProductId = ServiceLayer.safeParseInt(request.getParameter("applyUserProductId"), 0);
                result = ServiceLayer.applyAfterSale(applyUserProductId);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            申请售后结果: <%=result%>
        </div>
        <%
            }
        %>

        <!-- 更新售后状态 -->
        <h3>更新售后状态（管理员功能）</h3>
        <form method="post">
            <input type="hidden" name="action" value="updateAfterSaleStatus">
            <div class="form-group">
                <label>用户商品绑定ID:</label>
                <input type="number" name="updateAfterSaleUserProductId" min="1" required>
            </div>
            <div class="form-group">
                <label>新状态:</label>
                <select name="updateAfterSaleStatusValue" required>
                    <option value="申请中">申请中</option>
                    <option value="处理中">处理中</option>
                    <option value="已处理">已处理</option>
                    <option value="已拒绝">已拒绝</option>
                </select>
            </div>
            <button type="submit" class="btn">更新售后状态</button>
        </form>

        <%
            if ("updateAfterSaleStatus".equals(action)) {
                int updateAfterSaleUserProductId = ServiceLayer.safeParseInt(request.getParameter("updateAfterSaleUserProductId"), 0);
                String updateAfterSaleStatusValue = request.getParameter("updateAfterSaleStatusValue");
                result = ServiceLayer.updateAfterSaleStatus(updateAfterSaleUserProductId, updateAfterSaleStatusValue);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">
            更新售后状态结果: <%=result%>
        </div>
        <%
            }
        %>
    </div>

    <!-- 广告管理测试 -->
    <div id="ad-section" class="section">
        <h2>6. 广告管理测试</h2>

        <h3>添加广告</h3>
        <form method="post">
            <input type="hidden" name="action" value="addAd">
            <div class="form-group">
                <label>标题:</label>
                <input type="text" name="adTitle" required>
            </div>
            <div class="form-group">
                <label>图片路径:</label>
                <input type="text" name="adImg">
            </div>
            <div class="form-group">
                <label>跳转地址:</label>
                <input type="text" name="adUrl">
            </div>
            <button type="submit" class="btn">添加广告</button>
        </form>

        <%
            if ("addAd".equals(action)) {
                String title = request.getParameter("adTitle");
                String img = request.getParameter("adImg");
                String url = request.getParameter("adUrl");
                result = ServiceLayer.addAdvertisement(title, img, url, true);
                resultClass = "success".equals(result) ? "success" : "error";
        %>
        <div class="result <%=resultClass%>">添加广告结果: <%=result%></div>
        <%
            }
        %>

        <h3>查看广告</h3>
        <form method="post">
            <input type="hidden" name="action" value="listAd">
            <button type="submit" class="btn">获取广告列表</button>
        </form>

        <%
            if ("listAd".equals(action)) {
                List<Advertisement> ads = ServiceLayer.getAllAdvertisements();
        %>
        <div class="result info">
            <h4>广告列表(<%=ads.size()%>)</h4>
            <% if (!ads.isEmpty()) { %>
            <table>
                <tr><th>ID</th><th>标题</th><th>图片路径</th><th>跳转地址</th></tr>
                <% for (Advertisement ad : ads) { %>
                <tr>
                    <td><%=ad.id%></td>
                    <td><%=ad.title%></td>
                    <td><%=ad.imagePath%></td>
                    <td><%=ad.targetUrl%></td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
            <p>暂无广告</p>
            <% } %>
        </div>
        <%
            }
        %>
    </div>

    <!-- 工具方法测试 -->
    <div id="utility-section" class="section">
        <h2>7. 工具方法测试</h2>

        <h3>工具方法演示</h3>
        <div class="result info">
            <h4>价格格式化演示:</h4>
            <p>原始价格: 2999.0 → 格式化后: <%=ServiceLayer.formatPrice(2999.0)%>
            </p>
            <p>原始价格: 1234.56 → 格式化后: <%=ServiceLayer.formatPrice(1234.56)%>
            </p>

            <h4>时间格式化演示:</h4>
            <p>当前时间: <%=ServiceLayer.formatDateTime(new java.sql.Timestamp(System.currentTimeMillis()))%>
            </p>

            <h4>字符串检查演示:</h4>
            <p>空字符串检查: <%=ServiceLayer.isEmpty("")%>
            </p>
            <p>null检查: <%=ServiceLayer.isEmpty(null)%>
            </p>
            <p>正常字符串检查: <%=ServiceLayer.isEmpty("hello")%>
            </p>

            <h4>安全转换演示:</h4>
            <p>字符串"123"转整数: <%=ServiceLayer.safeParseInt("123", 0)%>
            </p>
            <p>字符串"abc"转整数(默认值0): <%=ServiceLayer.safeParseInt("abc", 0)%>
            </p>
            <p>字符串"99.99"转浮点数: <%=ServiceLayer.safeParseDouble("99.99", 0.0)%>
            </p>
            <p>字符串"xyz"转浮点数(默认值0.0): <%=ServiceLayer.safeParseDouble("xyz", 0.0)%>
            </p>
        </div>
    </div>

    <!-- 当前会话信息 -->
    <div class="section">
        <h2>7. 当前会话信息</h2>
        <div class="result info">
            <p>
                <strong>当前用户:</strong> <%=session.getAttribute("username") != null ? session.getAttribute("username") : "未登录"%>
            </p>
            <p>
                <strong>当前管理员:</strong> <%=session.getAttribute("admin") != null ? session.getAttribute("admin") : "未登录"%>
            </p>
            <p>
                <strong>用户ID:</strong> <%=session.getAttribute("userId") != null ? session.getAttribute("userId") : "无"%>
            </p>
        </div>
    </div>

    <div style="margin-top: 30px; text-align: center; color: #666;">
        <p>com.ServiceLayer 功能测试页面 - 测试完成</p>
        <p>环境: Java 1.8 + Tomcat 9.0.106</p>
    </div>
</div>
</body>
</html>