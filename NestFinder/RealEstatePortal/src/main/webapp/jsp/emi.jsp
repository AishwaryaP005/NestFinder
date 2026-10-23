<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- emi.jsp — EMI Calculator --%>
<%
String price = request.getParameter("price");
Double emi   = (Double) request.getAttribute("emi");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>EMI Calculator — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { padding-top: 68px; background: var(--bg); min-height: 100vh; }

    .emi-wrapper {
      max-width: 960px;
      margin: 60px auto;
      padding: 0 24px 60px;
    }

    .page-label { font-size: .78rem; font-weight: 600; letter-spacing: 2px; text-transform: uppercase; color: var(--primary); margin-bottom: 8px; }

    .emi-wrapper > h1 {
      font-family: var(--font-display); font-size: 2rem; margin-bottom: 6px;
    }
    .emi-wrapper > p { color: var(--muted); margin-bottom: 40px; }

    .emi-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 28px;
      align-items: start;
    }

    .emi-form-card {
      background: var(--white);
      border-radius: var(--radius-lg);
      padding: 36px;
      box-shadow: var(--shadow-sm);
    }

    .emi-form-card h3 {
      font-family: var(--font-display); font-size: 1.2rem; margin-bottom: 24px;
    }

    /* Range slider styling */
    .range-group { margin-bottom: 24px; }
    .range-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 8px; }
    .range-header label { font-size: .85rem; font-weight: 500; }
    .range-header .range-val {
      font-family: var(--font-display); font-size: 1.1rem;
      font-weight: 700; color: var(--primary);
    }
    input[type="range"] {
      width: 100%;
      -webkit-appearance: none;
      height: 5px;
      border-radius: 3px;
      background: linear-gradient(to right, var(--primary) 0%, var(--primary) var(--pct, 50%), var(--border) var(--pct, 50%));
      outline: none;
      cursor: pointer;
    }
    input[type="range"]::-webkit-slider-thumb {
      -webkit-appearance: none;
      width: 20px; height: 20px;
      border-radius: 50%;
      background: var(--primary);
      border: 3px solid white;
      box-shadow: 0 2px 8px rgba(255,154,134,.5);
      cursor: pointer;
    }
    input[type="range"]::-moz-range-thumb {
      width: 20px; height: 20px;
      border-radius: 50%;
      background: var(--primary);
      border: 3px solid white;
      cursor: pointer;
    }

    .emi-form-card .btn {
      width: 100%; justify-content: center; padding: 13px; margin-top: 8px;
    }

    /* Result card */
    .emi-result-card {
      background: linear-gradient(135deg, var(--primary), var(--secondary));
      border-radius: var(--radius-lg);
      padding: 36px;
      color: white;
    }

    .emi-result-card h3 {
      font-family: var(--font-display); font-size: 1.2rem; margin-bottom: 28px;
      opacity: .9;
    }

    .emi-result-empty {
      text-align: center; padding: 20px 0;
      opacity: .7;
    }
    .emi-result-empty .empty-icon { font-size: 3rem; margin-bottom: 12px; }
    .emi-result-empty p { font-size: .9rem; }

    .emi-amount {
      text-align: center;
      margin-bottom: 32px;
    }
    .emi-amount .label { font-size: .8rem; opacity: .8; margin-bottom: 6px; }
    .emi-amount .amount {
      font-family: var(--font-display);
      font-size: 3rem; font-weight: 700;
      line-height: 1;
    }
    .emi-amount .sub { font-size: .82rem; opacity: .7; margin-top: 4px; }

    .emi-breakdown {
      display: flex; flex-direction: column; gap: 14px;
    }
    .breakdown-row {
      display: flex; justify-content: space-between; align-items: center;
      padding: 12px 16px;
      background: rgba(255,255,255,.15);
      border-radius: var(--radius-sm);
    }
    .breakdown-row .br-label { font-size: .85rem; opacity: .85; }
    .breakdown-row .br-val { font-weight: 600; font-size: .95rem; }

    /* Bar chart */
    .emi-bar { margin-top: 24px; }
    .emi-bar .bar-label { font-size: .75rem; opacity: .7; margin-bottom: 6px; }
    .bar-track {
      height: 10px; background: rgba(255,255,255,.25);
      border-radius: 5px; overflow: hidden;
    }
    .bar-fill { height: 100%; background: white; border-radius: 5px; transition: width 1s ease; }

    /* Tips card */
    .tips-card {
      background: var(--white);
      border-radius: var(--radius-lg);
      padding: 28px 36px;
      box-shadow: var(--shadow-sm);
      margin-top: 28px;
      grid-column: 1 / -1;
    }
    .tips-card h4 { font-family: var(--font-display); font-size: 1.1rem; margin-bottom: 18px; }
    .tips-list { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
    .tip-item { display: flex; gap: 12px; align-items: flex-start; }
    .tip-icon { font-size: 1.5rem; flex-shrink: 0; }
    .tip-item p { font-size: .84rem; color: var(--muted); }

    @media (max-width: 700px) {
      .emi-grid { grid-template-columns: 1fr; }
      .tips-list { grid-template-columns: 1fr; }
      .emi-form-card, .emi-result-card { padding: 28px 20px; }
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
    <a href="javascript:history.back()" class="btn btn-ghost btn-sm">← Back</a>
  </div>
</nav>

<div class="emi-wrapper">
  <div class="page-label">Financial Tool</div>
  <h1>₹ EMI Calculator</h1>
  <p>Estimate your monthly home loan installment instantly.</p>

  <div class="emi-grid">

    <!-- FORM -->
    <div class="emi-form-card">
      <h3>Loan Details</h3>
      <form action="<%= request.getContextPath() %>/calculateEMI" method="post" id="emiForm">

        <div class="range-group">
          <div class="range-header">
            <label>Loan Amount</label>
            <span class="range-val" id="loanDisplay">₹<span id="loanVal">5000000</span></span>
          </div>
          <input type="range" name="loan" id="loanRange" min="500000" max="50000000" step="100000"
                 value="<%= price != null ? price : "5000000" %>"
                 oninput="updateRange(this,'loanVal',formatINR)"/>
        </div>

        <div class="range-group">
          <div class="range-header">
            <label>Interest Rate</label>
            <span class="range-val"><span id="rateVal">8.5</span>% p.a.</span>
          </div>
          <input type="range" name="rate" id="rateRange" min="5" max="20" step="0.1" value="8.5"
                 oninput="updateRange(this,'rateVal',v=>parseFloat(v).toFixed(1))"/>
        </div>

        <div class="range-group">
          <div class="range-header">
            <label>Tenure</label>
            <span class="range-val"><span id="tenureVal">240</span> months</span>
          </div>
          <input type="range" name="tenure" id="tenureRange" min="12" max="360" step="12" value="240"
                 oninput="updateRange(this,'tenureVal',v=>v)"/>
        </div>

        <!-- Hidden inputs synced for backend -->
        <input type="hidden" id="loanHidden" name="loan"   value="<%= price != null ? price : "5000000" %>"/>
        <input type="hidden" id="rateHidden" name="rate"   value="8.5"/>
        <input type="hidden" id="tenureHidden" name="tenure" value="240"/>

        <button type="button" class="btn btn-primary" onclick="calculatePreview()">Calculate EMI</button>
       <!--  <button type="submit" class="btn btn-ghost" style="margin-top:8px;">Submit to Server</button> -->
      </form>
    </div>

    <!-- RESULT -->
    <div class="emi-result-card">
      <h3>Your EMI Breakdown:</h3>

      <%-- Server-side result --%>
      <% if (emi != null) { %>
        <div class="emi-amount">
          <div class="label">Monthly EMI</div>
          <div class="amount">₹<%= String.format("%,.0f", emi) %></div>
          <div class="sub">per month</div>
        </div>
        <div class="emi-breakdown" id="breakdown">
          <div class="breakdown-row">
            <span class="br-label">Principal Amount</span>
            <span class="br-val">₹<%= price != null ? String.format("%,.0f", Double.parseDouble(price)) : "—" %></span>
          </div>
          <div class="breakdown-row">
            <span class="br-label">Total Interest</span>
            <span class="br-val" id="totalInterest">—</span>
          </div>
          <div class="breakdown-row">
            <span class="br-label">Total Payment</span>
            <span class="br-val" id="totalPayment">—</span>
          </div>
        </div>
      <% } else { %>
        <div class="emi-result-empty" id="resultPlaceholder">
          <div class="empty-icon">$</div>
          <p>Adjust the sliders and click <strong>Calculate EMI</strong> to see your monthly installment.</p>
        </div>
        <div id="liveResult" style="display:none;">
          <div class="emi-amount">
            <div class="label">Monthly EMI</div>
            <div class="amount" id="liveEMI">₹0</div>
            <div class="sub">per month</div>
          </div>
          <div class="emi-breakdown">
            <div class="breakdown-row">
              <span class="br-label">Principal</span>
              <span class="br-val" id="livePrincipal">₹0</span>
            </div>
            <div class="breakdown-row">
              <span class="br-label">Total Interest</span>
              <span class="br-val" id="liveInterest">₹0</span>
            </div>
            <div class="breakdown-row">
              <span class="br-label">Total Payment</span>
              <span class="br-val" id="liveTotal">₹0</span>
            </div>
          </div>
          <div class="emi-bar" style="margin-top:20px;">
            <div class="bar-label">Principal / Interest ratio</div>
            <div class="bar-track">
              <div class="bar-fill" id="principalBar" style="width:50%"></div>
            </div>
          </div>
        </div>
      <% } %>
    </div>

    <!-- TIPS -->
    <div class="tips-card">
      <h4>🌟 Home Loan Tips</h4>
      <div class="tips-list">
        <div class="tip-item">
          <div class="tip-icon"></div>
          <p>A higher down payment reduces your EMI significantly. Aim for at least 20%.</p>
        </div>
        <div class="tip-item">
          <div class="tip-icon"></div>
          <p>Shorter tenure means higher EMI but much less total interest paid overall.</p>
        </div>
        <div class="tip-item">
          <div class="tip-icon"></div>
          <p>Compare rates from multiple lenders. Even 0.5% difference saves lakhs long-term.</p>
        </div>
      </div>
    </div>

  </div>
</div>

<script>
// Format helpers
function formatINR(v) {
  return parseInt(v).toLocaleString('en-IN');
}

function updateRange(input, displayId, formatter) {
  const val = input.value;
  const pct = ((val - input.min) / (input.max - input.min)) * 100;
  input.style.setProperty('--pct', pct + '%');
  document.getElementById(displayId).textContent = formatter(val);

  // Sync hidden inputs
  if (input.id === 'loanRange')   document.getElementById('loanHidden').value   = val;
  if (input.id === 'rateRange')   document.getElementById('rateHidden').value   = val;
  if (input.id === 'tenureRange') document.getElementById('tenureHidden').value = val;
}

function calculatePreview() {
  const P = parseFloat(document.getElementById('loanRange').value);
  const r = parseFloat(document.getElementById('rateRange').value) / 12 / 100;
  const n = parseInt(document.getElementById('tenureRange').value);

  const emi   = P * r * Math.pow(1+r,n) / (Math.pow(1+r,n) - 1);
  const total = emi * n;
  const interest = total - P;
  const principalPct = (P / total * 100).toFixed(1);

  document.getElementById('liveEMI').textContent      = '₹' + Math.round(emi).toLocaleString('en-IN');
  document.getElementById('livePrincipal').textContent = '₹' + Math.round(P).toLocaleString('en-IN');
  document.getElementById('liveInterest').textContent  = '₹' + Math.round(interest).toLocaleString('en-IN');
  document.getElementById('liveTotal').textContent     = '₹' + Math.round(total).toLocaleString('en-IN');
  document.getElementById('principalBar').style.width = principalPct + '%';

  document.getElementById('resultPlaceholder').style.display = 'none';
  document.getElementById('liveResult').style.display        = 'block';
}

// Init slider visuals
['loanRange','rateRange','tenureRange'].forEach(id => {
  const el = document.getElementById(id);
  if (el) {
    const pct = ((el.value - el.min) / (el.max - el.min)) * 100;
    el.style.setProperty('--pct', pct + '%');
  }
});

// Init display for loan if price was passed
const lr = document.getElementById('loanRange');
if (lr) document.getElementById('loanVal').textContent = formatINR(lr.value);
</script>
</body>
</html>
