<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- addProperty.jsp --%>
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
  <title>Add Property — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { padding-top: 68px; background: var(--bg); }

    .add-prop-wrapper {
      max-width: 820px;
      margin: 60px auto;
      padding: 0 24px 60px;
    }

    .page-label {
      font-size: .78rem; font-weight: 600; letter-spacing: 2px;
      text-transform: uppercase; color: var(--primary); margin-bottom: 8px;
    }

    .add-prop-wrapper h1 {
      font-family: var(--font-display);
      font-size: 2rem; margin-bottom: 6px;
    }

    .add-prop-wrapper > p { color: var(--muted); margin-bottom: 40px; }

    .form-card {
      background: var(--white);
      border-radius: var(--radius-lg);
      padding: 40px;
      box-shadow: var(--shadow-sm);
    }

    .form-section-title {
      font-family: var(--font-display);
      font-size: 1.1rem; margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 1px solid var(--border);
    }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

    /* Upload area */
    .upload-area {
      border: 2px dashed var(--border);
      border-radius: var(--radius-md);
      padding: 40px 24px;
      text-align: center;
      cursor: pointer;
      transition: var(--transition);
      background: var(--bg);
      position: relative;
    }
    .upload-area:hover { border-color: var(--primary); background: rgba(255,154,134,.05); }
    .upload-area input[type="file"] {
      position: absolute; inset: 0;
      opacity: 0; cursor: pointer; width: 100%; height: 100%;
    }
    .upload-icon { font-size: 2.5rem; margin-bottom: 12px; }
    .upload-area p { color: var(--muted); font-size: .9rem; margin: 0; }
    .upload-area strong { color: var(--primary); }

    /* Preview */
    #previewContainer {
      display: flex; flex-wrap: wrap; gap: 12px; margin-top: 16px;
    }
    .preview-img {
      width: 100px; height: 80px;
      object-fit: cover;
      border-radius: var(--radius-sm);
      border: 2px solid var(--border);
    }

    textarea.form-control { resize: vertical; min-height: 110px; }

    .form-actions { display: flex; gap: 12px; margin-top: 32px; flex-wrap: wrap; }
    .form-actions .btn { flex: 1; justify-content: center; min-width: 160px; padding: 13px; }

    /* ---- SUCCESS POPUP ---- */
    #successPopup {
      display: none;
      position: fixed;
      top: 88px; right: 28px;
      z-index: 2000;
      background: var(--white);
      border-radius: var(--radius-md);
      box-shadow: var(--shadow-lg);
      border-left: 4px solid var(--primary);
      padding: 20px 24px;
      min-width: 300px;
      max-width: 360px;
      animation: slideIn .35s cubic-bezier(.4,0,.2,1) both;
    }
    #successPopup .popup-icon {
      font-size: 2rem; margin-bottom: 8px;
    }
    #successPopup .popup-title {
      font-family: var(--font-display);
      font-size: 1.05rem; font-weight: 700;
      color: var(--dark); margin-bottom: 4px;
    }
    #successPopup .popup-msg {
      font-size: .85rem; color: var(--muted);
    }
    #successPopup .popup-close {
      position: absolute; top: 10px; right: 12px;
      background: none; border: none;
      font-size: 1rem; color: var(--muted);
      cursor: pointer; line-height: 1;
    }
    #successPopup .popup-bar {
      height: 3px;
      background: linear-gradient(90deg, var(--primary), var(--accent));
      border-radius: 2px;
      margin-top: 14px;
      animation: shrink 3s linear forwards;
    }
    @keyframes slideIn {
      from { opacity: 0; transform: translateX(30px); }
      to   { opacity: 1; transform: translateX(0); }
    }
    @keyframes shrink {
      from { width: 100%; }
      to   { width: 0%; }
    }

    @media (max-width: 600px) {
      .form-row { grid-template-columns: 1fr; }
      .form-card { padding: 28px 20px; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
    <li><a href="<%= request.getContextPath() %>/jsp/sellerHome.jsp">Dashboard</a></li>
    <li><a href="<%= request.getContextPath() %>/viewAppointments">Appointments</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="<%= request.getContextPath() %>/jsp/profile.jsp" class="btn btn-ghost btn-sm">Profile</a>
  </div>
</nav>

<div class="add-prop-wrapper">
  <div class="page-label">Seller Portal</div>
  <h1>Add New Property</h1>
  <p>Fill in the details below to list your property and reach thousands of buyers.</p>

  <div class="form-card">
    <form action="<%= request.getContextPath() %>/addProperty" method="post"
          enctype="multipart/form-data" novalidate>

      <div class="form-section-title">🏠 Property Details</div>

      <div class="form-group">
        <label for="title">Property Title</label>
        <input class="form-control" type="text" name="title" id="title"
               placeholder="e.g. Spacious 2 BHK in Baner" required/>
      </div>

      <div class="form-row">
        <div class="form-group">
          <label for="price">Price (₹)</label>
          <input class="form-control" type="number" name="price" id="price"
                 placeholder="e.g. 4500000" required/>
        </div>
        <div class="form-group">
          <label for="bhk">BHK</label>
          <select class="form-control" name="bhk" id="bhk" required>
            <option value="">Select BHK</option>
            <option value="1">1 BHK</option>
            <option value="2">2 BHK</option>
            <option value="3">3 BHK</option>
            <option value="4">4 BHK</option>
            <option value="5">5+ BHK</option>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label for="location">Location / Address</label>
        <input class="form-control" type="text" name="location" id="location"
               placeholder="e.g. Baner, Pune, Maharashtra" required/>
      </div>

      <div class="form-group">
        <label for="description">Description</label>
        <textarea class="form-control" name="description" id="description"
                  placeholder="Describe the property — amenities, nearby landmarks, condition…"></textarea>
      </div>

      <div style="margin-top: 8px;">
        <div class="form-section-title" style="margin-top:24px;">📷 Property Images</div>
        <div class="upload-area" id="uploadArea">
          <input type="file" name="images" id="imageInput" multiple accept="image/*"
                 onchange="previewImages(this)" required/>
          <div class="upload-icon">🖼️</div>
          <p><strong>Click to upload</strong> or drag and drop images</p>
          <p style="font-size:.78rem;margin-top:4px;">PNG, JPG, WEBP — up to 10 files</p>
        </div>
        <div id="previewContainer"></div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn btn-primary">Publish Property</button>
        <a href="<%= request.getContextPath() %>/jsp/sellerHome.jsp" class="btn btn-outline">Cancel</a>
      </div>

    </form>
  </div>
</div>

<!-- SUCCESS POPUP -->
<div id="successPopup">
  <button class="popup-close" onclick="document.getElementById('successPopup').style.display='none'">✕</button>
  <div class="popup-icon">🏠</div>
  <div class="popup-title">Property Published!</div>
  <div class="popup-msg">Your listing is now live and visible to buyers.</div>
  <div class="popup-bar" id="popupBar"></div>
</div>

<script>
function previewImages(input) {
  const container = document.getElementById('previewContainer');
  container.innerHTML = '';
  Array.from(input.files).forEach(file => {
    const reader = new FileReader();
    reader.onload = e => {
      const img = document.createElement('img');
      img.src = e.target.result;
      img.className = 'preview-img';
      container.appendChild(img);
    };
    reader.readAsDataURL(file);
  });
}

// Show popup when redirected back with ?success=1
const params = new URLSearchParams(window.location.search);
if (params.get('success') === '1') {
  const popup = document.getElementById('successPopup');
  popup.style.display = 'block';
  // Auto-hide after 3 s
  setTimeout(() => { popup.style.display = 'none'; }, 3000);
  // Clean URL
  window.history.replaceState({}, document.title, window.location.pathname);
}
</script>
</body>
</html>
