function addToCart(pid){
    fetch('product.jsp',{
        method:'POST',
        headers:{'Content-Type':'application/x-www-form-urlencoded'},
        body:'addCart=1&productId='+pid
    }).then(()=>{location.href='cart.jsp';});
}
