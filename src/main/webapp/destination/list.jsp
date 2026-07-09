<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Destination" %>
<%@ page import="com.travel.service.DestinationService" %>
<%@ page import="java.util.List" %>
<%
    DestinationService ds = new DestinationService();
    // Get filter params
    String keyword = request.getParameter("keyword");
    String region = request.getParameter("region");
    String type = request.getParameter("type");
    String sortBy = request.getParameter("sortBy");

    List<Destination> destinations;
    if (keyword != null || region != null || type != null) {
        destinations = ds.search(keyword, region, type, sortBy);
    } else {
        destinations = ds.getTop(50);
    }

    List<String> regions = ds.getAllRegions();
    List<String> types = ds.getAllTypes();

    // Hero background images (use first 5 destinations)
    List<Destination> allDests = ds.getAll();
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
<%@ include file="../header.jsp" %>
<main>
    <!-- Page Header with rotating background -->
    <section class="hero">
        <div class="hero-bg-slider" id="heroBgSlider">
            <% for (int i = 0; i < imgCount; i++) { %>
            <div class="hero-bg-slide <%= (i == 0) ? "active" : "" %>"
                 style="background-image: url('<%= heroImages[i] %>');"></div>
            <% } %>
        </div>
        <div class="hero-overlay"></div>
        <div class="container">
            <div class="section-header" style="margin:0;">
                <h2>All Destinations</h2>
                <p>Browse, search, and discover your next adventure.</p>
            </div>
        </div>
    </section>

    <!-- Filters & Search -->
    <section style="padding-bottom:var(--space-6);">
        <div class="container">
            <form action="<%=contextPath%>/search" method="get" id="search-form" class="search-bar">
                <input type="text" name="keyword" class="search-input"
                       placeholder="Search by name or keyword..."
                       value="<%= keyword != null ? keyword : "" %>">
                <select name="region" class="form-input" style="max-width:150px;">
                    <option value="">All Regions</option>
                    <% for (String r : regions) { %>
                        <option value="<%= r %>" <%= r.equals(region) ? "selected" : "" %>><%= r %></option>
                    <% } %>
                </select>
                <select name="type" class="form-input" style="max-width:170px;">
                    <option value="">All Types</option>
                    <% for (String t : types) { %>
                        <option value="<%= t %>" <%= t.equals(type) ? "selected" : "" %>><%= t %></option>
                    <% } %>
                </select>
                <select name="sortBy" id="search-type" class="form-input" style="max-width:150px;">
                    <option value="popularity" <%= "popularity".equals(sortBy) ? "selected" : "" %>>Popular</option>
                    <option value="rating" <%= "rating".equals(sortBy) ? "selected" : "" %>>Top Rated</option>
                    <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Newest</option>
                </select>
                <button type="submit" class="btn btn-primary">Filter</button>
                <% if (keyword != null || region != null || type != null) { %>
                    <a href="list.jsp" class="btn btn-outline btn-sm">Clear</a>
                <% } %>
            </form>
        </div>
    </section>

    <!-- Active Filters -->
    <% if (region != null || type != null) { %>
    <div class="container" style="padding-bottom:var(--space-4);">
        <div class="filter-chips">
            <% if (region != null && !region.isEmpty()) { %>
                <span class="chip active"><%= region %> &times;</span>
            <% } %>
            <% if (type != null && !type.isEmpty()) { %>
                <span class="chip active"><%= type %> &times;</span>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- Destination Grid -->
    <section class="section" style="padding-top:0;">
        <div class="container">
            <% if (destinations.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-state-icon">&#128269;</div>
                    <h3>No destinations found</h3>
                    <p>Try adjusting your search criteria.</p>
                </div>
            <% } else { %>
                <div class="grid-3">
                    <% for (Destination d : destinations) { %>
                    <a href="detail.jsp?id=<%=d.getId()%>" style="text-decoration:none;">
                        <div class="card reveal">
                            <img class="card-img"
                                 src="<%= d.getImage() != null ? d.getImage() : "https://picsum.photos/seed/travel" + d.getId() + "/800/600" %>"
                                 alt="<%= d.getName() %>"
                                 style="aspect-ratio:3/2;"
                                 onerror="this.src='https://picsum.photos/seed/<%= d.getName() %>/800/600'">
                            <div class="card-body">
                                <div class="flex items-center justify-between mb-4">
                                    <span class="tag tag-green"><%= d.getType() %></span>
                                    <span class="rating">&#9733; <span class="score"><%= String.format("%.1f", d.getRating()) %></span></span>
                                </div>
                                <div class="card-title"><%= d.getName() %></div>
                                <div class="card-text"><%= d.getDescription() %></div>
                                <div class="card-meta">
                                    <span><%= d.getRegion() %></span>
                                    <span>&middot;</span>
                                    <span><%= d.getTicketPriceDisplay() %></span>
                                    <span>&middot;</span>
                                    <span><%= d.getVoteCount() %> likes</span>
                                </div>
                            </div>
                        </div>
                    </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </section>
</main>
<!-- Hero background rotation -->
<script>
(function() {
    var slides = document.querySelectorAll('.hero-bg-slide');
    if (slides.length < 2) return;
    var current = 0;
    setInterval(function() {
        slides[current].classList.remove('active');
        current = (current + 1) % slides.length;
        slides[current].classList.add('active');
    }, 30000);
})();
</script>
<%@ include file="../footer.jsp" %>
