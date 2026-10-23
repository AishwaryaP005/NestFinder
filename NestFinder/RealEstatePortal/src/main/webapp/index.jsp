<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- index.jsp — Real Estate Portal Homepage --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>NestFinder — Real Estate Portal</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    html { scroll-behavior: smooth; }

    /* ---- HERO ---- */
    .hero {
      position: relative;
      height: 100vh;
      min-height: 580px;
      display: flex;
      align-items: center;
      overflow: hidden;
    }
    .hero-slides {
      position: absolute;
      inset: 0;
    }
    .hero-slide {
      position: absolute;
      inset: 0;
      background-size: cover;
      background-position: center;
      opacity: 0;
      transition: opacity 1.2s ease;
    }
    .hero-slide.active { opacity: 1; }
    .hero-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(120deg,rgba(44,44,44,.65) 0%,rgba(44,44,44,.18) 100%);
    }
    .hero-content {
      position: relative;
      z-index: 2;
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 48px;
      padding-top: 68px;
    }
    .hero-label {
      display: inline-block;
      background: var(--primary);
      color: white;
      font-size: .72rem;
      font-weight: 600;
      letter-spacing: 2px;
      text-transform: uppercase;
      padding: 5px 14px;
      border-radius: 20px;
      margin-bottom: 20px;
      animation: fadeUp .7s ease both;
    }
    .hero-title {
      font-family: var(--font-display);
      font-size: clamp(2.2rem, 5vw, 3.8rem);
      color: var(--white);
      line-height: 1.18;
      margin-bottom: 22px;
      max-width: 620px;
      animation: fadeUp .8s .1s ease both;
    }
    .hero-title span { color: var(--accent); }
    .hero-subtitle {
      color: rgba(255,255,255,.85);
      font-size: 1.05rem;
      max-width: 460px;
      margin-bottom: 36px;
      animation: fadeUp .8s .2s ease both;
    }
    .hero-btns {
      display: flex;
      gap: 14px;
      animation: fadeUp .8s .3s ease both;
    }
    .hero-stats {
      display: flex;
      gap: 36px;
      margin-top: 60px;
      animation: fadeUp .8s .45s ease both;
    }
    .hero-stat strong {
      display: block;
      font-family: var(--font-display);
      font-size: 1.9rem;
      color: var(--accent);
      font-weight: 700;
    }
    .hero-stat span {
      font-size: .8rem;
      color: rgba(255,255,255,.75);
    }
    .hero-dots {
      position: absolute;
      bottom: 32px;
      left: 50%;
      transform: translateX(-50%);
      z-index: 2;
      display: flex;
      gap: 8px;
    }
    .hero-dot {
      width: 8px; height: 8px;
      background: rgba(255,255,255,.4);
      border-radius: 50%;
      cursor: pointer;
      transition: var(--transition);
    }
    .hero-dot.active { background: var(--primary); width: 22px; border-radius: 4px; }

    /* ---- VIRTUAL TOUR ---- */
    .virtual-tour-wrapper {
      max-width: 1200px;
      margin: 60px auto 0;
      padding: 0 48px;
    }
    .virtual-tour-header {
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      margin-bottom: 28px;
      flex-wrap: wrap;
      gap: 12px;
    }
    .virtual-tour-header .view-all {
      color: var(--primary);
      font-size: .88rem;
      font-weight: 600;
      text-decoration: none;
    }
    .virtual-tour-header .view-all:hover { text-decoration: underline; }
    .tour-track {
      display: flex;
      gap: 20px;
      overflow-x: auto;
      padding-bottom: 12px;
      scroll-snap-type: x mandatory;
      scrollbar-width: thin;
      scrollbar-color: var(--primary) transparent;
    }
    .tour-card {
      min-width: 300px;
      flex-shrink: 0;
      border-radius: var(--radius-lg);
      overflow: hidden;
      background: var(--white);
      box-shadow: var(--shadow-sm);
      transition: var(--transition);
      cursor: pointer;
      scroll-snap-align: start;
      position: relative;
    }
    .tour-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-md); }
    .tour-thumb {
      position: relative;
      height: 190px;
      overflow: hidden;
      background: #1a1a2e;
    }
    .tour-thumb img {
      width: 100%; height: 100%;
      object-fit: cover;
      opacity: 0.85;
      transition: transform .4s ease;
    }
    .tour-card:hover .tour-thumb img { transform: scale(1.06); }
    .tour-play-btn {
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      width: 52px; height: 52px;
      background: var(--primary);
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      box-shadow: 0 4px 20px rgba(0,0,0,.35);
      transition: var(--transition);
    }
    .tour-card:hover .tour-play-btn {
      background: var(--secondary);
      transform: translate(-50%, -50%) scale(1.1);
    }
    .tour-play-btn svg {
      width: 20px; height: 20px;
      fill: white;
      margin-left: 3px;
    }
    .tour-badge {
      position: absolute;
      top: 12px; left: 12px;
      background: var(--primary);
      color: white;
      font-size: .68rem;
      font-weight: 700;
      letter-spacing: 1px;
      text-transform: uppercase;
      padding: 4px 10px;
      border-radius: 20px;
    }
    .tour-duration {
      position: absolute;
      bottom: 10px; right: 12px;
      background: rgba(0,0,0,.65);
      color: white;
      font-size: .75rem;
      font-weight: 600;
      padding: 3px 8px;
      border-radius: 4px;
    }
    .tour-body { padding: 16px 18px 18px; }
    .tour-body h4 {
      font-family: var(--font-display);
      font-size: 1rem;
      margin-bottom: 6px;
      line-height: 1.35;
      color: var(--text);
    }
    .tour-meta {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: .78rem;
      color: var(--muted);
    }
    .tour-meta span { display: flex; align-items: center; gap: 4px; }
    .tour-meta .dot { width: 3px; height: 3px; background: var(--muted); border-radius: 50%; }

    /* ---- TOUR MODAL ---- */
    .tour-modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,.82);
      z-index: 9999;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .tour-modal-overlay.open { display: flex; }
    .tour-modal {
      background: #000;
      border-radius: var(--radius-lg);
      overflow: hidden;
      width: 100%;
      max-width: 860px;
      position: relative;
    }
    .tour-modal-close {
      position: absolute;
      top: 14px; right: 14px;
      z-index: 10;
      background: rgba(255,255,255,.18);
      border: none;
      color: white;
      width: 36px; height: 36px;
      border-radius: 50%;
      font-size: 1.2rem;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      transition: var(--transition);
    }
    .tour-modal-close:hover { background: var(--primary); }
    .tour-modal iframe {
      width: 100%;
      aspect-ratio: 16/9;
      border: none;
      display: block;
    }

    /* ---- CTA CARDS ---- */
    .cta-cards { display: grid; grid-template-columns: 1fr 1fr; gap: 28px; }
    .cta-card {
      position: relative;
      border-radius: var(--radius-lg);
      overflow: hidden;
      height: 320px;
      cursor: pointer;
    }
    .cta-card img {
      width: 100%; height: 100%;
      object-fit: cover;
      transition: transform .45s ease;
    }
    .cta-card:hover img { transform: scale(1.06); }
    .cta-card-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(0deg, rgba(44,44,44,.75) 0%, transparent 55%);
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      padding: 28px;
    }
    .cta-card-overlay h3 {
      font-family: var(--font-display);
      font-size: 1.5rem;
      color: white;
      margin-bottom: 8px;
    }
    .cta-card-overlay p { color: rgba(255,255,255,.8); font-size: .88rem; margin-bottom: 16px; }

    /* ---- UPCOMING PROJECTS ---- */
    .project-slider-wrapper {
      position: relative;
      border-radius: var(--radius-lg);
      overflow: hidden;
      height: 380px;
    }
    .project-slide {
      position: absolute;
      inset: 0;
      background-size: cover;
      background-position: center;
      opacity: 0;
      transition: opacity 1s ease;
    }
    .project-slide.active { opacity: 1; }
    .project-info {
      position: absolute;
      bottom: 0; left: 0; right: 0;
      background: linear-gradient(0deg, rgba(44,44,44,.85) 0%, transparent 100%);
      padding: 32px;
      color: white;
    }
    .project-info h3 {
      font-family: var(--font-display);
      font-size: 1.5rem;
      margin-bottom: 6px;
    }
    .project-info p { font-size: .88rem; color: rgba(255,255,255,.8); }
    .project-nav {
      position: absolute;
      top: 50%; right: 20px;
      transform: translateY(-50%);
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .project-nav button {
      width: 10px; height: 10px;
      border-radius: 50%;
      border: none;
      background: rgba(255,255,255,.4);
      cursor: pointer;
      transition: var(--transition);
    }
    .blog-card { cursor: pointer; }
    .project-nav button.active { background: var(--primary); transform: scale(1.4); }

    /* ---- BLOG CARDS ---- */
    .blogs-track {
      display: flex;
      gap: 20px;
      overflow-x: auto;
      padding-bottom: 10px;
      scrollbar-width: thin;
      scrollbar-color: var(--primary) transparent;
    }
    .blog-card { min-width: 280px; flex-shrink: 0; background: var(--white); border-radius: var(--radius-md); overflow: hidden; transition: var(--transition); }
    .blog-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
    .blog-card .blog-img { height: 170px; overflow: hidden; }
    .blog-card .blog-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .4s; }
    .blog-card:hover .blog-img img { transform: scale(1.05); }
    .blog-card .blog-body { padding: 18px; }
    .blog-card .blog-tag {
      font-size: .7rem; font-weight: 600; text-transform: uppercase;
      letter-spacing: 1px; color: var(--primary); margin-bottom: 8px;
    }
    .blog-card .blog-body h4 {
      font-family: var(--font-display); font-size: 1.05rem;
      margin-bottom: 8px; line-height: 1.35;
    }
    .blog-card .blog-meta { font-size: .78rem; color: var(--muted); }

    /* ---- WHY CHOOSE US ---- */
    .why-card {
      background: var(--white);
      border-radius: var(--radius-md);
      padding: 32px 24px;
      text-align: center;
      box-shadow: var(--shadow-sm);
      transition: var(--transition);
    }
    .why-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-md); }
    .why-icon {
      width: 60px; height: 60px;
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border-radius: var(--radius-md);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 18px;
      font-size: 1.6rem;
    }
    .why-card h4 { font-family: var(--font-display); font-size: 1.1rem; margin-bottom: 10px; }
    .why-card p { font-size: .88rem; color: var(--muted); }

    /* ---- REVIEWS ---- */
    .reviews-track {
      display: flex;
      gap: 20px;
      overflow-x: auto;
      padding-bottom: 12px;
      scrollbar-width: thin;
      scrollbar-color: var(--primary) transparent;
    }
    .review-card {
      min-width: 280px;
      background: var(--white);
      border-radius: var(--radius-md);
      padding: 24px;
      box-shadow: var(--shadow-sm);
      flex-shrink: 0;
    }
    .review-stars { color: var(--primary); font-size: 1.1rem; margin-bottom: 12px; }
    .review-card p { font-size: .9rem; color: var(--muted); line-height: 1.6; margin-bottom: 16px; }
    .review-author { display: flex; align-items: center; gap: 12px; }
    .review-avatar {
      width: 40px; height: 40px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--primary), var(--accent));
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; color: white; font-size: .9rem;
    }
    .review-author-info strong { display: block; font-size: .88rem; }
    .review-author-info span { font-size: .78rem; color: var(--muted); }

    /* ---- FOOTER ---- */
    .footer-grid {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr 1fr;
      gap: 40px;
      text-align: left;
      padding-bottom: 40px;
      border-bottom: 1px solid rgba(255,255,255,.1);
      margin-bottom: 28px;
    }
    .footer-col h5 { color: white; font-size: .9rem; font-weight: 600; margin-bottom: 16px; }
    .footer-col ul { list-style: none; display: flex; flex-direction: column; gap: 10px; }
    .footer-col ul li a { color: rgba(255,255,255,.55); font-size: .85rem; }

    /* ---- KEYFRAMES ---- */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(20px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 900px) {
      .cta-cards { grid-template-columns: 1fr; }
      .footer-grid { grid-template-columns: 1fr 1fr; }
    }
    @media (max-width: 600px) {
      .hero-stats { gap: 20px; }
      .virtual-tour-wrapper { padding: 0 20px; }
      .hero-content { padding: 0 20px; padding-top: 88px; }
      .footer-grid { grid-template-columns: 1fr; }
      .tour-card { min-width: 260px; }
    }
  </style>
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">Nest<span>Finder</span></a>
  <ul class="navbar-links">
    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
    <li><a href="#about">About</a></li>
    <li><a href="#blogs">Blogs</a></li>
    <li><a href="#contact">Contact</a></li>
  </ul>
  <div class="navbar-cta">
    <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-outline btn-sm">Login</a>
    <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn btn-primary btn-sm">Register</a>
  </div>
