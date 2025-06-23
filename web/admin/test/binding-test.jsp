<%@ page import="test.BindingTest" %>
<%@ page import="com.ServiceLayer" %><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Binding" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>绑定SN码测试页面</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
        }
        .content {
            padding: 20px;
        }
        .test-section {
            margin-bottom: 30px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
        }
        .section-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e0e0e0;
            font-weight: bold;
            color: #333;
        }
        .section-content {
            padding: 20px;
        }
        .user-card {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            margin-bottom: 15px;
            padding: 15px;
        }
        .user-info {
            font-weight: bold;
            color: #495057;
            margin-bottom: 10px;
        }
        .binding-list {
            margin-left: 20px;
        }
        .binding-item {
            background-color: white;
            border: 1px solid #e9ecef;
            border-radius: 4px;
            padding: 10px;
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .sn-code {
            font-family: 'Courier New', monospace;
            background-color: #e9ecef;
            padding: 2px 6px;
            border-radius: 3px;
            font-weight: bold;
        }
        .bind-time {
            color: #6c757d;
            font-size: 14px;
        }
        .no-bindings {
            color: #6c757d;
            font-style: italic;
            margin-left: 20px;
        }
        .stats {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
        }
        .stats-item {
            display: inline-block;
            margin: 0 20px;
        }
        .stats-number {
            font-size: 24px;
            font-weight: bold;
            display: block;
        }
        .stats-label {
            font-size: 14px;
            opacity: 0.9;
        }
        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin: 5px;
        }
        .btn:hover {
            opacity: 0.9;
        }
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .alert-info {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }
        .alert-warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }
        .loading {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>绑定SN码测试页面</h1>
            <p>测试 ServiceLayer 中与SN码绑定相关的所有功能</p>
        </div>
        
        <div class="content">
            <%
                try {
                    // 获取所有用户
                    List<User> allUsers = ServiceLayer.getAllUsers();
                    
                    if (allUsers == null || allUsers.isEmpty()) {
            %>
                        <div class="alert alert-warning">
                            <strong>警告:</strong> 系统中没有找到任何用户，无法进行绑定测试。
                        </div>
            <%
                    } else {
                        // 统计数据
                        int totalUsers = allUsers.size();
                        int totalBindings = 0;
                        int usersWithBindings = 0;
                        
                        for (User user : allUsers) {
                            List<Binding> userBindings = ServiceLayer.getBindingsByUser(user.getId());
                            int bindingCount = userBindings != null ? userBindings.size() : 0;
                            totalBindings += bindingCount;
                            if (bindingCount > 0) {
                                usersWithBindings++;
                            }
                        }
            %>
                        <!-- 统计信息 -->
                        <div class="stats">
                            <div class="stats-item">
                                <span class="stats-number"><%= totalUsers %></span>
                                <span class="stats-label">总用户数</span>
                            </div>
                            <div class="stats-item">
                                <span class="stats-number"><%= usersWithBindings %></span>
                                <span class="stats-label">有绑定的用户</span>
                            </div>
                            <div class="stats-item">
                                <span class="stats-number"><%= totalBindings %></span>
                                <span class="stats-label">总绑定记录</span>
                            </div>
                        </div>
                        
                        <div class="alert alert-info">
                            <strong>测试说明:</strong> 以下显示了所有用户的SN码绑定情况，包括绑定的SN码和绑定时间。
                        </div>
                        
                        <!-- 用户绑定详情 -->
                        <div class="test-section">
                            <div class="section-header">
                                所有用户SN绑定情况
                            </div>
                            <div class="section-content">
            <%
                        for (User user : allUsers) {
                            List<Binding> userBindings = ServiceLayer.getBindingsByUser(user.getId());
                            int bindingCount = userBindings != null ? userBindings.size() : 0;
            %>
                                <div class="user-card">
                                    <div class="user-info">
                                        用户: <%= user.getUsername() %> 
                                        (ID: <%= user.getId() %>, 邮箱: <%= user.getEmail() %>)
                                        - 绑定数量: <%= bindingCount %>
                                    </div>
                                    
            <%
                            if (bindingCount == 0) {
            %>
                                        <div class="no-bindings">该用户暂无绑定的SN码</div>
            <%
                            } else {
            %>
                                        <div class="binding-list">
            <%
                                for (int i = 0; i < userBindings.size(); i++) {
                                    Binding binding = userBindings.get(i);
            %>
                                            <div class="binding-item">
                                                <div>
                                                    <strong>[<%= i + 1 %>]</strong> 
                                                    <span class="sn-code"><%= binding.getSnCode() %></span>
                                                    <small>(绑定ID: <%= binding.getId() %>)</small>
                                                </div>
                                                <div class="bind-time">
                                                    <%= binding.getBindTime() %>
                                                </div>
                                            </div>
            <%
                                }
            %>
                                        </div>
            <%
                            }
            %>
                                </div>
            <%
                        }
            %>
                            </div>
                        </div>
                        
                        <!-- 绑定SN码功能 -->
                        <div class="test-section">
                            <div class="section-header">
                                绑定SN码测试
                            </div>
                            <div class="section-content">
                                <form method="post" action="" style="margin-bottom: 20px;">
                                    <div style="margin-bottom: 15px;">
                                        <label for="userId" style="display: block; margin-bottom: 5px; font-weight: bold;">选择用户:</label>
                                        <select id="userId" name="userId" style="width: 200px; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                                            <option value="">请选择用户</option>
<%
                                            for (User user : allUsers) {
%>
                                            <option value="<%= user.getId() %>"><%= user.getUsername() %> (ID: <%= user.getId() %>)</option>
<%
                                            }
%>
                                        </select>
                                    </div>
                                    <div style="margin-bottom: 15px;">
                                        <label for="snCode" style="display: block; margin-bottom: 5px; font-weight: bold;">SN码:</label>
                                        <input type="text" id="snCode" name="snCode" placeholder="输入要绑定的SN码" 
                                               style="width: 300px; padding: 8px; border: 1px solid #ddd; border-radius: 4px;" />
                                        <button type="button" onclick="generateRandomSN()" 
                                                style="margin-left: 10px; padding: 8px 12px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer;">
                                            生成随机SN
                                        </button>
                                    </div>
                                    <button type="submit" name="action" value="bind" class="btn">
                                        绑定SN码
                                    </button>
                                </form>
                                
<%
                                // 处理绑定请求
                                String action = request.getParameter("action");
                                if ("bind".equals(action)) {
                                    String userIdStr = request.getParameter("userId");
                                    String snCode = request.getParameter("snCode");
                                    
                                    if (userIdStr != null && !userIdStr.isEmpty() && snCode != null && !snCode.trim().isEmpty()) {
                                        try {
                                            int userId = Integer.parseInt(userIdStr);
                                            boolean bindResult = ServiceLayer.bindSN(userId, snCode.trim());
                                            
                                            if (bindResult) {
%>
                                                <div class="alert alert-info">
                                                    <strong>绑定成功!</strong> 用户ID <%= userId %> 已成功绑定SN码: <%= snCode.trim() %>
                                                    <br><small>页面将在3秒后自动刷新以显示最新数据</small>
                                                </div>
                                                <script>
                                                    setTimeout(function() {
                                                        location.reload();
                                                    }, 3000);
                                                </script>
<%
                                            } else {
%>
                                                <div class="alert alert-warning">
                                                    <strong>绑定失败!</strong> 可能的原因：SN码已被绑定、SN码不存在或数据库错误
                                                </div>
<%
                                            }
                                        } catch (NumberFormatException e) {
%>
                                            <div class="alert alert-warning">
                                                <strong>错误:</strong> 用户ID格式不正确
                                            </div>
<%
                                        }
                                    } else {
%>
                                        <div class="alert alert-warning">
                                            <strong>错误:</strong> 请选择用户并输入SN码
                                        </div>
<%
                                    }
                                }
%>
                            </div>
                        </div>
                        
                        <!-- 测试功能按钮 -->
                        <div class="test-section">
                            <div class="section-header">
                                其他测试功能
                            </div>
                            <div class="section-content">
                                <p>可以通过以下按钮执行不同的测试功能:</p>
                                <button class="btn" onclick="runTest('integrity')">
                                    运行完整性测试
                                </button>
                                <button class="btn" onclick="runTest('bind')">
                                    测试绑定功能
                                </button>
                                <button class="btn" onclick="runTest('unbind')">
                                    测试解绑功能
                                </button>
                                <button class="btn" onclick="location.reload()">
                                    刷新页面
                                </button>
                                
                                <div id="testResult" style="margin-top: 20px;"></div>
                            </div>
                        </div>
            <%
                    }
                } catch (Exception e) {
            %>
                    <div class="alert alert-warning">
                        <strong>错误:</strong> 获取绑定数据时发生异常: <%= e.getMessage() %>
                    </div>
            <%
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
    
    <script>
        function generateRandomSN() {
            // 生成随机SN码，格式：SN + 当前时间戳 + 随机数
            const timestamp = Date.now();
            const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
            const snCode = 'SN' + timestamp + random;
            document.getElementById('snCode').value = snCode;
        }
        
        function runTest(testType) {
            const resultDiv = document.getElementById('testResult');
            resultDiv.innerHTML = '<div class="loading">正在执行测试...</div>';
            
            // 模拟测试执行
            setTimeout(() => {
                let result = '';
                switch(testType) {
                    case 'integrity':
                        result = '<div class="alert alert-info"><strong>完整性测试:</strong> 已检查所有用户的绑定情况，详情见上方列表。</div>';
                        break;
                    case 'bind':
                        result = '<div class="alert alert-info"><strong>绑定测试:</strong> 绑定功能测试需要在后台Java代码中执行，请查看控制台输出。</div>';
                        break;
                    case 'unbind':
                        result = '<div class="alert alert-info"><strong>解绑测试:</strong> 解绑功能测试需要在后台Java代码中执行，请查看控制台输出。</div>';
                        break;
                }
                resultDiv.innerHTML = result;
            }, 1000);
        }
        
        // 页面加载完成后的初始化
        document.addEventListener('DOMContentLoaded', function() {
            console.log('绑定SN码测试页面已加载');
            
            // 可以在这里调用Java测试方法
            <%
                // 在页面加载时执行测试
                try {
                    String testResults = test.BindingTest.getTestResults();
            %>
                    console.log('测试结果:\n<%= testResults.replace("\n", "\\n") %>');
            <%
                } catch (Exception e) {
            %>
                    console.log('执行测试时发生异常: <%= e.getMessage() %>');
            <%
                }
            %>
        });
    </script>
</body>
</html>