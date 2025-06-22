users 表

id：自增主键，用户唯一标识。

username：用户登录名，唯一且不能为空。

password：用户密码（通常存储加密后的值）。

email：用户邮箱地址。

phone：联系电话。

is_admin：是否为管理员（1 表示管理员，0 为普通用户）。

products 表

id：自增主键，商品 ID。

name：商品名称。

price：商品单价，保留两位小数。

stock：库存数量。

description：商品描述。

addresses 表

id：自增主键，地址 ID。

user_id：关联的用户 ID。

receiver：收货人姓名。

phone：收货人电话。

detail：详细地址信息。

is_default：是否为默认地址。

FOREIGN KEY (user_id)：引用 users 表。

categories 表

id：自增主键，分类 ID。

name：分类名称。

parent_id：父级分类，可为空，支持多级分类结构。

cart_items 表

id：自增主键，购物车条目 ID。

user_id：所属用户。

product_id：购物车中商品的 ID。

quantity：商品数量。

FOREIGN KEY 约束连接 users 与 products 表。

orders 表

id：自增主键，订单 ID。

user_id：下单用户。

address_id：订单收货地址。

status：订单状态（默认 pending）。

total：订单总金额。

paid：是否已支付。

created_at：创建时间。

FOREIGN KEY 约束指向 users、addresses 表。

order_items 表

id：自增主键，订单明细 ID。

order_id：所属订单。

product_id：商品 ID。

quantity：购买数量。

price：下单时的商品单价。

FOREIGN KEY 连接 orders、products 表。

sn_codes 表

id：自增主键，SN 码记录 ID。

product_id：对应商品。

code：唯一的 SN 码。

status：SN 当前状态（默认 unsold）。

batch_id：批次编号，用于批量生成管理。

bindings 表

id：自增主键，绑定记录 ID。

user_id：绑定该 SN 的用户。

sn_code：SN 码（唯一约束）。

bind_time：绑定时间，默认当前时间。

FOREIGN KEY (user_id)：引用 users 表。

after_sales 表

id：自增主键，售后工单 ID。

user_id：申请售后的用户。

sn_code：对应的 SN 码。

type：售后类型（退货、保修等）。

reason：用户填写的原因。

status：处理状态（默认 pending）。

remark：处理备注。

FOREIGN KEY (user_id)：引用 users 表。

notifications 表

id：自增主键，通知 ID。

user_id：接收通知的用户。

content：通知内容。

read_status：是否已读（0 未读，1 已读）。

created_at：通知创建时间。

FOREIGN KEY (user_id)：引用 users 表。