function buyNow(productId) {
    // 检查用户是否登录
    <% if(session.getAttribute("user") == null) { %>
        window.location.href = 'login.jsp';
        return;
    <% } %>
    
    // 这里可以跳转到订单页面或支付页面
    alert('立即购买功能待实现');
}
