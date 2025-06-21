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
        a.setDetail(request.getParameter("detail"));
        if(ServiceLayer.addAddress(a)) message="添加成功"; else message="添加失败";
    }else if("update".equals(action)){
        Address a = new Address();
        a.setId(Integer.parseInt(request.getParameter("id")));
        a.setUserId(u.getId());
        a.setReceiver(request.getParameter("receiver"));
        a.setPhone(request.getParameter("phone"));
        a.setDetail(request.getParameter("detail"));
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
%>
<html>
<head>
    <title>地址管理</title>
    <link rel="stylesheet" href="../css/main.css"/>
</head>
<body>
<header>
    <div><a href="index.jsp" style="color:#fff;text-decoration:none;">小米商城</a></div>
    <div>
        欢迎，<%= u.getUsername() %>
        | <a href="cart.jsp">购物车</a>
        | <a href="orders.jsp">订单</a>
        | <a href="categories.jsp">分类</a>
        | <a href="addresses.jsp">地址</a>
        | <a href="notifications.jsp">通知</a>
        | <a href="bindings.jsp">绑定</a>
        | <a href="aftersales.jsp">售后</a>
        | <a href="logout.jsp">退出</a>
    </div>
</header>
<div class="container">
    <h2>收货地址</h2>
    <% if(message!=null){ %><div class="message"><%= message %></div><% } %>
    <form method="post">
        <input type="hidden" name="action" value="<%= (edit!=null)?"update":"add" %>"/>
        <% if(edit!=null){ %><input type="hidden" name="id" value="<%= edit.getId() %>"/><% } %>
        <label>收件人:<input type="text" name="receiver" value="<%= edit!=null?edit.getReceiver():"" %>" required></label>
        <label>电话:<input type="text" name="phone" value="<%= edit!=null?edit.getPhone():"" %>" required></label>
        <label>详细地址:<input type="text" name="detail" value="<%= edit!=null?edit.getDetail():"" %>" required></label>
        <button type="submit"><%= (edit!=null)?"更新":"添加" %></button>
        <% if(edit!=null){ %><a href="addresses.jsp">取消</a><% } %>
    </form>
    <table class="cart-table">
        <tr><th>ID</th><th>收件人</th><th>电话</th><th>地址</th><th>默认</th><th>操作</th></tr>
        <% for(Address a : list){ %>
        <tr>
            <td><%= a.getId() %></td>
            <td><%= a.getReceiver() %></td>
            <td><%= a.getPhone() %></td>
            <td><%= a.getDetail() %></td>
            <td><%= a.isDefault() ? "是" : "" %></td>
            <td>
                <a href="addresses.jsp?editId=<%= a.getId() %>">编辑</a>
                <form method="post" style="display:inline" onsubmit="return confirm('确定删除?');">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%= a.getId() %>"/>
                    <button type="submit">删除</button>
                </form>
                <% if(!a.isDefault()){ %>
                <form method="post" style="display:inline">
                    <input type="hidden" name="action" value="default"/>
                    <input type="hidden" name="id" value="<%= a.getId() %>"/>
                    <button type="submit">设为默认</button>
                </form>
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
