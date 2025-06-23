function selectPayment(type) {
    // 清除所有选中状态
    document.querySelectorAll('.payment-radio').forEach(radio => {
        radio.classList.remove('selected');
    });
    // 选中当前支付方式
    document.getElementById(type + '-radio').classList.add('selected');
}

// 默认选中测试支付
selectPayment('test');
