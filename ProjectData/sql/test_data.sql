-- 测试数据插入脚本
USE xiaomi_mall;

-- 插入测试用户数据
INSERT INTO users (username, password, email, phone, is_admin) VALUES 
('admin', '123456', 'admin@xiaomi.com', '13800138000', 1),
('user1', '123456', 'user1@example.com', '13800138001', 0),
('test', 'test123', 'test@example.com', '13800138002', 0);

-- 插入测试分类数据
INSERT INTO categories (name, parent_id) VALUES
('手机', NULL),
('平板', NULL),
('智能穿戴', NULL);

-- 插入测试商品数据，并关联分类
INSERT INTO products (name, price, stock, category_id, description) VALUES
('小米14', 3999.00, 100, 1, '小米14智能手机，骁龙8 Gen3处理器'),
('小米平板6', 1999.00, 50, 2, '小米平板6，11英寸2.8K屏幕'),
('小米手环8', 299.00, 200, 3, '小米手环8，健康监测专家');

-- 插入商品图片数据
INSERT INTO product_images (product_id, url) VALUES
(1, 'images/mi14-1.jpg'),
(2, 'images/pad6-1.jpg'),
(3, 'images/band8-1.jpg')
