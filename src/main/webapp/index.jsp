<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Destination" %>
<%@ page import="com.travel.service.DestinationService" %>
<%@ page import="java.util.List" %>
<%
    DestinationService destinationService = new DestinationService();
    List<Destination> topDestinations = destinationService.getTop(6);
    List<Destination> allDests = destinationService.getAll();
    List<String> regions = destinationService.getAllRegions();
    List<String> types = destinationService.getAllTypes();

    // Collect background images for hero slider (use first 5 scenic destinations)
    String[] heroImages = new String[5];
    int imgCount = 0;
    for (Destination d : allDests) {
        if (imgCount >= 5) break;
        String img = d.getImage();
        if (img != null && !img.isEmpty()) {
            heroImages[imgCount++] = img;
        }
    }
%>
<%@ include file="header.jsp" %>
<main>
    <!-- Hero Section - Taste-Skill: 标题≤2行，副文≤20词 -->
    <section class="hero">
        <!-- Rotating background images with left-to-right feather mask -->
        <div class="hero-bg-slider" id="heroBgSlider">
            <% for (int i = 0; i < imgCount; i++) { %>
            <div class="hero-bg-slide <%= (i == 0) ? "active" : "" %>"
                 style="background-image: url('<%= heroImages[i] %>');"
                 data-index="<%= i %>"></div>
            <% } %>
        </div>
        <!-- Gradient overlay: dark left side for text readability, transparent right -->
        <div class="hero-overlay"></div>
        <div class="container">
            <div class="hero-content">
                <h1>Discover the world,<br>one destination at a time.</h1>
                <p>Explore curated travel destinations, read reviews, and vote for your favorite places.</p>
                <div class="flex gap-2">
                    <a href="<%=contextPath%>/destination/list.jsp" class="btn btn-primary btn-lg">Explore Now</a>
                    <a href="<%=contextPath%>/register.jsp" class="btn btn-outline btn-lg">Join Us</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Search Section -->
    <section class="section">
        <div class="container">
            <form action="<%=contextPath%>/search" method="get" id="search-form" class="search-bar">
                <input type="text" name="keyword" class="search-input"
                       placeholder="Search destinations, regions, or keywords..." aria-label="Search">
                <select name="region" class="form-input" style="max-width:160px;">
                    <option value="">All Regions</option>
                    <% for (String r : regions) { %>
                        <option value="<%= r %>"><%= r %></option>
                    <% } %>
                </select>
                <select name="type" class="form-input" style="max-width:180px;">
                    <option value="">All Types</option>
                    <% for (String t : types) { %>
                        <option value="<%= t %>"><%= t %></option>
                    <% } %>
                </select>
                <button type="submit" class="btn btn-primary">Search</button>
            </form>
        </div>
    </section>

    <!-- Top Destinations - Taste-Skill Bento Grid: 非对称 12 列网格 -->
    <section class="section-lg">
        <div class="container">
            <div class="section-header">
                <h2>Top Destinations</h2>
                <p>Most popular travel spots loved by our community.</p>
            </div>
            <div class="bento-grid">
                <% for (Destination d : topDestinations) { %>
                <a href="<%=contextPath%>/destination/detail.jsp?id=<%=d.getId()%>" style="text-decoration:none;">
                    <div class="card reveal">
                        <img class="card-img"
                             src="<%= d.getImage() != null ? d.getImage() : "https://picsum.photos/seed/travel/800/600" %>"
                             alt="<%= d.getName() %>"
                             onerror="this.src='https://picsum.photos/seed/<%= d.getName() %>/800/600'">
                        <div class="card-body">
                            <div class="flex items-center justify-between mb-4">
                                <span class="tag tag-green"><%= d.getType() %></span>
                                <span class="rating">
                                    &#9733; <span class="score"><%= String.format("%.1f", d.getRating()) %></span>
                                </span>
                            </div>
                            <div class="card-title"><%= d.getName() %></div>
                            <div class="card-text"><%= d.getDescription() %></div>
                            <div class="card-meta">
                                <span><%= d.getRegion() %></span>
                                <span>&middot;</span>
                                <span><%= d.getTicketPriceDisplay() %></span>
                                <span>&middot;</span>
                                <span><%= d.getVoteCount() %> votes</span>
                            </div>
                        </div>
                    </div>
                </a>
                <% } %>
            </div>
            <div class="text-center mt-8">
                <a href="<%=contextPath%>/destination/list.jsp" class="btn btn-outline">View All Destinations</a>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="section" style="background:var(--color-surface);border-top:1px solid var(--color-border);border-bottom:1px solid var(--color-border);">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-card reveal">
                    <div class="stat-value"><%= destinationService.getCount() %></div>
                    <div class="stat-label">Destinations</div>
                </div>
                <div class="stat-card reveal" data-delay="100">
                    <div class="stat-value">12</div>
                    <div class="stat-label">Regions</div>
                </div>
                <div class="stat-card reveal" data-delay="200">
                    <div class="stat-value">6</div>
                    <div class="stat-label">Categories</div>
                </div>
                <div class="stat-card reveal" data-delay="300">
                    <%
                        int totalVotes = 0;
                        for (Destination d : topDestinations) {
                            totalVotes += d.getVoteCount();
                        }
                    %>
                    <div class="stat-value"><%= totalVotes %></div>
                    <div class="stat-label">Total Votes</div>
                </div>
            </div>
        </div>
    </section>
</main>
<!-- Hero background rotation script: 30s interval with crossfade -->
<script>
(function() {
    var slides = document.querySelectorAll('.hero-bg-slide');
    if (slides.length < 2) return;

    var current = 0;
    var total = slides.length;
    var interval = 30000; // 30 seconds

    function nextSlide() {
        // Remove active from current
        slides[current].classList.remove('active');
        // Advance to next (loop)
        current = (current + 1) % total;
        // Add active to next (triggers CSS crossfade)
        slides[current].classList.add('active');
    }

    // Start rotation
    setInterval(nextSlide, interval);
})();
</script>
<%@ include file="footer.jsp" %>
