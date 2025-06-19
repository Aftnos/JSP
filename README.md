明白了，我将根据你的说明撰写两个文档：

1. `README.md` 将详细说明项目背景、技术栈、部署方式、数据库结构、主要模块和使用说明。
2. `Agents.md` 将聚焦项目背景、AI Agent 编程守则、模块职责与开发提示词，帮助 Codex 一类 AI 更有效理解与编写代码。

我会严格依据你提供的仓库结构和设计要求来生成这两个文档，很快就会返回给你。


# 小米商城 JSP 项目

这是一个使用 **JSP + Java + MySQL** 构建的简单商城系统示例，模仿“小米商城”的商品 SN 码绑定机制。项目采用 Tomcat 9 容器运行，后台使用 Java 静态方法提供服务，通过 JDBC 操作 MySQL 数据库。核心功能包括用户通过 **SN码（订单号+商品ID）** 绑定商品，以及查看售后服务和电子说明书等。每件商品都有唯一的 SN 码，可绑定至用户账户（初始未绑定），且一个 SN 码只允许绑定一次。

## 技术栈说明

* **服务器环境：** Apache Tomcat 9.0.106
* **后端语言：** Java 1.8 (JSP 技术，Servlet 容器)
* **数据库：** MySQL 8.x 及以上（通过 JDBC 进行数据持久化）
* **前端：** JSP + HTML + CSS + JavaScript (无需额外前端框架)

以上技术栈选择保证项目能够在无需其他框架的情况下独立运行，适合学习 JSP/Servlet 基础与简单的数据库交互。

## 系统功能模块

* **商品管理：** 提供商品的新增、编辑、删除和查询功能。商品信息包括名称、价格、库存、描述和所属分类等，管理员可在后台管理商品数据。
* **订单管理：** 用户下单购买商品后生成订单，记录订单编号（8 位16进制）、下单时间、状态（如待支付、已完成等）和总金额。管理员可以查看所有订单并更新订单状态（发货、完成、取消等）。
* **购买功能：** 前台模拟简单的购物流程。用户将商品加入购物车并提交订单（购物车商品转为订单项），支持订单支付状态更新。订单创建后会生成唯一的订单号，用于后续商品绑定。
* **广告服务：** 支持在首页显示轮播广告/banner。管理员可新增广告条目（包括标题、图片路径、跳转链接和启用状态）、修改或删除广告，用于展示促销信息。
* **分类服务：** 提供商品分类的管理功能。管理员可增删改商品分类，每个商品归属一个类别，用于前台按分类浏览商品。
* **商品 SN 码绑定与售后处理：** **（核心特色）** 用户购买商品后，可通过商品的 SN 码将商品绑定到本人账号名下。SN 码由 **订单号（8位16进制） + 商品ID** 组成，确保每件出售商品拥有唯一编码。绑定后，用户可查看已绑定商品列表并提交售后服务申请；管理员可审核并更新售后处理状态（如“申请中”→“已处理”或“已拒绝”）。每个 SN 码仅能绑定一次，绑定后其他用户无法再次绑定同一商品，有效保障售后服务的专属性。

## 核心业务逻辑详解：SN 码生成与绑定

**订单号生成：** 每当用户创建订单时，系统自动生成一个唯一的订单编号 `order_no`。订单号采用 **8位十六进制字符串** 表示（例如 `5F3A7B1C`），通过当前时间戳截断哈希生成，保证一定程度的唯一性和不可预测性。这个订单号将用于标识订单及关联商品的 SN 码。

**SN 码组成：** 商品的 SN 码由“订单号 + 商品ID”拼接而成，作为商品绑定和售后的凭据。例如，如果订单号为 `5F3A7B1C`，其中包含商品 ID `1001`，则该商品的 SN 码可表示为 **`5F3A7B1C1001`**（订单号部分固定8位，后接商品的ID）。每件商品出库时应附带其 SN 码（如印刷在保修卡或标签上），用户收到商品后可通过网站输入 SN 码进行绑定。

**SN 码绑定流程：** 用户登录后，在个人中心或指定页面输入 SN 码进行绑定时，系统将解析出其中的订单号和商品ID，并进行以下校验逻辑：

