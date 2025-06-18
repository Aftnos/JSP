# 小米商城 JSP 示例项目

这是一个教学用途的简易 JSP + Servlet 项目，包含最基本的模型层代码与数据库脚本。根据 `项目说明和规范/简化版小米商城 JSP 项目设计.pdf` ，仓库中提供了若干 JavaBean、集中式数据库操作类以及建表 SQL。

## 数据库

`db.sql` 文件定义了用户、管理员、商品、订单及订单项表，直接在 MySQL 中执行即可初始化。

## 代码结构

```
src/
  DBHelper.java         数据库连接工具
  Model.java            集中式增删查改接口
  model/                简单的 JavaBean 模型
    User.java
    Admin.java
    Product.java
    Order.java
    OrderItem.java
```

`Model.java` 封装了对用户和商品的常用 CRUD 方法，数据库连接信息则放在 `db.properties` 中，`DBHelper` 负责读取该配置并提供连接。

## 使用

1. 在 MySQL 中执行 `db.sql` 创建表结构；
2. 根据实际情况编辑 `db.properties` 内的连接地址、用户名和密码；
3. 编译 Java 源码：`javac $(find src -name '*.java')`；
4. 将编译后的 class 文件部署到支持 JSP/Servlet 的容器（例如 Tomcat）。

代码仅覆盖了最核心的部分，便于初学者理解 MVC 模式下模型层与数据库交互的基本写法。
