<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.AfterSale" %>
<%@ page import="com.entity.Binding" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String message = null;
    String prefilledSN = request.getParameter("sn"); // 从URL获取预填充的SN码
    if("apply".equals(request.getParameter("action"))){
        AfterSale a = new AfterSale();
        a.setUserId(u.getId());
        a.setSnCode(request.getParameter("sn"));
        a.setType(request.getParameter("type"));
        a.setReason(request.getParameter("reason"));
        if(ServiceLayer.applyAfterSale(a)) message="已提交"; else message="提交失败";
    }
    java.util.List<AfterSale> list = ServiceLayer.getAfterSalesByUser(u.getId());
    java.util.List<Binding> bindings = ServiceLayer.getBindingsByUser(u.getId()); // 获取用户绑定设备
%>
<html>
<head>
    <title>售后服务</title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
</head>
<body>
<header>
    <div class="logo"><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div class="user">
        <% if(session.getAttribute("user")!=null){ %>
        欢迎，<%= ((com.entity.User)session.getAttribute("user")).getUsername() %> | <a href="logout.jsp" style="color:#fff;">退出</a>
        <% }else{ %>
        <a href="login.jsp" style="color:#fff;">登录</a> | <a href="register.jsp" style="color:#fff;">注册</a>
        <% } %>
    </div>
</header>
<style>
    .service-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 16px;
        background: #fff;
        border-bottom: 1px solid #e0e0e0;
    }
    .service-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
    }
    .back-btn {
        background: #f5f5f5;
        color: #666;
        border: none;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        cursor: pointer;
        text-decoration: none;
    }
    .service-form {
        background: white;
        margin: 16px;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 8px;
    }
    .form-input, .form-select, .form-textarea {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        font-size: 16px;
        background: #f9f9f9;
        box-sizing: border-box;
    }
    .form-input:focus, .form-select:focus, .form-textarea:focus {
        outline: none;
        border-color: #ff6700;
        background: white;
    }
    .form-textarea {
        min-height: 80px;
        resize: vertical;
    }
    .submit-btn {
        width: 100%;
        background: #ff6700;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
    }
    .submit-btn:hover {
        background: #e55a00;
    }
    .message {
        background: #e8f5e8;
        color: #2d7d2d;
        padding: 12px 16px;
        margin: 16px;
        border-radius: 8px;
        border-left: 4px solid #4caf50;
    }
    .message.error {
        background: #ffeaea;
        color: #d32f2f;
        border-left-color: #f44336;
    }
    .service-list {
        margin: 16px;
    }
    .list-title {
        font-size: 16px;
        font-weight: 600;
        color: #333;
        margin-bottom: 12px;
    }
    .service-item {
        background: white;
        border-radius: 12px;
        padding: 16px;
        margin-bottom: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .service-header-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }
    .service-sn {
        font-size: 16px;
        font-weight: 600;
        color: #333;
    }
    .service-status {
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 500;
    }
    .status-pending {
        background: #fff3cd;
        color: #856404;
    }
    .status-processing {
        background: #cce5ff;
        color: #004085;
    }
    .status-completed {
        background: #e8f5e8;
        color: #2d7d2d;
    }
    .service-details {
        font-size: 14px;
        color: #666;
        line-height: 1.5;
    }
    .service-type {
        font-weight: 600;
        color: #333;
    }
</style>

<div class="service-header">
    <div class="service-title">售后服务</div>
    <a href="service.jsp" class="back-btn">返回</a>
</div>

<% if(message!=null){ %>
    <div class="message <%= message.contains("失败") ? "error" : "" %>"><%= message %></div>
<% } %>

<div class="service-form">
    <form method="post">
        <input type="hidden" name="action" value="apply"/>
        <div class="form-group">
            <label class="form-label">选择设备</label>
            <select name="sn" class="form-select" required>
                <option value="">请选择要申请售后的设备</option>
                <% if(bindings != null && !bindings.isEmpty()) { %>
                    <% for(Binding binding : bindings) { %>
                        <option value="<%= binding.getSnCode() %>" 
                            <%= (prefilledSN != null && prefilledSN.equals(binding.getSnCode())) ? "selected" : "" %>>
                            SN: <%= binding.getSnCode() %>
                        </option>
                    <% } %>
                <% } %>
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">服务类型</label>
            <select name="type" class="form-select" required>
                <option value="">请选择服务类型</option>
                <option value="维修">维修</option>
                <option value="换货">换货</option>
                <option value="退货">退货</option>
                <option value="咨询">咨询</option>
            </select>
        </div>
        <div class="form-group">
            <label class="form-label">问题描述</label>
            <textarea name="reason" class="form-textarea" placeholder="请详细描述您遇到的问题..." required></textarea>
        </div>
        <button type="submit" class="submit-btn">提交申请</button>
    </form>
</div>

<div class="service-list">
    <div class="list-title">我的售后记录</div>
    <% if(list != null && !list.isEmpty()) { %>
        <% for(AfterSale a : list){ %>
            <div class="service-item">
                <div class="service-header-info">
                    <div class="service-sn">SN: <%= a.getSnCode() %></div>
                    <div class="service-status 
                        <%= "待处理".equals(a.getStatus()) ? "status-pending" : 
                            "处理中".equals(a.getStatus()) ? "status-processing" : "status-completed" %>">
                        <%= a.getStatus() %>
                    </div>
                </div>
                <div class="service-details">
                    <div><span class="service-type">服务类型:</span> <%= a.getType() %></div>
                    <div><span class="service-type">问题描述:</span> <%= a.getReason() %></div>
                    <% if(a.getRemark() != null && !a.getRemark().trim().isEmpty()) { %>
                        <div><span class="service-type">处理备注:</span> <%= a.getRemark() %></div>
                    <% } %>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div style="text-align: center; padding: 40px; color: #999;">
            <div style="font-size: 48px; margin-bottom: 16px;">🛠️</div>
            <div>暂无售后记录</div>
        </div>
    <% } %>
</div>
<!-- 底部导航 -->
<jsp:include page="footer.jsp" />
</body>
</html>