1. **订单校验：** 根据 SN 中的订单号在订单表查询订单记录。确保该订单存在、属于当前登录用户、且订单状态为“已完成”。只有已完成的订单商品才允许绑定（未完成或他人订单的 SN 码均不可绑定）。
2. **绑定关系校验：** 检查待绑定的商品是否已绑定过。系统设计上每个 SN 码仅能绑定一次，如数据库中已存在相同订单号+商品ID的绑定记录，则应拒绝重复绑定。当前版本要求 SN 码仅能由原购买用户绑定，避免他人恶意绑定。
3. **写入绑定记录：** 通过校验后，将用户ID、商品ID和订单号插入到用户商品绑定表（`user_products`）。这样建立用户和具体商品实例的关联。绑定成功后，该商品记录状态变为“已绑定”，今后无法再被其他账户绑定。

**售后服务：** 绑定完成的商品才可申请售后。用户在已绑定商品列表中可对某商品发起售后申请，系统会将该绑定记录的售后状态从“正常”更新为“申请中”。管理员在后台查看售后申请，并根据处理结果将状态修改为“已处理”或“已拒绝”等。通过 SN 码绑定，售后系统能够确保只有购买了并绑定了商品的用户才能申请售后服务，防止无购买凭证的无效申请。

*（注：当前实现中，SN 码绑定逻辑侧重演示功能，某些校验如“商品ID是否属于该订单”等尚不完善，实际应用可进一步加强校验以避免不一致或重复绑定。）*

## 项目结构简述

项目采用经典的三层架构划分，目录结构与当前代码仓库一致，如下：

```plaintext
JSP/
├── ProjectData/           # 配套数据与资源
│   ├── sql/schema.sql     # 数据库建库及表结构脚本
│   └── tomcat/            # Tomcat 9.0.106 二进制包（可选）
├── lib/                   # 外部依赖库
│   └── mysql-connector-j-8.0.33.jar   # MySQL JDBC 驱动
├── src/                   # Java 源码
│   ├── db.properties      # 数据库连接配置（URL、用户名密码等）
│   ├── Main.java          # （示例入口）简单的测试主程序
│   ├── ModelTest.java     # Model 类功能测试（直接调用 DAO）
│   ├── ServiceLayerTest.java  # ServiceLayer 封装接口测试
│   └── com/               # 主代码包
│       ├── db/DBUtil.java         # 数据库工具类，负责获取连接
│       ├── dao/            # DAO 数据访问层，每个表一个 DAO 类
│       │   ├── UserDAO.java, ProductDAO.java, ... 等等
│       │   └── UserProductDAO.java   # 用户-商品绑定及售后DAO
│       ├── entity/         # 实体类定义，每个表对应 POJO 类 (public 字段)
│       │   ├── User.java, Product.java, Order.java, ...
│       │   └── UserProduct.java      # 用户绑定商品实体（含 orderNo, afterSaleStatus 等）
│       ├── Model.java      # 模型层（静态方法集），封装各 DAO 调用
│       └── ServiceLayer.java # 服务层（业务接口），封装 Model 方法并提供业务规则，供 JSP 调用
├── web/                   # Web 根目录（部署内容）
│   ├── index.jsp           # 前台首页 JSP
│   ├── test_all_functions.jsp  # 功能调试页面（汇集各 ServiceLayer 接口的表单测试）
│   ├── admin/              # 后台管理相关页面
│   │   ├── sidebar.jsp        # 管理后台侧边栏公共部分
│   │   └── css/admin-layout.css  # 后台页面简单样式
│   └── WEB-INF/
│       ├── web.xml         # Web 应用配置（此项目主要配置字符编码过滤器）
│       └── lib/            # 运行时依赖库（同上面的 MySQL 驱动等）
└── .idea/                 # 开发环境配置（可忽略）
```

各模块职责如下：

