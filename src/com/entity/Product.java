package com.entity;

/**
 * 商品实体，对应資料表 <code>products</code>
 * 每个字段均使用公共属性，便于在 JSP 页面直接访问。
 */
public class Product {
    /** 商品ID */
    public int id;
    /** 商品名称 */
    public String name;
    /** 商品价格 */
    public double price;
    /** 库存数量 */
    public int stock;
    /** 商品描述 */
    public String description;
}
