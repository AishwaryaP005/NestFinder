<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- buyerHome.jsp --%>
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
  <title>Buyer Dashboard — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { padding-top: 68px; }
    .dashboard-layout { display: grid; grid-template-columns: 260px 1fr; min-height: calc(100vh - 68px); }

    /* SIDEBAR */
    .sidebar { background: var(--white); border-right: 1px solid var(--border); padding: 32px 20px; position: sticky; top: 68px; height: calc(100vh - 68px); overflow-y: auto; }
    .sidebar-avatar { width: 72px; height: 72px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 700; color: white; margin: 0 auto 12px; }
    .sidebar-name { text-align: center; font-family: var(--font-display); font-size: 1.05rem; font-weight: 600; margin-bottom: 4px; }
    .sidebar-role { text-align: center; font-size: .78rem; color: var(--primary); font-weight: 500; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 28px; }
    .sidebar-nav { list-style: none; display: flex; flex-direction: column; gap: 4px; }
    .sidebar-nav a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: var(--radius-sm); font-size: .9rem; font-weight: 500; color: var(--muted); transition: var(--transition); }
    .sidebar-nav a:hover, .sidebar-nav a.active { background: rgba(255,154,134,.1); color: var(--primary); }
    .sidebar-divider { height: 1px; background: var(--border); margin: 20px 0; }

    /* MAIN */
    .main-content { padding: 40px 48px; background: var(--bg); }
    .welcome-banner { background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); border-radius: var(--radius-lg); padding: 36px 40px; color: white; margin-bottom: 36px; position: relative; overflow: hidden; }
    .welcome-banner::after { content: '🏠'; position: absolute; right: 40px; top: 50%; transform: translateY(-50%); font-size: 5rem; opacity: .2; }
    .welcome-banner .greeting { font-size: .85rem; opacity: .85; margin-bottom: 6px; }
    .welcome-banner h2 { font-family: var(--font-display); font-size: 1.8rem; margin-bottom: 10px; }
    .welcome-banner p { font-size: .92rem; opacity: .85; }

    /* STAT CARDS */
    .stat-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 28px; }
    .stat-card { background: var(--white); border-radius: var(--radius-md); padding: 24px; box-shadow: var(--shadow-sm); display: flex; align-items: center; gap: 18px; transition: var(--transition); }
    .stat-card.clickable { cursor: pointer; }
    .stat-card.clickable:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); border-left: 3px solid var(--primary); }
    .stat-icon { width: 52px; height: 52px; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0; }
    .stat-icon.pink  { background: rgba(255,154,134,.15); }
    .stat-icon.peach { background: rgba(255,214,166,.3); }
    .stat-icon.cream { background: rgba(255,240,190,.6); }
    .stat-card strong { display: block; font-family: var(--font-display); font-size: 1.4rem; }
    .stat-card span { font-size: .8rem; color: var(--muted); }
    .stat-card .click-hint { font-size: .72rem; color: var(--primary); margin-top: 2px; }

    /* AJAX PANELS */
    .ajax-panel {
      background: var(--white);
      border-radius: var(--radius-md);
      box-shadow: var(--shadow-sm);
      border-left: 4px solid var(--primary);
      padding: 24px 28px;
      margin-bottom: 24px;
      display: none;
      animation: fadeDown .28s ease both;
    }
    .ajax-panel.visible { display: block; }
    @keyframes fadeDown { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }
    .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
    .panel-header h4 { font-family: var(--font-display); font-size: 1.05rem; margin: 0; }
    .panel-close { background: none; border: none; font-size: 1.2rem; color: var(--muted); cursor: pointer; line-height: 1; padding: 2px 6px; border-radius: 4px; transition: var(--transition); }
    .panel-close:hover { background: rgba(255,154,134,.1); color: var(--primary); }

    /* Appointment rows */
    .appt-row { background: var(--bg); border-radius: var(--radius-sm); padding: 14px 18px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; border: 1px solid var(--border); gap: 16px; }
    .appt-row:last-child { margin-bottom: 0; }
    .appt-title { font-weight: 600; font-size: .92rem; margin-bottom: 3px; }
    .appt-meta  { font-size: .8rem; color: var(--muted); }
    .appt-status { font-size: .72rem; font-weight: 600; text-transform: uppercase; letter-spacing: .8px; padding: 4px 12px; border-radius: 20px; white-space: nowrap; flex-shrink: 0; }
    .appt-status.pending   { background: rgba(255,214,166,.5);  color: #b36a00; }
    .appt-status.confirmed { background: rgba(100,220,150,.2);  color: #0a7a3e; }
    .appt-status.rejected  { background: rgba(220,100,100,.15); color: #c00; }
    .panel-empty   { text-align: center; padding: 20px; color: var(--muted); font-size: .9rem; }
    .panel-loading { text-align: center; padding: 20px; color: var(--muted); font-size: .88rem; }

    /* QUICK ACTIONS */
    .quick-actions { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .action-card { background: var(--white); border-radius: var(--radius-md); padding: 28px 24px; box-shadow: var(--shadow-sm); transition: var(--transition); cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 18px; color: inherit; }
    .action-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
    .action-icon { width: 56px; height: 56px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-size: 1.6rem; flex-shrink: 0; }
    .action-card h4 { font-family: var(--font-display); font-size: 1.05rem; margin-bottom: 4px; }
    .action-card p  { font-size: .82rem; color: var(--muted); }

    @media (max-width: 900px) {
      .dashboard-layout { grid-template-columns: 1fr; }
      .sidebar { display: none; }
      .main-content { padding: 28px 20px; }
      .stat-cards { grid-template-columns: 1fr 1fr; }
    }
    @media (max-width: 600px) {
      .stat-cards { grid-template-columns: 1fr; }
      .quick-actions { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
   
    <li><a href="${pageContext.request.contextPath}/viewProperties">Properties</a></li>
    <li><a href="${pageContext.request.contextPath}/jsp/chat.jsp">Messages</a></li>
    <li><a href="${pageContext.request.contextPath}/jsp/emi.jsp">EMI</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="${pageContext.request.contextPath}/jsp/profile.jsp" class="btn btn-ghost btn-sm">Profile</a>
    <button class="btn btn-primary" onclick="logout()">Logout</button>
  </div>
</nav>

<div class="dashboard-layout">
  <aside class="sidebar">
    <div class="sidebar-avatar"><%= user.getName().charAt(0) %></div>
    <div class="sidebar-name"><%= user.getName() %></div>
    <div class="sidebar-role">Buyer</div>
    <ul class="sidebar-nav">
      <li><a href="#" class="active"><span class="nav-icon"></span> Dashboard</a></li>
      <li><a href="<%= request.getContextPath() %>/viewProperties"><span class="nav-icon"></span> Properties</a></li>
      <li><a href="<%= request.getContextPath() %>/jsp/chat.jsp"><span class="nav-icon"></span> Messages</a></li>
      <li><a href="<%= request.getContextPath() %>/jsp/emi.jsp"><span class="nav-icon"></span> EMI Calculator</a></li>
      <li><a href="<%= request.getContextPath() %>/jsp/profile.jsp"><span class="nav-icon"></span> My Profile</a></li>
    </ul>
    <div class="sidebar-divider"></div>
    <div class="sidebar-logout">
      <button class="btn btn-primary" onclick="logout()" style="width:100%;justify-content:center;">Logout</button>
    </div>
  </aside>

  <main class="main-content">

    <div class="welcome-banner">
      <div class="greeting">Good day!</div>
      <h2>Welcome, <%= user.getName() %>!</h2>
      <p>Ready to find your dream home? Browse verified listings and connect with sellers today.</p>
    </div>

    <!-- STAT CARDS — cards 2+3 are AJAX triggers -->
    <div class="stat-cards">
      <div class="stat-card">
        <div class="stat-icon pink">🏠</div>
        <div><strong>5,240</strong><span>Available Properties</span></div>
      </div>

      <div class="stat-card clickable" onclick="togglePanel('latestApptPanel', fetchLatestAppointment, 'latestLoaded')">
        <div class="stat-icon peach">📑</div>
        <div>
          <strong>Latest</strong>
          <span>Appointment</span>
          <div class="click-hint">Click to view →</div>
        </div>
      </div>

      <div class="stat-card clickable" onclick="togglePanel('allApptPanel', fetchAllAppointments, 'allLoaded')">
        <div class="stat-icon cream">📋</div>
        <div>
          <strong>All</strong>
          <span>Appointments</span>
          <div class="click-hint">Click to view →</div>
        </div>
      </div>
    </div>

    <!-- AJAX PANEL: LATEST APPOINTMENT -->
    <div id="latestApptPanel" class="ajax-panel">
      <div class="panel-header">
        <h4>📑 Your Latest Appointment</h4>
        <button class="panel-close" onclick="closePanel('latestApptPanel')">✕ Close</button>
      </div>
      <div id="latestApptContent"><div class="panel-loading">Loading…</div></div>
    </div>

    <!-- AJAX PANEL: ALL APPOINTMENTS -->
    <div id="allApptPanel" class="ajax-panel">
      <div class="panel-header">
        <h4>📋 All Your Appointments</h4>
        <button class="panel-close" onclick="closePanel('allApptPanel')">✕ Close</button>
      </div>
      <div id="allApptContent"><div class="panel-loading">Loading…</div></div>
    </div>

    <!-- QUICK ACTIONS -->
    <h3 style="font-family:var(--font-display);font-size:1.25rem;margin-bottom:20px;">Quick Actions</h3>
    <div class="quick-actions">
      <a class="action-card" href="<%= request.getContextPath() %>/viewProperties">
        <div class="action-icon">🔍︎</div>
        <div><h4>Browse Properties</h4><p>Explore available homes, villas, and plots with filters.</p></div>
      </a>
      <a class="action-card" href="<%= request.getContextPath() %>/jsp/chat.jsp">
        <div class="action-icon">💬</div>
        <div><h4>Open Chat</h4><p>Message sellers directly and ask questions in real-time.</p></div>
      </a>
      <a class="action-card" href="<%= request.getContextPath() %>/jsp/emi.jsp">
        <div class="action-icon">₹</div>
        <div><h4>EMI Calculator</h4><p>Plan your home loan and calculate monthly installments.</p></div>
      </a>
      <a class="action-card" href="<%= request.getContextPath() %>/jsp/profile.jsp">
        <div class="action-icon">☺</div>
        <div><h4>My Profile</h4><p>View and manage your personal account information.</p></div>
      </a>
    </div>

  </main>
</div>

<!-- BOOKING SUCCESS POPUP (triggered from viewProperties after booking) -->
<div id="bookingPopup" style="
  display:none; position:fixed; top:88px; right:28px; z-index:2000;
  background:var(--white); border-radius:var(--radius-md);
  box-shadow:var(--shadow-lg); border-left:4px solid var(--primary);
  padding:20px 24px; min-width:300px; max-width:360px;">
  <button onclick="document.getElementById('bookingPopup').style.display='none'"
    style="position:absolute;top:10px;right:12px;background:none;border:none;font-size:1rem;color:var(--muted);cursor:pointer;">✕</button>
  <div style="font-size:2rem;margin-bottom:8px;">📅</div>
  <div style="font-family:var(--font-display);font-size:1.05rem;font-weight:700;margin-bottom:4px;">Appointment Booked!</div>
  <div style="font-size:.85rem;color:var(--muted);">Your visit request has been sent to the seller.</div>
  <div id="bookingPopupBar" style="height:3px;background:linear-gradient(90deg,var(--primary),var(--accent));border-radius:2px;margin-top:14px;"></div>
</div>

<script>
var contextPath  = "<%= request.getContextPath() %>";
var latestLoaded = false;
var allLoaded    = false;

function logout() { window.location.href = contextPath + "/jsp/login.jsp"; }

/* Panel toggle/close */
function closePanel(id) { document.getElementById(id).classList.remove('visible'); }

function togglePanel(panelId, fetchFn, loadedFlag) {
    var panel = document.getElementById(panelId);
    // close sibling
    var sibling = panelId === 'latestApptPanel' ? 'allApptPanel' : 'latestApptPanel';
    document.getElementById(sibling).classList.remove('visible');

    if (panel.classList.contains('visible')) {
        panel.classList.remove('visible');
        return;
    }
    panel.classList.add('visible');
    panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    if (loadedFlag === 'latestLoaded' && !latestLoaded) { fetchFn(); }
    if (loadedFlag === 'allLoaded'    && !allLoaded)    { fetchFn(); }
}

/* ---- Traditional XHR: Latest Appointment ---- */
function fetchLatestAppointment() {
    var Request = new XMLHttpRequest();
    Request.onreadystatechange = function() {
        if (Request.readyState == 4 && Request.status == 200) {
            displayLatestAppointment(Request.responseText);
            latestLoaded = true;
        } else if (Request.readyState == 4) {
            document.getElementById('latestApptContent').innerHTML =
                '<div class="panel-empty">Could not load data. Please try again.</div>';
        }
    };
    Request.open("GET", contextPath + "/buyerLatestAppointment");
    Request.send();
}

function displayLatestAppointment(responseText) {
    var container = document.getElementById('latestApptContent');
    try {
        var data = JSON.parse(responseText);
        if (!data || data.error || !data.propertyTitle) {
            container.innerHTML = '<div class="panel-empty">No appointments booked yet.</div>';
            return;
        }
        var sc = (data.status || 'pending').toLowerCase();
        container.innerHTML =
            '<div class="appt-row">' +
              '<div>' +
                '<div class="appt-title"> ' + esc(data.propertyTitle) + '</div>' +
                '<div class="appt-meta"> ' + esc(data.location) + ' &nbsp;·&nbsp; 📅 ' + esc(data.date) + '</div>' +
              '</div>' +
              '<span class="appt-status ' + sc + '">' + esc(data.status) + '</span>' +
            '</div>';
    } catch(e) {
        container.innerHTML = '<div class="panel-empty">No appointments found.</div>';
    }
}

/* ---- Traditional XHR: All Appointments ---- */
function fetchAllAppointments() {
    var Request = new XMLHttpRequest();
    Request.onreadystatechange = function() {
        if (Request.readyState == 4 && Request.status == 200) {
            displayAllAppointments(Request.responseText);
            allLoaded = true;
        } else if (Request.readyState == 4) {
            document.getElementById('allApptContent').innerHTML =
                '<div class="panel-empty">Could not load data. Please try again.</div>';
        }
    };
    Request.open("GET", contextPath + "/buyerAppointments");
    Request.send();
}

function displayAllAppointments(responseText) {
    var container = document.getElementById('allApptContent');
    try {
        var list = JSON.parse(responseText);
        if (!list || list.length === 0) {
            container.innerHTML = '<div class="panel-empty">You have no appointments yet.</div>';
            return;
        }
        var html = '';
        for (var i = 0; i < list.length; i++) {
            var a = list[i];
            var sc = (a.status || 'pending').toLowerCase();
            html +=
                '<div class="appt-row">' +
                  '<div>' +
                    '<div class="appt-title"> ' + esc(a.propertyTitle) + '</div>' +
                    '<div class="appt-meta"> ' + esc(a.location) + ' &nbsp;·&nbsp; 📅 ' + esc(a.date) + '</div>' +
                  '</div>' +
                  '<span class="appt-status ' + sc + '">' + esc(a.status) + '</span>' +
                '</div>';
        }
        container.innerHTML = html;
    } catch(e) {
        container.innerHTML = '<div class="panel-empty">No appointments found.</div>';
    }
}

function esc(str) {
    if (!str) return '—';
    return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

/* Booking success popup (called from viewProperties via sessionStorage) */
window.addEventListener('load', function() {
    if (sessionStorage.getItem('bookingSuccess') === '1') {
        sessionStorage.removeItem('bookingSuccess');
        var pop = document.getElementById('bookingPopup');
        pop.style.display = 'block';
        setTimeout(function(){ pop.style.display = 'none'; }, 3500);
    }
});
</script>
</body>
</html>
