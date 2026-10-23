<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- chat.jsp — Modern real-time chat UI --%>
<%@ page import="java.util.*,com.realestate.dao.UserDAO,com.realestate.model.User" %>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
    return;
}
String userId   = String.valueOf(user.getId());
String userName = user.getName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Chat — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    * { box-sizing: border-box; }
   body { 
  padding-top: 68px; 
  background: var(--bg); 
  min-height: 100vh; 
  overflow-y: auto;   /* ✅ allow scrolling */
}
.chat-layout {
  display: grid;
  grid-template-columns: 320px 1fr;
  min-height: calc(100vh - 68px);  /* ✅ flexible height */
}

    /* ---- CONTACTS PANEL ---- */
    .contacts-panel {
      background: var(--white);
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      height: 100%;
    }

    .contacts-header {
      padding: 20px 20px 16px;
      border-bottom: 1px solid var(--border);
    }
    .contacts-header h3 {
      font-family: var(--font-display);
      font-size: 1.15rem;
      margin-bottom: 12px;
    }
    .contacts-search {
      position: relative;
    }
    .contacts-search input {
      width: 100%;
      padding: 9px 14px 9px 36px;
      background: var(--bg);
      border: 1.5px solid var(--border);
      border-radius: 20px;
      font-family: var(--font-body);
      font-size: .85rem;
      outline: none;
      transition: var(--transition);
    }
    .contacts-search input:focus { border-color: var(--primary); }
    .contacts-search .search-icon {
      position: absolute; left: 12px; top: 50%;
      transform: translateY(-50%); color: var(--muted); font-size: .9rem;
    }

    .contacts-list { flex: 1; overflow-y: auto; }

    .contact-item {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 14px 20px;
      cursor: pointer;
      transition: var(--transition);
      border-bottom: 1px solid rgba(240,224,200,.5);
      position: relative;
    }
    .contact-item:hover { background: rgba(255,154,134,.05); }
    .contact-item.active { background: rgba(255,154,134,.1); }
    .contact-item.active::before {
      content: '';
      position: absolute;
      left: 0; top: 0; bottom: 0;
      width: 3px;
      background: var(--primary);
      border-radius: 0 2px 2px 0;
    }

    .contact-avatar {
      width: 46px; height: 46px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--primary), var(--accent));
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; color: white; font-size: 1rem;
      flex-shrink: 0;
    }

    .contact-info { flex: 1; min-width: 0; }
    .contact-info .contact-name {
      font-weight: 600; font-size: .9rem;
      white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .contact-info .contact-role {
      font-size: .75rem; color: var(--muted); margin-top: 2px;
    }

    .contact-online {
      width: 10px; height: 10px;
      background: #22c55e;
      border-radius: 50%;
      border: 2px solid white;
      flex-shrink: 0;
    }

    /* ---- CHAT PANEL ---- */
    .chat-panel {
      display: flex;
      flex-direction: column;
      height: 100%;
      background: var(--bg);
    }

    .chat-empty {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      color: var(--muted);
    }
    .chat-empty .empty-icon { font-size: 4rem; margin-bottom: 16px; opacity: .4; }
    .chat-empty p { font-size: .92rem; }

    /* Chat when active */
    .chat-header {
      background: var(--white);
      border-bottom: 1px solid var(--border);
      padding: 14px 24px;
      display: flex;
      align-items: center;
      gap: 14px;
      flex-shrink: 0;
    }
    .chat-header .ch-avatar {
      width: 42px; height: 42px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--primary), var(--accent));
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; color: white;
    }
    .chat-header .ch-info strong { display: block; font-size: .95rem; }
    .chat-header .ch-info span { font-size: .78rem; color: #22c55e; font-weight: 500; }

    .chat-messages {
      flex: 1;
      overflow-y: auto;
      padding: 20px 24px;
      display: flex;
      flex-direction: column;
      gap: 10px;
      background-image: radial-gradient(circle at 20% 80%, rgba(255,214,166,.2) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(255,154,134,.1) 0%, transparent 50%);     
  	scroll-behavior: smooth;

    }

    .message {
      display: flex;
      flex-direction: column;
      max-width: 65%;
    }
    .message.sent { align-self: flex-end; align-items: flex-end; }
    .message.received { align-self: flex-start; align-items: flex-start; }

    .message-bubble {
      padding: 10px 16px;
      border-radius: 18px;
      font-size: .9rem;
      line-height: 1.5;
      word-wrap: break-word;
    }
    .message.sent .message-bubble {
      background: var(--primary);
      color: white;
      border-bottom-right-radius: 4px;
    }
    .message.received .message-bubble {
      background: var(--white);
      color: var(--dark);
      box-shadow: var(--shadow-sm);
      border-bottom-left-radius: 4px;
    }

    .message-meta {
      font-size: .7rem;
      color: var(--muted);
      margin-top: 3px;
      padding: 0 4px;
    }

    .date-divider {
      text-align: center;
      font-size: .72rem;
      color: var(--muted);
      margin: 8px 0;
      position: relative;
    }
    .date-divider::before, .date-divider::after {
      content: '';
      position: absolute;
      top: 50%;
      width: 35%;
      height: 1px;
      background: var(--border);
    }
    .date-divider::before { left: 0; }
    .date-divider::after { right: 0; }

    /* Input */
    .chat-input-bar {
      background: var(--white);
      border-top: 1px solid var(--border);
      padding: 14px 20px;
      display: flex;
      align-items: center;
      gap: 12px;
      flex-shrink: 0;
    }
    .chat-input-bar input {
      flex: 1;
      padding: 11px 18px;
      background: var(--bg);
      border: 1.5px solid var(--border);
      border-radius: 24px;
      font-family: var(--font-body);
      font-size: .9rem;
      outline: none;
      transition: var(--transition);
    }
    .chat-input-bar input:focus { border-color: var(--primary); background: var(--white); }
    .send-btn {
      width: 44px; height: 44px;
      background: var(--primary);
      border: none;
      border-radius: 50%;
      color: white;
      font-size: 1.1rem;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      transition: var(--transition);
      flex-shrink: 0;
    }
    .send-btn:hover { background: #ff8570; transform: scale(1.05); }

    /* Receiver selector (hidden; kept for backend) */
    #receiver { display: none; }

    @media (max-width: 700px) {
      .contacts-panel { display: none; }
      .chat-layout { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
 
    <li><a href="${pageContext.request.contextPath}/viewProperties">Properties</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="${pageContext.request.contextPath}/jsp/profile.jsp" class="btn btn-ghost btn-sm">Profile</a>
  </div>
</nav>

<!-- Hidden original receiver select (backend integration preserved) -->
<select id="receiver">
<%
UserDAO dao = new UserDAO();
List<User> users = dao.getChatUsers(user.getId());
for (User s : users) {
    if (s.getId() != user.getId()) {
%>
  <option value="<%= s.getId() %>"><%= s.getName() %></option>
<%
    }
}
%>
</select>

<div class="chat-layout">

  <!-- CONTACTS PANEL -->
  <div class="contacts-panel">
    <div class="contacts-header">
      <h3>Messages</h3>
      <div class="contacts-search">
        <span class="search-icon">⌕</span>
        <input type="text" placeholder="Search chats…" id="contactSearch"/>
      </div>
    </div>
    <div class="contacts-list" id="contactsList">
    <%
    if (users != null) {
      for (User s : users) {
        if (s.getId() != user.getId()) {
    %>
      <div class="contact-item" data-id="<%= s.getId() %>"
           data-name="<%= s.getName() %>"
           data-role="<%= s.getRole() %>"
           onclick="selectContact(this)">
        <div class="contact-avatar"><%= s.getName().charAt(0) %></div>
        <div class="contact-info">
          <div class="contact-name"><%= s.getName() %></div>
          <div class="contact-role"><%= s.getRole() %></div>
        </div>
        <div class="contact-online"></div>
      </div>
    <%
        }
      }
    }
    %>
    </div>
  </div>

  <!-- CHAT PANEL -->
  <div class="chat-panel" id="chatPanel">
    <div class="chat-empty" id="chatEmpty">
      <div class="empty-icon">💬</div>
      <p>Select a contact to start chatting</p>
    </div>

    <div id="activeChatArea" style="display:none;flex-direction:column;height:100%;flex:1;">
      <div class="chat-header" id="chatHeader">
        <div class="ch-avatar" id="chatAvatarHead">?</div>
        <div class="ch-info">
          <strong id="chatNameHead">—</strong>
          <span>Online</span>
        </div>
      </div>

      <div class="chat-messages" id="chatBox">
        <div class="date-divider">Today</div>
      </div>

      <div class="chat-input-bar">
        <input type="text" id="msg" placeholder="Type a message…"
               onkeydown="if(event.key==='Enter') sendMessage()"/>
        <button class="send-btn" onclick="sendMessage()">➤</button>
      </div>
    </div>
  </div>

</div>

<script>
var userId   = "<%= userId %>";
var userName = "<%= userName %>";
var contextPath = "<%= request.getContextPath() %>";

// WebSocket (original backend logic preserved)
var ws = new WebSocket("ws://" + window.location.host + contextPath + "/chat?userId=" + userId);

ws.onopen = function() { console.log("WebSocket connected"); };

ws.onmessage = function(event) {
  appendMessage(event.data, 'received');
};

ws.onerror = function(error) { console.error("WebSocket Error:", error); };

function selectContact(el) {
  // Update hidden select
  var id   = el.dataset.id;
  var name = el.dataset.name;
  document.getElementById('receiver').value = id;

  // UI
  document.querySelectorAll('.contact-item').forEach(c => c.classList.remove('active'));
  el.classList.add('active');
  document.getElementById('chatEmpty').style.display = 'none';
  var area = document.getElementById('activeChatArea');
  area.style.display = 'flex';

  document.getElementById('chatAvatarHead').textContent = name.charAt(0);
  document.getElementById('chatNameHead').textContent   = name;

  // Clear previous messages
  document.getElementById('chatBox').innerHTML = '<div class="date-divider">Today</div>';
  document.getElementById('msg').focus();
}

function sendMessage() {
  var msgInput = document.getElementById('msg');
  var msg      = msgInput.value.trim();
  if (!msg) return;

  var receiver = document.getElementById('receiver').value;
  if (!receiver) return;

  ws.send(userId + "|" + receiver + "|" + userName + "|" + msg);

  // Append own message
  var chatBox = document.getElementById('chatBox');
  var div = document.createElement('div');
  div.className = 'message sent';
  div.innerHTML = '<div class="message-bubble">' + escapeHtml(msg) + '</div>' +
                  '<div class="message-meta">' + getTime() + ' ✓✓</div>';
  chatBox.appendChild(div);
  chatBox.scrollTop = chatBox.scrollHeight;

  msgInput.value = '';
}

function appendMessage(text, type) {
  var chatBox = document.getElementById('chatBox');
  var div = document.createElement('div');
  div.className = 'message ' + type;
  div.innerHTML = '<div class="message-bubble">' + escapeHtml(text) + '</div>' +
                  '<div class="message-meta">' + getTime() + '</div>';
  chatBox.appendChild(div);
  chatBox.scrollTop = chatBox.scrollHeight;
}

function getTime() {
  return new Date().toLocaleTimeString('en-IN', {hour:'2-digit', minute:'2-digit'});
}

function escapeHtml(str) {
  return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// Contact search
document.getElementById('contactSearch').addEventListener('input', function() {
  var q = this.value.toLowerCase();
  document.querySelectorAll('.contact-item').forEach(c => {
    c.style.display = c.dataset.name.toLowerCase().includes(q) ? '' : 'none';
  });
});
</script>
</body>
</html>
