document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("submission-form");
  const nameInput = document.getElementById("name-input");
  const emailInput = document.getElementById("email-input");
  const messageInput = document.getElementById("message-input");
  const formMessage = document.getElementById("form-message");

  form.addEventListener("submit", async function (event) {
    event.preventDefault();

    // Очищення попередніх повідомлень
    formMessage.textContent = "";
    formMessage.classList.remove("text-success", "text-danger");

    // Валідація полів
    const name = nameInput.value.trim();
    const email = emailInput.value.trim();
    const message = messageInput.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!name) {
      formMessage.textContent = "Ім’я не може бути порожнім!";
      formMessage.classList.add("text-danger");
      return;
    }
    if (!emailRegex.test(email)) {
      formMessage.textContent = "Введіть коректний email!";
      formMessage.classList.add("text-danger");
      return;
    }
    if (!message) {
      formMessage.textContent = "Повідомлення не може бути порожнім!";
      formMessage.classList.add("text-danger");
      return;
    }

    // Відправлення даних на сервер
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
        form.reset();
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