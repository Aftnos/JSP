package com.entity;

/**
 * 订单项实体，对应資料表 <code>order_items</code>。
 */
public class OrderItem {
    /** 主键ID */
    public int id;
    /** 所属订单ID */
    public int orderId;
    /** 商品ID */
    public int productId;
    /** 购买数量 */
    public int quantity;
    /** 商品单价 */
    public double price;
}
