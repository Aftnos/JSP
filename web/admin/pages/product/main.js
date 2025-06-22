// 商品管理页面JavaScript

// 页面初始化
document.addEventListener('DOMContentLoaded', function() {
    console.log('商品管理页面已加载');
    initializeEventListeners();
    loadProductData();
});

// 初始化事件监听器
function initializeEventListeners() {
    // 搜索框回车事件
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchProducts();
            }
        });
    }
    
    // 分类选择变化事件
    const categorySelect = document.getElementById('categorySelect');
    if (categorySelect) {
        categorySelect.addEventListener('change', function() {
            searchProducts();
        });
    }
    
    // 模态框外部点击关闭
    const modal = document.getElementById('productModal');
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeProductModal();
            }
        });
    }
    
    // ESC键关闭模态框
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeProductModal();
        }
    });
}

// 加载商品数据
function loadProductData() {
    // TODO: 实现从服务器加载商品数据
    console.log('加载商品数据功能待实现');
    
    // 示例：更新表格数据
    // updateProductTable(products);
}

// 更新商品表格
function updateProductTable(products) {
    const tbody = document.getElementById('productTableBody');
    if (!tbody) return;
    
    if (!products || products.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 20px;">暂无商品数据</td></tr>';
        return;
    }
    
    let html = '';
    products.forEach((product, index) => {
        html += `
            <tr>
                <td>
                    <input type="checkbox" class="checkbox row-checkbox" value="${product.id}">
                </td>
                <td>${index + 1}</td>
                <td>
                    <div class="product-image">
                        <img src="${product.imageUrl || '../../images/product-placeholder.png'}" 
                             alt="商品图片" class="product-thumb" 
                             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjYwIiBmaWxsPSIjRjVGNUY1Ii8+CjxwYXRoIGQ9Ik0yMCAyMEg0MFY0MEgyMFYyMFoiIGZpbGw9IiNEREREREQiLz4KPHBhdGggZD0iTTI1IDI1SDM1VjM1SDI1VjI1WiIgZmlsbD0iI0JCQkJCQiIvPgo8L3N2Zz4='">
                    </div>
                </td>
                <td>${product.name}</td>
                <td class="price">¥${parseFloat(product.price).toFixed(2)}</td>
                <td class="stock ${getStockClass(product.stock)}">${product.stock}</td>
                <td class="description" title="${product.description || ''}">${product.description || ''}</td>
                <td>
                    <div class="table-actions">
                        <button class="btn btn-primary btn-sm" onclick="editProduct(${product.id})">
                            编辑
                        </button>
                        <button class="btn btn-success btn-sm" onclick="viewProduct(${product.id})">
                            查看
                        </button>
                        <button class="btn btn-danger btn-sm" onclick="deleteProduct(${product.id})">
                            删除
                        </button>
                    </div>
                </td>
            </tr>
        `;
    });
    
    tbody.innerHTML = html;
}

// 获取库存状态样式类
function getStockClass(stock) {
    if (stock <= 10) return 'low';
    if (stock <= 50) return 'medium';
    return 'high';
}

// 搜索商品
function searchProducts() {
    const searchTerm = document.getElementById('searchInput').value.trim();
    const categoryId = document.getElementById('categorySelect').value;
    
    console.log('搜索条件:', { searchTerm, categoryId });
    
    // TODO: 实现搜索逻辑
    // 发送AJAX请求到服务器
    // 更新表格数据
    
    showMessage('搜索功能待实现', 'info');
}

// 添加商品
function addProduct() {
    resetProductForm();
    document.getElementById('modalTitle').textContent = '添加商品';
    document.getElementById('productId').value = '';
    showProductModal();
}

// 编辑商品
function editProduct(productId) {
    console.log('编辑商品，ID:', productId);
    
    // TODO: 从服务器加载商品数据
    // loadProductForEdit(productId);
    
    document.getElementById('modalTitle').textContent = '编辑商品';
    document.getElementById('productId').value = productId;
    
    // 示例数据填充
    fillProductForm({
        id: productId,
        name: '示例商品',
        price: 999.00,
        stock: 100,
        categoryId: 1,
        description: '这是一个示例商品描述'
    });
    
    showProductModal();
}

// 查看商品详情
function viewProduct(productId) {
    console.log('查看商品详情，ID:', productId);
    // TODO: 实现查看功能，可以打开只读模态框或跳转到详情页
    showMessage('查看功能待实现', 'info');
}

// 删除单个商品
function deleteProduct(productId) {
    if (!confirm('确定要删除该商品吗？此操作不可撤销！')) {
        return;
    }
    
    console.log('删除商品，ID:', productId);
    
    // TODO: 发送删除请求到服务器
    // deleteProductRequest(productId);
    
    showMessage('删除功能待实现', 'warning');
}

