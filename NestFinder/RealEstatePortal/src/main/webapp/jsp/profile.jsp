<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.realestate.model.User" %>

<%
User user = (User) session.getAttribute("user");

if (user == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Profile — NestFinder</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

  <style>
    body { min-height: 100vh; display: flex; flex-direction: column; }

    .auth-wrapper {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: 100vh;
    }

    /* LEFT PANEL */
    .auth-visual {
      position: relative;
      background-image: url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=900');
      background-size: cover;
      background-position: center;
    }

    .auth-visual-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(160deg,rgba(255,154,134,.85),rgba(44,44,44,.7));
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
      text-decoration: none;
    }

    .auth-visual-brand span { color: var(--accent); }

    .auth-visual-copy {
      color: white;
    }

    /* RIGHT PANEL */
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

    .auth-header h1 {
      font-family: var(--font-display);
      font-size: 2rem;
      margin-bottom: 10px;
    }

    .profile-info {
      margin-top: 20px;
    }

    .profile-item {
      margin-bottom: 15px;
      padding: 10px;
      border-bottom: 1px solid var(--border);
    }

    .label {
      font-weight: bold;
      color: var(--dark);
    }

    .value {
      color: var(--muted);
    }

    .btn-group {
      margin-top: 20px;
      display: flex;
      gap: 10px;
    }

    .btn {
      flex: 1;
      padding: 12px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }

    .btn-primary {
      background: #FF9A86;
      color: white;
    }

    .btn-secondary {
      background: #FFD6A6;
    }

    @media (max-width: 700px) {
      .auth-visual { display: none; }
      .auth-wrapper { grid-template-columns: 1fr; }
    }
  </style>
</head>

<body>

<div class="auth-wrapper">

  <!-- LEFT PANEL -->
  <div class="auth-visual">
    <div class="auth-visual-overlay">
      <a href="${pageContext.request.contextPath}/index.jsp" class="auth-visual-brand">
        Nest<span>Finder</span>
      </a>

      <div class="auth-visual-copy">
        <h2>Your Profile</h2>
        <p>Manage your personal information and account details.</p>
      </div>
    </div>
  </div>

  <!-- RIGHT PANEL -->
  <div class="auth-form-panel">
    <div class="auth-card">

      <div class="auth-header">
        <h1>Hello, <%= user.getName() %> </h1>
        <p>Here are your account details</p>
      </div>

      <div class="profile-info">

        <div class="profile-item">
          <div class="label">Email</div>
          <div class="value"><%= user.getEmail() %></div>
        </div>

        <div class="profile-item">
          <div class="label">Phone</div>
          <div class="value"><%= user.getPhone() %></div>
        </div>

        <div class="profile-item">
          <div class="label">Date of Birth</div>
          <div class="value"><%= user.getDob() %></div>
        </div>

        <div class="profile-item">
          <div class="label">Role</div>
          <div class="value"><%= user.getRole() %></div>
        </div>

      </div>

      <div class="btn-group">
        <button class="btn btn-secondary" onclick="goBack()">Back</button>
        <button class="btn btn-primary" onclick="logout()">Logout</button>
      </div>

    </div>
  </div>

</div>

<script>
function goBack() {
    window.history.back();
}

function logout() {
    window.location.href = "<%= request.getContextPath() %>/jsp/login.jsp";
}
</script>

</body>
</html>