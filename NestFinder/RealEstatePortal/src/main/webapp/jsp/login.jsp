<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- login.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { min-height: 100vh; display: flex; flex-direction: column; }

    .auth-wrapper {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: 100vh;
    }

    /* Left panel — image */
    .auth-visual {
      position: relative;
      background-image: url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=900');
      background-size: cover;
      background-position: center;
    }
    .auth-visual-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(160deg,rgba(255,154,134,.85) 0%,rgba(44,44,44,.7) 100%);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 40px;
    }
    .auth-visual-brand {
      font-family: var(--font-display);
      font-size: 1.8rem;
      font-weight: 700;
      color: white;
    }
    .auth-visual-brand span { color: var(--accent); }
    .auth-visual-copy { color: white; }
    .auth-visual-copy h2 {
      font-family: var(--font-display);
      font-size: 2rem;
      line-height: 1.25;
      margin-bottom: 12px;
    }
    .auth-visual-copy p { color: rgba(255,255,255,.8); font-size: .95rem; }

    /* Right panel — form */
    .auth-form-panel {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 60px 40px;
      background: var(--bg);
    }

    .auth-card {
      width: 100%;
      max-width: 420px;
    }

    .auth-card .auth-header { margin-bottom: 36px; }
    .auth-card .auth-header h1 {
      font-family: var(--font-display);
      font-size: 2rem;
      color: var(--dark);
      margin-bottom: 8px;
    }
    .auth-card .auth-header p { color: var(--muted); font-size: .92rem; }

    .auth-divider {
      display: flex;
      align-items: center;
      gap: 14px;
      margin: 24px 0;
      color: var(--muted);
      font-size: .8rem;
    }
    .auth-divider::before, .auth-divider::after {
      content: '';
      flex: 1;
      height: 1px;
      background: var(--border);
    }

    .auth-footer {
      text-align: center;
      margin-top: 24px;
      font-size: .88rem;
      color: var(--muted);
    }
    .auth-footer a { color: var(--primary); font-weight: 500; }
    .auth-footer a:hover { text-decoration: underline; }

    .input-icon-wrapper { position: relative; }
    .input-icon-wrapper .form-control { padding-left: 40px; }
    .input-icon {
      position: absolute;
      left: 13px; top: 50%;
      transform: translateY(-50%);
      color: var(--muted);
      font-size: 1rem;
      pointer-events: none;
    }

    .forgot-link {
      display: block;
      text-align: right;
      font-size: .8rem;
      color: var(--primary);
      margin-top: -8px;
      margin-bottom: 20px;
    }

    @media (max-width: 700px) {
      .auth-visual { display: none; }
      .auth-wrapper { grid-template-columns: 1fr; }
      .auth-form-panel { padding: 40px 24px; padding-top: 80px; }
    }
  </style>
</head>
<body>

<div class="auth-wrapper">
  <!-- Visual Panel -->
  <div class="auth-visual">
    <div class="auth-visual-overlay">
      <a href="${pageContext.request.contextPath}/index.jsp" class="auth-visual-brand">Nest<span>Finder</span></a>
      <div class="auth-visual-copy">
        <h2>Your Dream Home Awaits</h2>
        <p>Join thousands of happy buyers and sellers on India's most trusted real estate platform.</p>
      </div>
    </div>
  </div>

  <!-- Form Panel -->
  <div class="auth-form-panel">
    <div class="auth-card">
      <div class="auth-header">
        <h1>Welcome back</h1>
        <p>Sign in to continue to your account</p>
      </div>

      <%-- Show error from servlet if any --%>
      <% String err = (String) request.getAttribute("error"); %>
      <% if (err != null) { %>
        <div class="alert alert-error"><%= err %></div>
      <% } %>

      <form action="<%= request.getContextPath() %>/login" method="post" novalidate>

        <div class="form-group">
          <label for="email">Email Address</label>
          <div class="input-icon-wrapper">
            <span class="input-icon">✉</span>
            <input class="form-control" type="email" id="email" name="email" placeholder="you@example.com" required/>
          </div>
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <div class="input-icon-wrapper">
            <span class="input-icon">🔒</span>
            <input class="form-control" type="password" id="password" name="password" placeholder="••••••••" required/>
          </div>
        </div>

    <!--    <a href="#" class="forgot-link">Forgot password?</a> --> 

        <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;padding:13px;">Sign In</button>

      </form>

      <div class="auth-footer">
        Don't have an account? <a href="<%= request.getContextPath() %>/jsp/register.jsp">Create one →</a>
      </div>
    </div>
  </div>
</div>

</body>
</html>
