-- ============================================================
-- 旅游地点评选与互动系统 (TravelRating)
-- 数据库完整转储 SQL 文件
-- 数据库引擎: H2 Database 2.3.232 (MySQL 兼容模式)
-- 数据库名称: travel_db
-- 导出日期: 2026-07-08
-- 表数: 4 (users, destinations, comments, votes)
-- ============================================================

-- 创建数据库（H2 嵌入式模式，文件存储于 ./data/travel_db.mv.db）
-- 连接 URL: jdbc:h2:file:./data/travel_db;MODE=MySQL;DATABASE_TO_LOWER=TRUE;DB_CLOSE_DELAY=-1

-- ============================================================
-- 1. 用户表 users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    avatar      VARCHAR(255) DEFAULT NULL,
    role        VARCHAR(10)  DEFAULT 'user',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 管理员账号 (密码: admin123, 使用 SHA-256 + Salt 加密)
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@travel.com', 's8BvL9mKxP2qR7wY=:9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', 'admin');

-- ============================================================
-- 2. 旅游目的地表 destinations
-- ============================================================
CREATE TABLE IF NOT EXISTS destinations (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    region       VARCHAR(50)  NOT NULL,
    type         VARCHAR(50)  NOT NULL,
    image        VARCHAR(255) DEFAULT NULL,
    description  TEXT,
    address      VARCHAR(255) DEFAULT NULL,
    open_time    VARCHAR(100) DEFAULT NULL,
    ticket_price DECIMAL(10,2) DEFAULT 0.00,
    rating       DOUBLE DEFAULT 0.0,
    popularity   INT DEFAULT 0,
    created_by   INT DEFAULT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- 12条中国著名旅游目的地示例数据
INSERT INTO destinations (name, region, type, image, description, address, open_time, ticket_price, rating, popularity) VALUES
('黄山风景区', '华东', '自然风光',
 'https://qimgs.qunarzz.com/piao_qsight_provider_piao_qsight_web/0101p1200087cum179214.jpg_710x360_6d297f16.jpg',
 '黄山以奇松、怪石、云海、温泉四绝闻名于世，被誉为天下第一奇山。',
 '安徽省黄山市黄山区', '06:00-17:00', 190.00, 4.8, 980),

('故宫博物院', '华北', '历史古迹',
 'https://www.shuomingshu.cn/wp-content/uploads/images/2022/12/02/a382daee878049f2969575e60d9f2464_vgf1x4cfjcj.jpg',
 '明清两代的皇家宫殿，世界上现存规模最大、保存最完整的木质结构古建筑群。',
 '北京市东城区景山前街4号', '08:30-17:00', 60.00, 4.9, 1200),

('三亚亚龙湾', '华南', '海岛度假',
 'https://ts1.tc.mm.bing.net/th/id/R-C.3648af7ed8ba8c00a5390f53e1679327?rik=4wpsJtM2ZxESzA&riu=http%3a%2f%2fpic.ylwpark.com%2fimage%2f201503%2f30%2f5518b70991785.jpg&ehk=t4uc8s180ryMdCBgOOQ6UCSnYjGvWG5mtuGHtXHuDUk%3d&risl=&pid=ImgRaw&r=0',
 '中国最南端的热带海滨旅游城市，碧海蓝天，椰风海韵。',
 '海南省三亚市亚龙湾', '全天开放', 0.00, 4.7, 860),

('丽江古城', '西南', '历史古迹',
 'https://ts1.tc.mm.bing.net/th/id/OIP-C.by5loua0w_sBBqwS8oNADgAAAA?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
 '纳西族文化的瑰宝，世界文化遗产，小桥流水人家的意境之美。',
 '云南省丽江市古城区', '全天开放', 50.00, 4.6, 750),

('九寨沟', '西南', '自然风光',
 'https://p1.ssl.qhmsg.com/t01c5118f984a75ec07.jpg',
 '被称为人间仙境的九寨沟，以其独特的高原钙华地貌和多彩湖泊闻名。',
 '四川省阿坝州九寨沟县', '08:00-17:00', 169.00, 4.9, 1100),

('西湖', '华东', '自然风光',
 'https://hzyly.com/upload/201908/26/201908261930373237.jpg',
 '欲把西湖比西子，淡妆浓抹总相宜。杭州明珠，江南韵味。',
 '浙江省杭州市西湖区', '全天开放', 0.00, 4.7, 1050),

('西安兵马俑', '西北', '历史古迹',
 'https://ts3.tc.mm.bing.net/th/id/OIP-C.qPHK2sHfvXVtZutSv1RY_QHaEK?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
 '世界第八大奇迹，秦始皇陵兵马俑展现了秦朝的强盛军力。',
 '陕西省西安市临潼区', '08:30-18:00', 120.00, 4.8, 920),

('成都锦里', '西南', '美食之旅',
 'https://ts3.tc.mm.bing.net/th/id/OIP-C.hA_CaJ-mV-TCDvX3WJBIqQHaEK?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
 '锦里古街是成都美食的集中地，火锅、串串、担担面等你来尝。',
 '四川省成都市武侯区', '09:00-22:00', 0.00, 4.5, 680),

('张家界国家森林公园', '华中', '自然风光',
 'https://so1.360tres.com/t01a91e60b4b166dd0a.jpg',
 '阿凡达取景地，千峰耸立，云雾缭绕，地球上最像外星球的地方。',
 '湖南省张家界市武陵源区', '07:00-18:00', 228.00, 4.7, 890),

('布达拉宫', '西南', '历史古迹',
 'https://ts2.tc.mm.bing.net/th/id/OIP-C.iWF1lrTNSgMO7_jvTn7YLwHaE5?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
 '世界屋脊上的明珠，藏传佛教圣殿，西藏最宏伟的建筑群。',
 '西藏拉萨市城关区', '09:00-16:00', 200.00, 4.8, 780),

('呼伦贝尔大草原', '华北', '自然风光',
 'https://img.pconline.com.cn/images/upload/upc/tx/itbbs/2103/26/c14/258785371_1616767884199_mthumb.jpg',
 '中国最美的草原，风吹草低见牛羊，体验原始游牧生活。',
 '内蒙古呼伦贝尔市', '全天开放', 0.00, 4.6, 620),

('鼓浪屿', '华东', '海岛度假',
 'https://ts1.tc.mm.bing.net/th/id/R-C.e41bf9fad189c942d2f1ebfc6e480506?rik=MyW3YxI6qU5v0A&riu=http%3a%2f%2fpic5.40017.cn%2f01%2f001%2fa9%2fc8%2frBLkBlt-NCOAVKbJAAJPCC4zSQc163.jpg&ehk=MI3pIApmq%2fzVSsej7gzfUG4FkSMMcefnDGUe7%2ffBwpc%3d&risl=&pid=ImgRaw&r=0',
 '钢琴之岛，万国建筑博览，文艺青年的天堂。',
 '福建省厦门市思明区', '全天开放', 35.00, 4.5, 730);

-- ============================================================
-- 3. 评论表 comments
-- ============================================================
CREATE TABLE IF NOT EXISTS comments (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    destination_id INT NOT NULL,
    user_id        INT NOT NULL,
    content        TEXT NOT NULL,
    rating         INT DEFAULT 5,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- 4. 投票/评分表 votes
-- ============================================================
CREATE TABLE IF NOT EXISTS votes (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    destination_id INT NOT NULL,
    user_id        INT NOT NULL,
    score          INT DEFAULT 0,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (destination_id, user_id),
    FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- 数据库统计摘要
-- ============================================================
-- users 表: 1 条记录 (管理员 admin)
-- destinations 表: 12 条记录 (中国著名旅游目的地)
-- comments 表: 0 条记录 (初始为空，用户使用后产生数据)
-- votes 表: 0 条记录 (初始为空，用户使用后产生数据)

-- ============================================================
-- 使用说明
-- ============================================================
-- 1. 本 SQL 文件适用于 H2 Database (MySQL 兼容模式)
-- 2. 迁移至 MySQL 时，将 INT AUTO_INCREMENT 改为 INT AUTO_INCREMENT
-- 3. 密码字段存储格式: Base64Salt:SHA256Hash
-- 4. 管理员默认账号: admin / admin123
-- 5. 首次启动时 DBUtil.java 会自动执行以上建表和数据插入
-- ============================================================
