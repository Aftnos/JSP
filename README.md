# 简化版小米商城示例

该项目展示了一个基于 JSP 与 Servlet 的简化商城示例，数据库操作都封装在 `com.Model.java` 中。仓库内包含建表脚本和基本的 JDBC 配置文件，方便快速搭建测试环境。

## 数据库初始化

1. 安装并启动 MySQL 服务。
2. 执行 `sql/schema.sql` 创建 `xiaomi_mall` 数据库及其表结构。
3. 根据实际的数据库账号密码修改 `src/db.properties` 中的配置项。

```bash
mysql -u root -p < sql/schema.sql
```

## 主要代码说明

- `src/com.Model.java`：集中式数据库操作类，提供用户、管理员、商品及订单的 CRUD 方法，所有操作均通过 JDBC 实现。
- `src/db.properties`：数据库连接配置文件，包含 URL、用户名与密码。
- `sql/schema.sql`：项目所需的 MySQL 建表脚本。

`com.Model.java` 通过读取 `db.properties` 获取连接信息，在静态代码块中加载 JDBC 驱动。示例方法包括：

```java
com.Model.addUser("alice", "123");
com.Model.validateUser("alice", "123");
com.Model.getAllProducts();
com.Model.createOrder(userId, cartItems);
```

在 Servlet 或其他业务代码中直接调用这些静态方法即可完成数据库操作。

## 运行

项目结构仅包含核心代码，部署到支持 JSP/Servlet 的容器（如 Tomcat）即可运行。确保 `lib` 目录中包含 MySQL JDBC 驱动，或在应用服务器的类路径中提供该依赖。

