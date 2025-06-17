document.addEventListener("DOMContentLoaded", function () {
  const registerForm = document.getElementById("register-form");
  const loginForm = document.getElementById("login-form");
  const submissionForm = document.getElementById("submission-form");
  const logoutBtn = document.getElementById("logout-btn");
  const registerMessage = document.getElementById("register-message");
  const loginMessage = document.getElementById("login-message");
  const formMessage = document.getElementById("form-message");
  const usernameDisplay = document.getElementById("username");

  // Реєстрація
  if (registerForm) {
    registerForm.addEventListener("submit", async function (event) {
      event.preventDefault();
      const username = document.getElementById("username-input").value.trim();
      const password = document.getElementById("password-input").value.trim();

      registerMessage.textContent = "";
      registerMessage.classList.remove("text-success", "text-danger");

      if (!username || !password) {
        registerMessage.textContent = "Заповніть усі поля!";
        registerMessage.classList.add("text-danger");
        return;
      }

      try {
        const response = await fetch("/register", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ username, password }),
        });

        const data = await response.json();
        if (response.ok) {
          registerMessage.textContent = data.msg;
          registerMessage.classList.add("text-success");
          registerForm.reset();
          setTimeout(() => window.location.href = "/login", 1000);
        } else {
          registerMessage.textContent = data.detail || "Помилка реєстрації!";
          registerMessage.classList.add("text-danger");
        }
      } catch (error) {
        registerMessage.textContent = "Помилка мережі!";
        registerMessage.classList.add("text-danger");
      }
    });
  }

  // Логін
  if (loginForm) {
    loginForm.addEventListener("submit", async function (event) {
      event.preventDefault();
      const username = document.getElementById("username-input").value.trim();
      const password = document.getElementById("password-input").value.trim();

      loginMessage.textContent = "";
      loginMessage.classList.remove("text-success", "text-danger");

      if (!username || !password) {
        loginMessage.textContent = "Заповніть усі поля!";
        loginMessage.classList.add("text-danger");
        return;
      }

      try {
        const response = await fetch("/login", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: `username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}`,
        });

        const data = await response.json();
        if (response.ok) {
          loginMessage.textContent = "Вхід успішний!";
          loginMessage.classList.add("text-success");
          localStorage.setItem("token", data.access_token);
          setTimeout(() => window.location.href = "/profile", 1000);
        } else {
          loginMessage.textContent = data.detail || "Помилка входу!";
          loginMessage.classList.add("text-danger");
        }
      } catch (error) {
        loginMessage.textContent = "Помилка мережі!";
        loginMessage.classList.add("text-danger");
      }
    });
  }

  // Завантаження профілю
  if (usernameDisplay) {
    const token = localStorage.getItem("token");
    if (token) {
      fetch("/api/profile", {
        headers: {
          "Authorization": `Bearer ${token}`,
        },
      })
        .then(response => response.json())
        .then(data => {
          if (response.ok) {
            usernameDisplay.textContent = `Вітаємо, ${data.username}!`;
          } else {
            usernameDisplay.textContent = data.detail || "Помилка профілю!";
            usernameDisplay.classList.add("text-danger");
          }
        })
        .catch(() => {
          usernameDisplay.textContent = "Помилка мережі!";
          usernameDisplay.classList.add("text-danger");
        });
    } else {
      window.location.href = "/login";
    }
  }

  // Форма надсилання повідомлення
  if (submissionForm) {
    submissionForm.addEventListener("submit", async function (event) {
      event.preventDefault();
      const name = document.getElementById("name-input").value.trim();
      const email = document.getElementById("email-input").value.trim();
      const message = document.getElementById("message-input").value.trim();
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      formMessage.textContent = "";
      formMessage.classList.remove("text-success", "text-danger");

      if (!name || !emailRegex.test(email) || !message) {
        formMessage.textContent = "Заповніть усі поля коректно!";
        formMessage.classList.add("text-danger");
        return;
      }

      try {
        const response = await fetch("/api/submit", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ name, email, message }),
        });

        const data = await response.json();
        if (response.ok) {
          formMessage.textContent = data.message;
          formMessage.classList.add("text-success");
          submissionForm.reset();
        } else {
          formMessage.textContent = data.detail || "Помилка сервера!";
          formMessage.classList.add("text-danger");
        }
      } catch (error) {
        formMessage.textContent = "Помилка мережі!";
        formMessage.classList.add("text-danger");
      }
    });
  }

  // Вихід
  if (logoutBtn) {
    logoutBtn.addEventListener("click", function () {
      localStorage.removeItem("token");
      window.location.href = "/login";
    });
  }
});