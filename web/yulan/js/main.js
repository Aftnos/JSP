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
