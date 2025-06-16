package com.entity;

/**
 * 用户绑定商品实体，对应資料表 <code>user_products</code>。
 * 用于记录用户购买的每件商品及其售后状态。
 */
public class UserProduct {
    /** 绑定记录ID */
    public int id;
    /** 用户ID */
    public int userId;
    /** 商品ID */
    public int productId;
    /** 商品序列号 */
    public String sn;
    /** 售后状态 */
    public String afterSaleStatus;
    /** 商品名称（联表查询时填充） */
    public String productName;
}
