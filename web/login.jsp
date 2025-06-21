<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理系统登录</title>
    <!-- 引入登录页面样式 -->
    <link rel="stylesheet" type="text/css" href="static/css/login.css">
    <!-- 引入图标字体 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <%
        request.setCharacterEncoding("UTF-8");
        String message = request.getParameter("message"); // 获取URL参数中的消息（如注册成功消息）
        
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            if (username != null && password != null && !username.trim().isEmpty() && !password.trim().isEmpty()) {
                try {
                    User user = ServiceLayer.login(username.trim(), password.trim());
                    
                    if (user != null) {
                        // 登录成功，设置session
                        session.setAttribute("user", user);
                        session.setAttribute("userId", user.getId());
                        session.setAttribute("username", user.getUsername());
                        
                        // 根据用户类型跳转
                        if (user.isAdmin() || user.getId() == 1) {
                            response.sendRedirect("admin/index.jsp");
                            return;
                        } else {
                            response.sendRedirect("front/index.jsp");
                            return;
                        }
                    } else {
                        message = "用户名或密码错误";
                    }
                } catch (Exception e) {
                    message = "登录失败，请稍后重试";
                    e.printStackTrace();
                }
            } else {
                message = "请输入用户名和密码";
            }
        }
        
        // 检查是否已经登录（除非是重新登录请求）
        String relogin = request.getParameter("relogin");
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null && !"true".equals(relogin)) {
            if (currentUser.isAdmin() || currentUser.getId() == 1) {
                response.sendRedirect("admin/index.jsp");
                return;
            } else {
                response.sendRedirect("front/index.jsp");
                return;
            }
        }
    %>
    
    <!-- 登录容器 -->
    <div class="login-container">
        <!-- 左侧图片区域 -->
        <div class="login-image"></div>
        
        <!-- 右侧表单区域 -->
        <div class="login-form-section">
            <div class="login-form-container">
                <!-- 标题 -->
                <h1 class="login-title">小米商城系统登录</h1>
                
                <!-- 登录表单 -->
                <form id="loginForm" method="post" action="login.jsp">
                    <!-- 用户名输入框 -->
                    <div class="form-group">
                        <label class="form-label" for="username">账号</label>
                        <div class="input-container">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" 
                                   id="username" 
                                   name="username" 
                                   class="form-input" 
                                   placeholder="请输入用户名" 
                                   value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                                   required>
                        </div>
                    </div>
                    
                    <!-- 密码输入框 -->
                    <div class="form-group">
                        <label class="form-label" for="password">密码</label>
                        <div class="input-container">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" 
                                   id="password" 
                                   name="password" 
                                   class="form-input has-toggle" 
                                   placeholder="请输入密码" 
                                   required>
                            <i class="fas fa-eye password-toggle" id="togglePassword" title="显示/隐藏密码"></i>
                        </div>
                        <!-- 忘记密码链接 -->
                        <div class="forgot-password">
                            <a href="#" id="forgotPassword">忘记密码？</a>
                        </div>
                    </div>
                    
                    <!-- 错误消息显示 -->
                    <% if (message != null) { %>
                        <div class="error-message show" style="color: #F56565;">
                            <%= message %>
                        </div>
                    <% } %>
                    <div id="errorMessage" class="error-message"></div>
                    
                    <!-- 登录按钮 -->
                    <button type="submit" id="loginBtn" class="login-btn">
                        登录
                    </button>
                </form>
                
                <!-- 注册链接 -->
                <div class="register-link">
                    <a href="#" id="registerLink">还没账号？去注册</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="static/js/login.js"></script>
    
    <!-- 内联脚本处理忘记密码和注册功能 -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 忘记密码功能
            const forgotPasswordLink = document.getElementById('forgotPassword');
            if (forgotPasswordLink) {
                forgotPasswordLink.addEventListener('click', function(e) {
                    e.preventDefault();
                    alert('请联系管理员重置密码\n\n管理员邮箱: admin@xiaomi.com\n客服电话: 400-100-5678');
                });
            }
            
            // 注册链接功能
            const registerLink = document.getElementById('registerLink');
            if (registerLink) {
                registerLink.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.location.href = 'register.jsp';
                });
            }
            
            // 自动聚焦到用户名输入框
            const usernameInput = document.getElementById('username');
            if (usernameInput && !usernameInput.value) {
                usernameInput.focus();
            }
            
            // 密码显示/隐藏功能
            const togglePassword = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');
            
            if (togglePassword && passwordInput) {
                togglePassword.addEventListener('click', function() {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);
                    
                    // 切换图标
                    if (type === 'text') {
                        this.classList.remove('fa-eye');
                        this.classList.add('fa-eye-slash');
                        this.setAttribute('title', '隐藏密码');
                    } else {
                        this.classList.remove('fa-eye-slash');
                        this.classList.add('fa-eye');
                        this.setAttribute('title', '显示密码');
                    }
                });
            }
        });
    </script>
</body>
</html>