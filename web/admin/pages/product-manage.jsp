<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.entity.User" %>

<%
    // 检查管理员权限
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理 - 后台管理系统</title>
    
    <!-- 引入Font Awesome图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- 引入样式文件 -->
    <link rel="stylesheet" href="../../static/css/admin-layout.css">
    <style>
        .page-container {
            padding: 20px;
            background: #f5f5f5;
            min-height: 100vh;
        }
        
        .page-header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .page-title {
            margin: 0;
            color: #333;
            font-size: 24px;
        }
        
        .page-description {
            margin: 8px 0 0 0;
            color: #666;
            font-size: 14px;
        }
        
        .content-card {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .placeholder-icon {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .placeholder-text {
            color: #999;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .placeholder-desc {
            color: #ccc;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- 侧边栏 -->
        <%@ include file="../components/sidebar.jsp" %>
        
        <!-- 主内容区 -->
        <div class="main-content">
            <!-- 顶部用户信息栏 -->
            <%@ include file="../components/header.jsp" %>
            
            <!-- 页面内容 -->
            <div class="page-container">
                <div class="page-header">
                    <h1 class="page-title">
                        <i class="fas fa-box"></i> 商品管理
                    </h1>
                    <p class="page-description">管理商品信息、库存和状态</p>
                </div>
                
                <div class="content-card">
                    <div class="placeholder-icon">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="placeholder-text">商品管理功能</div>
                    <div class="placeholder-desc">此功能正在开发中，敬请期待...</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>