</nav>

<!-- ===== HERO ===== -->
<section class="hero">
  <div class="hero-slides" id="heroSlides">
    <div class="hero-slide active" style="background-image:url('https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=1600')"></div>
    <div class="hero-slide" style="background-image:url('https://images.unsplash.com/photo-1507089947368-19c1da9775ae?w=1600')"></div>
    <div class="hero-slide" style="background-image:url('https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=1600')"></div>
  </div>
  <div class="hero-overlay"></div>
  <div class="hero-content">
    <div class="hero-label">✦ #1 Real Estate Platform</div>
    <h1 class="hero-title">Find Your <span>Perfect</span> Home Today</h1>
    <p class="hero-subtitle">Browse thousands of verified listings, connect with trusted sellers, and book visits effortlessly.</p>
    <div class="hero-btns">
      <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-primary btn-lg" onclick="this.href='${pageContext.request.contextPath}/jsp/login.jsp'">Explore Properties</a>
      <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="btn btn-lg" style="background:rgba(255,255,255,.15);color:white;border:1.5px solid rgba(255,255,255,.4)">List Your Property</a>
    </div>
    <div class="hero-stats">
      <div class="hero-stat"><strong>5K+</strong><span>Properties Listed</span></div>
      <div class="hero-stat"><strong>12K+</strong><span>Happy Buyers</span></div>
      <div class="hero-stat"><strong>98%</strong><span>Verified Listings</span></div>
    </div>
  </div>
  <div class="hero-dots" id="heroDots">
    <div class="hero-dot active"></div>
    <div class="hero-dot"></div>
    <div class="hero-dot"></div>
  </div>
