<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- viewProperties.jsp --%>
<%@ page import="java.util.*,com.realestate.model.Property" %>
<%
  /* Pull filter values set by the servlet so inputs stay populated */
  String fLocation     = (String) request.getAttribute("filterLocation");
  String fBhk          = (String) request.getAttribute("filterBhk");
  String fMaxPrice     = (String) request.getAttribute("filterMaxPrice");
  String fPropertyType = (String) request.getAttribute("filterPropertyType");
  String fSort         = (String) request.getAttribute("filterSort");
  if (fLocation     == null) fLocation     = "";
  if (fBhk          == null) fBhk          = "";
  if (fMaxPrice     == null) fMaxPrice     = "";
  if (fPropertyType == null) fPropertyType = "";
  if (fSort         == null) fSort         = "newest";

  List<Property> list = (List<Property>) request.getAttribute("propertyList");
  Integer totalCount  = (Integer) request.getAttribute("totalCount");
  int shown = (list != null) ? list.size() : 0;
  int total = (totalCount != null) ? totalCount : shown;

  /* Helper to mark a <select> option as selected */
  // (used inline below via Java ternary)
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Properties — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { padding-top: 68px; }

    .props-layout { display: grid; grid-template-columns: 280px 1fr; max-width: 1300px; margin: 0 auto; gap: 0; }

    /* FILTER SIDEBAR */
    .filter-sidebar { background: var(--white); border-right: 1px solid var(--border); padding: 32px 24px; position: sticky; top: 68px; height: calc(100vh - 68px); overflow-y: auto; }
    .filter-sidebar h3 { font-family: var(--font-display); font-size: 1.1rem; margin-bottom: 24px; }
    .filter-section { margin-bottom: 28px; }
    .filter-section label { display: block; font-size: .8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: var(--muted); margin-bottom: 10px; }

    /* MAIN */
    .props-main { padding: 32px 40px; background: var(--bg); }
    .props-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; flex-wrap: wrap; gap: 12px; }
    .props-header h2 { font-family: var(--font-display); font-size: 1.5rem; }
    .result-count { font-size: .88rem; color: var(--muted); }

    .props-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 24px; margin-bottom: 40px; }

    .property-card .card-image { height: 190px; }
    .property-card .card-actions .btn { flex: 1; justify-content: center; font-size: .8rem; }

    /* Appointment form */
    .appt-form { padding: 16px 20px; border-top: 1px solid var(--border); background: rgba(255,240,190,.3); }
    .appt-form label { font-size: .78rem; color: var(--muted); display: block; margin-bottom: 5px; }
    .appt-form input[type="datetime-local"] { width: 100%; padding: 8px 12px; border: 1.5px solid var(--border); border-radius: var(--radius-sm); background: var(--white); font-family: var(--font-body); font-size: .85rem; outline: none; margin-bottom: 10px; }
    .appt-form input[type="datetime-local"]:focus { border-color: var(--primary); }
    .appt-form .btn { width: 100%; justify-content: center; }

    /* Details panel */
    .details-panel { background: var(--white); border-radius: var(--radius-lg); padding: 36px; box-shadow: var(--shadow-md); margin-top: 8px; display: none; }
    .details-panel.visible { display: block; }
    .details-panel h3 { font-family: var(--font-display); font-size: 1.4rem; margin-bottom: 16px; }
    .details-meta { display: flex; gap: 24px; flex-wrap: wrap; margin-bottom: 20px; }
    .details-meta .meta-item { font-size: .88rem; color: var(--muted); }
    .details-meta .meta-item strong { color: var(--dark); display: block; font-size: 1rem; }
    .details-images { display: flex; gap: 12px; flex-wrap: wrap; }
    .details-images img { height: 160px; width: 220px; object-fit: cover; border-radius: var(--radius-sm); cursor: pointer; transition: opacity .2s; }
    .details-images img:hover { opacity: .8; }
    .close-details { float: right; background: none; border: none; font-size: 1.4rem; cursor: pointer; color: var(--muted); }

    /* Seller info box inside details */
    .seller-box {
      margin-top: 24px; padding: 18px 20px;
      background: linear-gradient(135deg, rgba(255,154,134,.08), rgba(255,240,190,.3));
      border-radius: var(--radius-md); border: 1px solid var(--border);
      display: flex; align-items: center; gap: 16px;
    }
    .seller-avatar {
      width: 48px; height: 48px; border-radius: 50%;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      display: flex; align-items: center; justify-content: center;
      font-size: 1.3rem; font-weight: 700; color: white; flex-shrink: 0;
    }
    .seller-info-label { font-size: .7rem; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: var(--primary); margin-bottom: 4px; }
    .seller-info strong { font-size: .95rem; display: block; }
    .seller-info span   { font-size: .82rem; color: var(--muted); }

    /* IMAGE LIGHTBOX */
    .lightbox-overlay { display: none; position: fixed; inset: 0; z-index: 3000; background: rgba(44,44,44,.92); align-items: center; justify-content: center; flex-direction: column; }
    .lightbox-overlay.open { display: flex; }
    .lightbox-img-wrap { position: relative; display: flex; align-items: center; justify-content: center; width: 100%; max-width: 880px; padding: 0 64px; }
    #lightboxImg { max-height: 75vh; max-width: 100%; border-radius: var(--radius-md); box-shadow: 0 24px 60px rgba(0,0,0,.5); object-fit: contain; transition: opacity .2s ease; }
    .lb-btn { position: absolute; top: 50%; transform: translateY(-50%); width: 44px; height: 44px; background: rgba(255,240,190,.15); border: 1.5px solid rgba(255,240,190,.35); border-radius: 50%; color: white; font-size: 1.2rem; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background .2s; backdrop-filter: blur(4px); }
    .lb-btn:hover { background: var(--primary); border-color: var(--primary); }
    .lb-prev { left: 8px; } .lb-next { right: 8px; }
    .lb-close { position: fixed; top: 20px; right: 24px; background: none; border: none; color: rgba(255,255,255,.7); font-size: 1.8rem; cursor: pointer; line-height: 1; transition: color .2s; }
    .lb-close:hover { color: var(--primary); }
    .lb-counter { margin-top: 16px; font-size: .82rem; color: rgba(255,255,255,.55); }
    .lb-dots { display: flex; gap: 6px; margin-top: 10px; }
    .lb-dot { width: 7px; height: 7px; background: rgba(255,255,255,.3); border-radius: 50%; cursor: pointer; transition: background .2s; }
    .lb-dot.active { background: var(--primary); }

    /* BOOKING POPUP */
    #bookingPopup {
      display: none; position: fixed; top: 88px; right: 28px; z-index: 2000;
      background: var(--white); border-radius: var(--radius-md);
      box-shadow: var(--shadow-lg); border-left: 4px solid var(--primary);
      padding: 20px 24px; min-width: 300px; max-width: 360px;
      animation: slideIn .35s cubic-bezier(.4,0,.2,1) both;
    }
    @keyframes slideIn { from { opacity:0; transform:translateX(30px); } to { opacity:1; transform:translateX(0); } }
    #bookingPopupBar { height: 3px; background: linear-gradient(90deg,var(--primary),var(--accent)); border-radius: 2px; margin-top: 14px; animation: shrinkBar 3.5s linear forwards; }
    @keyframes shrinkBar { from { width: 100%; } to { width: 0%; } }

    @media (max-width: 900px) {
      .props-layout { grid-template-columns: 1fr; }
      .filter-sidebar { display: none; }
      .props-main { padding: 24px 20px; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
     <li><a href="<%= request.getContextPath() %>/jsp/buyerHome.jsp">Dashboard</a></li>
    <li><a href="${pageContext.request.contextPath}/jsp/chat.jsp">Messages</a></li>
    <li><a href="${pageContext.request.contextPath}/jsp/emi.jsp">EMI</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="${pageContext.request.contextPath}/jsp/profile.jsp" class="btn btn-ghost btn-sm">Profile</a>
  </div>
</nav>

<div class="props-layout">

  <%-- ═══════════════ FILTER SIDEBAR ═══════════════ --%>
  <aside class="filter-sidebar">
    <h3>Filters</h3>

    <%-- All filters submit as GET to /viewProperties --%>
    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/viewProperties">

      <div class="filter-section">
        <label>Location</label>
        <input class="form-control" type="text" name="location"
               placeholder="City or locality…"
               value="<%= fLocation %>"/>
      </div>

      <div class="filter-section">
        <label>BHK Type</label>
        <select class="form-control" name="bhk">
          <option value="" <%= fBhk.isEmpty()            ? "selected" : "" %>>Any</option>
          <option value="1 BHK"  <%= "1 BHK".equals(fBhk)  ? "selected" : "" %>>1 BHK</option>
          <option value="2 BHK"  <%= "2 BHK".equals(fBhk)  ? "selected" : "" %>>2 BHK</option>
          <option value="3 BHK"  <%= "3 BHK".equals(fBhk)  ? "selected" : "" %>>3 BHK</option>
          <option value="4+ BHK" <%= "4+ BHK".equals(fBhk) ? "selected" : "" %>>4+ BHK</option>
        </select>
      </div>

      <div class="filter-section">
        <label>Max Price (₹)</label>
        <input class="form-control" type="number" name="maxPrice"
               placeholder="e.g. 5000000"
               value="<%= fMaxPrice %>"/>
      </div>

      <div class="filter-section">
        <label>Property Type</label>
        <select class="form-control" name="propertyType">
          <option value=""         <%= fPropertyType.isEmpty()                ? "selected" : "" %>>Any</option>
          <option value="Apartment"<%= "Apartment".equals(fPropertyType)     ? "selected" : "" %>>Apartment</option>
          <option value="Villa"    <%= "Villa".equals(fPropertyType)         ? "selected" : "" %>>Villa</option>
          <option value="Plot"     <%= "Plot".equals(fPropertyType)          ? "selected" : "" %>>Plot</option>
          <option value="Row House"<%= "Row House".equals(fPropertyType)     ? "selected" : "" %>>Row House</option>
        </select>
      </div>

      <%-- Hidden field so sort selection is preserved across Apply clicks --%>
      <input type="hidden" name="sort" id="hiddenSort" value="<%= fSort %>"/>

      <button type="submit" class="btn btn-primary"
              style="width:100%;justify-content:center;margin-top:8px;">Apply Filters</button>

    </form>

    <%-- Clear: navigate to /viewProperties with no params --%>
    <a href="${pageContext.request.contextPath}/viewProperties"
       class="btn btn-ghost"
       style="width:100%;justify-content:center;margin-top:10px;display:flex;">Clear</a>
  </aside>

  <%-- ═══════════════ MAIN CONTENT ═══════════════ --%>
  <main class="props-main">
    <div class="props-header">
      <div>
        <h2>Available Properties</h2>
        <div class="result-count">
          <%
            boolean isFiltered = !fLocation.isEmpty() || !fBhk.isEmpty()
                               || !fMaxPrice.isEmpty() || !fPropertyType.isEmpty();
            if (isFiltered) {
              out.print("Showing " + shown + " of " + total + " listings");
            } else {
              out.print("Showing all " + shown + " listings");
            }
          %>
        </div>
      </div>

      <%-- Sort dropdown — submits the filter form with updated sort value --%>
      <select class="form-control" style="width:auto;" id="sortSelect"
              onchange="applySort(this.value)">
        <option value="newest" <%= "newest".equals(fSort) ? "selected" : "" %>>Sort: Newest First</option>
        <option value="low"    <%= "low".equals(fSort)    ? "selected" : "" %>>Price: Low to High</option>
        <option value="high"   <%= "high".equals(fSort)   ? "selected" : "" %>>Price: High to Low</option>
      </select>
    </div>

    <div class="props-grid">
    <%
    if (list != null && !list.isEmpty()) {
      for (Property p : list) {
        String firstImg = (p.getImages() != null && !p.getImages().isEmpty()) ? p.getImages().get(0) : null;
    %>
      <div class="property-card">
        <div class="card-image">
          <% if (firstImg != null) { %>
            <img src="<%= request.getContextPath() %>/images/<%= firstImg %>" alt="<%= p.getTitle() %>"/>
          <% } else { %>
            <div style="width:100%;height:100%;background:linear-gradient(135deg,var(--accent),var(--secondary));display:flex;align-items:center;justify-content:center;font-size:3rem;">🏠</div>
          <% } %>
          <div class="card-badge">For Sale</div>
        </div>
        <div class="card-body">
          <div class="card-price">₹ <%= String.format("%,.0f", (double)p.getPrice()) %></div>
          <div class="card-title"><%= p.getTitle() %></div>
          <div class="card-meta">
            <span>📍 <%= p.getLocation() %></span>
            <span>🛏 <%= p.getBhk() %> BHK</span>
          </div>
          <div class="card-actions">
            <button class="btn btn-outline btn-sm" onclick="loadDetails(<%= p.getId() %>)">Details</button>
            <form action="<%= request.getContextPath() %>/jsp/emi.jsp" method="get" style="flex:1;">
              <input type="hidden" name="price" value="<%= p.getPrice() %>"/>
              <button type="submit" class="btn btn-ghost btn-sm" style="width:100%;">EMI</button>
            </form>
          </div>
        </div>
        <div class="appt-form">
          <label>Book a Visit</label>
          <input type="datetime-local" id="apptDate_<%= p.getId() %>" required/>
          <button type="button" class="btn btn-primary btn-sm"
                  onclick="bookAppointment(<%= p.getId() %>)">Book Visit</button>
        </div>
      </div>
    <%
      }
    } else {
    %>
      <div style="grid-column:1/-1;text-align:center;padding:60px 0;color:var(--muted);">
        <div style="font-size:4rem;margin-bottom:16px;">⌕</div>
        <p>No properties match your filters. Try adjusting your search.</p>
        <a href="${pageContext.request.contextPath}/viewProperties"
           class="btn btn-primary" style="margin-top:16px;display:inline-flex;">Clear Filters</a>
      </div>
    <% } %>
    </div>

    <!-- DETAILS PANEL -->
    <div id="propertyDetails" class="details-panel">
      <button class="close-details" onclick="closeDetails()">✕</button>
      <h3 id="det-title">Property Details</h3>
      <div class="details-meta" id="det-meta"></div>
      <p id="det-desc" style="font-size:.9rem;color:var(--muted);margin-bottom:18px;"></p>
      <div class="details-images" id="det-images"></div>
      <div id="det-seller"></div>
    </div>
  </main>
</div>

<!-- LIGHTBOX -->
<div class="lightbox-overlay" id="lightbox" onclick="lbBgClose(event)">
  <button class="lb-close" onclick="closeLightbox()">✕</button>
  <div class="lightbox-img-wrap">
    <button class="lb-btn lb-prev" onclick="lbNav(-1)">&#8592;</button>
    <img id="lightboxImg" src="" alt="Property image"/>
    <button class="lb-btn lb-next" onclick="lbNav(1)">&#8594;</button>
  </div>
  <div class="lb-counter" id="lbCounter">1 / 1</div>
  <div class="lb-dots" id="lbDots"></div>
</div>

<!-- BOOKING SUCCESS POPUP -->
<div id="bookingPopup">
  <button onclick="document.getElementById('bookingPopup').style.display='none'"
    style="position:absolute;top:10px;right:12px;background:none;border:none;font-size:1rem;color:var(--muted);cursor:pointer;">✕</button>
  <div style="font-size:2rem;margin-bottom:8px;">📅</div>
  <div style="font-family:var(--font-display);font-size:1.05rem;font-weight:700;color:var(--dark);margin-bottom:4px;">Appointment Booked!</div>
  <div style="font-size:.85rem;color:var(--muted);">Your visit request has been sent to the seller.</div>
  <div id="bookingPopupBar"></div>
</div>

<script>
var contextPath = "<%= request.getContextPath() %>";
var lbImages = [];
var lbIndex  = 0;

/* ── Sort dropdown: update hidden field and re-submit filter form ── */
function applySort(val) {
    document.getElementById('hiddenSort').value = val;
    document.getElementById('filterForm').submit();
}

/* ── BOOK APPOINTMENT via AJAX ── */
function bookAppointment(propertyId) {
    var dateInput = document.getElementById('apptDate_' + propertyId);
    if (!dateInput || !dateInput.value) { alert('Please select a date and time.'); return; }
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
            if (xhr.status == 200) { dateInput.value = ''; showBookingPopup(); }
            else { alert('Booking failed. Please try again.'); }
        }
    };
    xhr.open("POST", contextPath + "/bookAppointment");
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.send("propertyId=" + propertyId + "&date=" + encodeURIComponent(dateInput.value));
}

