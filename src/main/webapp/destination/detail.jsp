<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Destination" %>
<%@ page import="com.travel.model.Comment" %>
<%@ page import="com.travel.model.User" %>
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
    int voteCount = vs.getVoteCount(destId);
    double avgRating = vs.getAverageScore(destId);
    boolean hasVoted = (detailCurrentUser != null) && vs.hasVoted(detailCurrentUser.getId(), destId);
    int userScore = hasVoted ? vs.getUserScore(detailCurrentUser.getId(), destId) : 0;
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

                    <!-- ★ Star Rating Section ★ -->
                    <div class="rating-section reveal" style="margin-top:var(--space-5);">
                        <div class="rating-overview">
                            <div class="rating-stars-large" id="rating-display">
                                <span class="rating-number"><%= String.format("%.1f", avgRating) %></span>
                                <div class="stars-display">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <span class="star-display <%= (i <= Math.round(avgRating)) ? "filled" : "" %>">&#9733;</span>
                                    <% } %>
                                </div>
                                <span class="rating-count">(<%= voteCount %> 人评价)</span>
                            </div>

                            <!-- Interactive Star Rating -->
                            <% if (detailCurrentUser != null) { %>
                            <div class="rating-interactive" id="rating-interactive">
                                <span class="rating-label"><%= hasVoted ? "你的评分：" : "给个评分：" %></span>
                                <div class="stars-interactive" id="stars-interactive"
                                     data-destination-id="<%= destId %>"
                                     data-user-score="<%= userScore %>">
                                    <% for (int i = 1; i <= 5; i++) { %>
                                        <button class="star-btn <%= (i <= userScore) ? "active" : "" %>"
                                                data-star="<%= i %>"
                                                aria-label="<%= i %> 星">&#9733;</button>
                                    <% } %>
                                </div>
                                <span class="rating-hint" id="rating-hint">
                                    <%= hasVoted ? "（点击可修改评分）" : "（点击星星进行评分）" %>
                                </span>
                            </div>
                            <% } else { %>
                            <div class="rating-login-hint">
                                <a href="<%=contextPath%>/login.jsp">登录</a> 后即可评分
                            </div>
                            <% } %>
                        </div>
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

    <!-- Reviews Section -->
    <section class="section" style="background:var(--color-surface);border-top:1px solid var(--color-border);">
        <div class="container">
            <div class="section-header">
                <h2>评价与留言 (<%= comments.size() %>)</h2>
                <p>看看其他游客怎么说，也留下你的评价吧。</p>
            </div>

            <!-- Comment Form -->
            <% if (currentUser != null) { %>
            <form action="<%=contextPath%>/comment" method="post" class="comment-form reveal" style="margin-bottom:var(--space-8);">
                <input type="hidden" name="destinationId" value="<%= destId %>">
                <input type="hidden" name="rating" value="5">
                <div class="form-group">
                    <label class="form-label" for="commentContent">写评价</label>
                    <textarea id="commentContent" name="content" class="form-input"
                              placeholder="分享你在这个地方的旅行体验..." rows="4" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">提交评价</button>
            </form>
            <% } else { %>
                <div class="alert alert-info reveal" style="margin-bottom:var(--space-8);">
                    请 <a href="<%=contextPath%>/login.jsp">登录</a> 后发表评价。
                </div>
            <% } %>

            <!-- Comment List -->
            <div class="comment-list">
                <% if (comments.isEmpty()) { %>
                    <div class="empty-state reveal">
                        <p>还没有评价，快来成为第一个分享体验的人吧！</p>
                    </div>
                <% } else { %>
                    <% for (Comment c : comments) { %>
                    <div class="comment-item reveal" id="comment-<%= c.getId() %>">
                        <div class="comment-header">
                            <span class="comment-avatar"><%= c.getInitial() %></span>
                            <div style="flex:1;">
                                <div class="comment-author"><%= c.getUsername() != null ? c.getUsername() : "User" %></div>
                                <div class="comment-time">
                                    <%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0, 10) : "" %>
                                </div>
                            </div>
                            <%-- Delete button: visible to comment author or admin --%>
                            <% if (detailCurrentUser != null &&
                                  (detailCurrentUser.isAdmin() || detailCurrentUser.getId() == c.getUserId())) { %>
                            <form action="<%=contextPath%>/comment" method="post"
                                  onsubmit="return confirm('确定要删除这条评论吗？');" style="margin:0;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="commentId" value="<%= c.getId() %>">
                                <input type="hidden" name="destinationId" value="<%= destId %>">
                                <button type="submit" class="comment-delete-btn" title="删除评论" aria-label="删除评论">&times;</button>
                            </form>
                            <% } %>
                        </div>
                        <div class="comment-body"><%= c.getContent() %></div>
                    </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </section>
</main>

<!-- Toast notification -->
<div id="toast" class="toast" style="display:none;"></div>

<script>
/* ===== Star Rating Interaction ===== */
(function() {
    var starsContainer = document.getElementById('stars-interactive');
    if (!starsContainer) return;

    var destId = starsContainer.dataset.destinationId;
    var currentScore = parseInt(starsContainer.dataset.userScore) || 0;
    var starBtns = starsContainer.querySelectorAll('.star-btn');
    var hint = document.getElementById('rating-hint');
    var ratingDisplay = document.getElementById('rating-display');
    var currentHover = 0;
    var isSubmitting = false;

    // Highlight stars up to N
    function highlight(n) {
        starBtns.forEach(function(btn) {
            var star = parseInt(btn.dataset.star);
            if (star <= n) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
    }

    // Reset to current actual score
    function reset() {
        highlight(currentHover || currentScore);
    }

    // Send rating to server
    function submitRating(score) {
        if (isSubmitting) return;
        isSubmitting = true;

        var formData = new FormData();
        formData.append('destinationId', destId);
        formData.append('score', score);

        fetch('<%=contextPath%>/vote', {
            method: 'POST',
            body: new URLSearchParams({
                destinationId: destId,
                score: score,
                action: 'rate'
            })
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            isSubmitting = false;
            if (data.success) {
                currentScore = score;
                starsContainer.dataset.userScore = score;
                highlight(score);
                hint.textContent = '评分成功！';
                hint.style.color = 'var(--color-accent)';

                // Update average display
                var ratingNum = ratingDisplay.querySelector('.rating-number');
                var starsDisplay = ratingDisplay.querySelector('.stars-display');
                var ratingCount = ratingDisplay.querySelector('.rating-count');
                if (ratingNum) ratingNum.textContent = data.avgRating.toFixed(1);
                if (ratingCount) ratingCount.textContent = '(' + data.voteCount + ' 人评价)';
                if (starsDisplay) {
                    var stars = starsDisplay.querySelectorAll('.star-display');
                    var avgRounded = Math.round(data.avgRating);
                    stars.forEach(function(s, i) {
                        if ((i + 1) <= avgRounded) {
                            s.classList.add('filled');
                        } else {
                            s.classList.remove('filled');
                        }
                    });
                }

                showToast('评分成功！你给了 ' + score + ' 星');
                setTimeout(function() {
                    hint.textContent = '（点击可修改评分）';
                    hint.style.color = '';
                }, 2000);
            } else {
                hint.textContent = '评分失败，请重试';
                hint.style.color = 'var(--color-error-text)';
                showToast(data.message || '评分失败');
            }
        })
        .catch(function(err) {
            isSubmitting = false;
            hint.textContent = '网络错误，请重试';
            hint.style.color = 'var(--color-error-text)';
            showToast('网络错误');
        });
    }

    // Mouse hover
    starBtns.forEach(function(btn) {
        btn.addEventListener('mouseenter', function() {
            currentHover = parseInt(this.dataset.star);
            highlight(currentHover);
            var labels = ['', '很差', '较差', '一般', '较好', '非常好'];
            hint.textContent = labels[currentHover];
            hint.style.color = '#e6a817';
        });

        btn.addEventListener('mouseleave', function() {
            currentHover = 0;
            highlight(currentScore);
            hint.textContent = currentScore > 0 ? '（点击可修改评分）' : '（点击星星进行评分）';
            hint.style.color = '';
        });

        btn.addEventListener('click', function() {
            var score = parseInt(this.dataset.star);
            highlight(score);
            hint.textContent = '提交中...';
            submitRating(score);
        });
    });
})();

/* ===== Toast Notification ===== */
function showToast(msg) {
    var toast = document.getElementById('toast');
    toast.textContent = msg;
    toast.className = 'toast show';
    setTimeout(function() {
        toast.className = 'toast';
    }, 2500);
}
</script>

<%@ include file="../footer.jsp" %>
