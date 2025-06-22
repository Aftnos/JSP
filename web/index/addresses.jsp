<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Address" %>
<%
    Object obj = session.getAttribute("user");
    if(obj == null){ response.sendRedirect("login.jsp"); return; }
    com.entity.User u = (com.entity.User)obj;
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String message = null;
    if("add".equals(action)){
        Address a = new Address();
        a.setUserId(u.getId());
        a.setReceiver(request.getParameter("receiver"));
        a.setPhone(request.getParameter("phone"));
        String region = request.getParameter("region");
        String detail = request.getParameter("detail");
        if(region!=null && !region.isEmpty()) detail = region + " " + detail;
        a.setDetail(detail);
        if(ServiceLayer.addAddress(a)) message="添加成功"; else message="添加失败";
    }else if("update".equals(action)){
        Address a = new Address();
        a.setId(Integer.parseInt(request.getParameter("id")));
        a.setUserId(u.getId());
        a.setReceiver(request.getParameter("receiver"));
        a.setPhone(request.getParameter("phone"));
        String region = request.getParameter("region");
        String detail = request.getParameter("detail");
        if(region!=null && !region.isEmpty()) detail = region + " " + detail;
        a.setDetail(detail);
        if(ServiceLayer.updateAddress(a)) message="已更新"; else message="更新失败";
    }else if("delete".equals(action)){
        int id = Integer.parseInt(request.getParameter("id"));
        if(ServiceLayer.deleteAddress(id)) message="已删除"; else message="删除失败";
    }else if("default".equals(action)){
        int id = Integer.parseInt(request.getParameter("id"));
        ServiceLayer.setDefaultAddress(u.getId(), id);
        message="已设置默认";
    }
    java.util.List<Address> list = ServiceLayer.getAddresses(u.getId());
    Address edit = null;
    String editId = request.getParameter("editId");
    if(editId != null){
        int eid = Integer.parseInt(editId);
        for(Address a : list){ if(a.getId()==eid){ edit=a; break; } }
    }
    String showForm = request.getParameter("showForm");
    boolean isAddMode = "true".equals(showForm) || edit != null;
%>
<html>
<head>
    <title><%= edit != null ? "编辑地址" : (isAddMode ? "新增地址" : "收货地址") %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <link rel="stylesheet" href="css/main.css"/>
    <link rel="stylesheet" href="css/addresses.css"/>
</head>
<body>
    <% if(isAddMode) { %>
        <!-- 新增/编辑地址页面 -->
        <div class="address-header">
            <button class="back-btn" onclick="window.location.href='addresses.jsp'">&lt;</button>
            <div class="header-title"><%= edit != null ? "编辑地址" : "新增地址" %></div>
        </div>
        
        <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
        
        <form method="post" class="address-form">
            <input type="hidden" name="action" value="<%= (edit!=null)?"update":"add" %>"/>
            <% if(edit!=null){ %><input type="hidden" name="id" value="<%= edit.getId() %>"/><% } %>
            
            <div class="form-group">
                <label class="form-label">收货姓名</label>
                <input type="text" name="receiver" class="form-input" placeholder="收货人姓名" 
                       value="<%= edit!=null?edit.getReceiver():"" %>" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">手机号码</label>
                <input type="tel" name="phone" class="form-input" placeholder="收货人手机号码" 
                       value="<%= edit!=null?edit.getPhone():"" %>" required>
            </div>
            
            <div class="form-group">
                <label class="form-label">收货地区</label>
                <div class="location-group">
                    <select id="province" class="location-select"></select>
                    <select id="city" class="location-select"></select>
                    <select id="district" class="location-select"></select>
                    <button type="button" class="location-btn">定位 📍</button>
                </div>
                <input type="hidden" name="region" id="regionField"/>
            </div>
            
            <div class="form-group">
                <label class="form-label">详细地址</label>
                <input type="text" name="detail" class="form-input" placeholder="街道、楼牌号等" 
                       value="<%= edit!=null?edit.getDetail():"" %>" required>
            </div>
            
            <div class="form-group">
                <label style="display: flex; align-items: center; gap: 8px; font-size: 14px; color: #333;">
                    <input type="checkbox" name="setDefault" value="true" 
                           <%= edit != null && edit.isDefault() ? "checked" : "" %>>
                    设为默认地址
                </label>
            </div>
            
            <button type="submit" class="save-btn">保存</button>
        </form>
    <% } else { %>
        <!-- 地址列表页面 -->
        <div class="address-header">
            <button class="back-btn" onclick="window.history.back()">&lt;</button>
            <div class="header-title">收货地址</div>
        </div>
        
        <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
        
        <div class="address-list">
            <% if(list.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon">📍</div>
                    <div>暂无收货地址</div>
                </div>
            <% } else { %>
                <% for(Address a : list){ %>
                    <div class="address-item <%= a.isDefault() ? "default" : "" %>">
                        <div class="address-info">
                            <div class="receiver-info">
                                <span class="receiver-name"><%= a.getReceiver() %></span>
                                <span class="receiver-phone"><%= a.getPhone() %></span>
                                <% if(a.isDefault()) { %>
                                    <span class="default-tag">默认</span>
                                <% } %>
                            </div>
                            <div class="address-detail"><%= a.getDetail() %></div>
                        </div>
                        
                        <div class="address-actions">
                            <button class="action-btn primary" onclick="window.location.href='addresses.jsp?editId=<%= a.getId() %>'">
                                编辑
                            </button>
                            <% if(!a.isDefault()){ %>
                                <form method="post" style="display:inline">
                                    <input type="hidden" name="action" value="default"/>
                                    <input type="hidden" name="id" value="<%= a.getId() %>"/>
                                    <button type="submit" class="action-btn">设为默认</button>
                                </form>
                            <% } %>
                            <form method="post" style="display:inline" onsubmit="return confirm('确定删除这个地址吗?');">
                                <input type="hidden" name="action" value="delete"/>
                                <input type="hidden" name="id" value="<%= a.getId() %>"/>
                                <button type="submit" class="action-btn">删除</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
        
        <button class="add-address-btn" onclick="window.location.href='addresses.jsp?showForm=true'">
            ➕ 添加新地址
        </button>
</div>
    <% } %>
    <!-- 底部导航 -->
    <jsp:include page="footer.jsp" />
    <script src="js/pcas.js"></script>
</body>
</html>