function showBookingPopup() {
    var pop = document.getElementById('bookingPopup');
    pop.style.display = 'block';
    var bar = document.getElementById('bookingPopupBar');
    bar.style.animation = 'none'; bar.offsetHeight; bar.style.animation = '';
    setTimeout(function(){ pop.style.display = 'none'; }, 3500);
}

/* ── PROPERTY DETAILS with seller info ── */
function loadDetails(id) {
    fetch(contextPath + "/propertyDetails?id=" + id)
        .then(r => r.json())
        .then(data => {
            document.getElementById('det-title').textContent = data.title;
            document.getElementById('det-meta').innerHTML =
                '<div class="meta-item"><strong>₹ ' + Number(data.price).toLocaleString('en-IN') + '</strong>Price</div>' +
                '<div class="meta-item"><strong>' + esc(data.location) + '</strong>Location</div>' +
                '<div class="meta-item"><strong>' + esc(data.bhk) + ' BHK</strong>Bedrooms</div>';
            document.getElementById('det-desc').textContent = data.description || '';

            lbImages = [];
            var imgContainer = document.getElementById('det-images');
            imgContainer.innerHTML = '';
            (data.images || []).forEach((img, i) => {
                var parts = img.split('/');
                var fn  = encodeURIComponent(parts.pop());
                var src = contextPath + '/images/' + parts.join('/') + '/' + fn;
                lbImages.push(src);
                var el = document.createElement('img');
                el.src = src; el.alt = '';
                el.setAttribute('data-index', i);
                el.onclick = function(){ openLightbox(parseInt(this.getAttribute('data-index'))); };
                imgContainer.appendChild(el);
            });

            var sellerBox = document.getElementById('det-seller');
            if (data.sellerName) {
                sellerBox.innerHTML =
                    '<div class="seller-box">' +
                        '<div class="seller-avatar">' + esc(data.sellerName.charAt(0)) + '</div>' +
                        '<div>' +
                            '<div class="seller-info-label">Listed by</div>' +
                            '<div class="seller-info">' +
                                '<strong>' + esc(data.sellerName) + '</strong>' +
                                '<span>💌 ' + esc(data.sellerEmail) + '</span>' +
                                (data.sellerPhone ? '<br><span>🕻 ' + esc(data.sellerPhone) + '</span>' : '') +
                            '</div>' +
                        '</div>' +
                    '</div>';
            } else { sellerBox.innerHTML = ''; }

            var panel = document.getElementById('propertyDetails');
            panel.classList.add('visible');
            panel.scrollIntoView({ behavior: 'smooth', block: 'start' });
        })
        .catch(err => console.error(err));
}

