package com.travel.util;

import java.sql.*;
import java.math.BigDecimal;

/**
 * Database connection utility.
 * Uses H2 embedded database (MySQL-compatible mode, zero installation).
 * Auto-creates tables and sample data on first run.
 */
public class DBUtil {

    private static final String DRIVER = "org.h2.Driver";
    private static final String URL = "jdbc:h2:file:./data/travel_db"
            + ";MODE=MySQL"
            + ";DATABASE_TO_LOWER=TRUE"
            + ";DB_CLOSE_DELAY=-1";
    private static final String USER = "sa";
    private static final String PASSWORD = "";

    private static volatile boolean initialized = false;

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("H2 Driver not found.", e);
        }
    }

    /**
     * Get a database connection. Auto-initializes on first call.
     */
    public static Connection getConnection() throws SQLException {
        if (!initialized) {
            synchronized (DBUtil.class) {
                if (!initialized) {
                    initDatabase();
                    initialized = true;
                }
            }
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * Create tables and seed sample data.
     */
    private static void initDatabase() {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement()) {

            // Drop existing tables for clean start
            stmt.execute("DROP TABLE IF EXISTS votes");
            stmt.execute("DROP TABLE IF EXISTS comments");
            stmt.execute("DROP TABLE IF EXISTS destinations");
            stmt.execute("DROP TABLE IF EXISTS users");

            // Users table
            stmt.execute(
                "CREATE TABLE users (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  username VARCHAR(50) NOT NULL UNIQUE," +
                "  email VARCHAR(100) NOT NULL UNIQUE," +
                "  password VARCHAR(255) NOT NULL," +
                "  avatar VARCHAR(255) DEFAULT NULL," +
                "  role VARCHAR(10) DEFAULT 'user'," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // Destinations table
            stmt.execute(
                "CREATE TABLE destinations (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  name VARCHAR(100) NOT NULL," +
                "  region VARCHAR(50) NOT NULL," +
                "  type VARCHAR(50) NOT NULL," +
                "  image VARCHAR(255) DEFAULT NULL," +
                "  description TEXT," +
                "  address VARCHAR(255) DEFAULT NULL," +
                "  open_time VARCHAR(100) DEFAULT NULL," +
                "  ticket_price DECIMAL(10,2) DEFAULT 0.00," +
                "  rating DOUBLE DEFAULT 0.0," +
                "  popularity INT DEFAULT 0," +
                "  created_by INT DEFAULT NULL," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL" +
                ")"
            );

            // Comments table
            stmt.execute(
                "CREATE TABLE comments (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  destination_id INT NOT NULL," +
                "  user_id INT NOT NULL," +
                "  content TEXT NOT NULL," +
                "  rating INT DEFAULT 5," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE," +
                "  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                ")"
            );

            // Votes table (star rating: 1-5 score per user per destination)
            stmt.execute(
                "CREATE TABLE votes (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  destination_id INT NOT NULL," +
                "  user_id INT NOT NULL," +
                "  score INT DEFAULT 0," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                "  UNIQUE (destination_id, user_id)," +
                "  FOREIGN KEY (destination_id) REFERENCES destinations(id) ON DELETE CASCADE," +
                "  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                ")"
            );

            // Seed admin user (password: admin123)
            String adminPasswordHash = PasswordUtil.hash("admin123");
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)")) {
                ps.setString(1, "admin");
                ps.setString(2, "admin@travel.com");
                ps.setString(3, adminPasswordHash);
                ps.setString(4, "admin");
                ps.executeUpdate();
            }

            // Seed sample destinations
            String[][] samples = {
                {"黄山风景区", "华东", "自然风光", "https://picsum.photos/seed/huangshan/800/600",
                 "黄山以奇松、怪石、云海、温泉四绝闻名于世，被誉为天下第一奇山。", "安徽省黄山市黄山区", "06:00-17:00", "190.00", "4.8", "980"},
                {"故宫博物院", "华北", "历史古迹", "https://picsum.photos/seed/gugong/800/600",
                 "明清两代的皇家宫殿，世界上现存规模最大、保存最完整的木质结构古建筑群。", "北京市东城区景山前街4号", "08:30-17:00", "60.00", "4.9", "1200"},
                {"三亚亚龙湾", "华南", "海岛度假", "https://picsum.photos/seed/sanya/800/600",
                 "中国最南端的热带海滨旅游城市，碧海蓝天，椰风海韵。", "海南省三亚市亚龙湾", "全天开放", "0.00", "4.7", "860"},
                {"丽江古城", "西南", "历史古迹", "https://picsum.photos/seed/lijiang/800/600",
                 "纳西族文化的瑰宝，世界文化遗产，小桥流水人家的意境之美。", "云南省丽江市古城区", "全天开放", "50.00", "4.6", "750"},
                {"九寨沟", "西南", "自然风光", "https://picsum.photos/seed/jiuzhaigou/800/600",
                 "被称为人间仙境的九寨沟，以其独特的高原钙华地貌和多彩湖泊闻名。", "四川省阿坝州九寨沟县", "08:00-17:00", "169.00", "4.9", "1100"},
                {"西湖", "华东", "自然风光", "https://picsum.photos/seed/xihu/800/600",
                 "欲把西湖比西子，淡妆浓抹总相宜。杭州明珠，江南韵味。", "浙江省杭州市西湖区", "全天开放", "0.00", "4.7", "1050"},
                {"西安兵马俑", "西北", "历史古迹", "https://picsum.photos/seed/bingmayong/800/600",
                 "世界第八大奇迹，秦始皇陵兵马俑展现了秦朝的强盛军力。", "陕西省西安市临潼区", "08:30-18:00", "120.00", "4.8", "920"},
                {"成都锦里", "西南", "美食之旅", "https://picsum.photos/seed/jinli/800/600",
                 "锦里古街是成都美食的集中地，火锅、串串、担担面等你来尝。", "四川省成都市武侯区", "09:00-22:00", "0.00", "4.5", "680"},
                {"张家界国家森林公园", "华中", "自然风光", "https://picsum.photos/seed/zhangjiajie/800/600",
                 "阿凡达取景地，千峰耸立，云雾缭绕，地球上最像外星球的地方。", "湖南省张家界市武陵源区", "07:00-18:00", "228.00", "4.7", "890"},
                {"布达拉宫", "西南", "历史古迹", "https://picsum.photos/seed/budalagong/800/600",
                 "世界屋脊上的明珠，藏传佛教圣殿，西藏最宏伟的建筑群。", "西藏拉萨市城关区", "09:00-16:00", "200.00", "4.8", "780"},
                {"呼伦贝尔大草原", "华北", "自然风光", "https://picsum.photos/seed/hulunbeier/800/600",
                 "中国最美的草原，风吹草低见牛羊，体验原始游牧生活。", "内蒙古呼伦贝尔市", "全天开放", "0.00", "4.6", "620"},
                {"鼓浪屿", "华东", "海岛度假", "https://picsum.photos/seed/gulangyu/800/600",
                 "钢琴之岛，万国建筑博览，文艺青年的天堂。", "福建省厦门市思明区", "全天开放", "35.00", "4.5", "730"}
            };

            String insertSql = "INSERT INTO destinations (name, region, type, image, description, address, open_time, ticket_price, rating, popularity) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                for (String[] row : samples) {
                    ps.setString(1, row[0]);
                    ps.setString(2, row[1]);
                    ps.setString(3, row[2]);
                    ps.setString(4, row[3]);
                    ps.setString(5, row[4]);
                    ps.setString(6, row[5]);
                    ps.setString(7, row[6]);
                    ps.setBigDecimal(8, new java.math.BigDecimal(row[7]));
                    ps.setDouble(9, Double.parseDouble(row[8]));
                    ps.setInt(10, Integer.parseInt(row[9]));
                    ps.executeUpdate();
                }
            }

            System.out.println("[TravelRating] Database initialized with 12 sample destinations.");

        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize database.", e);
        }
    }

    /**
     * Close resources silently.
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}