* **DBUtil：** 负责加载数据库配置（`db.properties`）并提供获取 `Connection` 的静态方法。
* **DAO 层：** 每张数据库表对应一个 DAO 类，提供该表相关的增删改查操作方法。例如 `UserDAO` 处理用户表读写，`ProductDAO` 处理商品表操作等。
* **Model 模型层：** 提供统一的静态方法接口，相当于 DAO 的门面(Facade)。`Model.java` 中定义了一系列静态方法，每个方法内部调用相应的 DAO 完成数据库操作。本身不包含业务逻辑，仅对 DAO 层进行简单封装，方便其它层调用。
* **ServiceLayer 服务层：** 封装业务逻辑的静态接口类。在 Model 基础上增加了参数校验、业务规则（例如订单完成才能绑定等），将底层操作组合为更高层的服务。JSP 页面直接调用 `ServiceLayer` 的静态方法完成各种操作，从而保证所有业务逻辑在Java代码中统一处理。
* **实体类 (`entity` 包)：** 定义了与数据库表对应的简单 Java 对象，如 `User`, `Product`, `Order`, `UserProduct` 等。字段均为 `public` 且命名与表字段一致，方便 JSP 页面直接读取属性（如 `order.total`）。这些实体主要用来封装 DAO 查询结果，用于在页面展示或传递数据。
* **JSP 页面 (`web` 目录)**：包含前端界面的 JSP 文件以及相关静态资源。示例中的 `index.jsp` 为首页，`test_all_functions.jsp` 提供了一个调试页面，包含调用所有 ServiceLayer 接口的示例表单和结果展示，方便开发过程中快速验证功能。实际应用中可根据需要将这些功能拆分到不同的页面。如 `admin` 目录下存放管理后台的页面及样式文件（例如简单的侧边栏等）。

## 如何运行

1. **数据库初始化：** 确保已安装 MySQL，并创建项目数据库。运行仓库中提供的 SQL 脚本来创建数据库和必要的表：

   ```bash
   mysql -u <用户名> -p < ProjectData/sql/schema.sql
   ```

   上述脚本将在 MySQL 中创建名为 **`xiaomi_mall`** 的数据库，并建立所有需要的表（users, products, orders 等）。初始化后，可根据需要向表中插入一些测试数据（例如新增商品分类、管理员账号等）。默认情况下脚本未插入管理员账户，如需测试管理员功能请手动添加，如：

   ```sql
   INSERT INTO admins (username, password) VALUES ('admin', 'admin123');
   ```

2. **配置数据库连接：** 打开 `src/db.properties` 文件，根据本地环境修改数据库连接信息，包括数据库 URL、端口、用户名和密码等，使之与上一步创建的数据库匹配。确保 MySQL 服务已启动，并且所配置的账户有权限访问该数据库。

3. **部署应用至 Tomcat：** 将整个 `web` 目录部署到 Tomcat 容器中。常见做法是在 Tomcat `webapps` 目录下创建项目目录并拷贝 `web` 下的内容，或者在开发IDE中配置服务器。请确保 Tomcat 版本为 9.x 且 Java 环境为1.8，以避免兼容性问题。

   *提示：仓库的 ProjectData/tomcat/ 目录提供了 Windows 环境下的 Tomcat 9.0.106 压缩包，可选用此版本。将 `web` 目录内容复制到 `apache-tomcat-9.0.106/webapps/ROOT/` 下可以作为快速部署方式。*

4. **加载数据库驱动：** 确认 MySQL JDBC 驱动已放置在应用的 classpath 中。仓库自带的 `lib/mysql-connector-j-8.0.33.jar` 已复制在 `web/WEB-INF/lib/` 下，Tomcat 部署时会自动加载该驱动。如果采用其他部署方式，请确保驱动 jar 在应用运行时可用（例如放入 Tomcat 的 `lib` 目录或作为 WAR 包的一部分）。

5. **启动应用并访问：** 启动 Tomcat 服务器，观察控制台确保没有异常。然后在浏览器中访问 `http://localhost:8080/` 即可进入商城首页。若部署在非 ROOT 路径下，使用相应的子路径。

   * 在首页，您可以进行用户注册、登录、浏览商品等基础操作（需根据实际 JSP 页面实现情况）。
   * 如果没有专门的绑定入口页面，可访问提供的测试页面 `test_all_functions.jsp`，页面包含了各项功能的演示表单。例如，在“SN码绑定测试”部分输入订单号和商品ID进行绑定测试，查看绑定结果和售后申请流程。

6. **测试与验证：** 可以使用提供的测试类验证主要功能是否正常。在命令行下编译运行：

   ```bash
   # 编译所有源代码（假设处于项目根目录）
   javac -cp lib/mysql-connector-j-8.0.33.jar -d out $(find src -name "*.java")
   # 运行 ServiceLayer 测试主程序
   java -cp out:lib/mysql-connector-j-8.0.33.jar ServiceLayerTest
   ```

   该测试程序将按模块依次调用 ServiceLayer 的方法，并输出每一步的测试结果。在控制台可以看到用户注册登录、商品CRUD、订单创建支付、SN绑定及售后流程等结果。如有某步出现失败或异常，可根据提示信息进行排查。

