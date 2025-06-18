# 小米商城 JSP 项目

这是一个使用 **JSP + JDBC** 构建的简单商城示例，主要用于学习如何在不依赖框架的情况下搭建 Web 应用。本项目模仿小米商城的基本功能，推荐在如下环境下运行：

- **JDK 1.8_202**
- **Tomcat 9.0.106**
- **MySQL 8.x**

项目目录中提供了数据库建表脚本以及 Windows 版 Tomcat 压缩包，可直接用于本地开发。

## 快速开始

1. **导入数据库**
   ```bash
   mysql -u root -p < ProjectData/sql/schema.sql
   ```
   修改 `src/db.properties` 中的数据库连接信息以匹配本地环境。

2. **构建与部署**
   - 将 `web` 目录部署到 Tomcat 的 `webapps` 下（或在 IDE 中配置）。
   - `web/WEB-INF/lib` 已包含 `mysql-connector-j-8.0.33.jar`，确保其在运行时能够被加载。

3. **访问应用**
   启动 Tomcat 后，访问 `http://localhost:8080/` 即可进入首页，在 `test_all_functions.jsp` 中集成了 `ServiceLayer` 的各项功能测试。

## 项目结构

```
JSP/
├── ProjectData/          # 配套数据（SQL、Tomcat安装包）
│   ├── sql/schema.sql    # 数据库建表脚本
│   └── tomcat/           # Tomcat 9.0.106 压缩包
├── lib/                  # 项目依赖
│   └── mysql-connector-j-8.0.33.jar
├── src/                  # Java 源代码
│   ├── db.properties     # 数据库连接配置
│   ├── Main.java         # 简单的入口示例
│   ├── ModelTest.java    # 直接调用 Model 的测试代码
│   ├── ServiceLayerTest.java # 调用 ServiceLayer 的测试代码
│   └── com/
│       ├── db/DBUtil.java      # JDBC 工具类
│       ├── dao/               # DAO 层，封装各表的操作
│       ├── entity/            # 简单的 POJO 实体
│       ├── Model.java         # DAO 的统一入口
│       └── ServiceLayer.java  # 业务封装，供 JSP 调用
├── web/                  # Web 资源根目录
│   ├── index.jsp         # 主页
│   ├── test_all_functions.jsp # 调试页面，演示所有 ServiceLayer 功能
│   ├── admin/            # 管理后台示例及样式
│   │   ├── sidebar.jsp
│   │   └── css/admin-layout.css
│   └── WEB-INF/
│       ├── web.xml       # 仅配置字符编码过滤器
│       └── lib/          # 运行时依赖 jar（与 lib 下同）
└── .idea/                # IntelliJ IDEA 配置文件（可忽略）
```

### 主要模块简介

- **DBUtil**：读取 `db.properties`，提供获取数据库连接的方法。
- **DAO 层**：每个实体对应一个 DAO，例如 `UserDAO`、`ProductDAO`，封装增删改查操作。
- **Model**：作为 DAO 的统一入口，不包含业务逻辑，方便在其他层调用。
- **ServiceLayer**：在 Model 基础上封装业务规则，对外提供简化的接口，JSP 页面一般只需要调用此类。
- **entity** 包：定义 `Product`、`Order` 等简单 POJO，字段均为 public，便于 JSP 直接访问。
- **web** 目录：存放 JSP 页面及静态资源。`test_all_functions.jsp` 中提供了完整的表单和结果展示，便于在浏览器中快速验证每个接口。

## 运行测试

`src` 目录下的 `ModelTest.java` 与 `ServiceLayerTest.java` 提供了控制台测试入口，可在终端中编译运行：

```bash
javac -d out -cp lib/mysql-connector-j-8.0.33.jar $(find src -name "*.java")
java -cp out:lib/mysql-connector-j-8.0.33.jar ServiceLayerTest
```

运行前请确保 MySQL 数据库已启动且配置正确。

---

该项目结构清晰，功能以简单示例为主，适合作为学习 JSP 与 JDBC 的参考。后续开发者可在此基础上扩展更多业务逻辑或前端页面。希望对你有所帮助！
