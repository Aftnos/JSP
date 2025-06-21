<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.User" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        if (username != null && password != null && confirmPassword != null && 
            email != null && phone != null && 
            !username.trim().isEmpty() && !password.trim().isEmpty() && 
            !confirmPassword.trim().isEmpty() && !email.trim().isEmpty() && 
            !phone.trim().isEmpty()) {
            
            // 验证密码确认
            if (!password.equals(confirmPassword)) {
                message = "两次输入的密码不一致";
            } else if (password.length() < 6) {
                message = "密码长度不能少于6位";
            } else {
                try {
                    // 创建用户对象
                    User user = new User();
                    user.setUsername(username.trim());
                    user.setPassword(password.trim());
                    user.setEmail(email.trim());
                    user.setPhone(phone.trim());
                    user.setAdmin(false); // 默认为普通用户
                    
                    // 调用注册方法
                    boolean success = ServiceLayer.register(user);
                    
                    if (success) {
                        System.out.println("注册成功，用户名：" + username);
                        // 注册成功，跳转到登录页面
                        response.sendRedirect("login.jsp");
                        return;
                    } else {
                        message = "注册失败，用户名可能已存在";
                    }
                } catch (Exception e) {
                    message = "注册失败，请稍后重试";
                    e.printStackTrace();
                }
            }
        } else {
            message = "请填写所有必填信息";
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理系统注册</title>
    <!-- 引入登录页面样式 -->
    <link rel="stylesheet" type="text/css" href="static/css/login.css">
    <!-- 引入图标字体 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    
    <!-- 注册容器 -->
    <div class="login-container">
        <!-- 左侧图片区域 -->
        <div class="login-image"></div>
        
        <!-- 右侧表单区域 -->
        <div class="login-form-section">
            <div class="login-form-container">
                <!-- 标题 -->
                <h1 class="login-title">小米商城系统注册</h1>
                
                <!-- 注册表单 -->
                <form id="registerForm" method="post" action="register.jsp">
                    <!-- 用户名输入框 -->
                    <div class="form-group">
                        <label class="form-label" for="username">用户名</label>
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
                    
                    <!-- 邮箱输入框 -->
                    <div class="form-group">
                        <label class="form-label" for="email">邮箱</label>
                        <div class="input-container">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   class="form-input" 
                                   placeholder="请输入邮箱地址" 
                                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                                   required>
                        </div>
                    </div>
                    
                    <!-- 手机号输入框 -->
                    <div class="form-group">
                        <label class="form-label" for="phone">手机号</label>
                        <div class="input-container">
                            <i class="fas fa-phone input-icon"></i>
                            <input type="tel" 
                                   id="phone" 
                                   name="phone" 
                                   class="form-input" 
                                   placeholder="请输入手机号" 
                                   value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
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
                                   placeholder="请输入密码（至少6位）" 
                                   required>
                            <i class="fas fa-eye password-toggle" id="togglePassword" title="显示/隐藏密码"></i>
                        </div>
                    </div>
                    
                    <!-- 确认密码输入框 -->
                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">确认密码</label>
                        <div class="input-container">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" 
                                   id="confirmPassword" 
                                   name="confirmPassword" 
                                   class="form-input has-toggle" 
                                   placeholder="请再次输入密码" 
                                   required>
                            <i class="fas fa-eye password-toggle" id="toggleConfirmPassword" title="显示/隐藏密码"></i>
                        </div>
                    </div>
                    
                    <!-- 错误消息显示 -->
                    <% if (message != null) { %>
                        <div class="error-message show" style="color: #F56565;">
                            <%= message %>
                        </div>
                    <% } %>
                    <div id="errorMessage" class="error-message"></div>
                    
                    <!-- 注册按钮 -->
                    <button type="submit" id="registerBtn" class="login-btn">
                        注册
                    </button>
                </form>
                
                <!-- 返回登录链接 -->
                <div class="register-link">
                    <a href="login.jsp" id="backToLogin">已有账号？返回登录</a>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="static/js/login.js"></script>
    
    <!-- 内联脚本处理注册页面特有功能 -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 重写表单验证函数以适应注册页面
            const registerForm = document.getElementById('registerForm');
            const usernameInput = document.getElementById('username');
            const emailInput = document.getElementById('email');
            const phoneInput = document.getElementById('phone');
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const registerBtn = document.getElementById('registerBtn');
            const errorMessage = document.getElementById('errorMessage');
            
            // 注册表单提交处理
            registerForm.addEventListener('submit', function(e) {
                // 获取输入值
                const username = usernameInput.value.trim();
                const email = emailInput.value.trim();
                const phone = phoneInput.value.trim();
                const password = passwordInput.value.trim();
                const confirmPassword = confirmPasswordInput.value.trim();
                
                // 验证表单
                if (!validateRegisterForm(username, email, phone, password, confirmPassword)) {
                    e.preventDefault();
                    return;
                }
                
                // 显示加载状态
                showRegisterLoading();
                
                // 让表单正常提交到服务器
            });
            
            // 注册表单验证
            function validateRegisterForm(username, email, phone, password, confirmPassword) {
                // 清除之前的错误消息
                hideError();
                
                if (!username) {
                    showError('请输入用户名');
                    usernameInput.focus();
                    return false;
                }
                
                if (username.length < 3) {
                    showError('用户名长度不能少于3位');
                    usernameInput.focus();
                    return false;
                }
                
                if (!email) {
                    showError('请输入邮箱地址');
                    emailInput.focus();
                    return false;
                }
                
                if (!isValidEmail(email)) {
                    showError('请输入有效的邮箱地址');
                    emailInput.focus();
                    return false;
                }
                
                if (!phone) {
                    showError('请输入手机号');
                    phoneInput.focus();
                    return false;
                }
                
                if (!isValidPhone(phone)) {
                    showError('请输入有效的手机号');
                    phoneInput.focus();
                    return false;
                }
                
                if (!password) {
                    showError('请输入密码');
                    passwordInput.focus();
                    return false;
                }
                
                if (password.length < 6) {
                    showError('密码长度不能少于6位');
                    passwordInput.focus();
                    return false;
                }
                
                if (!confirmPassword) {
                    showError('请确认密码');
                    confirmPasswordInput.focus();
                    return false;
                }
                
                if (password !== confirmPassword) {
                    showError('两次输入的密码不一致');
                    confirmPasswordInput.focus();
                    return false;
                }
                
                return true;
            }
            
            // 邮箱格式验证
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }
            
            // 手机号格式验证
            function isValidPhone(phone) {
                const phoneRegex = /^1[3-9]\d{9}$/;
                return phoneRegex.test(phone);
            }
            
            // 显示错误消息
            function showError(message) {
                errorMessage.textContent = message;
                errorMessage.className = 'error-message show';
                errorMessage.style.color = '#F56565';
            }
            
            // 隐藏错误消息
            function hideError() {
                errorMessage.className = 'error-message';
            }
            
            // 显示注册加载状态
            function showRegisterLoading() {
                registerBtn.disabled = true;
                registerBtn.textContent = '注册中...';
                registerBtn.style.opacity = '0.7';
            }
            
            // 自动聚焦到用户名输入框
            if (usernameInput && !usernameInput.value) {
                usernameInput.focus();
            }
            
            // 密码确认实时验证
            confirmPasswordInput.addEventListener('blur', function() {
                const password = passwordInput.value.trim();
                const confirmPassword = this.value.trim();
                
                if (confirmPassword && password !== confirmPassword) {
                    showError('两次输入的密码不一致');
                } else {
                    hideError();
                }
            });
            
            // 密码显示/隐藏功能
            const togglePassword = document.getElementById('togglePassword');
            const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
            
            // 主密码输入框的显示/隐藏
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
            
            // 确认密码输入框的显示/隐藏
            if (toggleConfirmPassword && confirmPasswordInput) {
                toggleConfirmPassword.addEventListener('click', function() {
                    const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    confirmPasswordInput.setAttribute('type', type);
                    
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