*运行过程中，如果出现数据库连接失败或表不存在等错误，请检查第1-2步的数据库设置是否正确执行。确保 MySQL 服务已启动、账号密码正确，数据库及表已创建。*

## 接口文档

本项目后端通过 **ServiceLayer.java** 提供统一的静态方法接口，供 JSP 页面直接调用以实现各种业务功能。以下对主要接口按模块作简要说明：

* **用户服务接口：** 提供用户注册、登录及信息管理功能。常用方法有：

   * `userLogin(String username, String password)`：验证用户登录，成功返回 true 并在会话中保存用户信息。
   * `userRegister(String username, String password)`：注册新用户，返回 `"success"` 或错误信息（如用户名已存在、格式不符等）。
   * `updateUserPassword(int userId, String newPwd)`：更新用户密码，返回 `"success"` 或失败原因。
   * `updateUserProfile(int userId, String displayName, String avatar)`：更新用户昵称或头像。
   * `getUserById(int userId)`：根据用户ID获取用户对象（包含用户名、头像等），未找到则返回 null。
   * `getAllUsers()`：获取所有用户列表（管理员功能，可用于后台用户管理）。
   * `deleteUser(int userId)`：删除指定用户（管理员功能）。

* **管理员服务接口：** 提供管理员账户的登录及管理功能：

   * `adminLogin(String username, String password)`：管理员登录验证。
   * `updateAdminPassword(int adminId, String newPwd)`：更新管理员密码。
     *（提示：实际应用中管理员页面应有访问控制，当前只是提供接口，需结合会话验证权限。）*

* **商品与分类服务接口：** 提供商品及类别的管理和查询：

   * `getAllProducts()` / `getProductById(int id)`：获取所有商品列表或根据ID查询单个商品详情。
   * `addProduct(String name, double price, int stock, String desc, int categoryId)`：新增商品，返回 `"success"` 或错误信息。
   * `updateProduct(int id, ...)`：更新商品信息。
   * `deleteProduct(int id)`：删除商品。
   * `getAllCategories()` / `getCategoryById(int id)`：获取所有商品分类或按ID查询分类。
   * `addCategory(String name)` / `updateCategory(int id, String name)` / `deleteCategory(int id)`：分类的增、改、删操作，成功返回 `"success"`。

* **订单与购买服务接口：** 提供订单创建、查询及状态更新等功能：

   * `createOrder(int userId, List<CartItem> items)`：创建订单并写入订单项列表。参数包括用户ID和购物车商品列表，每个 CartItem 包含 productId, quantity, price。成功返回 `"success"`。订单创建时系统会自动生成订单号、计算总价并存数据库。
   * `getUserOrders(int userId)`：获取指定用户的所有订单列表（按下单时间倒序）。可用于用户个人订单历史页面。
   * `getAllOrders()`：获取系统中所有订单列表（管理员查看所有订单）。
   * `payOrder(int orderId)`：模拟订单支付，将指定订单的支付状态更新为“已支付”。
   * `updateOrderStatus(int orderId, String status)`：更新订单状态（管理员操作，如改为“已发货”“已完成”等）。返回 `"success"` 或错误提示。
   * `getOrderById(int orderId)`：根据订单ID获取订单对象（包含订单项明细）。
   * `deleteOrder(int orderId)`：删除订单记录（管理员功能，例如取消订单时删除，注意级联影响）。

* **商品 SN码绑定及售后接口：** 提供用户绑定商品和售后服务相关的方法：

   * `bindUserProduct(int userId, int productId, String orderNo)`：绑定用户与商品关系。将 **订单号** 为 `orderNo` 且 **商品ID** 为 `productId` 的商品绑定到用户 `userId` 名下。内部会校验订单存在且属于该用户并已完成，符合条件则插入绑定记录。成功返回 `"success"`，否则返回错误原因（如“订单不存在或未完成”）。
   * `getUserProducts(int userId)`：获取用户已绑定的商品列表。返回列表中的每个 `UserProduct` 对象包含商品名称、订单号、售后状态等，可用于前端展示绑定商品及其售后进度。
   * `applyAfterSale(int userProductId)`：用户申请售后服务。将对应绑定记录的 `after_sale_status` 更新为“申请中”，并返回 `"success"` 或失败信息。后续管理员处理结果再更新状态。
   * `updateAfterSaleStatus(int userProductId, String status)`：管理员更新售后状态。例如将状态改为“已处理”表示售后完成。返回 `"success"` 或错误信息（如记录不存在等）。
   * `getUserProductById(int id)`：根据绑定记录ID获取具体的绑定信息（包括哪个用户、商品及订单号，以及当前售后状态）。
   * `deleteUserProduct(int id)`：删除用户与商品的绑定关系。一般用于取消绑定或测试清理数据。删除后该 SN 码可重新用于绑定（实际场景中很少解除绑定，这里主要作为演示）。

