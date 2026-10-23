<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- sellerHome.jsp --%>
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
  <title>Seller Dashboard — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { padding-top: 68px; }
    .dashboard-layout { display: grid; grid-template-columns: 260px 1fr; min-height: calc(100vh - 68px); }

    /* SIDEBAR */
    .sidebar { background: var(--white); border-right: 1px solid var(--border); padding: 32px 20px; position: sticky; top: 68px; height: calc(100vh - 68px); overflow-y: auto; }
    .sidebar-avatar { width: 72px; height: 72px; background: linear-gradient(135deg, var(--dark), #555); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; font-weight: 700; color: white; margin: 0 auto 12px; }
    .sidebar-name { text-align: center; font-family: var(--font-display); font-size: 1.05rem; font-weight: 600; margin-bottom: 4px; }
    .sidebar-role { text-align: center; font-size: .78rem; color: var(--dark); font-weight: 500; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 28px; }
    .sidebar-nav { list-style: none; display: flex; flex-direction: column; gap: 4px; }
    .sidebar-nav a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: var(--radius-sm); font-size: .9rem; font-weight: 500; color: var(--muted); transition: var(--transition); }
    .sidebar-nav a:hover, .sidebar-nav a.active { background: rgba(44,44,44,.07); color: var(--dark); }
    .sidebar-divider { height: 1px; background: var(--border); margin: 20px 0; }

    /* MAIN */
    .main-content { padding: 40px 48px; background: var(--bg); }
    .welcome-banner { background: linear-gradient(135deg, var(--dark) 0%, #444 100%); border-radius: var(--radius-lg); padding: 36px 40px; color: white; margin-bottom: 36px; position: relative; overflow: hidden; }
    .welcome-banner::after { content: '🏗️'; position: absolute; right: 40px; top: 50%; transform: translateY(-50%); font-size: 5rem; opacity: .15; }
    .welcome-banner .greeting { font-size: .85rem; opacity: .75; margin-bottom: 6px; }
    .welcome-banner h2 { font-family: var(--font-display); font-size: 1.8rem; margin-bottom: 10px; }
    .welcome-banner p { font-size: .92rem; opacity: .75; }

    /* STAT CARDS */
    .stat-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 28px; }
    .stat-card { background: var(--white); border-radius: var(--radius-md); padding: 24px; box-shadow: var(--shadow-sm); display: flex; align-items: center; gap: 18px; transition: var(--transition); }
    .stat-card.clickable { cursor: pointer; }
    .stat-card.clickable:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); border-left: 3px solid var(--primary); }
    .stat-icon { width: 52px; height: 52px; border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0; }
    .stat-icon.a { background: rgba(255,154,134,.15); }
    .stat-icon.b { background: rgba(255,154,134,.15); }
    .stat-icon.c { background: rgba(255,154,134,.15); }
    .stat-card strong { display: block; font-family: var(--font-display); font-size: 1.6rem; }
    .stat-card span { font-size: .8rem; color: var(--muted); }
    .stat-card .click-hint { font-size: .72rem; color: var(--primary); margin-top: 2px; }

    /* AJAX PANELS */
    .ajax-panel {
      background: var(--white); border-radius: var(--radius-md); box-shadow: var(--shadow-sm);
      border-left: 4px solid var(--primary); padding: 24px 28px;
      margin-bottom: 24px; display: none;
      animation: fadeDown .28s ease both;
    }
    .ajax-panel.visible { display: block; }
    @keyframes fadeDown { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }
    .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
    .panel-header h4 { font-family: var(--font-display); font-size: 1.05rem; margin: 0; }
    .panel-close { background: none; border: none; font-size: 1.2rem; color: var(--muted); cursor: pointer; padding: 2px 6px; border-radius: 4px; transition: var(--transition); }
    .panel-close:hover { background: rgba(255,154,134,.1); color: var(--primary); }
    .panel-empty   { text-align: center; padding: 20px; color: var(--muted); font-size: .9rem; }
    .panel-loading { text-align: center; padding: 20px; color: var(--muted); font-size: .88rem; }

    /* Property rows inside panel */
    .prop-row { background: var(--bg); border-radius: var(--radius-sm); padding: 14px 18px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; border: 1px solid var(--border); gap: 16px; }
    .prop-row:last-child { margin-bottom: 0; }
    .prop-title { font-weight: 600; font-size: .92rem; margin-bottom: 3px; }
    .prop-meta  { font-size: .8rem; color: var(--muted); }
    .prop-price { font-family: var(--font-display); font-weight: 700; color: var(--primary); white-space: nowrap; }

    /* Appointment rows */
    .appt-row { background: var(--bg); border-radius: var(--radius-sm); padding: 14px 18px; margin-bottom: 10px; border: 1px solid var(--border); }
    .appt-row:last-child { margin-bottom: 0; }
    .appt-row-header { display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; }
    .appt-title  { font-weight: 600; font-size: .92rem; margin-bottom: 3px; }
    .appt-meta   { font-size: .8rem; color: var(--muted); margin-bottom: 10px; }
    .appt-status { font-size: .72rem; font-weight: 600; text-transform: uppercase; letter-spacing: .8px; padding: 4px 12px; border-radius: 20px; white-space: nowrap; flex-shrink: 0; }
    .appt-status.pending   { background: rgba(255,214,166,.5);  color: #b36a00; }
    .appt-status.confirmed { background: rgba(100,220,150,.2);  color: #0a7a3e; }
    .appt-status.rejected  { background: rgba(220,100,100,.15); color: #c00; }

    /* Action buttons in appointment row */
    .appt-actions { display: flex; gap: 8px; }
    .appt-btn { padding: 6px 14px; border: none; border-radius: var(--radius-sm); font-family: var(--font-body); font-size: .8rem; font-weight: 500; cursor: pointer; transition: var(--transition); }
    .appt-btn.approve { background: rgba(100,220,150,.2); color: #0a7a3e; border: 1px solid rgba(100,220,150,.4); }
    .appt-btn.approve:hover { background: rgba(100,220,150,.35); }
    .appt-btn.reject  { background: rgba(220,100,100,.1); color: #c00; border: 1px solid rgba(220,100,100,.25); }
    .appt-btn.reject:hover  { background: rgba(220,100,100,.2); }

    /* QUICK ACTIONS */
    .quick-actions { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .action-card { background: var(--white); border-radius: var(--radius-md); padding: 28px 24px; box-shadow: var(--shadow-sm); transition: var(--transition); cursor: pointer; text-decoration: none; display: flex; align-items: center; gap: 18px; color: inherit; }
    .action-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
    .action-icon { width: 56px; height: 56px; background: linear-gradient(135deg, #555, var(--dark)); border-radius: var(--radius-md); display: flex; align-items: center; justify-content: center; font-size: 1.6rem; flex-shrink: 0; }
    .action-card h4 { font-family: var(--font-display); font-size: 1.05rem; margin-bottom: 4px; }
    .action-card p  { font-size: .82rem; color: var(--muted); }

    @media (max-width: 900px) {
      .dashboard-layout { grid-template-columns: 1fr; }
      .sidebar { display: none; }
      .main-content { padding: 28px 20px; }
      .stat-cards { grid-template-columns: 1fr 1fr; }
      .quick-actions { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
   
    <li><a href="<%= request.getContextPath() %>/jsp/addProperty.jsp">Add Property</a></li>
    <li><a href="<%= request.getContextPath() %>/viewAppointments">Appointments</a></li>
    <li><a href="<%= request.getContextPath() %>/jsp/chat.jsp">Messages</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="<%= request.getContextPath() %>/jsp/profile.jsp" class="btn btn-ghost btn-sm">Profile</a>
    <button class="btn btn-primary" onclick="logout()">Logout</button>
  </div>
</nav>

<div class="dashboard-layout">
  <aside class="sidebar">
    <div class="sidebar-avatar"><%= user.getName().charAt(0) %></div>
    <div class="sidebar-name"><%= user.getName() %></div>
    <div class="sidebar-role">Seller</div>
    <ul class="sidebar-nav">
      <li><a href="#" class="active"><span></span> Dashboard</a></li>
      <li><a href="<%= request.getContextPath() %>/jsp/addProperty.jsp"><span></span> Add Property</a></li>
      <li><a href="<%= request.getContextPath() %>/viewAppointments"><span></span> Appointments</a></li>
      <li><a href="<%= request.getContextPath() %>/jsp/chat.jsp"><span></span> Messages</a></li>
      <li><a href="<%= request.getContextPath() %>/jsp/profile.jsp"><span></span> My Profile</a></li>
    </ul>
    <div class="sidebar-divider"></div>
    <div class="sidebar-logout">
      <button class="btn btn-primary" onclick="logout()" style="width:100%;justify-content:center;">Logout</button>
    </div>
  </aside>

  <main class="main-content">

    <div class="welcome-banner">
      <div class="greeting">Seller Portal</div>
      <h2>Welcome, <%= user.getName() %>!</h2>
      <p>Manage your listings, track appointments, and connect with potential buyers effortlessly.</p>
    </div>

    <!-- STAT CARDS — all 3 are clickable AJAX triggers -->
    <div class="stat-cards">
      <div class="stat-card clickable" onclick="togglePanel('propsPanel', fetchProperties, 'propsLoaded')">
        <div class="stat-icon a">🏠</div>
        <div>
          <strong id="propCount">—</strong>
          <span>Properties Listed</span>
          <div class="click-hint">Click to view →</div>
        </div>
      </div>

      <div class="stat-card clickable" onclick="togglePanel('pendingPanel', fetchPendingAppointments, 'pendingLoaded')">
        <div class="stat-icon b">📑</div>
        <div>
          <strong id="pendingCount">—</strong>
          <span>Pending Appointments</span>
          <div class="click-hint">Click to view →</div>
        </div>
      </div>

      <div class="stat-card clickable" onclick="togglePanel('approvedPanel', fetchApprovedAppointments, 'approvedLoaded')">
        <div class="stat-icon c">☑</div>
        <div>
          <strong id="approvedCount">—</strong>
          <span>Confirmed Bookings</span>
          <div class="click-hint">Click to view →</div>
        </div>
      </div>
    </div>

    <!-- AJAX PANEL: PROPERTIES -->
    <div id="propsPanel" class="ajax-panel">
      <div class="panel-header">
        <h4>Your Listed Properties</h4>
        <button class="panel-close" onclick="closePanel('propsPanel')">✕ Close</button>
      </div>
      <div id="propsContent"><div class="panel-loading">Loading…</div></div>
    </div>

    <!-- AJAX PANEL: PENDING APPOINTMENTS -->
    <div id="pendingPanel" class="ajax-panel" style="border-left-color:#b36a00;">
      <div class="panel-header">
        <h4>Pending Appointments</h4>
        <button class="panel-close" onclick="closePanel('pendingPanel')">✕ Close</button>
      </div>
      <div id="pendingContent"><div class="panel-loading">Loading…</div></div>
    </div>

    <!-- AJAX PANEL: APPROVED APPOINTMENTS -->
    <div id="approvedPanel" class="ajax-panel" style="border-left-color:#0a7a3e;">
      <div class="panel-header">
        <h4>Confirmed Appointments</h4>
        <button class="panel-close" onclick="closePanel('approvedPanel')">✕ Close</button>
      </div>
      <div id="approvedContent"><div class="panel-loading">Loading…</div></div>
    </div>

    <!-- QUICK ACTIONS -->
    <h3 style="font-family:var(--font-display);font-size:1.25rem;margin-bottom:20px;">Quick Actions</h3>
    <div class="quick-actions">
      <a class="action-card" href="<%= request.getContextPath() %>/jsp/addProperty.jsp">
        <div class="action-icon">+󠀫󠀫󠀫󠀫</div>
        <div><h4>Add New Property</h4><p>List a new property with photos, price, and description.</p></div>
      </a>
      <a class="action-card" href="<%= request.getContextPath() %>/viewAppointments">
        <div class="action-icon">📑</div>
        <div><h4>View Appointments</h4><p>Review and manage buyer visit requests.</p></div>
      </a>
      <a class="action-card" href="<%= request.getContextPath() %>/jsp/chat.jsp">
        <div class="action-icon">💬</div>
        <div><h4>Open Chat</h4><p>Respond to buyer enquiries in real-time.</p></div>
      </a>
      <a class="action-card" href="<%= request.getContextPath() %>/jsp/profile.jsp">
        <div class="action-icon">☺</div>
        <div><h4>My Profile</h4><p>View and update your seller account details.</p></div>
      </a>
    </div>

  </main>
</div>

<script>
var contextPath   = "<%= request.getContextPath() %>";
var propsLoaded   = false;
var pendingLoaded = false;
var approvedLoaded= false;

function logout() { window.location.href = contextPath + "/jsp/login.jsp"; }

function closePanel(id) { document.getElementById(id).classList.remove('visible'); }

function togglePanel(panelId, fetchFn, flag) {
    var allPanels = ['propsPanel','pendingPanel','approvedPanel'];
    var panel = document.getElementById(panelId);

    if (panel.classList.contains('visible')) {
        panel.classList.remove('visible');
        return;
    }
    // close others
    allPanels.forEach(function(id){ if (id !== panelId) document.getElementById(id).classList.remove('visible'); });
    panel.classList.add('visible');
    panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

    if (flag === 'propsLoaded'    && !propsLoaded)    fetchFn();
    if (flag === 'pendingLoaded'  && !pendingLoaded)  fetchFn();
    if (flag === 'approvedLoaded' && !approvedLoaded) fetchFn();
}

/* ---- fetch: Seller Properties ---- */
function fetchProperties() {
    fetch(contextPath + "/sellerProperties")
        .then(r => r.json())
        .then(function(list) {
            propsLoaded = true;
            document.getElementById('propCount').textContent = list.length || 0;
            var container = document.getElementById('propsContent');
            if (!list || list.length === 0) {
                container.innerHTML = '<div class="panel-empty">No properties listed yet.</div>'; return;
            }
            var html = '';
            list.forEach(function(p) {
                html +=
                    '<div class="prop-row">' +
                        '<div>' +
                            '<div class="prop-title"> ' + esc(p.title) + '</div>' +
                            '<div class="prop-meta"> ' + esc(p.location) + ' &nbsp;·&nbsp; 🛏 ' + esc(p.bhk) + ' BHK</div>' +
                        '</div>' +
                        '<div class="prop-price">₹' + Number(p.price).toLocaleString('en-IN') + '</div>' +
                    '</div>';
            });
            container.innerHTML = html;
        })
        .catch(function(){ document.getElementById('propsContent').innerHTML = '<div class="panel-empty">Could not load data.</div>'; });
}

/* ---- fetch: Pending Appointments ---- */
function fetchPendingAppointments() {
    fetch(contextPath + "/sellerAppointmentsJson?status=pending")
        .then(r => r.json())
        .then(function(list) {
            pendingLoaded = true;
            document.getElementById('pendingCount').textContent = list.length || 0;
            renderAppointments('pendingContent', list, true);
        })
        .catch(function(){ document.getElementById('pendingContent').innerHTML = '<div class="panel-empty">Could not load data.</div>'; });
}

/* ---- fetch: Approved Appointments ---- */
function fetchApprovedAppointments() {
    fetch(contextPath + "/sellerAppointmentsJson?status=confirmed")
        .then(r => r.json())
        .then(function(list) {
            approvedLoaded = true;
            document.getElementById('approvedCount').textContent = list.length || 0;
            renderAppointments('approvedContent', list, false);
        })
        .catch(function(){ document.getElementById('approvedContent').innerHTML = '<div class="panel-empty">Could not load data.</div>'; });
}

/* ---- Render appointment rows ---- */
function renderAppointments(containerId, list, showActions) {
    var container = document.getElementById(containerId);
    if (!list || list.length === 0) {
        container.innerHTML = '<div class="panel-empty">No appointments found.</div>'; return;
    }
    var html = '';
    list.forEach(function(a) {
        var sc = (a.status || 'pending').toLowerCase();
        html +=
            '<div class="appt-row" id="apptRow_' + a.id + '">' +
                '<div class="appt-row-header">' +
                    '<div>' +
                        '<div class="appt-title"> ' + esc(a.propertyTitle) + '</div>' +
                        '<div class="appt-meta">' +
                            ' ' + esc(a.buyerName) + ' &nbsp;·&nbsp; ' +
                            '📅 ' + esc(a.date) +
                        '</div>' +
                    '</div>' +
                    '<span class="appt-status ' + sc + '">' + esc(a.status) + '</span>' +
                '</div>';
        if (showActions) {
            html +=
                '<div class="appt-actions" style="margin-top:10px;">' +
                    '<button class="appt-btn approve" onclick="updateAppt(' + a.id + ',\'confirmed\')">✅ Approve</button>' +
                    '<button class="appt-btn reject"  onclick="updateAppt(' + a.id + ',\'rejected\')">❌ Reject</button>' +
                '</div>';
        }
        html += '</div>';
    });
    container.innerHTML = html;
}

/* ---- Update appointment status ---- */
function updateAppt(id, status) {
    fetch(contextPath + "/updateAppointment", {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + id + '&status=' + status
    })
    .then(function(r) {
        if (r.ok || r.redirected) {
            // Reload panels


            
            
            Loaded  = false;
            approvedLoaded = false;
            // Refresh both visible panels
            fetchPendingAppointments();
            fetchApprovedAppointments();
        }
    })
    .catch(function(err){ console.error(err); });
}

/* Load counts on page load without opening panels */
window.addEventListener('load', function() {
    fetch(contextPath + "/sellerProperties").then(r => r.json())
        .then(function(l){ document.getElementById('propCount').textContent = l.length || 0; }).catch(function(){});
    fetch(contextPath + "/sellerAppointmentsJson?status=pending").then(r => r.json())
        .then(function(l){ document.getElementById('pendingCount').textContent = l.length || 0; }).catch(function(){});
    fetch(contextPath + "/sellerAppointmentsJson?status=confirmed").then(r => r.json())
        .then(function(l){ document.getElementById('approvedCount').textContent = l.length || 0; }).catch(function(){});
});

function esc(str) {
    if (!str && str !== 0) return '—';
    return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
</script>
</body>
</html>
