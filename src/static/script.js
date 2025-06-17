document.addEventListener("DOMContentLoaded", function () {
  // Обробка кнопки привітання
  const button = document.getElementById("hello-btn");
  const greetingDiv = document.getElementById("greeting");
  button.addEventListener("click", function () {
    greetingDiv.textContent = "Привіт, користувачу!";
    greetingDiv.classList.add("text-success");
  });

  // Обробка форми та валідація email
  const form = document.getElementById("email-form");
  const emailInput = document.getElementById("email-input");
  const formMessage = document.getElementById("form-message");

  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    const email = emailInput.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    formMessage.textContent = "";
    formMessage.classList.remove("text-success", "text-danger");

    if (!emailRegex.test(email)) {
      formMessage.textContent = "Будь ласка, введіть коректний email!";
      formMessage.classList.add("text-danger");
      return;
    }

    try {
      const response = await fetch("/api/message", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ email: email }),
      });

      const data = await response.json();
      if (response.ok) {
        formMessage.textContent = data.message;
        formMessage.classList.add("text-success");
        emailInput.value = "";
      } else {
        formMessage.textContent = data.detail || "Помилка сервера!";
        formMessage.classList.add("text-danger");
      }
    } catch (error) {
      formMessage.textContent = "Помилка мережі!";
      formMessage.classList.add("text-danger");
    }
  });
});