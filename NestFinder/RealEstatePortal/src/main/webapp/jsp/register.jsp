<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- register.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Register — NestFinder</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
  <style>
    body { min-height: 100vh; display: flex; flex-direction: column; }

    .auth-wrapper {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
      min-height: 100vh;
    }

    .auth-visual {
      position: relative;
      background-image: url('https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=900');
      background-size: cover;
      background-position: center;
    }
    .auth-visual-overlay {
      position: absolute; inset: 0;
      background: linear-gradient(160deg,rgba(255,154,134,.85),rgba(44,44,44,.7));
      display: flex; flex-direction: column;
      justify-content: space-between; padding: 40px;
    }
    .auth-visual-brand {
      font-family: var(--font-display); font-size: 1.8rem;
      font-weight: 700; color: white;
    }
    .auth-visual-brand span { color: var(--accent); }
    .auth-visual-copy { color: white; }
    .auth-visual-copy h2 {
      font-family: var(--font-display); font-size: 2rem;
      line-height: 1.25; margin-bottom: 12px;
    }
    .auth-visual-copy p { color: rgba(255,255,255,.8); font-size: .95rem; }

    .auth-form-panel {
      display: flex; align-items: center;
      justify-content: center;
      padding: 60px 40px;
      background: var(--bg);
      overflow-y: auto;
    }

    .auth-card { width: 100%; max-width: 460px; }

    .auth-card .auth-header { margin-bottom: 32px; }
    .auth-card .auth-header h1 {
      font-family: var(--font-display); font-size: 2rem;
      color: var(--dark); margin-bottom: 8px;
    }
    .auth-card .auth-header p { color: var(--muted); font-size: .92rem; }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

    .role-selector { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
    .role-option { display: none; }
    .role-label {
      display: flex; flex-direction: column; align-items: center;
      gap: 8px; padding: 18px 12px;
      border: 2px solid var(--border);
      border-radius: var(--radius-md);
      cursor: pointer; transition: var(--transition);
      font-size: .88rem; font-weight: 500; color: var(--muted);
      background: var(--white);
    }
    .role-label .role-icon { font-size: 1.8rem; }
    .role-option:checked + .role-label {
      border-color: var(--primary);
      background: rgba(255,154,134,.08);
      color: var(--dark);
    }

    .auth-footer {
      text-align: center; margin-top: 24px;
      font-size: .88rem; color: var(--muted);
    }
    .auth-footer a { color: var(--primary); font-weight: 500; }
    .auth-footer a:hover { text-decoration: underline; }

    .field-error {
      color: #d00; font-size: .76rem;
      margin-top: 4px; display: none;
    }
    .field-error.show { display: block; }

    @media (max-width: 700px) {
      .auth-visual { display: none; }
      .auth-wrapper { grid-template-columns: 1fr; }
      .auth-form-panel { padding: 80px 24px 40px; }
      .form-row { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<div class="auth-wrapper">
  <div class="auth-visual">
    <div class="auth-visual-overlay">
      <a href="${pageContext.request.contextPath}/index.jsp" class="auth-visual-brand">Nest<span>Finder</span></a>
      <div class="auth-visual-copy">
        <h2>Start Your Real Estate Journey</h2>
        <p>Create an account to browse verified listings, connect with sellers, and book visits effortlessly.</p>
      </div>
    </div>
  </div>

  <div class="auth-form-panel">
    <div class="auth-card">
      <div class="auth-header">
        <h1>Create Account</h1>
        <p>Fill in your details to get started</p>
      </div>

      <form action="<%= request.getContextPath() %>/register" method="post"
            onsubmit="return validateForm()" novalidate>

        <div class="form-row">
          <div class="form-group">
            <label for="name">Full Name</label>
            <input class="form-control" type="text" name="name" id="name"
                   placeholder="Rahul Mehta" required/>
            <div class="field-error" id="nameErr"></div>
          </div>
          <div class="form-group">
            <label for="email">Email Address</label>
            <input class="form-control" type="email" name="email" id="email"
                   placeholder="you@email.com" required/>
            <div class="field-error" id="emailErr"></div>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="phone">Phone Number</label>
            <input class="form-control" type="tel" name="phone" id="phone"
                   placeholder="10-digit number" required/>
            <div class="field-error" id="phoneErr"></div>
          </div>
          <div class="form-group">
            <label for="dob">Date of Birth</label>
            <input class="form-control" type="date" name="dob" id="dob" required/>
            <div class="field-error" id="dobErr"></div>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="password">Password</label>
            <input class="form-control" type="password" name="password" id="password"
                   placeholder="Min 6 characters" required/>
            <div class="field-error" id="passErr"></div>
          </div>
          <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input class="form-control" type="password" id="confirmPassword"
                   placeholder="Repeat password" required/>
            <div class="field-error" id="confirmErr"></div>
          </div>
        </div>

        <div class="form-group">
          <label>I am a…</label>
          <div class="role-selector">
            <input type="radio" name="role" id="roleBuyer" value="buyer" class="role-option" checked/>
            <label for="roleBuyer" class="role-label">
              <span class="role-icon">🏠</span> Buyer
            </label>
            <input type="radio" name="role" id="roleSeller" value="seller" class="role-option"/>
            <label for="roleSeller" class="role-label">
              <span class="role-icon">🏗️</span> Seller
            </label>
          </div>
        </div>

        <div class="field-error" id="globalErr" style="margin-bottom:12px;font-size:.85rem;"></div>

        <button type="submit" class="btn btn-primary"
                style="width:100%;justify-content:center;padding:13px;">
          Create Account
        </button>

      </form>

      <div class="auth-footer">
        Already have an account? <a href="<%= request.getContextPath() %>/jsp/login.jsp">Sign in →</a>
      </div>
    </div>
  </div>
</div>

<script>
function showErr(id, msg) {
  const el = document.getElementById(id);
  el.textContent = msg;
  el.classList.add('show');
}
function clearErr(id) {
  const el = document.getElementById(id);
  el.textContent = '';
  el.classList.remove('show');
}
function clearAll() {
  ['nameErr','emailErr','phoneErr','dobErr','passErr','confirmErr','globalErr']
    .forEach(clearErr);
}

function validateForm() {
	  clearAll();

	  const name    = document.getElementById('name').value.trim();
	  const email   = document.getElementById('email').value.trim(); // ✅ added
	  const phone   = document.getElementById('phone').value.trim();
	  const dob     = document.getElementById('dob').value;
	  const pass    = document.getElementById('password').value;
	  const confirm = document.getElementById('confirmPassword').value;

	  let valid = true;

	  if (name.length < 3) {
	    showErr('nameErr', 'Name must be at least 3 characters'); 
	    valid = false;
	  }

	  // ✅ EMAIL VALIDATION
	  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	  if (!emailRegex.test(email)) {
	    showErr('emailErr', 'Enter a valid email (example: abc@gmail.com)');
	    valid = false;
	  }

	  if (!/^[0-9]{10}$/.test(phone)) {
	    showErr('phoneErr', 'Enter a valid 10-digit number'); 
	    valid = false;
	  }

	  if (dob) {
	    const today = new Date(), birth = new Date(dob);
	    if (birth > today) {
	      showErr('dobErr', 'DOB cannot be in the future'); 
	      valid = false;
	    } else {
	      let age = today.getFullYear() - birth.getFullYear();
	      const m = today.getMonth() - birth.getMonth();
	      if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) age--;
	      if (age < 18) { 
	        showErr('dobErr', 'You must be at least 18 years old'); 
	        valid = false; 
	      }
	    }
	  }

	  if (pass.length < 6) {
	    showErr('passErr', 'Password must be at least 6 characters'); 
	    valid = false;
	  }

	  if (pass !== confirm) {
	    showErr('confirmErr', 'Passwords do not match'); 
	    valid = false;
	  }

	  return valid;
	}
</script>
</body>
</html>
