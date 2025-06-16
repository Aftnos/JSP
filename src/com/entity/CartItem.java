package com.entity;

/**
 * 购物车中商品的信息封装。
 * 在创建订单时会根据此对象生成订单项。
 */
public class CartItem {
    /** 商品ID */
    public int productId;
    /** 购买数量 */
    public int quantity;
    /** 商品单价 */
    public double price;
}
