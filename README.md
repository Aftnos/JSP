# 小米商城 JSP 示例

本仓库提供了一个使用 **JSP + JDBC** 编写的简单电商项目，以小米商城的业务为蓝本，旨在展示在无框架的情况下如何组织 Java Web 应用、数据库访问以及 JSP 页面。项目包含完整的数据库脚本和示例页面，适合作为学习或实验之用。

## 环境要求

- **JDK 1.8_202**（或兼容版本）
- **Tomcat 9.0.106**
- **MySQL 8.x**

`ProjectData/sql` 目录中提供建表脚本和测试数据，`ProjectData/tomcat` 提供用于开发的 Windows 版 Tomcat 压缩包。

## 功能模块概览

1. **用户管理**：注册 / 登录、个人资料维护、收货地址管理、权限区分（普通用户/管理员）。
2. **商品管理**：商品及分类的增删改查，商品图片及附加图片管理，前台商品浏览与搜索。
3. **购物车与订单**：加入购物车、下单、修改订单状态、支付回调及订单查询。
4. **SN 码管理**：为商品生成唯一 SN，支持批次操作、状态更新和删除。
5. **SN 绑定**：购买后绑定 SN，查看绑定记录，管理员可解除绑定。
6. **售后 / 客服**：基于 SN 的售后申请、审核、关闭流程。
7. **通知中心**：系统事件产生通知，用户可查看和标记已读。

## 功能结构设计

整体采用 **JSP → ServiceLayer → Model/DAO → 数据库** 的分层方式。JSP 页面只负责展示
和简单的表单收集，所有业务逻辑都封装在 `ServiceLayer` 内。`Model` 与各 `DAO` 完成
数据库访问，DAO 层对表结构做最基本的增删改查封装。主要模块及其关系如下：

```
用户 → 购物车 → 订单 → SN码 → 绑定/售后
              ↘ 通知中心
```

每个模块都对应一组实体类与表结构，并在 ServiceLayer 中暴露统一的静态方法供 JSP 调用，
便于页面之间复用逻辑。

## 快速开始

1. **初始化数据库**
   ```bash
   mysql -u root -p < ProjectData/sql/schema.sql
   mysql -u root -p xiaomi_mall < ProjectData/sql/test_data.sql # 可选，导入示例数据
   ```
   完成后根据实际数据库连接信息修改 `src/db.properties`。

2. **编译与部署**
   - 在 `src` 目录下编译所有 Java 文件：
     ```bash
     javac -d out -cp lib/mysql-connector-j-8.0.33.jar $(find src -name "*.java")
     ```
   - 将 `web` 目录作为 Web 应用部署到 Tomcat 的 `webapps` 目录，或在 IDE 中创建相应的运行配置。
   - 确保 `web/WEB-INF/lib/mysql-connector-j-8.0.33.jar` 能被加载。

3. **访问应用**
   启动 Tomcat 后访问 `http://localhost:8080/`，页面 `test_all_functions.jsp` 可以快速验证各项功能是否正常。

## 目录结构

```
JSP/
├── ProjectData/           # 数据库脚本及打包的 Tomcat
│   ├── sql/               # schema.sql、test_data.sql、SQLdoc.md
│   └── tomcat/            # 预置的 Tomcat 压缩包
├── lib/                   # 第三方依赖
│   └── mysql-connector-j-8.0.33.jar
├── src/                   # Java 源码
│   ├── com/               # 实体、DAO、ServiceLayer 等
│   ├── ModelTest.java
│   ├── ServiceLayerTest.java
│   └── db.properties      # 数据库配置
└── web/                   # JSP 页面及静态资源
    ├── WEB-INF/
    ├── admin/
    ├── css/
    ├── images/
    └── ...
```

## 运行测试

`src` 目录下提供了 `ModelTest` 和 `ServiceLayerTest` 两个测试类，可在命令行执行：

```bash
java -cp out:lib/mysql-connector-j-8.0.33.jar ServiceLayerTest
```

测试会按照固定流程调用所有 ServiceLayer 方法并输出结果，方便验证数据库和环境配置是否正确。

## 许可证

项目代码基于 MIT License 发布，详见仓库中的 `LICENSE` 文件。

