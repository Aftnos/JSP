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
