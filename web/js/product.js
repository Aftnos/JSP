function buyNow(productId) {
    const form = document.createElement('form');
    form.method = 'post';
    form.action = 'product.jsp?id=' + productId;
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'buyNow';
    input.value = '1';
    form.appendChild(input);
    document.body.appendChild(form);
    form.submit();
}

document.addEventListener('DOMContentLoaded', function () {
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

    prev.addEventListener('click', function () {
        index = (index - 1 + images.length) % images.length;
        update();
    });
    next.addEventListener('click', function () {
        index = (index + 1) % images.length;
        update();
    });

    update();
});
