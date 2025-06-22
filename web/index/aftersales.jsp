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
    <link rel="stylesheet" href="css/aftersales.css"/>
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
