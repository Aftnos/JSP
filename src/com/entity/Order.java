package com.entity;

import java.sql.Timestamp;
import java.util.List;

/**
 * 订单实体，对应資料表 <code>orders</code>。
 */
public class Order {
    /** 订单ID */
    public int id;
    /** 订单编号(8位16进制) */
    public String orderNo;
    /** 下单用户ID */
    public int userId;
    /** 下单时间 */
    public Timestamp orderDate;
    /** 当前订单状态 */
    public String status;
    /** 支付状态 */
    public String payStatus;
    /** 订单总金额 */
    public double total;
    /** 包含的订单项列表 */
    public List<OrderItem> items;
}
