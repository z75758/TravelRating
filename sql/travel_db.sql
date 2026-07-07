-- ============================================
-- 旅游地点评选与互动系统 - 数据库脚本
-- Taste-Skill Minimalist Design System
-- ============================================

CREATE DATABASE IF NOT EXISTS travel_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE travel_db;

-- ============================================
-- 用户表
-- ============================================
DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS destinations;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar VARCHAR(255) DEFAULT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 旅游地点表
-- ============================================
CREATE TABLE destinations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL COMMENT '地区',
    type VARCHAR(50) NOT NULL COMMENT '类型：自然风光/历史古迹/城市观光/海岛度假/美食之旅/探险户外',
    image VARCHAR(255) DEFAULT NULL COMMENT '封面图片',
    description TEXT COMMENT '简介',
    address VARCHAR(255) DEFAULT NULL COMMENT '详细地址',
    open_time VARCHAR(100) DEFAULT NULL COMMENT '开放时间',
    ticket_price DECIMAL(10,2) DEFAULT 0.00 COMMENT '门票价格',
    rating DECIMAL(2,1) DEFAULT 0.0 COMMENT '平均评分',
    popularity INT DEFAULT 0 COMMENT '热度',
    created_by INT DEFAULT NULL COMMENT '创建者ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 评论表
-- ============================================
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    destination_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    rating INT DEFAULT 5 COMMENT '评分 1-5',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 投票表（点赞/推荐）
-- ============================================
CREATE TABLE votes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    destination_id INT NOT NULL,
    user_id INT NOT NULL,
    vote_type ENUM('like', 'recommend') DEFAULT 'like',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_vote (destination_id, user_id),
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 管理员账户 (密码: admin123, bcrypt加密)
-- ============================================
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@travel.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5Eh', 'admin');

-- ============================================
-- 示例旅游地点数据
-- ============================================
INSERT INTO destinations (name, region, type, image, description, address, open_time, ticket_price, rating, popularity) VALUES
('黄山风景区', '华东', '自然风光', 'https://picsum.photos/seed/huangshan/800/600', '黄山以奇松、怪石、云海、温泉四绝闻名于世，被誉为天下第一奇山。', '安徽省黄山市黄山区', '06:00-17:00', 190.00, 4.8, 980),
('故宫博物院', '华北', '历史古迹', 'https://picsum.photos/seed/gugong/800/600', '明清两代的皇家宫殿，世界上现存规模最大、保存最完整的木质结构古建筑群。', '北京市东城区景山前街4号', '08:30-17:00', 60.00, 4.9, 1200),
('三亚亚龙湾', '华南', '海岛度假', 'https://picsum.photos/seed/sanya/800/600', '中国最南端的热带海滨旅游城市，碧海蓝天，椰风海韵。', '海南省三亚市亚龙湾', '全天开放', 0.00, 4.7, 860),
('丽江古城', '西南', '历史古迹', 'https://picsum.photos/seed/lijiang/800/600', '纳西族文化的瑰宝，世界文化遗产，小桥流水人家的意境之美。', '云南省丽江市古城区', '全天开放', 50.00, 4.6, 750),
('九寨沟', '西南', '自然风光', 'https://picsum.photos/seed/jiuzhaigou/800/600', '被称为人间仙境的九寨沟，以其独特的高原钙华地貌和多彩湖泊闻名。', '四川省阿坝州九寨沟县', '08:00-17:00', 169.00, 4.9, 1100),
('西湖', '华东', '自然风光', 'https://picsum.photos/seed/xihu/800/600', '欲把西湖比西子，淡妆浓抹总相宜。杭州明珠，江南韵味。', '浙江省杭州市西湖区', '全天开放', 0.00, 4.7, 1050),
('西安兵马俑', '西北', '历史古迹', 'https://picsum.photos/seed/bingmayong/800/600', '世界第八大奇迹，秦始皇陵兵马俑展现了秦朝的强盛军力。', '陕西省西安市临潼区', '08:30-18:00', 120.00, 4.8, 920),
('成都锦里', '西南', '美食之旅', 'https://picsum.photos/seed/jinli/800/600', '锦里古街是成都美食的集中地，火锅、串串、担担面等你来尝。', '四川省成都市武侯区', '09:00-22:00', 0.00, 4.5, 680),
('张家界国家森林公园', '华中', '自然风光', 'https://picsum.photos/seed/zhangjiajie/800/600', '阿凡达取景地，千峰耸立，云雾缭绕，地球上最像外星球的地方。', '湖南省张家界市武陵源区', '07:00-18:00', 228.00, 4.7, 890),
('布达拉宫', '西南', '历史古迹', 'https://picsum.photos/seed/budalagong/800/600', '世界屋脊上的明珠，藏传佛教圣殿，西藏最宏伟的建筑群。', '西藏拉萨市城关区', '09:00-16:00', 200.00, 4.8, 780),
('呼伦贝尔大草原', '华北', '自然风光', 'https://picsum.photos/seed/hulunbeier/800/600', '中国最美的草原，风吹草低见牛羊，体验原始游牧生活。', '内蒙古呼伦贝尔市', '全天开放', 0.00, 4.6, 620),
('鼓浪屿', '华东', '海岛度假', 'https://picsum.photos/seed/gulangyu/800/600', '钢琴之岛，万国建筑博览，文艺青年的天堂。', '福建省厦门市思明区', '全天开放', 35.00, 4.5, 730);

-- ============================================
-- 示例评论数据
-- ============================================
INSERT INTO comments (destination_id, user_id, content, rating) VALUES
(1, 1, '黄山真的名不虚传，云海日出太震撼了！', 5),
(1, 1, '爬山有点累，但山顶的风景值了。', 4),
(2, 1, '故宫的文物太精美了，每次去都有新发现。', 5),
(3, 1, '亚龙湾的沙很细，水很清，度假的好地方。', 5);
