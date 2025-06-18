# Tomcat 中文乱码解决方案

## 问题描述
POST提交请求出现中文乱码，数据传递到ServiceLayer.java时已经是乱码。

## 解决方案

### 1. web.xml配置（已完成）
已在web.xml中添加字符编码过滤器：
```xml
<filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>org.apache.catalina.filters.SetCharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
        <param-name>ignore</param-name>
        <param-value>false</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

### 2. JSP页面配置（已完成）
已在test_all_functions.jsp页面开始处添加：
```jsp
<%
    // 统一设置请求字符编码，解决POST提交中文乱码问题
    request.setCharacterEncoding("UTF-8");
%>
```

### 3. Tomcat server.xml配置（需要手动配置）
在Tomcat的conf/server.xml文件中，找到HTTP Connector配置，添加URIEncoding属性：

```xml
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           URIEncoding="UTF-8" />
```

### 4. 验证步骤
1. 重启Tomcat服务器
2. 访问test_all_functions.jsp页面
3. 测试用户注册功能，输入中文用户名
4. 测试商品添加功能，输入中文商品名称和描述
5. 检查数据库中存储的数据是否为正确的中文字符

### 5. 其他注意事项
- 确保数据库连接字符集为UTF-8
- 确保数据库表字符集为utf8mb4或utf8
- 确保IDE编码设置为UTF-8
- 确保JSP页面保存时使用UTF-8编码

### 6. 如果问题仍然存在
可以在JSP页面中添加调试代码：
```jsp
<%
    String testParam = request.getParameter("paramName");
    out.println("原始参数: " + testParam);
    out.println("参数字节长度: " + (testParam != null ? testParam.getBytes().length : 0));
    out.println("参数字符长度: " + (testParam != null ? testParam.length() : 0));
%>
```