</section>

<!-- ===== VIRTUAL TOUR ===== -->
<div class="virtual-tour-wrapper">
  <div class="virtual-tour-header">
    <div>
      <div class="section-label">Immersive Experience</div>
      <h2 class="section-title" style="margin-bottom:0">Virtual Property Tours</h2>
    </div>
  
  </div>

  <div class="tour-track">

    <!-- Tour Card 1 -->
    <div class="tour-card" onclick="openTour('cBKItGWe1F0')">
      <div class="tour-thumb">
        <img src="https://img.youtube.com/vi/cBKItGWe1F0/hqdefault.jpg" alt="Luxury Villa Tour"/>
        <span class="tour-badge">🏡 Villa</span>
        <div class="tour-play-btn">
          <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
        </div>
        <span class="tour-duration">3:45</span>
      </div>
      <div class="tour-body">
        <h4>Luxury Villa — Panoramic Tour</h4>
        <div class="tour-meta">
          <span>📍 Pune</span>
          <span class="dot"></span>
          <span>4 BHK</span>
          <span class="dot"></span>
          <span>₹1.2 Cr</span>
        </div>
      </div>
    </div>

    <!-- Tour Card 2 -->
    <div class="tour-card" onclick="openTour('33iSe5xBZVA')">
      <div class="tour-thumb">
        <img src="https://img.youtube.com/vi/33iSe5xBZVA/hqdefault.jpg" alt="Modern Apartment Tour"/>
        <span class="tour-badge">🏢 Apartment</span>
        <div class="tour-play-btn">
          <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
        </div>
        <span class="tour-duration">4:12</span>
      </div>
      <div class="tour-body">
        <h4>Modern Apartment — 3D Walkthrough</h4>
        <div class="tour-meta">
          <span>📍 Mumbai</span>
          <span class="dot"></span>
          <span>2 BHK</span>
          <span class="dot"></span>
          <span>₹85 L</span>
        </div>
      </div>
    </div>

    <!-- Tour Card 3 -->
    <div class="tour-card" onclick="openTour('FQ5VXOfavcM')">
      <div class="tour-thumb">
        <img src="https://img.youtube.com/vi/FQ5VXOfavcM/hqdefault.jpg" alt="Premium Flat Tour"/>
        <span class="tour-badge">✨ Premium</span>
        <div class="tour-play-btn">
          <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
        </div>
        <span class="tour-duration">5:20</span>
      </div>
      <div class="tour-body">
        <h4>Premium Flat — Interior Showcase</h4>
        <div class="tour-meta">
          <span>📍 Bangalore</span>
          <span class="dot"></span>
          <span>3 BHK</span>
          <span class="dot"></span>
          <span>₹95 L</span>
        </div>
      </div>
    </div>

    <!-- Tour Card 4 -->
    <div class="tour-card" onclick="openTour('2Vo7xfYQYhg')">
      <div class="tour-thumb">
        <img src="https://img.youtube.com/vi/2Vo7xfYQYhg/hqdefault.jpg" alt="Penthouse Tour"/>
        <span class="tour-badge">👑 Penthouse</span>
        <div class="tour-play-btn">
          <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
        </div>
        <span class="tour-duration">6:05</span>
      </div>
      <div class="tour-body">
        <h4>Skyline Penthouse — Full Tour</h4>
        <div class="tour-meta">
          <span>📍 Delhi</span>
          <span class="dot"></span>
          <span>5 BHK</span>
          <span class="dot"></span>
          <span>₹3.5 Cr</span>
        </div>
      </div>
    </div>

    <!-- Tour Card 5 -->
    <div class="tour-card" onclick="openTour('QL2BkxKGtK8')">
      <div class="tour-thumb">
        <img src="https://img.youtube.com/vi/QL2BkxKGtK8/hqdefault.jpg" alt="Budget Home Tour"/>
        <span class="tour-badge">💰 Budget Pick</span>
        <div class="tour-play-btn">
          <svg viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
        </div>
        <span class="tour-duration">3:58</span>
      </div>
      <div class="tour-body">
        <h4>Smart Budget Home — Complete Tour</h4>
        <div class="tour-meta">
          <span>📍 Hyderabad</span>
          <span class="dot"></span>
          <span>2 BHK</span>
          <span class="dot"></span>
          <span>₹42 L</span>
        </div>
      </div>
    </div>

  </div>