function closeDetails() { document.getElementById('propertyDetails').classList.remove('visible'); }

/* ── LIGHTBOX ── */
function openLightbox(idx) { lbIndex = idx; lbRender(); document.getElementById('lightbox').classList.add('open'); document.body.style.overflow = 'hidden'; }
function closeLightbox()   { document.getElementById('lightbox').classList.remove('open'); document.body.style.overflow = ''; }
function lbBgClose(e) { if (e.target === document.getElementById('lightbox')) closeLightbox(); }
function lbNav(dir) { lbIndex = (lbIndex + dir + lbImages.length) % lbImages.length; lbRender(); }
function lbRender() {
    var img = document.getElementById('lightboxImg');
    img.style.opacity = '0';
    setTimeout(() => { img.src = lbImages[lbIndex]; img.style.opacity = '1'; }, 120);
    document.getElementById('lbCounter').textContent = (lbIndex + 1) + ' / ' + lbImages.length;
    var dotsEl = document.getElementById('lbDots');
    dotsEl.innerHTML = '';
    lbImages.forEach((_, i) => {
        var d = document.createElement('div');
        d.className = 'lb-dot' + (i === lbIndex ? ' active' : '');
        d.onclick = () => { lbIndex = i; lbRender(); };
        dotsEl.appendChild(d);
    });
}
document.addEventListener('keydown', e => {
    if (!document.getElementById('lightbox').classList.contains('open')) return;
    if (e.key === 'ArrowLeft')  lbNav(-1);
    if (e.key === 'ArrowRight') lbNav(1);
    if (e.key === 'Escape')     closeLightbox();
});

function esc(str) {
    if (!str && str !== 0) return '—';
    return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
</script>
</body>
</html>
