# com.Model.java 测试说明

## 问题诊断

根据测试输出，主要问题是：
1. **MySQL JDBC驱动未找到** - `ClassNotFoundException: com.mysql.cj.jdbc.Driver`
2. **数据库连接失败** - `No suitable driver found for jdbc:mysql://...`

## 解决方案

### 方案1：使用批处理脚本（推荐）

1. 运行项目根目录下的 `setup-mysql-driver.bat`
2. 脚本会自动下载MySQL JDBC驱动到 `lib` 目录
3. 自动编译Java文件
4. 按提示运行测试

```bash
# 双击运行或在命令行执行
setup-mysql-driver.bat
```

### 方案2：手动下载驱动

1. 创建 `lib` 目录
2. 下载MySQL JDBC驱动：
   - 下载地址：https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar
   - 保存到 `lib/mysql-connector-java-8.0.33.jar`

3. 编译和运行：
```bash
# 编译
javac -cp "lib\mysql-connector-java-8.0.33.jar" -d . src\*.java

# 运行测试
java -cp ".;lib\mysql-connector-java-8.0.33.jar" ModelTest
```

### 方案3：使用Maven（如果已安装）

项目已包含 `pom.xml` 文件，可以使用Maven管理依赖：

```bash
# 编译项目
mvn compile

# 运行测试
mvn exec:java -Dexec.mainClass="ModelTest"
```

## 数据库配置

确保以下配置正确：

### 1. 数据库连接配置 (`src/db.properties`)
```properties
url=jdbc:mysql://localhost:3306/xiaomi_mall?useSSL=false&serverTimezone=UTC
user=root
password=123456
```

### 2. MySQL服务状态
- 确保MySQL服务已启动
- 确保端口3306可访问
- 确保用户名密码正确

### 3. 数据库和表结构
- 确保数据库 `xiaomi_mall` 已创建
- 运行 `sql/schema.sql` 创建必要的表：
  - `users` - 用户表
  - `admins` - 管理员表
  - `products` - 商品表
  - `orders` - 订单表
  - `order_items` - 订单项表

## 测试功能

改进后的测试类包含以下功能：

1. **驱动检查** - 自动检测MySQL JDBC驱动是否可用
2. **数据库连接测试** - 测试连接并检查表结构
3. **用户操作测试** - 添加用户、登录验证
4. **管理员操作测试** - 管理员登录验证
5. **商品操作测试** - CRUD操作
6. **订单操作测试** - 创建订单、查询订单、更新状态
7. **错误处理** - 提供详细的错误信息和解决建议

## 常见问题

### Q: 仍然提示驱动未找到
A: 检查classpath是否正确包含了MySQL驱动jar文件

### Q: 数据库连接被拒绝
A: 检查MySQL服务是否启动，用户名密码是否正确

### Q: 表不存在错误
A: 运行sql/schema.sql创建必要的数据库表结构

### Q: 编译错误
A: 确保Java环境正确配置，使用正确的classpath参数

## 项目结构

```
JSP/
├── src/
│   ├── com.Model.java          # 数据库操作模型类
│   ├── ModelTest.java      # 测试类
│   └── db.properties       # 数据库配置
├── lib/                    # 依赖库目录（需创建）
├── sql/
│   └── schema.sql          # 数据库表结构
├── pom.xml                 # Maven配置文件
├── setup-mysql-driver.bat  # 自动设置脚本
└── README-测试说明.md       # 本说明文件
```