</div>

<!-- ===== TOUR MODAL ===== -->
<div class="tour-modal-overlay" id="tourModal" onclick="closeTourOnOverlay(event)">
  <div class="tour-modal">
    <button class="tour-modal-close" onclick="closeTour()">✕</button>
    <iframe id="tourIframe" src="" allow="autoplay; encrypted-media" allowfullscreen></iframe>
  </div>
</div>

<!-- ===== START YOUR JOURNEY ===== -->
<div style="max-width:1200px;margin:72px auto 0;padding:0 48px;">
  <div style="text-align:center;margin-bottom:40px;">
    <div class="section-label">Get Started</div>
    <h2 class="section-title">Start Your Journey</h2>
    <p class="section-subtitle" style="margin:0 auto;">Whether you're looking to buy your dream home or list a property for sale, we make it simple.</p>
  </div>
  <div class="cta-cards">
    <div class="cta-card" onclick="window.location='${pageContext.request.contextPath}/jsp/login.jsp'">
      <img src="https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800" alt="Explore Properties"/>
      <div class="cta-card-overlay">
        <h3>Explore Properties</h3>
        <p>Find verified homes, villas & plots tailored to your budget.</p>
        <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-primary btn-sm">Browse Now →</a>
      </div>
    </div>
    <div class="cta-card" onclick="window.location='${pageContext.request.contextPath}/jsp/login.jsp'">
      <img src="https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800" alt="Sell Properties"/>
      <div class="cta-card-overlay">
        <h3>Sell Your Property</h3>
        <p>List your property and connect with thousands of buyers instantly.</p>
        <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="btn btn-primary btn-sm">List Now →</a>
      </div>
    </div>
  </div>
