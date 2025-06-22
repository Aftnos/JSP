// 登录页面JavaScript功能

// DOM加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 获取表单元素
    const loginForm = document.getElementById('loginForm');
    const usernameInput = document.getElementById('username');
    const passwordInput = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');
    const errorMessage = document.getElementById('errorMessage');

    // 输入框聚焦效果
    const inputs = document.querySelectorAll('.form-input');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.classList.remove('focused');
        });
    });

    // 表单提交处理
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // 获取输入值
        const username = usernameInput.value.trim();
        const password = passwordInput.value.trim();
        
        // 基础验证
        if (!validateForm(username, password)) {
            return;
        }
        
        // 显示加载状态
        showLoading();
        
        // 执行登录
        performLogin(username, password);
    });

    // 表单验证
    function validateForm(username, password) {
        // 清除之前的错误消息
        hideError();
        
        if (!username) {
            showError('请输入用户名');
            usernameInput.focus();
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
        
        return true;
    }

    // 执行登录
    function performLogin(username, password) {
        // 直接提交表单，让login.jsp处理
        const form = document.getElementById('loginForm');
        
        // 设置表单值
        document.getElementById('username').value = username;
        document.getElementById('password').value = password;
        
        // 提交表单
        form.submit();
    }

    // 显示错误消息
    function showError(message) {
        errorMessage.textContent = message;
        errorMessage.className = 'error-message show';
        errorMessage.style.color = '#F56565';
    }

    // 显示成功消息
    function showSuccess(message) {
        errorMessage.textContent = message;
        errorMessage.className = 'error-message show';
        errorMessage.style.color = '#48BB78';
    }

    // 隐藏错误消息
    function hideError() {
        errorMessage.className = 'error-message';
    }

    // 显示加载状态
    function showLoading() {
        loginBtn.disabled = true;
        loginBtn.textContent = '登录中...';
        loginBtn.style.opacity = '0.7';
    }

    // 隐藏加载状态
    function hideLoading() {
        loginBtn.disabled = false;
        loginBtn.textContent = '登录';
        loginBtn.style.opacity = '1';
    }

    // 回车键登录
    document.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            loginForm.dispatchEvent(new Event('submit'));
        }
    });

    // 忘记密码功能
    const forgotPasswordLink = document.getElementById('forgotPassword');
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', function(e) {
            e.preventDefault();
            alert('请联系管理员重置密码');
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
    
    // 返回登录链接功能（用于注册页面）
    const backToLoginLink = document.getElementById('backToLogin');
    if (backToLoginLink) {
        backToLoginLink.addEventListener('click', function(e) {
            e.preventDefault();
            window.location.href = 'login.jsp';
        });
    }
});