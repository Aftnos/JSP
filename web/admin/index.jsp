<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>小米商城管理系统</title>
    <!-- 引入基础样式 -->
    <link rel="stylesheet" type="text/css" href="../static/css/admin-layout.css">
    <!-- 引入主样式 -->
    <link rel="stylesheet" type="text/css" href="./css/main.css">
</head>
<body>
    <!-- 后台管理系统容器 -->
    <div class="admin-container">
        <!-- 侧边栏组件 -->
        <%@ include file="components/sidebar.jsp" %>
        
        <!-- 主内容区域 -->
        <div class="main-content" id="mainContent">
            <!-- 顶部用户信息栏组件 -->
            <%@ include file="components/header.jsp" %>
            
            <!-- 页面内容区域 -->
            <div class="page-content" id="pageContent">
                <div class="welcome-section">
                    <h1>欢迎使用小米商城管理系统</h1>
                    <p>请从左侧菜单选择功能模块进行操作。</p>
                    
                    <!-- 快捷操作卡片 -->
                    <div class="quick-actions">
                        <div class="action-card" onclick="navigateTo('user-profile-management')">
                            <div class="card-icon">👥</div>
                            <div class="card-title">用户管理</div>
                            <div class="card-desc">管理用户资料和地址信息</div>
                        </div>
                        <div class="action-card" onclick="navigateTo('product-management')">
                            <div class="card-icon">📦</div>
                            <div class="card-title">商品管理</div>
                            <div class="card-desc">管理商品分类和商品信息</div>
                        </div>
                        <div class="action-card" onclick="navigateTo('order-global-query')">
                            <div class="card-icon">📋</div>
                            <div class="card-title">订单管理</div>
                            <div class="card-desc">查询和管理订单状态</div>
                        </div>
                        <div class="action-card" onclick="navigateTo('sn-batch-generation')">
                            <div class="card-icon">🔢</div>
                            <div class="card-title">SN码管理</div>
                            <div class="card-desc">批量生成和管理SN码</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="./js/main.js"></script>
</body>
</html>