</div>

<!-- ===== UPCOMING PROJECTS ===== -->
<div style="max-width:1200px;margin:80px auto 0;padding:0 48px;">
  <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:32px;flex-wrap:wrap;gap:12px;">
    <div>
      <div class="section-label">Coming Soon</div>
      <h2 class="section-title" style="margin-bottom:0">Upcoming Projects</h2>
    </div>
   <a href="${pageContext.request.contextPath}/jsp/login.jsp">View All Projects</a>
  </div>
  <div class="project-slider-wrapper">
    <div class="project-slide active" style="background-image:url('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200')"></div>
    <div class="project-slide" style="background-image:url('https://images.unsplash.com/photo-1582407947304-fd86f028f716?w=1200')"></div>
    <div class="project-info">
      <h3>Skyline Residences – Phase II</h3>
      <p>📍 Pune, Maharashtra &nbsp;|&nbsp; Possession: Dec 2025 &nbsp;|&nbsp; Starts ₹45L</p>
    </div>
    <div class="project-nav" id="projectNav">
      <button class="active"></button>
      <button></button>
    </div>
  </div>
</div>

<!-- ===== BLOGS ===== -->
<div id="blogs" style="max-width:1200px;margin:80px auto 0;padding:0 48px;">
  <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:32px;flex-wrap:wrap;gap:12px;">
    <div>
      <div class="section-label">Insights</div>
      <h2 class="section-title" style="margin-bottom:0">Real Estate Blogs</h2>
    </div>
  </div>
  <div class="blogs-track">

  <div class="blog-card" onclick="openBlog('https://www.confident-group.com/blog/villa-vs-apartment-which-is-better/')">
    <div class="blog-img"><img src="https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=600"></div>
    <div class="blog-body">
      <div class="blog-tag">Buying Guide</div>
      <h4>Villa vs Apartment — Which is Better?</h4>
      <div class="blog-meta">5 min read</div>
    </div>
  </div>

  <div class="blog-card" onclick="openBlog('https://www.confident-group.com/blog/confident-fantasy-serene-creekside-luxury-smartly-priced/')">
    <div class="blog-img"><img src="https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=600"></div>
    <div class="blog-body">
      <div class="blog-tag">Luxury</div>
      <h4>Smart Luxury Living — Creekside Homes</h4>
      <div class="blog-meta">6 min read</div>
    </div>
  </div>

  <div class="blog-card" onclick="openBlog('https://www.confident-group.com/blog/apartments-in-growing-cities-roi/')">
    <div class="blog-img"><img src="https://images.unsplash.com/photo-1604014237800-1c9102c219da?w=600"></div>
    <div class="blog-body">
      <div class="blog-tag">Investment</div>
      <h4>Apartments in Growing Cities — ROI Guide</h4>
      <div class="blog-meta">7 min read</div>
    </div>
  </div>

  <div class="blog-card" onclick="openBlog('https://www.confident-group.com/blog/tdr-in-real-estate/')">
    <div class="blog-img"><img src="https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600"></div>
    <div class="blog-body">
      <div class="blog-tag">Legal</div>
      <h4>What is TDR in Real Estate?</h4>
      <div class="blog-meta">4 min read</div>
    </div>
  </div>

  <div class="blog-card" onclick="openBlog('https://www.confident-group.com/blog/what-is-built-up-area/')">
    <div class="blog-img"><img src="https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=600"></div>
    <div class="blog-body">
      <div class="blog-tag">Basics</div>
      <h4>Understanding Built-up Area</h4>
      <div class="blog-meta">3 min read</div>
    </div>
  </div>

