<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    </div><!-- close .container from header or main content -->
</main>

<!-- Footer - Taste-Skill: 1px border-top, clean minimal -->
<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <span class="footer-brand">&copy; 2026 TravelVote. Built with Taste-Skill design system.</span>
            <ul class="footer-links">
                <li><a href="<%=request.getContextPath()%>/">Home</a></li>
                <li><a href="<%=request.getContextPath()%>/destination/list.jsp">Destinations</a></li>
                <li><a href="#">Privacy</a></li>
                <li><a href="#">Terms</a></li>
            </ul>
        </div>
    </div>
</footer>

<script src="<%=request.getContextPath()%>/js/main.js"></script>
</body>
</html>
