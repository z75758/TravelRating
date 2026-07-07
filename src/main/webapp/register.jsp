<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<main>
    <div class="auth-container">
        <div class="auth-card reveal">
            <h2>Create account</h2>
            <p class="subtitle">Join our travel community.</p>
            <form action="<%=contextPath%>/user/register" method="post" onsubmit="return validateRegister()">
                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="At least 2 characters" required minlength="2" autocomplete="username">
                </div>
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-input"
                           placeholder="you@example.com" required autocomplete="email">
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="At least 6 characters" required minlength="6" autocomplete="new-password">
                </div>
                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                           placeholder="Re-enter your password" required autocomplete="new-password">
                </div>
                <button type="submit" class="btn btn-primary w-full" style="width:100%;">Create Account</button>
            </form>
            <div class="auth-footer">
                Already have an account? <a href="<%=contextPath%>/login.jsp">Sign in</a>
            </div>
        </div>
    </div>
</main>
<script>
function validateRegister() {
    var p1 = document.getElementById('password').value;
    var p2 = document.getElementById('confirmPassword').value;
    if (p1 !== p2) {
        alert('Passwords do not match.');
        return false;
    }
    return true;
}
</script>
<%@ include file="footer.jsp" %>
