# 旅游地点评选与互动系统

基于 JSP + Servlet + MySQL 的旅游地点评选与互动系统，前端设计遵循 Taste-Skill 极简美学原则。

## 技术栈

| 层级 | 技术 |
|------|------|
| 前端 | JSP + HTML5 + CSS3 + JavaScript (Fetch API) |
| 后端 | Java Servlet |
| 数据库 | MySQL 5.7+ |
| 服务器 | Apache Tomcat 8.0+ |
| 设计系统 | Taste-Skill Minimalist |

## 项目结构

```
TravelRating/
├── src/main/java/com/travel/
│   ├── controller/    # Servlet 控制器
│   ├── model/         # 实体类
│   ├── dao/           # 数据访问层
│   ├── service/       # 业务逻辑层
│   ├── util/          # 工具类
│   └── filter/        # 过滤器
├── src/main/webapp/
│   ├── WEB-INF/web.xml
│   ├── css/           # 样式文件
│   ├── js/            # JavaScript
│   ├── destination/   # 旅游地点页面
│   ├── user/          # 用户页面
│   ├── admin/         # 后台管理
│   └── images/        # 图片资源
└── sql/
    └── travel_db.sql  # 数据库脚本
```

## 快速启动

1. 导入 `sql/travel_db.sql` 到 MySQL
2. 修改 `src/main/java/com/travel/util/DBUtil.java` 中的数据库连接信息
3. 使用 Maven 或 IDE 部署到 Tomcat
4. 访问 `http://localhost:8080/TravelRating/`

## 默认账户

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | admin123 |
| 普通用户 | 自行注册 | - |