// 批量删除商品
function batchDelete() {
    const checkboxes = document.querySelectorAll('.row-checkbox:checked');
    if (checkboxes.length === 0) {
        showMessage('请先选择要删除的商品！', 'warning');
        return;
    }
    
    const productIds = Array.from(checkboxes).map(cb => cb.value);
    
    if (!confirm(`确定要删除选中的 ${productIds.length} 个商品吗？此操作不可撤销！`)) {
        return;
    }
    
    console.log('批量删除商品，IDs:', productIds);
    
    // TODO: 发送批量删除请求到服务器
    // batchDeleteProductsRequest(productIds);
    
    showMessage('批量删除功能待实现', 'warning');
}

// 保存商品
function saveProduct() {
    if (!validateProductForm()) {
        return;
    }
    
    const formData = getProductFormData();
    console.log('保存商品数据:', formData);
    
    // TODO: 发送保存请求到服务器
    // saveProductRequest(formData);
    
    showMessage('保存功能待实现', 'info');
    closeProductModal();
}

// 验证商品表单
function validateProductForm() {
    let isValid = true;
    
    // 清除之前的错误信息
    clearFormErrors();
    
    // 验证商品名称
    const name = document.getElementById('productName').value.trim();
    if (!name) {
        showFieldError('nameError', '请输入商品名称');
        isValid = false;
    }
    
    // 验证价格
    const price = parseFloat(document.getElementById('productPrice').value);
    if (isNaN(price) || price <= 0) {
        showFieldError('priceError', '请输入有效的价格');
        isValid = false;
    }
    
    // 验证库存
    const stock = parseInt(document.getElementById('productStock').value);
    if (isNaN(stock) || stock < 0) {
        showFieldError('stockError', '请输入有效的库存数量');
        isValid = false;
    }
    
    // 验证分类
    const categoryId = document.getElementById('productCategory').value;
    if (!categoryId) {
        showFieldError('categoryError', '请选择商品分类');
        isValid = false;
    }
    
    return isValid;
}

// 获取表单数据
function getProductFormData() {
    return {
        id: document.getElementById('productId').value,
        name: document.getElementById('productName').value.trim(),
        price: parseFloat(document.getElementById('productPrice').value),
        stock: parseInt(document.getElementById('productStock').value),
        categoryId: parseInt(document.getElementById('productCategory').value),
        description: document.getElementById('productDescription').value.trim()
    };
}

// 填充商品表单
function fillProductForm(product) {
    document.getElementById('productName').value = product.name || '';
    document.getElementById('productPrice').value = product.price || '';
    document.getElementById('productStock').value = product.stock || '';
    document.getElementById('productCategory').value = product.categoryId || '';
    document.getElementById('productDescription').value = product.description || '';
}

// 重置商品表单
function resetProductForm() {
    document.getElementById('productForm').reset();
    clearFormErrors();
    document.getElementById('imagePreview').style.display = 'none';
}

// 显示商品模态框
function showProductModal() {
    document.getElementById('productModal').style.display = 'block';
    document.body.style.overflow = 'hidden';
}

// 关闭商品模态框
function closeProductModal() {
    document.getElementById('productModal').style.display = 'none';
    document.body.style.overflow = 'auto';
}

// 全选/取消全选
function toggleSelectAll() {
    const selectAllCheckbox = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    
    rowCheckboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
}

// 显示字段错误信息
function showFieldError(errorId, message) {
    const errorElement = document.getElementById(errorId);
    if (errorElement) {
        errorElement.textContent = message;
    }
}

// 清除表单错误信息
function clearFormErrors() {
    const errorElements = document.querySelectorAll('.error-message');
    errorElements.forEach(element => {
        element.textContent = '';
    });
}

// 显示消息提示
function showMessage(message, type = 'info') {
    // TODO: 实现消息提示功能
    console.log(`[${type.toUpperCase()}] ${message}`);
    alert(message); // 临时使用alert，后续可以改为更美观的提示
}

// 图片预览功能
document.addEventListener('DOMContentLoaded', function() {
    const imageInput = document.getElementById('productImage');
    if (imageInput) {
        imageInput.addEventListener('change', function(e) {
            const file = e.target.files[0];
            const preview = document.getElementById('imagePreview');
            const previewImg = document.getElementById('previewImg');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
            }
        });
    }
});

// 工具函数：格式化价格
function formatPrice(price) {
    return `¥${parseFloat(price).toFixed(2)}`;
}

// 工具函数：格式化日期
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('zh-CN');
}

// 工具函数：防抖
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// 导出函数供全局使用
window.productManager = {
    searchProducts,
    addProduct,
    editProduct,
    viewProduct,
    deleteProduct,
    batchDelete,
    saveProduct,
    closeProductModal,
    toggleSelectAll
};