* **广告服务接口：** 提供首页广告条目的管理：

   * `getAllAdvertisements()`：获取广告列表。每条广告包含标题、图片路径、目标URL和是否启用等字段。前台首页可根据启用状态显示广告轮播。
   * `addAdvertisement(String title, String imagePath, String targetUrl, boolean enabled)`：新增广告，enabled 为 true/false 表示是否立即启用。
   * `updateAdvertisement(int id, ...)`：更新广告内容或状态（例如上/下架）。
   * `deleteAdvertisement(int id)`：删除广告条目。

以上接口均为 **public static** 方法，可在 JSP 页面通过 `<% ... %>` 调用，例如：

```jsp
<%
    String result = com.ServiceLayer.bindUserProduct(userId, prodId, snCode);
    if ("success".equals(result)) {
        out.println("绑定成功！");
    } else {
        out.println("绑定失败：" + result);
    }
%>
```

在 JSP 中使用时，请确保已按需导入相应类或使用完整类名（如 `com.ServiceLayer`、`com.entity.Order` 等）。此外，这些接口返回的数据类型如果是实体或列表，JSP 页面可直接通过点运算符访问属性并遍历列表。返回 `"success"` 或错误消息的接口，可用字符串比较判断是否调用成功。

## 约定规范

* **统一的接口入口：** 后端所有提供给 JSP 调用的功能必须封装在 `ServiceLayer.java` 中作为静态方法。这是项目的后端服务总入口。直接在 JSP 中访问数据库或调用 DAO 属于不规范行为。若需新增功能，应遵循 **DAO → Model → ServiceLayer** 三层调用流程，以保持代码组织清晰。
* **JSP 页面职责：** JSP 仅负责表现层逻辑，通过 HTML 表单收集用户输入，通过调用 `ServiceLayer` 方法获取处理结果，然后以易读的格式显示给用户。页面中应避免复杂的业务计算或数据访问，所有这些应在 Java 类中完成。
* **静态方法设计：** 所有 `ServiceLayer` 提供的方法都遵循以下约定：参数使用基本类型或简单对象，首先做必要的合法性校验（非空、范围正确等），然后调用 `Model` 层执行数据库操作，并将结果以**简单明了的返回值**表示——通常 `"success"` 字符串表示操作成功，其他返回值表示失败原因。调用者（JSP）据此判断下一步逻辑。这样的约定使 JSP 调用代码直观（通过判断字符串是否为"success"即可了解执行结果）。
* **异常与错误处理：** 在 ServiceLayer 中捕获了可能的异常并输出错误日志到标准错误，但不向上抛出异常，以免 JSP 页面混乱。任何底层异常都会转换为 user-friendly 的错误信息返回。例如数据库连接失败，会返回“系统错误，请稍后重试”。这一规范保证前端页面不会直接暴露堆栈信息。
* **实体对象使用：** `com.entity` 包中的 POJO 实体采用 public 字段，无需 getter/setter，便于 JSP 中直接使用。如 `order.total`、`user.username` 直接访问。这是简化设计的约定，开发时应遵守这种数据传递方式。实体主要作为数据载体，没有业务方法。
* **命名与状态约定：** 项目中用字符串表示的一些状态有固定取值。例如订单状态 `"未发货"|"已发货"|"已完成"|"已取消"`，支付状态 `"未支付"|"已支付"`；售后状态 `"正常"|"申请中"|"已处理"|"已拒绝"` 等。在开发新功能或调整逻辑时，请遵循并复用这些状态值，保持前后端表达一致。
* **ServiceLayer 作者说明：** ServiceLayer 类头部文档和各方法注释详细说明了用途、参数和返回，可作为开发参考。在扩展功能时也请为新方法撰写类似注释，方便他人（或 AI Agent）理解和使用。

---

以上即为项目的 README 文档，涵盖了项目介绍、功能说明、运行指南和开发约定等内容。如需了解面向 AI 编码助手的项目指引，请参阅仓库中的 **Agents.md** 文档，以获取关于 AI 开发Agent的使用场景和注意事项说明。

---