</div>
</div>

<!-- ===== WHY CHOOSE US ===== -->
<div id="about" style="background:linear-gradient(135deg,rgba(255,214,166,.25),rgba(255,240,190,.6));margin-top:80px;padding:80px 0;">
  <div style="max-width:1200px;margin:0 auto;padding:0 48px;text-align:center;">
    <div class="section-label">Our Promise</div>
    <h2 class="section-title">Why Choose NestFinder?</h2>
    <p class="section-subtitle" style="margin:0 auto 48px;">We combine technology, transparency, and trust to make your real estate journey smooth and rewarding.</p>
    <div class="grid-3">
      <div class="why-card">
        <div class="why-icon">✪</div>
        <h4>Trusted Platform</h4>
        <p>Over 12,000 happy buyers and sellers have found their perfect match through NestFinder.</p>
      </div>
      <div class="why-card">
        <div class="why-icon">❤︎</div>
        <h4>Verified Listings</h4>
        <p>Every listing is manually verified by our team to ensure authenticity and accuracy.</p>
      </div>
      <div class="why-card">
        <div class="why-icon">🏠︎</div>
        <h4>Easy Booking</h4>
        <p>Book site visits with a single click and chat directly with sellers in real-time.</p>
      </div>
    </div>
  </div>
</div>

