# 数据库结构说明

本项目的所有表均在 `schema.sql` 中定义，默认数据库名为 `xiaomi_mall`。下面按表列出主要字段及含义。

## users

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `username` | VARCHAR(50) | 登录名，唯一 |
| `password` | VARCHAR(100) | 登录密码（建议加密存储） |
| `email` | VARCHAR(100) | 邮箱地址 |
| `phone` | VARCHAR(20) | 联系电话 |
| `is_admin` | TINYINT | 是否为管理员，1 表示管理员 |

示例：

| id | username | password | email | phone | is_admin |
| -- | -------- | -------- | ----- | ----- | -------- |
| 1 | admin | 123456 | admin@xiaomi.com | 13800138000 | 1 |

## categories

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `name` | VARCHAR(100) | 分类名称 |
| `parent_id` | INT | 父级分类，可为空 |

示例：

| id | name | parent_id |
| -- | ---- | --------- |
| 1 | 手机 | NULL |

## products

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `name` | VARCHAR(255) | 商品名称 |
| `price` | DECIMAL(10,2) | 商品价格 |
| `stock` | INT | 库存数量 |
| `category_id` | INT | 所属分类 ID |
| `description` | TEXT | 商品描述 |

示例：

| id | name | price | stock | category_id | description |
| -- | ---- | ----- | ----- | ----------- | ----------- |
| 1 | 小米14 | 3999.00 | 100 | 1 | 小米14智能手机，骁龙8 Gen3处理器 |

## product_images

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `product_id` | INT | 所属商品 |
| `url` | VARCHAR(255) | 图片地址 |

示例：

| id | product_id | url |
| -- | ---------- | --- |
| 1 | 1 | images/mi14-1.jpg |

## product_extra_images

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `product_id` | INT | 所属商品 |
| `url` | VARCHAR(255) | 图片地址 |
| `type` | VARCHAR(20) | 图片类型（副图、介绍图等） |

示例：

| id | product_id | url | type |
| -- | ---------- | --- | ---- |
| 1 | 1 | images/mi14-intro1.jpg | intro |

## addresses

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `user_id` | INT | 所属用户 |
| `receiver` | VARCHAR(50) | 收货人姓名 |
| `phone` | VARCHAR(20) | 收货人电话 |
| `detail` | VARCHAR(255) | 详细地址 |
| `is_default` | TINYINT | 是否默认地址 |

示例：

| id | user_id | receiver | phone | detail | is_default |
| -- | ------- | -------- | ----- | ------ | ---------- |
| 1 | 2 | 张三 | 13800138001 | 北京市海淀区1号 | 1 |

## cart_items

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `user_id` | INT | 所属用户 |
| `product_id` | INT | 商品 ID |
| `quantity` | INT | 数量 |

示例：

| id | user_id | product_id | quantity |
| -- | ------- | ---------- | -------- |
| 1 | 2 | 1 | 2 |

## orders

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `user_id` | INT | 下单用户 |
| `address_id` | INT | 收货地址 |
| `status` | VARCHAR(20) | 订单状态，默认 `pending` |
| `total` | DECIMAL(10,2) | 总金额 |
| `paid` | TINYINT | 是否已支付 |
| `created_at` | DATETIME | 创建时间 |

示例：

| id | user_id | content | read_status | created_at |
| -- | ------- | ------- | ----------- | ---------- |
| 1 | 2 | "订单已发货" | 0 | 2024-01-03 09:00:00 |

示例：

| id | user_id | address_id | status | total | paid | created_at |
| -- | ------- | ---------- | ------ | ----- | ---- | ---------- |
| 1 | 2 | 1 | pending | 7998.00 | 0 | 2024-01-01 10:00:00 |

## order_items

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `order_id` | INT | 所属订单 |
| `product_id` | INT | 商品 ID |
| `quantity` | INT | 购买数量 |
| `price` | DECIMAL(10,2) | 下单时单价 |

示例：

| id | order_id | product_id | quantity | price |
| -- | -------- | ---------- | -------- | ----- |
| 1 | 1 | 1 | 2 | 3999.00 |

## sn_codes

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `product_id` | INT | 对应商品 |
| `code` | VARCHAR(100) | SN 编码，唯一 |
| `status` | VARCHAR(20) | 状态，默认 `unsold` |
| `batch_id` | INT | 批次编号 |

示例：

| id | product_id | code | status | batch_id |
| -- | ---------- | ---- | ------ | -------- |
| 1 | 1 | SN0001 | sold | 101 |

## bindings

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `user_id` | INT | 绑定该 SN 的用户 |
| `sn_code` | VARCHAR(100) | SN 码，唯一 |
| `bind_time` | DATETIME | 绑定时间 |

示例：

| id | user_id | sn_code | bind_time |
| -- | ------- | ------- | --------- |
| 1 | 2 | SN0001 | 2024-01-02 12:00:00 |

## after_sales

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `user_id` | INT | 申请用户 |
| `sn_code` | VARCHAR(100) | 对应 SN |
| `type` | VARCHAR(20) | 售后类型 |
| `reason` | TEXT | 申请原因 |
| `status` | VARCHAR(20) | 处理状态，默认 `pending` |
| `remark` | TEXT | 处理备注 |

示例：

| id | user_id | sn_code | type | reason | status | remark |
| -- | ------- | ------- | ---- | ------ | ------ | ------ |
| 1 | 2 | SN0001 | return | 屏幕有瑕疵 | pending | |

## notifications

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `id` | INT AUTO_INCREMENT | 主键 |
| `user_id` | INT | 接收用户 |
| `content` | TEXT | 通知内容 |
| `read_status` | TINYINT | 是否已读，0 未读 1 已读 |
| `created_at` | DATETIME | 创建时间 |

