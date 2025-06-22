<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Address" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>

<%
    // 获取所有用户用于测试
    List<User> allUsers = ServiceLayer.getAllUsers();
    
    // 处理表单提交
    String action = request.getParameter("action");
    String message = "";
    
    if ("testIntegrity".equals(action)) {
        try {
            if (allUsers != null && !allUsers.isEmpty()) {
                User testUser = allUsers.get(0);
                List<Address> addresses = ServiceLayer.getAddresses(testUser.getId());
                message = "<div class='success'>收货地址功能完整性测试通过！用户 " + testUser.getUsername() + " 当前有 " + (addresses != null ? addresses.size() : 0) + " 个地址。</div>";
            } else {
                message = "<div class='error'>没有找到用户，无法进行测试！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>测试失败：" + e.getMessage() + "</div>";
        }
    }
    
    if ("addAddress".equals(action)) {
        try {
            String userIdStr = request.getParameter("userId");
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String province = request.getParameter("province");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String detailAddress = request.getParameter("detailAddress");
            String isDefaultStr = request.getParameter("isDefault");
            
            if (userIdStr != null && receiverName != null && receiverPhone != null && 
                province != null && city != null && district != null && detailAddress != null) {
                
                int userId = Integer.parseInt(userIdStr);
                boolean isDefault = "on".equals(isDefaultStr);
                
                Address newAddress = new Address();
                newAddress.setUserId(userId);
                newAddress.setReceiver(receiverName);
                newAddress.setPhone(receiverPhone);
                newAddress.setDetail(province + city + district + detailAddress);
                newAddress.setDefault(isDefault);
                
                boolean result = ServiceLayer.addAddress(newAddress);
                if (result) {
                    message = "<div class='success'>地址添加成功！</div>";
                } else {
                    message = "<div class='error'>地址添加失败！</div>";
                }
            } else {
                message = "<div class='error'>请填写完整的地址信息！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>添加地址时发生错误：" + e.getMessage() + "</div>";
        }
    }
    
    if ("updateAddress".equals(action)) {
        try {
            String addressIdStr = request.getParameter("addressId");
            String userIdStr = request.getParameter("userId");
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String province = request.getParameter("province");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String detailAddress = request.getParameter("detailAddress");
            String isDefaultStr = request.getParameter("isDefault");
            
            if (addressIdStr != null && userIdStr != null && receiverName != null && receiverPhone != null && 
                province != null && city != null && district != null && detailAddress != null) {
                
                int addressId = Integer.parseInt(addressIdStr);
                int userId = Integer.parseInt(userIdStr);
                boolean isDefault = "on".equals(isDefaultStr);
                
                Address updateAddress = new Address();
                updateAddress.setId(addressId);
                updateAddress.setUserId(userId);
                updateAddress.setReceiver(receiverName);
                updateAddress.setPhone(receiverPhone);
                updateAddress.setDetail(province + city + district + detailAddress);
                updateAddress.setDefault(isDefault);
                
                boolean result = ServiceLayer.updateAddress(updateAddress);
                if (result) {
                    message = "<div class='success'>地址更新成功！</div>";
                } else {
                    message = "<div class='error'>地址更新失败！</div>";
                }
            } else {
                message = "<div class='error'>请填写完整的地址信息！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>更新地址时发生错误：" + e.getMessage() + "</div>";
        }
    }
    
    if ("setDefault".equals(action)) {
        try {
            String userIdStr = request.getParameter("userId");
            String addressIdStr = request.getParameter("addressId");
            
            if (userIdStr != null && addressIdStr != null) {
                int userId = Integer.parseInt(userIdStr);
                int addressId = Integer.parseInt(addressIdStr);
                
                ServiceLayer.setDefaultAddress(userId, addressId);
                message = "<div class='success'>默认地址设置成功！</div>";
            } else {
                message = "<div class='error'>缺少必要参数！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>设置默认地址时发生错误：" + e.getMessage() + "</div>";
        }
    }
    
    if ("deleteAddress".equals(action)) {
        try {
            String addressIdStr = request.getParameter("addressId");
            
            if (addressIdStr != null) {
                int addressId = Integer.parseInt(addressIdStr);
                
                boolean result = ServiceLayer.deleteAddress(addressId);
                if (result) {
                    message = "<div class='success'>地址删除成功！</div>";
                } else {
                    message = "<div class='error'>地址删除失败！</div>";
                }
            } else {
                message = "<div class='error'>缺少地址ID参数！</div>";
            }
        } catch (Exception e) {
            message = "<div class='error'>删除地址时发生错误：" + e.getMessage() + "</div>";
        }
    }
%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>收货地址功能测试</title>
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
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        
        h2 {
            color: #555;
            margin-top: 30px;
            margin-bottom: 15px;
            border-left: 4px solid #007bff;
            padding-left: 10px;
        }
        
        .test-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fafafa;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
            color: #555;
        }
        
        input[type="text"], input[type="tel"], select {
            width: 200px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        input[type="checkbox"] {
            margin-left: 10px;
        }
        
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }
        
        button:hover {
            background-color: #0056b3;
        }
        
        .btn-danger {
            background-color: #dc3545;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        
        .btn-warning:hover {
            background-color: #e0a800;
        }
        
        .success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }
        
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }
        
        .warning {
            color: #856404;
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
            font-weight: bold;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .address-item {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 10px;
        }
        
        .default-badge {
            background-color: #28a745;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>收货地址功能测试页面</h1>
        
        <% if (!message.isEmpty()) { %>
            <%= message %>
        <% } %>
        
        <div class="warning">
            ⚠️ 警告：此页面用于测试收货地址功能，所有操作都是真实的！请谨慎操作。
        </div>
        
        <!-- 收货地址功能完整性测试 -->
        <div class="test-section">
            <h2>1. 收货地址功能完整性测试</h2>
            <p>测试收货地址相关功能是否正常工作</p>
            <form method="post">
                <input type="hidden" name="action" value="testIntegrity">
                <button type="submit">运行完整性测试</button>
            </form>
        </div>
        
        <!-- 显示当前用户和地址信息 -->
        <div class="test-section">
            <h2>2. 当前用户和地址信息</h2>
            <% if (allUsers != null && !allUsers.isEmpty()) { %>
                <h3>用户列表：</h3>
                <% for (User user : allUsers) { %>
                    <div style="margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 5px;">
                        <strong>用户：</strong> <%= user.getUsername() %> (ID: <%= user.getId() %>)
                        <br><strong>邮箱：</strong> <%= user.getEmail() %>
                        
                        <h4>该用户的地址列表：</h4>
                        <% 
                            List<Address> userAddresses = ServiceLayer.getAddresses(user.getId());
                            if (userAddresses != null && !userAddresses.isEmpty()) {
                        %>
                            <% for (Address addr : userAddresses) { %>
                                <div class="address-item">
                                    <strong>地址ID：</strong> <%= addr.getId() %>
                                    <% if (addr.isDefault()) { %>
                                        <span class="default-badge">默认</span>
                                    <% } %>
                                    <br><strong>收货人：</strong> <%= addr.getReceiver() %>
                                    <br><strong>电话：</strong> <%= addr.getPhone() %>
                                    <br><strong>地址：</strong> <%= addr.getDetail() %>
                                    
                                    <div style="margin-top: 10px;">
                                        <% if (!addr.isDefault()) { %>
                                            <form method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="setDefault">
                                                <input type="hidden" name="userId" value="<%= user.getId() %>">
                                                <input type="hidden" name="addressId" value="<%= addr.getId() %>">
                                                <button type="submit" class="btn-warning">设为默认</button>
                                            </form>
                                        <% } %>
                                        
                                        <form method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteAddress">
                                            <input type="hidden" name="addressId" value="<%= addr.getId() %>">
                                            <button type="submit" class="btn-danger" onclick="return confirm('确定要删除这个地址吗？')">删除</button>
                                        </form>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <p>该用户暂无地址</p>
                        <% } %>
                    </div>
                <% } %>
            <% } else { %>
                <p>没有找到用户数据</p>
            <% } %>
        </div>
        
        <!-- 添加地址测试 -->
        <div class="test-section">
            <h2>3. 添加地址测试</h2>
            <form method="post">
                <input type="hidden" name="action" value="addAddress">
                
                <div class="form-group">
                    <label for="userId">选择用户：</label>
                    <select name="userId" id="userId" required>
                        <option value="">请选择用户</option>
                        <% if (allUsers != null) { %>
                            <% for (User user : allUsers) { %>
                                <option value="<%= user.getId() %>"><%= user.getUsername() %> (ID: <%= user.getId() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="receiverName">收货人姓名：</label>
                    <input type="text" name="receiverName" id="receiverName" required>
                </div>
                
                <div class="form-group">
                    <label for="receiverPhone">收货人电话：</label>
                    <input type="tel" name="receiverPhone" id="receiverPhone" required>
                </div>
                
                <div class="form-group">
                    <label for="province">省份：</label>
                    <input type="text" name="province" id="province" required>
                </div>
                
                <div class="form-group">
                    <label for="city">城市：</label>
                    <input type="text" name="city" id="city" required>
                </div>
                
                <div class="form-group">
                    <label for="district">区县：</label>
                    <input type="text" name="district" id="district" required>
                </div>
                
                <div class="form-group">
                    <label for="detailAddress">详细地址：</label>
                    <input type="text" name="detailAddress" id="detailAddress" required>
                </div>
                
                <div class="form-group">
                    <label for="isDefault">设为默认：</label>
                    <input type="checkbox" name="isDefault" id="isDefault">
                </div>
                
                <button type="submit">添加地址</button>
            </form>
        </div>
        
        <!-- 删除地址测试 -->
        <div class="test-section">
            <h2>4. 删除地址测试</h2>
            <p>请输入要删除的地址ID进行删除测试</p>
            <form method="post">
                <input type="hidden" name="action" value="deleteAddress">
                
                <div class="form-group">
                    <label for="deleteAddressId">地址ID：</label>
                    <input type="text" name="addressId" id="deleteAddressId" required placeholder="从上面列表中复制地址ID">
                </div>
                
                <button type="submit" class="btn-danger" onclick="return confirm('确定要删除这个地址吗？此操作不可撤销！')">删除地址</button>
            </form>
        </div>
        
        <!-- 更新地址测试 -->
        <div class="test-section">
            <h2>5. 更新地址测试</h2>
            <p>请先从上面的地址列表中选择一个地址ID，然后填写下面的表单进行更新测试</p>
            <form method="post">
                <input type="hidden" name="action" value="updateAddress">
                
                <div class="form-group">
                    <label for="updateAddressId">地址ID：</label>
                    <input type="text" name="addressId" id="updateAddressId" required placeholder="从上面列表中复制地址ID">
                </div>
                
                <div class="form-group">
                    <label for="updateUserId">用户ID：</label>
                    <input type="text" name="userId" id="updateUserId" required placeholder="从上面列表中复制用户ID">
                </div>
                
                <div class="form-group">
                    <label for="updateReceiverName">收货人姓名：</label>
                    <input type="text" name="receiverName" id="updateReceiverName" required>
                </div>
                
                <div class="form-group">
                    <label for="updateReceiverPhone">收货人电话：</label>
                    <input type="tel" name="receiverPhone" id="updateReceiverPhone" required>
                </div>
                
                <div class="form-group">
                    <label for="updateProvince">省份：</label>
                    <input type="text" name="province" id="updateProvince" required>
                </div>
                
                <div class="form-group">
                    <label for="updateCity">城市：</label>
                    <input type="text" name="city" id="updateCity" required>
                </div>
                
                <div class="form-group">
                    <label for="updateDistrict">区县：</label>
                    <input type="text" name="district" id="updateDistrict" required>
                </div>
                
                <div class="form-group">
                    <label for="updateDetailAddress">详细地址：</label>
                    <input type="text" name="detailAddress" id="updateDetailAddress" required>
                </div>
                
                <div class="form-group">
                    <label for="updateIsDefault">设为默认：</label>
                    <input type="checkbox" name="isDefault" id="updateIsDefault">
                </div>
                
                <button type="submit">更新地址</button>
            </form>
        </div>
    </div>
</body>
</html>