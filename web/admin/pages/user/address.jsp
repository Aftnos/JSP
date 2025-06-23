<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ServiceLayer" %>
<%@ page import="com.entity.Address" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ include file="../../checkAdmin.jsp" %>
<%
    // 处理各种操作
    String action = request.getParameter("action");
    String operationResult = null;
    
    if ("updateAddress".equals(action)) {
        try {
            String addressIdStr = request.getParameter("addressId");
            String userIdStr = request.getParameter("userId");
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String detailAddress = request.getParameter("detailAddress");
            String isDefaultStr = request.getParameter("isDefault");
            
            if (addressIdStr != null && userIdStr != null && receiverName != null && receiverPhone != null && detailAddress != null) {
                int addressId = Integer.parseInt(addressIdStr);
                int userId = Integer.parseInt(userIdStr);
                boolean isDefault = "on".equals(isDefaultStr);
                
                Address updateAddress = new Address();
                updateAddress.setId(addressId);
                updateAddress.setUserId(userId);
                updateAddress.setReceiver(receiverName);
                updateAddress.setPhone(receiverPhone);
                updateAddress.setDetail(detailAddress);
                updateAddress.setDefault(isDefault);
                
                boolean result = ServiceLayer.updateAddress(updateAddress);
                if (result) {
                    operationResult = "地址更新成功！";
                } else {
                    operationResult = "地址更新失败！";
                }
            } else {
                operationResult = "请填写完整的地址信息！";
            }
        } catch (Exception e) {
            operationResult = "更新地址时发生错误：" + e.getMessage();
        }
    } else if ("deleteAddress".equals(action)) {
        String addressIdStr = request.getParameter("addressId");
        if (addressIdStr != null && !addressIdStr.trim().isEmpty()) {
            try {
                int addressId = Integer.parseInt(addressIdStr);
                boolean result = ServiceLayer.deleteAddress(addressId);
                if (result) {
                    operationResult = "地址删除成功！";
                } else {
                    operationResult = "地址删除失败！";
                }
            } catch (NumberFormatException e) {
                operationResult = "错误: 地址ID必须是数字";
            } catch (Exception e) {
                operationResult = "删除地址时发生错误：" + e.getMessage();
            }
        }
    } else if ("batchDelete".equals(action)) {
        String addressIdsStr = request.getParameter("addressIds");
        if (addressIdsStr != null && !addressIdsStr.trim().isEmpty()) {
            try {
                String[] addressIdStrArray = addressIdsStr.split(",");
                int successCount = 0;
                int totalCount = addressIdStrArray.length;
                
                for (String addressIdStr : addressIdStrArray) {
                    try {
                        int addressId = Integer.parseInt(addressIdStr.trim());
                        boolean result = ServiceLayer.deleteAddress(addressId);
                        if (result) {
                            successCount++;
                        }
                    } catch (NumberFormatException e) {
                        // 跳过无效的ID
                    }
                }
                
                operationResult = "批量删除完成！成功删除 " + successCount + "/" + totalCount + " 个地址";
            } catch (Exception e) {
                operationResult = "批量删除时发生错误：" + e.getMessage();
            }
        }
    }
    
    // 获取所有地址数据
    List<Address> allAddresses = null;
    try {
        // 获取所有用户
        List<User> allUsers = ServiceLayer.getAllUsers();
        allAddresses = new java.util.ArrayList<Address>();
        
        // 遍历所有用户，获取每个用户的地址
        if (allUsers != null && !allUsers.isEmpty()) {
            for (User user : allUsers) {
                List<Address> userAddresses = ServiceLayer.getAddresses(user.getId());
                if (userAddresses != null && !userAddresses.isEmpty()) {
                    allAddresses.addAll(userAddresses);
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        allAddresses = new java.util.ArrayList<Address>();
    }
    request.setAttribute("allAddresses", allAddresses);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>收货地址管理 - 小米商城管理系统</title>
    <!-- 引入基础样式 -->
    <link rel="stylesheet" type="text/css" href="../../static/css/admin-layout.css">
    <!-- 引入主样式 -->
    <link rel="stylesheet" type="text/css" href="../../css/main.css">
    <link rel="stylesheet" href="./main.css">
    <!-- 引入弹框样式 -->
    <link rel="stylesheet" href="./modal.css">
</head>
<body>
   <!-- 后台管理系统容器 -->
   <div class="admin-container">
    <!-- 侧边栏 -->
    <div class="sidebar" id="sidebar">
        <!-- 侧边栏头部 -->
        <div class="sidebar-header">
            <div class="logo">小米商城管理系统</div>
            <button class="sidebar-toggle" onclick="toggleSidebar()">
                <i class="icon">☰</i>
            </button>
        </div>

        <!-- 菜单容器 -->
        <div class="sidebar-menu">
            <!-- 用户管理 -->
            <div class="menu-item" onclick="toggleSubmenu('user-menu')">
                <div class="icon">👥</div>
                <span class="text">用户管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="user-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('user-profile-management')">
                    <span class="text">用户资料管理</span>
                </div>
                <div class="submenu-item" onclick="navigateTo('address-management')">
                    <span class="text">收货地址管理</span>
                </div>
            </div>

            <!-- 商品管理 -->
            <div class="menu-item" onclick="toggleSubmenu('product-menu')">
                <div class="icon">📦</div>
                <span class="text">商品管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="product-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('product-management')">
                    <span class="text">商品管理</span>
                </div>
            </div>

            <!-- 订单管理 -->
            <div class="menu-item" onclick="toggleSubmenu('order-menu')">
                <div class="icon">📋</div>
                <span class="text">订单管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="order-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('order-global-query')">
                    <span class="text">全局查询</span>
                </div>
            </div>

            <!-- SN码管理 -->
            <div class="menu-item" onclick="toggleSubmenu('sn-menu')">
                <div class="icon">🔢</div>
                <span class="text">SN码管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="sn-menu" style="display: none;">

                <div class="submenu-item" onclick="navigateTo('sn-global-query')">
                    <span class="text">全局查询</span>
                </div>
            </div>

            <!-- SN绑定管理 -->
            <div class="menu-item" onclick="toggleSubmenu('sn-binding-menu')">
                <div class="icon">🔗</div>
                <span class="text">SN绑定管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="sn-binding-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('sn-forced-unbinding')">
                    <span class="text">全局查询</span>
                </div>
            </div>

            <!-- 售后管理 -->
            <div class="menu-item" onclick="toggleSubmenu('aftersales-menu')">
                <div class="icon">🛠️</div>
                <span class="text">售后管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="aftersales-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('aftersales-workflow-control')">
                    <span class="text">工单全流程控制</span>
                </div>
            </div>

            <!-- 系统通知管理 -->
            <div class="menu-item" onclick="toggleSubmenu('notification-menu')">
                <div class="icon">🔔</div>
                <span class="text">系统通知管理</span>
                <div class="submenu-arrow">▼</div>
            </div>
            <div class="submenu" id="notification-menu" style="display: none;">
                <div class="submenu-item" onclick="navigateTo('message-center-maintenance')">
                    <span class="text">消息中心维护</span>
                </div>
            </div>
        </div>
    </div>
        
        <!-- 主内容区域 -->
        <div class="main-content" id="mainContent">
            <!-- 顶部用户信息栏 -->
            <div class="top-header">
                <div class="user-info">
                    <div class="user-text">
                        <div class="greeting">Hi, <span id="username">小锦鲤</span></div>
                        <div class="welcome-text">欢迎进入小米商城管理系统</div>
                    </div>
                    <div class="user-avatar-container">
                        <img src="../../images/default-avatar.png" alt="用户头像" class="user-avatar" id="userAvatar" onclick="toggleUserMenu()" onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNFNUU1RTUiLz4KPGNpcmNsZSBjeD0iMjAiIGN5PSIxNiIgcj0iNiIgZmlsbD0iIzk5OTk5OSIvPgo8cGF0aCBkPSJNMzAgMzJDMzAgMjYuNDc3MSAyNS41MjI5IDIyIDIwIDIyQzE0LjQ3NzEgMjIgMTAgMjYuNDc3MSAxMCAzMkgzMFoiIGZpbGw9IiM5OTk5OTkiLz4KPC9zdmc+'">
                        <!-- 用户下拉菜单 -->
                        <div class="user-dropdown" id="userDropdown">
                            <div class="dropdown-item" onclick="window.location.href='../../index.jsp'">
                                <i class="icon">🏠</i>
                                <span>返回用户端</span>
                            </div>
                            <div class="dropdown-item" onclick="logout()">
                                <i class="icon">🚪</i>
                                <span>退出登录</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 页面内容区域 -->
            <div class="page-content" id="pageContent">
                <!-- 页面标题 -->
                <div class="page-header">
                    <h1 class="page-title">收货地址管理</h1>
                    <p class="page-subtitle">管理系统用户的收货地址信息和默认设置</p>
                </div>
                
                <!-- 操作结果显示 -->
                <%
                    if (operationResult != null) {
                %>
                <div class="alert alert-info" style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; font-family: monospace; white-space: pre-line;">
                    <strong>操作结果:</strong><br>
                    <%= operationResult %>
                </div>
                <%
                    }
                %>
                
                <!-- 工具栏 -->
                <div class="toolbar">
                    <!-- 搜索区域 -->
                    <div class="search-section">
                        <input type="text" class="search-input" placeholder="搜索用户ID、收货人姓名、电话号码或地址..." id="searchInput">
                        <button class="btn btn-primary" onclick="searchAddresses()">
                            🔍 搜索
                        </button>
                    </div>
                    
                    <!-- 操作按钮 -->
                    <div class="action-buttons">
                        <button class="btn btn-danger" onclick="batchDelete()">
                            🗑️ 批量删除
                        </button>
                    </div>
                </div>
                
                <!-- 数据表格 -->
                <div class="data-table">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th width="50">
                                        <input type="checkbox" class="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                    </th>
                                    <th width="80">序号</th>
                                    <th width="100">用户ID</th>
                                    <th width="120">收货人姓名</th>
                                    <th width="150">电话号码</th>
                                    <th width="250">收货地址</th>
                                    <th width="120">是否默认地址</th>
                                    <th width="200">操作</th>
                                </tr>
                            </thead>
                            <tbody id="addressTableBody">
                                <%
                                    List<Address> addresses = (List<Address>) request.getAttribute("allAddresses");
                                    if (addresses != null && !addresses.isEmpty()) {
                                        for (int i = 0; i < addresses.size(); i++) {
                                            Address address = addresses.get(i);
                                %>
                                <tr>
                                    <td>
                                        <input type="checkbox" class="checkbox row-checkbox" value="<%= address.getId() %>">
                                    </td>
                                    <td><%= i + 1 %></td>
                                    <td><%= address.getUserId() %></td>
                                    <td><%= address.getReceiver() %></td>
                                    <td><%= address.getPhone() != null ? address.getPhone() : "" %></td>
                                    <td><%= address.getDetail() != null ? address.getDetail() : "" %></td>
                                    <td>
                                        <% if (address.isDefault()) { %>
                                            <span class="badge badge-success">默认地址</span>
                                        <% } else { %>
                                            <span class="badge badge-secondary">普通地址</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="table-actions">
                                            <button class="btn btn-primary btn-sm" onclick="editAddress(<%= address.getId() %>)">
                                                编辑
                                            </button>
                                            <button class="btn btn-success btn-sm" onclick="viewAddress(<%= address.getId() %>)">
                                                查看
                                            </button>
                                            <button class="btn btn-danger btn-sm" onclick="deleteAddress(<%= address.getId() %>)">
                                                删除
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 20px;">暂无地址数据</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- 分页 -->
                    <div class="pagination">
                        <div class="pagination-info">
                            <%
                                List<Address> paginationAddresses = (List<Address>) request.getAttribute("allAddresses");
                                int totalCount = paginationAddresses != null ? paginationAddresses.size() : 0;
                            %>
                            显示第 1-<%= totalCount %> 条，共 <%= totalCount %> 条记录
                        </div>
                        <div class="pagination-controls">
                            <button class="page-btn" disabled>上一页</button>
                            <button class="page-btn active">1</button>
                            <button class="page-btn" disabled>下一页</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 编辑地址弹框 -->
    <div class="modal" id="editAddressModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>编辑地址信息</h3>
                <span class="close" onclick="closeEditModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="editAddressForm">
                    <input type="hidden" id="editAddressId" name="addressId">
                    
                    <div class="form-group">
                        <label for="editUserId">用户ID：</label>
                        <input type="text" id="editUserId" name="userId" class="form-control" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="editReceiver">收货人姓名：</label>
                        <input type="text" id="editReceiver" name="receiver" class="form-control" required>
                        <span class="error-message" id="receiverError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="editPhone">电话号码：</label>
                        <input type="tel" id="editPhone" name="phone" class="form-control" required>
                        <span class="error-message" id="phoneError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="editDetail">详细地址：</label>
                        <textarea id="editDetail" name="detail" class="form-control" rows="3" required></textarea>
                        <span class="error-message" id="detailError"></span>
                    </div>
                    
                    <div class="form-group">
                        <label for="editIsDefault">设为默认地址：</label>
                        <input type="checkbox" id="editIsDefault" name="isDefault" class="checkbox">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeEditModal()">取消</button>
                <button type="button" class="btn btn-primary" onclick="saveAddressChanges()">保存</button>
            </div>
        </div>
    </div>
    
    <!-- 查看地址弹框 -->
    <div class="modal" id="viewAddressModal" style="display: none;">
        <div class="modal-content">
            <div class="modal-header">
                <h3>查看地址信息</h3>
                <span class="close" onclick="closeViewModal()">&times;</span>
            </div>
            <div class="modal-body">
                <div class="view-info">
                    <div class="info-item">
                        <label>地址ID：</label>
                        <span id="viewAddressId"></span>
                    </div>
                    <div class="info-item">
                        <label>用户ID：</label>
                        <span id="viewUserId"></span>
                    </div>
                    <div class="info-item">
                        <label>收货人姓名：</label>
                        <span id="viewReceiver"></span>
                    </div>
                    <div class="info-item">
                        <label>电话号码：</label>
                        <span id="viewPhone"></span>
                    </div>
                    <div class="info-item">
                        <label>详细地址：</label>
                        <span id="viewDetail"></span>
                    </div>
                    <div class="info-item">
                        <label>是否默认：</label>
                        <span id="viewIsDefault"></span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeViewModal()">关闭</button>
            </div>
        </div>
    </div>
    
    <!-- 引入JavaScript -->
    <script src="../../js/main.js"></script>
    <script src="./main.js"></script>
    
    <!-- 地址管理功能JavaScript -->
    <script>
        // 存储所有地址数据
        let allAddressesData = [];
        let filteredAddressesData = [];
        
        // 搜索地址
        function searchAddresses() {
            const keyword = document.getElementById('searchInput').value.trim();
            console.log('搜索地址:', keyword);
            
            if (keyword === '') {
                // 如果搜索框为空，显示所有地址
                filteredAddressesData = [...allAddressesData];
            } else {
                // 根据用户ID和收货人姓名进行模糊搜索
                filteredAddressesData = allAddressesData.filter(address => {
                    const userId = address.userId.toString();
                    const receiver = address.receiver.toLowerCase();
                    const searchKeyword = keyword.toLowerCase();
                    
                    return userId.includes(searchKeyword) || receiver.includes(searchKeyword);
                });
            }
            
            // 渲染搜索结果
            renderAddressTable(filteredAddressesData);
            
            // 搜索后清空输入框
            document.getElementById('searchInput').value = '';
            
            // 更新分页信息
            updatePaginationInfo(filteredAddressesData.length);
        }
        
        // 单个地址删除
        function deleteAddress(addressId) {
            if (confirm('确定要删除地址ID为 ' + addressId + ' 的地址吗？此操作不可撤销！')) {
                // 创建表单并提交
                var form = document.createElement('form');
                form.method = 'post';
                form.action = '';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteAddress';
                form.appendChild(actionInput);
                
                var addressIdInput = document.createElement('input');
                addressIdInput.type = 'hidden';
                addressIdInput.name = 'addressId';
                addressIdInput.value = addressId;
                form.appendChild(addressIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 批量删除
        function batchDelete() {
            var checkboxes = document.querySelectorAll('.row-checkbox:checked');
            if (checkboxes.length === 0) {
                alert('请先选择要删除的地址！');
                return;
            }
            
            var addressIds = [];
            checkboxes.forEach(function(checkbox) {
                addressIds.push(checkbox.value);
            });
            
            if (confirm('确定要删除选中的 ' + addressIds.length + ' 个地址吗？此操作不可撤销！')) {
                // 创建表单并提交
                var form = document.createElement('form');
                form.method = 'post';
                form.action = '';
                
                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'batchDelete';
                form.appendChild(actionInput);
                
                var addressIdsInput = document.createElement('input');
                addressIdsInput.type = 'hidden';
                addressIdsInput.name = 'addressIds';
                addressIdsInput.value = addressIds.join(',');
                form.appendChild(addressIdsInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // 全选/取消全选
        function toggleSelectAll() {
            var selectAll = document.getElementById('selectAll');
            var checkboxes = document.querySelectorAll('.row-checkbox');
            
            checkboxes.forEach(function(checkbox) {
                checkbox.checked = selectAll.checked;
            });
        }
        
        // 渲染地址表格
        function renderAddressTable(addresses) {
            const tbody = document.getElementById('addressTableBody');
            tbody.innerHTML = '';
            
            if (addresses.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 20px;">暂无地址数据</td></tr>';
                return;
            }
            
            addresses.forEach((address, index) => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>
                        <input type="checkbox" class="checkbox row-checkbox" value="${address.id}">
                    </td>
                    <td>${index + 1}</td>
                    <td>${address.userId}</td>
                    <td>${address.receiver}</td>
                    <td>${address.phone || ''}</td>
                    <td>${address.detail || ''}</td>
                    <td>
                        ${address.isDefault ? '<span class="badge badge-success">默认地址</span>' : '<span class="badge badge-secondary">普通地址</span>'}
                    </td>
                    <td>
                        <div class="table-actions">
                            <button class="btn btn-primary btn-sm" onclick="editAddress(${address.id})">
                                编辑
                            </button>
                            <button class="btn btn-success btn-sm" onclick="viewAddress(${address.id})">
                                查看
                            </button>
                            <button class="btn btn-danger btn-sm" onclick="deleteAddress(${address.id})">
                                删除
                            </button>
                        </div>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }
        
        // 更新分页信息
        function updatePaginationInfo(count) {
            const paginationInfo = document.querySelector('.pagination-info');
            paginationInfo.textContent = `显示第 1-${count} 条，共 ${count} 条记录`;
        }
        
        // 初始化地址数据
        function initializeAddressData() {
            // 从页面中提取地址数据
            const rows = document.querySelectorAll('#addressTableBody tr');
            allAddressesData = [];
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length > 1) { // 确保不是"暂无数据"行
                    const address = {
                        id: parseInt(cells[0].querySelector('.row-checkbox').value),
                        userId: parseInt(cells[2].textContent),
                        receiver: cells[3].textContent,
                        phone: cells[4].textContent,
                        detail: cells[5].textContent,
                        isDefault: cells[6].textContent.includes('默认地址')
                    };
                    allAddressesData.push(address);
                }
            });
            
            filteredAddressesData = [...allAddressesData];
            console.log('初始化地址数据:', allAddressesData);
        }
        
        // 搜索框回车事件
        document.addEventListener('DOMContentLoaded', function() {
            // 初始化地址数据
            initializeAddressData();
            
            // 绑定搜索框回车事件
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        searchAddresses();
                    }
                });
            }
        });
        
        // 编辑地址
        function editAddress(addressId) {
            console.log('编辑地址:', addressId);
            
            // 从allAddressesData中找到对应的地址数据
            const address = allAddressesData.find(addr => addr.id === addressId);
            if (!address) {
                alert('未找到地址信息！');
                return;
            }
            
            // 填充编辑表单
            document.getElementById('editAddressId').value = address.id;
            document.getElementById('editUserId').value = address.userId;
            document.getElementById('editReceiver').value = address.receiver;
            document.getElementById('editPhone').value = address.phone;
            document.getElementById('editDetail').value = address.detail;
            document.getElementById('editIsDefault').checked = address.isDefault;
            
            // 清除错误信息
            document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
            
            // 显示编辑弹框
            document.getElementById('editAddressModal').style.display = 'block';
        }
        
        // 查看地址
        function viewAddress(addressId) {
            console.log('查看地址:', addressId);
            
            // 从allAddressesData中找到对应的地址数据
            const address = allAddressesData.find(addr => addr.id === addressId);
            if (!address) {
                alert('未找到地址信息！');
                return;
            }
            
            // 填充查看信息
            document.getElementById('viewAddressId').textContent = address.id;
            document.getElementById('viewUserId').textContent = address.userId;
            document.getElementById('viewReceiver').textContent = address.receiver;
            document.getElementById('viewPhone').textContent = address.phone;
            document.getElementById('viewDetail').textContent = address.detail;
            document.getElementById('viewIsDefault').textContent = address.isDefault ? '是' : '否';
            
            // 显示查看弹框
            document.getElementById('viewAddressModal').style.display = 'block';
        }
        
        // 关闭编辑弹框
        function closeEditModal() {
            document.getElementById('editAddressModal').style.display = 'none';
        }
        
        // 关闭查看弹框
        function closeViewModal() {
            document.getElementById('viewAddressModal').style.display = 'none';
        }
        
        // 点击弹框外部关闭弹框
        window.onclick = function(event) {
            const editModal = document.getElementById('editAddressModal');
            const viewModal = document.getElementById('viewAddressModal');
            
            if (event.target === editModal) {
                closeEditModal();
            }
            if (event.target === viewModal) {
                closeViewModal();
            }
        }
        
        // 保存地址修改
        function saveAddressChanges() {
            // 获取表单数据
            const addressId = document.getElementById('editAddressId').value;
            const userId = document.getElementById('editUserId').value;
            const receiver = document.getElementById('editReceiver').value.trim();
            const phone = document.getElementById('editPhone').value.trim();
            const detail = document.getElementById('editDetail').value.trim();
            const isDefault = document.getElementById('editIsDefault').checked;
            
            // 清除之前的错误信息
            document.querySelectorAll('.error-message').forEach(el => el.textContent = '');
            
            // 验证表单
            let hasError = false;
            
            if (!receiver) {
                document.getElementById('receiverError').textContent = '请输入收货人姓名';
                hasError = true;
            }
            
            if (!phone) {
                document.getElementById('phoneError').textContent = '请输入电话号码';
                hasError = true;
            } else if (!/^1[3-9]\d{9}$/.test(phone)) {
                document.getElementById('phoneError').textContent = '请输入正确的手机号码';
                hasError = true;
            }
            
            if (!detail) {
                document.getElementById('detailError').textContent = '请输入详细地址';
                hasError = true;
            }
            
            if (hasError) {
                return;
            }
            
            // 创建表单并提交
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '';
            
            const fields = {
                'action': 'updateAddress',
                'addressId': addressId,
                'userId': userId,
                'receiverName': receiver,
                'receiverPhone': phone,
                'detailAddress': detail
            };
            
            if (isDefault) {
                fields['isDefault'] = 'on';
            }
            
            for (const [name, value] of Object.entries(fields)) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }
            
            document.body.appendChild(form);
            form.submit();
        }
    </script>
    
    <style>
        /* 地址管理页面特有样式 */
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .badge-success {
            background-color: #28a745;
            color: white;
        }
        
        .badge-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .view-info {
            padding: 20px 0;
        }
        
        .info-item {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        
        .info-item label {
            width: 120px;
            font-weight: bold;
            color: #555;
        }
        
        .info-item span {
            flex: 1;
            color: #333;
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        
        .form-control:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
        }
        
        .checkbox {
            margin-left: 0;
        }
    </style>
</body>
</html>