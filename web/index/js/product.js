function buyNow(productId) {
    // 检查用户是否登录
    <% if(session.getAttribute("user") == null) { %>
        window.location.href = 'login.jsp';
        return;
    <% } %>
    
    // 这里可以跳转到订单页面或支付页面
    alert('立即购买功能待实现');
}

document.addEventListener('DOMContentLoaded', function() {
    var carousel = document.getElementById('imgCarousel');
    if (!carousel) return;
    var container = carousel.querySelector('.carousel-images');
    var images = container.querySelectorAll('img');
    var indicator = document.getElementById('carouselIndicator');
    var prev = carousel.querySelector('.prev');
    var next = carousel.querySelector('.next');
    var index = 0;

    function update() {
        container.style.transform = 'translateX(' + (-index * 100) + '%)';
        if (indicator) indicator.textContent = (index + 1) + '/' + images.length;
    }

    prev.addEventListener('click', function() {
        index = (index - 1 + images.length) % images.length;
        update();
    });
    next.addEventListener('click', function() {
        index = (index + 1) % images.length;
        update();
    });

    update();
});
