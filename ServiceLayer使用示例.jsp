<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="Model.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ServiceLayer 使用示例</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .example { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .code { background: #e8e8e8; padding: 10px; margin: 5px 0; font-family: monospace; }
        h2 { color: #333; border-bottom: 2px solid #007cba; padding-bottom: 5px; }
        h3 { color: #007cba; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>ServiceLayer 接口使用示例</h1>
    <p>本页面展示了如何在JSP中使用ServiceLayer提供的各种接口</p>
    
    <!-- ==================== 用户相关示例 ==================== -->
    <h2>1. 用户相关功能示例</h2>
    
    <div class="example">
        <h3>1.1 用户登录示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;String username = request.getParameter("username");<br>
&nbsp;&nbsp;&nbsp;&nbsp;String password = request.getParameter("password");<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (username != null && password != null) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;boolean loginSuccess = ServiceLayer.userLogin(username, password);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (loginSuccess) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;session.setAttribute("username", username);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='success'&gt;登录成功！&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='error'&gt;用户名或密码错误&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 实际演示 -->
        <%
            // 模拟登录测试（使用测试数据）
            String testUsername = "testuser";
            String testPassword = "123456";
            
            out.println("<div class='info'>模拟登录测试：</div>");
            boolean loginResult = ServiceLayer.userLogin(testUsername, testPassword);
            if (loginResult) {
                out.println("<span class='success'>用户 " + testUsername + " 登录成功！</span>");
            } else {
                out.println("<span class='error'>用户 " + testUsername + " 登录失败（可能用户不存在）</span>");
            }
        %>
    </div>
    
    <div class="example">
        <h3>1.2 用户注册示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;String newUsername = request.getParameter("newUsername");<br>
&nbsp;&nbsp;&nbsp;&nbsp;String newPassword = request.getParameter("newPassword");<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (newUsername != null && newPassword != null) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;String result = ServiceLayer.userRegister(newUsername, newPassword);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if ("success".equals(result)) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='success'&gt;注册成功！&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='error'&gt;注册失败：" + result + "&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 参数验证演示 -->
        <%
            out.println("<div class='info'>参数验证演示：</div>");
            
            // 测试空用户名
            String result1 = ServiceLayer.userRegister("", "123456");
            out.println("<div>空用户名测试：<span class='error'>" + result1 + "</span></div>");
            
            // 测试短密码
            String result2 = ServiceLayer.userRegister("testuser", "123");
            out.println("<div>短密码测试：<span class='error'>" + result2 + "</span></div>");
            
            // 测试长用户名
            String result3 = ServiceLayer.userRegister("这是一个非常非常长的用户名超过了二十个字符", "123456");
            out.println("<div>长用户名测试：<span class='error'>" + result3 + "</span></div>");
        %>
    </div>
    
    <!-- ==================== 商品相关示例 ==================== -->
    <h2>2. 商品相关功能示例</h2>
    
    <div class="example">
        <h3>2.1 获取所有商品示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;List&lt;Model.Product&gt; products = ServiceLayer.getAllProducts();<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (products.isEmpty()) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("暂无商品");<br>
&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for (Model.Product product : products) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("商品名：" + product.name);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("价格：" + ServiceLayer.formatPrice(product.price));<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("库存：" + product.stock);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 实际演示 -->
        <%
            out.println("<div class='info'>商品列表演示：</div>");
            List<Model.Product> products = ServiceLayer.getAllProducts();
            if (products.isEmpty()) {
                out.println("<div>暂无商品数据（数据库可能未连接或无数据）</div>");
            } else {
                out.println("<div>找到 " + products.size() + " 个商品：</div>");
                for (int i = 0; i < Math.min(3, products.size()); i++) {
                    Model.Product product = products.get(i);
                    out.println("<div>" + (i+1) + ". " + product.name + " - " + 
                               ServiceLayer.formatPrice(product.price) + " (库存:" + product.stock + ")</div>");
                }
                if (products.size() > 3) {
                    out.println("<div>... 还有 " + (products.size() - 3) + " 个商品</div>");
                }
            }
        %>
    </div>
    
    <div class="example">
        <h3>2.2 根据ID获取商品示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;int productId = ServiceLayer.safeParseInt(request.getParameter("id"), 0);<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (productId &gt; 0) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Model.Product product = ServiceLayer.getProductById(productId);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (product != null) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("商品详情：" + product.name);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("价格：" + ServiceLayer.formatPrice(product.price));<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("描述：" + product.description);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("商品不存在");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 演示 -->
        <%
            out.println("<div class='info'>根据ID获取商品演示：</div>");
            Model.Product product = ServiceLayer.getProductById(1);
            if (product != null) {
                out.println("<div class='success'>找到商品ID=1：" + product.name + "</div>");
            } else {
                out.println("<div class='error'>商品ID=1不存在（数据库可能未连接或无此商品）</div>");
            }
        %>
    </div>
    
    <!-- ==================== 订单相关示例 ==================== -->
    <h2>3. 订单相关功能示例</h2>
    
    <div class="example">
        <h3>3.1 创建订单示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 构建购物车<br>
&nbsp;&nbsp;&nbsp;&nbsp;List&lt;Model.CartItem&gt; cartItems = new ArrayList&lt;&gt;();<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;Model.CartItem item1 = new Model.CartItem();<br>
&nbsp;&nbsp;&nbsp;&nbsp;item1.productId = 1;<br>
&nbsp;&nbsp;&nbsp;&nbsp;item1.quantity = 2;<br>
&nbsp;&nbsp;&nbsp;&nbsp;item1.price = 2999.0;<br>
&nbsp;&nbsp;&nbsp;&nbsp;cartItems.add(item1);<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;Model.CartItem item2 = new Model.CartItem();<br>
&nbsp;&nbsp;&nbsp;&nbsp;item2.productId = 2;<br>
&nbsp;&nbsp;&nbsp;&nbsp;item2.quantity = 1;<br>
&nbsp;&nbsp;&nbsp;&nbsp;item2.price = 1999.0;<br>
&nbsp;&nbsp;&nbsp;&nbsp;cartItems.add(item2);<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 创建订单<br>
&nbsp;&nbsp;&nbsp;&nbsp;int userId = 1; // 从session获取<br>
&nbsp;&nbsp;&nbsp;&nbsp;String result = ServiceLayer.createOrder(userId, cartItems);<br>
&nbsp;&nbsp;&nbsp;&nbsp;if ("success".equals(result)) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("订单创建成功");<br>
&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("创建失败：" + result);<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 参数验证演示 -->
        <%
            out.println("<div class='info'>订单创建参数验证演示：</div>");
            
            // 测试空购物车
            String result1 = ServiceLayer.createOrder(1, new ArrayList<Model.CartItem>());
            out.println("<div>空购物车测试：<span class='error'>" + result1 + "</span></div>");
            
            // 测试无效用户ID
            List<Model.CartItem> testCart = new ArrayList<>();
            Model.CartItem testItem = new Model.CartItem();
            testItem.productId = 1;
            testItem.quantity = 1;
            testItem.price = 100.0;
            testCart.add(testItem);
            
            String result2 = ServiceLayer.createOrder(0, testCart);
            out.println("<div>无效用户ID测试：<span class='error'>" + result2 + "</span></div>");
        %>
    </div>
    
    <div class="example">
        <h3>3.2 获取用户订单示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;int userId = (Integer) session.getAttribute("userId");<br>
&nbsp;&nbsp;&nbsp;&nbsp;List&lt;Model.Order&gt; orders = ServiceLayer.getUserOrders(userId);<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (orders.isEmpty()) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("您还没有订单");<br>
&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;for (Model.Order order : orders) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("订单号：" + order.id);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("下单时间：" + ServiceLayer.formatDateTime(order.orderDate));<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("订单状态：" + order.status);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("订单总额：" + ServiceLayer.formatPrice(order.total));<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 演示 -->
        <%
            out.println("<div class='info'>获取用户订单演示：</div>");
            List<Model.Order> orders = ServiceLayer.getUserOrders(1); // 测试用户ID=1
            if (orders.isEmpty()) {
                out.println("<div>用户ID=1暂无订单（数据库可能未连接或无数据）</div>");
            } else {
                out.println("<div class='success'>用户ID=1有 " + orders.size() + " 个订单</div>");
            }
        %>
    </div>
    
    <!-- ==================== 工具方法示例 ==================== -->
    <h2>4. 工具方法示例</h2>
    
    <div class="example">
        <h3>4.1 安全参数转换示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 安全的整数转换<br>
&nbsp;&nbsp;&nbsp;&nbsp;int productId = ServiceLayer.safeParseInt(request.getParameter("id"), 0);<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (productId &gt; 0) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 处理有效的商品ID<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 安全的浮点数转换<br>
&nbsp;&nbsp;&nbsp;&nbsp;double price = ServiceLayer.safeParseDouble(request.getParameter("price"), 0.0);<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (price &gt; 0) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 处理有效的价格<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <!-- 演示 -->
        <%
            out.println("<div class='info'>安全参数转换演示：</div>");
            
            // 测试各种输入
            String[] testInputs = {"123", "abc", "", null, "0", "-5"};
            for (String input : testInputs) {
                int result = ServiceLayer.safeParseInt(input, -1);
                out.println("<div>输入 '" + input + "' 转换结果：" + result + "</div>");
            }
        %>
    </div>
    
    <div class="example">
        <h3>4.2 格式化方法示例</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 格式化价格<br>
&nbsp;&nbsp;&nbsp;&nbsp;double price = 2999.5;<br>
&nbsp;&nbsp;&nbsp;&nbsp;String formattedPrice = ServiceLayer.formatPrice(price);<br>
&nbsp;&nbsp;&nbsp;&nbsp;out.println("价格：" + formattedPrice); // 输出：价格：¥2,999.50<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 格式化时间<br>
&nbsp;&nbsp;&nbsp;&nbsp;Timestamp now = new Timestamp(System.currentTimeMillis());<br>
&nbsp;&nbsp;&nbsp;&nbsp;String formattedTime = ServiceLayer.formatDateTime(now);<br>
&nbsp;&nbsp;&nbsp;&nbsp;out.println("当前时间：" + formattedTime);<br>
%&gt;
        </div>
        
        <!-- 演示 -->
        <%
            out.println("<div class='info'>格式化方法演示：</div>");
            
            // 价格格式化
            double[] prices = {2999.0, 1999.99, 0.5, 10000.0};
            for (double price : prices) {
                out.println("<div>" + price + " → " + ServiceLayer.formatPrice(price) + "</div>");
            }
            
            // 时间格式化
            java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
            out.println("<div>当前时间：" + ServiceLayer.formatDateTime(now) + "</div>");
        %>
    </div>
    
    <!-- ==================== 完整业务流程示例 ==================== -->
    <h2>5. 完整业务流程示例</h2>
    
    <div class="example">
        <h3>5.1 用户购物完整流程</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;// 1. 用户登录<br>
&nbsp;&nbsp;&nbsp;&nbsp;String username = "customer1";<br>
&nbsp;&nbsp;&nbsp;&nbsp;String password = "123456";<br>
&nbsp;&nbsp;&nbsp;&nbsp;boolean loginSuccess = ServiceLayer.userLogin(username, password);<br>
&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;if (loginSuccess) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;session.setAttribute("username", username);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 2. 浏览商品<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;List&lt;Model.Product&gt; products = ServiceLayer.getAllProducts();<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 3. 添加到购物车<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;List&lt;Model.CartItem&gt; cart = new ArrayList&lt;&gt;();<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (!products.isEmpty()) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Model.CartItem item = new Model.CartItem();<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;item.productId = products.get(0).id;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;item.quantity = 1;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;item.price = products.get(0).price;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cart.add(item);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 4. 创建订单<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (!cart.isEmpty()) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;String orderResult = ServiceLayer.createOrder(1, cart);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if ("success".equals(orderResult)) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("购物成功！");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <p class="info">这个示例展示了一个完整的用户购物流程，包括登录、浏览商品、添加购物车和创建订单。</p>
    </div>
    
    <!-- ==================== 错误处理示例 ==================== -->
    <h2>6. 错误处理最佳实践</h2>
    
    <div class="example">
        <h3>6.1 统一错误处理模式</h3>
        <div class="code">
&lt;%<br>
&nbsp;&nbsp;&nbsp;&nbsp;try {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 获取并验证参数<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;String productName = request.getParameter("name");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (ServiceLayer.isEmpty(productName)) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='error'&gt;商品名称不能为空&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;double price = ServiceLayer.safeParseDouble(request.getParameter("price"), 0);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (price &lt;= 0) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='error'&gt;价格必须大于0&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// 调用业务方法<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;String result = ServiceLayer.addProduct(productName, price, 100, "测试商品");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if ("success".equals(result)) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='success'&gt;操作成功&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='error'&gt;操作失败：" + result + "&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
&nbsp;&nbsp;&nbsp;&nbsp;} catch (Exception e) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;out.println("&lt;span class='error'&gt;系统错误：" + e.getMessage() + "&lt;/span&gt;");<br>
&nbsp;&nbsp;&nbsp;&nbsp;}<br>
%&gt;
        </div>
        
        <p class="info">这个示例展示了如何在JSP中进行统一的错误处理，包括参数验证、业务逻辑调用和异常捕获。</p>
    </div>
    
    <hr>
    <h2>总结</h2>
    <p>ServiceLayer 提供了以下主要功能：</p>
    <ul>
        <li><strong>用户管理</strong>：登录验证、用户注册</li>
        <li><strong>管理员功能</strong>：管理员登录验证</li>
        <li><strong>商品管理</strong>：获取商品列表、商品详情、添加/更新/删除商品</li>
        <li><strong>订单管理</strong>：创建订单、查询订单、更新订单状态</li>
        <li><strong>售后服务</strong>：商品绑定、售后申请、售后状态管理</li>
        <li><strong>工具方法</strong>：参数转换、格式化、验证等</li>
    </ul>
    
    <p><strong>使用建议：</strong></p>
    <ul>
        <li>始终进行参数验证，使用 ServiceLayer 提供的安全转换方法</li>
        <li>统一使用 ServiceLayer 的返回格式进行错误处理</li>
        <li>在 session 中保存用户状态信息</li>
        <li>使用格式化方法美化显示效果</li>
        <li>遵循示例中的错误处理模式</li>
    </ul>
</body>
</html>