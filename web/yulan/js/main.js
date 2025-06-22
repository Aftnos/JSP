function addToCart(pid){
  const form=document.createElement('form');
  form.method='post';
  form.action='product.jsp?id='+pid;
  const input=document.createElement('input');
  input.type='hidden';
  input.name='addCart';
  form.appendChild(input);
  document.body.appendChild(form);
  form.submit();
}

document.addEventListener('DOMContentLoaded',function(){
  var page=location.pathname.split('/').pop();
  document.querySelectorAll('.bottom-nav a').forEach(function(a){
    if(a.getAttribute('href')===page){
      a.classList.add('active');
    }
  });
});
