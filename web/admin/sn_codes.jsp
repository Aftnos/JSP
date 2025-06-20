<%@ include file="check_admin.jspf" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.SNCode" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = null;
    String action = request.getParameter("action");
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        if ("generate".equals(action)) {
            int pid = Integer.parseInt(request.getParameter("productId"));
            int size = Integer.parseInt(request.getParameter("size"));
            int batch = Integer.parseInt(request.getParameter("batchId"));
            ServiceLayer.generateSNCodes(pid, size, batch);
            message = "生成完成";
        } else if ("update".equals(action)) {
            String code = request.getParameter("code");
            String status = request.getParameter("status");
            if (ServiceLayer.updateSNStatus(code, status)) message = "更新成功"; else message="更新失败";
        } else if ("deleteBatch".equals(action)) {
            int batch = Integer.parseInt(request.getParameter("batchId"));
            if (ServiceLayer.deleteSNCodes(batch)) message="删除成功"; else message="删除失败";
        }
    }
    int searchPid = 0;
    String pidStr = request.getParameter("searchPid");
    if (pidStr != null && !pidStr.isEmpty()) searchPid = Integer.parseInt(pidStr);
    String statusFilter = request.getParameter("searchStatus");
    java.util.List<SNCode> list = ServiceLayer.listSNCodes(searchPid, statusFilter);
%>
<html>
<head>
    <title>SN码管理</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
<div class="container">
    <%@ include file="sidebar.jsp" %>
    <h2>SN码管理</h2>
    <% if (message != null) { %><div class="message"><%= message %></div><% } %>
    <h3>生成SN码</h3>
    <form method="post">
        <input type="hidden" name="action" value="generate"/>
        <label>商品ID:<input type="text" name="productId" required></label>
        <label>数量:<input type="number" name="size" required></label>
        <label>批次ID:<input type="number" name="batchId" required></label>
        <button type="submit">生成</button>
    </form>
    <h3>查询SN码</h3>
    <form method="get">
        <label>商品ID:<input type="text" name="searchPid" value="<%= searchPid==0?"":searchPid %>"></label>
        <label>状态:<input type="text" name="searchStatus" value="<%= statusFilter!=null?statusFilter:"" %>"></label>
        <button type="submit">查询</button>
    </form>
    <table>
        <tr><th>ID</th><th>商品ID</th><th>编码</th><th>状态</th><th>批次</th><th>操作</th></tr>
        <% for (SNCode s : list) { %>
        <tr>
            <td><%= s.getId() %></td>
            <td><%= s.getProductId() %></td>
            <td><%= s.getCode() %></td>
            <td><%= s.getStatus() %></td>
            <td><%= s.getBatchId() %></td>
            <td>
                <form method="post" style="display:inline">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="code" value="<%= s.getCode() %>"/>
                    <input type="text" name="status" value="<%= s.getStatus() %>"/>
                    <button type="submit">更新状态</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <h3>删除批次</h3>
    <form method="post" onsubmit="return confirm('确定删除未售出批次?');">
        <input type="hidden" name="action" value="deleteBatch"/>
        <label>批次ID:<input type="number" name="batchId" required></label>
        <button type="submit">删除</button>
    </form>
</div>
</body>
</html>
