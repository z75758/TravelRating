<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Destination" %>
<%@ page import="com.travel.model.Comment" %>
<%@ page import="com.travel.service.DestinationService" %>
<%@ page import="com.travel.service.CommentService" %>
<%@ page import="com.travel.service.VoteService" %>
<%@ page import="java.util.List" %>
<%
    // Get current user from session (before header.jsp include)
    User detailCurrentUser = (User) session.getAttribute("user");

    String idParam = request.getParameter("id");
    if (idParam == null) {
        response.sendRedirect(request.getContextPath() + "/destination/list.jsp");
        return;
    }
    int destId = Integer.parseInt(idParam);
    DestinationService ds = new DestinationService();
    CommentService cs = new CommentService();
    VoteService vs = new VoteService();

    Destination destination = ds.getById(destId);
    if (destination == null) {
        response.sendRedirect(request.getContextPath() + "/destination/list.jsp");
        return;
    }
    ds.incrementPopularity(destId);

    List<Comment> comments = cs.getByDestination(destId);
    boolean hasVoted = (detailCurrentUser != null) && vs.hasVoted(detailCurrentUser.getId(), destId);
    int voteCount = vs.getVoteCount(destId);
    double avgRating = cs.getAvgRating(destId);
%>
<%@ include file="../header.jsp" %>
<main>
    <!-- Detail Hero Image -->
    <div class="container" style="padding-top:var(--space-8);">
        <div class="detail-hero reveal">
            <img src="<%= destination.getImage() != null ? destination.getImage() : "https://picsum.photos/seed/dest" + destId + "/1200/600" %>"
                 alt="<%= destination.getName() %>"
                 onerror="this.src='https://picsum.photos/seed/<%= destination.getName() %>/1200/600'">
        </div>
    </div>

    <!-- Detail Content -->
    <section class="section" style="padding-top:0;">
        <div class="container">
            <div class="detail-content">
                <!-- Main Content -->
                <div>
                    <div class="flex items-center gap-4 mb-4">
                        <span class="tag tag-green"><%= destination.getType() %></span>
                        <span class="tag tag-blue"><%= destination.getRegion() %></span>
                    </div>
                    <h1><%= destination.getName() %></h1>
                    <div class="flex items-center gap-4 mb-6" style="margin-top:var(--space-4);">
                        <span class="rating" style="font-size:var(--text-xl);">
                            &#9733; <span class="score"><%= String.format("%.1f", avgRating > 0 ? avgRating : destination.getRating()) %></span>
                        </span>
                        <span style="color:var(--color-text-tertiary);">(<%= comments.size() %> reviews)</span>

                        <!-- Vote Button -->
                        <button class="vote-btn <%= hasVoted ? "voted" : "" %>"
                                data-destination-id="<%= destId %>">
                            &#9829; <span class="vote-count"><%= voteCount %></span>
                        </button>
                    </div>

                    <div style="margin-top:var(--space-6);">
                        <p style="font-size:var(--text-lg);color:var(--color-text-secondary);"><%= destination.getDescription() %></p>
                    </div>
                </div>

                <!-- Sidebar Info -->
                <div>
                    <div class="card" style="position:sticky;top:80px;">
                        <div class="card-body" style="padding:var(--space-6);">
                            <h4 style="margin-bottom:var(--space-4);">Location Info</h4>

                            <% if (destination.getAddress() != null && !destination.getAddress().isEmpty()) { %>
                            <div class="detail-info-item">
                                <div>
                                    <div class="detail-info-label">Address</div>
                                    <div class="detail-info-value"><%= destination.getAddress() %></div>
                                </div>
                            </div>
                            <% } %>

                            <% if (destination.getOpenTime() != null && !destination.getOpenTime().isEmpty()) { %>
                            <div class="detail-info-item">
                                <div>
                                    <div class="detail-info-label">Open Hours</div>
                                    <div class="detail-info-value"><%= destination.getOpenTime() %></div>
                                </div>
                            </div>
                            <% } %>

                            <div class="detail-info-item">
                                <div>
                                    <div class="detail-info-label">Ticket Price</div>
                                    <div class="detail-info-value" style="color:var(--color-accent);font-weight:600;">
                                        <%= destination.getTicketPriceDisplay() %>
                                    </div>
                                </div>
                            </div>

                            <div class="detail-info-item">
                                <div>
                                    <div class="detail-info-label">Popularity</div>
                                    <div class="detail-info-value"><%= destination.getPopularity() %> visits</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Comments Section -->
    <section class="section" style="background:var(--color-surface);border-top:1px solid var(--color-border);">
        <div class="container">
            <div class="section-header">
                <h2>Reviews (<%= comments.size() %>)</h2>
                <p>What our community says about this destination.</p>
            </div>

            <!-- Comment Form -->
            <% if (currentUser != null) { %>
            <form action="<%=contextPath%>/comment" method="post" style="margin-bottom:var(--space-8);">
                <input type="hidden" name="destinationId" value="<%= destId %>">
                <div class="form-group">
                    <label class="form-label" for="rating">Your Rating</label>
                    <select name="rating" id="rating" class="form-input" style="max-width:200px;">
                        <option value="5">5 - Excellent</option>
                        <option value="4">4 - Good</option>
                        <option value="3">3 - Average</option>
                        <option value="2">2 - Poor</option>
                        <option value="1">1 - Terrible</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="commentContent">Your Review</label>
                    <textarea id="commentContent" name="content" class="form-input"
                              placeholder="Share your experience at this destination..." required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Post Review</button>
            </form>
            <% } else { %>
                <div class="alert alert-info" style="margin-bottom:var(--space-8);">
                    Please <a href="<%=contextPath%>/login.jsp">sign in</a> to leave a review.
                </div>
            <% } %>

            <!-- Comment List -->
            <div class="comment-list">
                <% if (comments.isEmpty()) { %>
                    <div class="empty-state">
                        <p>No reviews yet. Be the first to share your experience.</p>
                    </div>
                <% } else { %>
                    <% for (Comment c : comments) { %>
                    <div class="comment-item reveal">
                        <div class="comment-header">
                            <span class="comment-avatar"><%= c.getInitial() %></span>
                            <div>
                                <div class="comment-author"><%= c.getUsername() != null ? c.getUsername() : "User" %></div>
                                <div class="comment-time">
                                    <span class="rating" style="font-size:var(--text-xs);">
                                        <% for (int i = 1; i <= 5; i++) { %>
                                            <%= i <= c.getRating() ? "&#9733;" : "&#9734;" %>
                                        <% } %>
                                    </span>
                                    &middot; <%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0, 10) : "" %>
                                </div>
                            </div>
                        </div>
                        <div class="comment-body"><%= c.getContent() %></div>
                    </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </section>
</main>
<%@ include file="../footer.jsp" %>
