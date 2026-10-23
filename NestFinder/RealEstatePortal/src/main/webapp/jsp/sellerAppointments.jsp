<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- sellerAppointments.jsp --%>
<%@ page import="java.util.*,com.realestate.model.Appointment,com.realestate.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
List<Appointment> list = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Appointments — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { padding-top: 68px; background: var(--bg); }

    .appts-wrapper {
      max-width: 900px;
      margin: 60px auto;
      padding: 0 24px 60px;
    }

    .page-label { font-size: .78rem; font-weight: 600; letter-spacing: 2px; text-transform: uppercase; color: var(--primary); margin-bottom: 8px; }

    .appts-wrapper h1 { font-family: var(--font-display); font-size: 2rem; margin-bottom: 6px; }
    .appts-wrapper > p { color: var(--muted); margin-bottom: 36px; }

    /* FILTER TABS */
    .filter-tabs { display: flex; gap: 8px; margin-bottom: 28px; flex-wrap: wrap; }
    .filter-tab {
      padding: 8px 18px; border-radius: 20px;
      border: 1.5px solid var(--border);
      background: var(--white); font-family: var(--font-body);
      font-size: .85rem; font-weight: 500; cursor: pointer;
      transition: var(--transition); color: var(--muted);
    }
    .filter-tab:hover { border-color: var(--primary); color: var(--primary); }
    .filter-tab.active { background: var(--primary); border-color: var(--primary); color: white; }

    /* APPOINTMENT CARD */
    .appt-card {
      background: var(--white);
      border-radius: var(--radius-md);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
      margin-bottom: 16px;
      transition: var(--transition);
      border-left: 4px solid transparent;
    }
    .appt-card:hover { box-shadow: var(--shadow-md); }
    .appt-card.pending   { border-left-color: #f6a623; }
    .appt-card.confirmed { border-left-color: #22c55e; }
    .appt-card.rejected  { border-left-color: #ef4444; }

    .appt-card-body {
      padding: 20px 24px;
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 12px 24px;
      align-items: center;
    }

    .appt-prop-title { font-family: var(--font-display); font-size: 1.05rem; font-weight: 600; margin-bottom: 6px; }
    .appt-info-grid { display: flex; flex-wrap: wrap; gap: 10px 24px; }
    .appt-info-item { font-size: .82rem; color: var(--muted); display: flex; align-items: center; gap: 5px; }
    .appt-info-item strong { color: var(--dark); }

    .appt-status-badge {
      font-size: .72rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: 1px;
      padding: 5px 14px; border-radius: 20px;
      white-space: nowrap;
    }
    .appt-status-badge.pending   { background: rgba(246,166,35,.15);  color: #b36a00; }
    .appt-status-badge.confirmed { background: rgba(34,197,94,.12);   color: #0a7a3e; }
    .appt-status-badge.rejected  { background: rgba(239,68,68,.1);    color: #c00; }

    .appt-card-footer {
      padding: 12px 24px;
      background: var(--bg);
      border-top: 1px solid var(--border);
      display: flex;
      gap: 10px;
      justify-content: flex-end;
    }

    .appt-btn {
      padding: 7px 18px; border-radius: var(--radius-sm);
      font-family: var(--font-body); font-size: .82rem; font-weight: 500;
      cursor: pointer; border: none; transition: var(--transition);
    }
    .appt-btn.approve { background: rgba(34,197,94,.15); color: #0a7a3e; border: 1px solid rgba(34,197,94,.3); }
    .appt-btn.approve:hover { background: rgba(34,197,94,.25); }
    .appt-btn.reject  { background: rgba(239,68,68,.1);  color: #c00;    border: 1px solid rgba(239,68,68,.2); }
    .appt-btn.reject:hover  { background: rgba(239,68,68,.18); }

    .empty-state { text-align: center; padding: 60px 0; color: var(--muted); }
    .empty-state .empty-icon { font-size: 3.5rem; margin-bottom: 16px; opacity: .4; }

    .back-btn { margin-bottom: 24px; }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
    <li><a href="<%= request.getContextPath() %>/jsp/sellerHome.jsp">Dashboard</a></li>
    <li><a href="<%= request.getContextPath() %>/jsp/addProperty.jsp">Add Property</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="<%= request.getContextPath() %>/jsp/profile.jsp" class="btn btn-ghost btn-sm">Profile</a>
  </div>
</nav>

<div class="appts-wrapper">
 

  <div class="page-label">Seller Portal</div>
  <h1>Appointment Requests</h1>
  <p>Review, approve, or reject buyer visit requests below.</p>

  <!-- Filter tabs -->
  <div class="filter-tabs">
    <button class="filter-tab active" onclick="filterCards('all',   this)">All</button>
    <button class="filter-tab"        onclick="filterCards('pending',   this)">Pending</button>
    <button class="filter-tab"        onclick="filterCards('confirmed', this)">Confirmed</button>
    <button class="filter-tab"        onclick="filterCards('rejected',  this)">Rejected</button>
  </div>

  <div id="apptList">
  <%
  if (list == null || list.isEmpty()) {
  %>
    <div class="empty-state">
      <div class="empty-icon">📭</div>
      <p>No appointment requests yet.</p>
    </div>
  <%
  } else {
    for (Appointment a : list) {
      String sc = a.getStatus() == null ? "pending" : a.getStatus().toLowerCase();
  %>
    <div class="appt-card <%= sc %>" data-status="<%= sc %>">
      <div class="appt-card-body">
        <div>
          <div class="appt-prop-title">Property #<%= a.getPropertyId() %></div>
          <div class="appt-info-grid">
            <div class="appt-info-item">👤 <strong>Buyer ID:</strong> <%= a.getUserId() %></div>
            <div class="appt-info-item">📅 <strong>Date:</strong> <%= a.getDate() %></div>
            <div class="appt-info-item">🔑 <strong>Booking #</strong><%= a.getId() %></div>
          </div>
        </div>
        <span class="appt-status-badge <%= sc %>"><%= a.getStatus() %></span>
      </div>
      <% if ("pending".equals(sc)) { %>
      <div class="appt-card-footer">
        <form action="<%= request.getContextPath() %>/updateAppointment" method="post" style="display:inline;">
          <input type="hidden" name="id" value="<%= a.getId() %>"/>
          <button class="appt-btn approve" name="status" value="confirmed">✅ Approve</button>
        </form>
        <form action="<%= request.getContextPath() %>/updateAppointment" method="post" style="display:inline;">
          <input type="hidden" name="id" value="<%= a.getId() %>"/>
          <button class="appt-btn reject" name="status" value="rejected">❌ Reject</button>
        </form>
      </div>
      <% } %>
    </div>
  <%
    }
  }
  %>
  </div>
</div>

<script>
function filterCards(status, btn) {
    document.querySelectorAll('.filter-tab').forEach(function(t){ t.classList.remove('active'); });
    btn.classList.add('active');

    document.querySelectorAll('.appt-card').forEach(function(card) {
        if (status === 'all' || card.dataset.status === status) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>
</body>
</html>