<!-- ===== REVIEWS ===== -->
<div style="max-width:1200px;margin:80px auto 0;padding:0 48px;">
  <div class="section-label">What They Say</div>
  <h2 class="section-title">User Reviews</h2>
  <div class="reviews-track">
    <div class="review-card">
      <div class="review-stars">★★★★★</div>
      <p>"Found my dream apartment within 2 weeks. The real-time chat with the seller was a game changer!"</p>
      <div class="review-author">
        <div class="review-avatar">R</div>
        <div class="review-author-info"><strong>Rahul Mehta</strong><span>Buyer, Pune</span></div>
      </div>
    </div>
    <div class="review-card">
      <div class="review-stars">★★★★★</div>
      <p>"Listed my property and got inquiries within hours. The platform is incredibly easy to use."</p>
      <div class="review-author">
        <div class="review-avatar">P</div>
        <div class="review-author-info"><strong>Priya Sharma</strong><span>Seller, Mumbai</span></div>
      </div>
    </div>
    <div class="review-card">
      <div class="review-stars">★★★★☆</div>
      <p>"The EMI calculator helped me plan my budget perfectly. Highly recommended for first-time buyers!"</p>
      <div class="review-author">
        <div class="review-avatar">A</div>
        <div class="review-author-info"><strong>Anjali Desai</strong><span>Buyer, Bangalore</span></div>
      </div>
    </div>
    <div class="review-card">
      <div class="review-stars">★★★★★</div>
      <p>"Very transparent process. Appointment booking was smooth and the seller was great to talk to."</p>
      <div class="review-author">
        <div class="review-avatar">V</div>
        <div class="review-author-info"><strong>Vikram Patel</strong><span>Buyer, Ahmedabad</span></div>
      </div>
    </div>
    <div class="review-card">
      <div class="review-stars">★★★★★</div>
      <p>"Best real estate portal I've used. Clean UI, no clutter, and all info is accurate and up-to-date."</p>
      <div class="review-author">
        <div class="review-avatar">S</div>
        <div class="review-author-info"><strong>Sneha Kapoor</strong><span>Seller, Delhi</span></div>
      </div>
    </div>
  </div>
</div>

