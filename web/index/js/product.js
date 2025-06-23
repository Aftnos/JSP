function buyNow(productId) {
    // 检查用户是否登录
    <% if(session.getAttribute("user") == null) { %>
    window.location.href = 'login.jsp';
    return;
    <% } %>

    // 构造并提交隐藏表单
    const form = document.createElement('form');
    form.method = 'post';
    form.style.display = 'none';
    form.innerHTML = '<input type="hidden" name="buyNow" value="1">';
    document.body.appendChild(form);
    form.submit();
}