<!-- ===== FOOTER ===== -->
<footer id="contact" style="margin-top:80px;">
  <div style="max-width:1200px;margin:0 auto;">
    <div class="footer-grid">
      <div class="footer-col">
        <div class="footer-brand">Nest<span>Finder</span></div>
        <p style="font-size:.85rem;line-height:1.7;max-width:260px;">Your trusted partner in finding the perfect home. Real estate made simple, transparent, and enjoyable.</p>
      </div>
      <div class="footer-col">
        <h5>Quick Links</h5>
        <ul>
          <li><a href="#">Home</a></li>
          <li><a href="#about">About Us</a></li>
          <li><a href="#blogs">Blogs</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h5>For Users</h5>
        <ul>
          <li><a href="${pageContext.request.contextPath}/jsp/login.jsp">Login</a></li>
          <li><a href="${pageContext.request.contextPath}/jsp/register.jsp">Register</a></li>
          <li><a href="${pageContext.request.contextPath}/jsp/emi.jsp">EMI Calculator</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h5>Contact</h5>
        <ul>
          <li><a href="#">support@nestfinder.in</a></li>
          <li><a href="#">+91 98765 43210</a></li>
          <li><a href="#">Pune, Maharashtra</a></li>
        </ul>
      </div>
    </div>
    <p style="font-size:.8rem;color:rgba(255,255,255,.4);">All rights reserved.</p>
  </div>
</footer>

<script>
// Hero slider
const heroSlides = document.querySelectorAll('.hero-slide');
const heroDots   = document.querySelectorAll('.hero-dot');
let heroIdx = 0;

setInterval(() => {
  heroSlides[heroIdx].classList.remove('active');
  heroDots[heroIdx].classList.remove('active');
  heroIdx = (heroIdx + 1) % heroSlides.length;
  heroSlides[heroIdx].classList.add('active');
  heroDots[heroIdx].classList.add('active');
}, 4000);

heroDots.forEach((dot, i) => {
  dot.addEventListener('click', () => {
    heroSlides[heroIdx].classList.remove('active');
    heroDots[heroIdx].classList.remove('active');
    heroIdx = i;
    heroSlides[i].classList.add('active');
    heroDots[i].classList.add('active');
  });
});

// Project slider
const projSlides = document.querySelectorAll('.project-slide');
const projBtns   = document.querySelectorAll('.project-nav button');
let pIdx = 0;

const projectInfo = [
  { title: 'Skyline Residences – Phase II', sub: '📍 Pune, Maharashtra &nbsp;|&nbsp; Possession: Dec 2025 &nbsp;|&nbsp; Starts ₹45L' },
  { title: 'Green Valley Villas', sub: '📍 Bangalore, Karnataka &nbsp;|&nbsp; Possession: Mar 2026 &nbsp;|&nbsp; Starts ₹85L' }
];

function setProject(i) {
  projSlides[pIdx].classList.remove('active');
  projBtns[pIdx].classList.remove('active');
  pIdx = i;
  projSlides[i].classList.add('active');
  projBtns[i].classList.add('active');
  document.querySelector('.project-info h3').textContent = projectInfo[i].title;
  document.querySelector('.project-info p').innerHTML  = projectInfo[i].sub;
}

setInterval(() => setProject((pIdx + 1) % projSlides.length), 4500);
projBtns.forEach((b, i) => b.addEventListener('click', () => setProject(i)));

// Blog open
function openBlog(url) {
  window.open(url, '_blank');
}

// Virtual Tour Modal
function openTour(videoId) {
  const modal = document.getElementById('tourModal');
  const iframe = document.getElementById('tourIframe');
  iframe.src = 'https://www.youtube.com/embed/' + videoId + '?autoplay=1&rel=0';
  modal.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeTour() {
  const modal = document.getElementById('tourModal');
  const iframe = document.getElementById('tourIframe');
  iframe.src = '';
  modal.classList.remove('open');
  document.body.style.overflow = '';
}

function closeTourOnOverlay(e) {
  if (e.target === document.getElementById('tourModal')) {
    closeTour();
  }
}

// Close modal on Escape key
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') closeTour();
});
</script>
</body>
</html>


