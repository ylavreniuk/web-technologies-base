document.addEventListener("DOMContentLoaded", function() {
  // Handle form submissions
  const forms = document.querySelectorAll("form");
  forms.forEach(form => {
    form.addEventListener("submit", function(event) {
      event.preventDefault(); // Prevent immediate submission

      // Basic validation: Ensure all inputs are filled
      const inputs = this.querySelectorAll("input[required]");
      let isValid = true;
      inputs.forEach(input => {
        if (input.value.trim() === "") {
          isValid = false;
          input.style.border = "2px solid red";
        } else {
          input.style.border = "1px solid #ccc";
        }
      });

      if (!isValid) {
        alert("Please fill in all required fields.");
        return;
      }

      // Simulate a success message
      alert("Form submitted successfully!");
      this.submit(); // Now allow the form to submit
    });
  });

  // Enhance UI: Change color of list items on hover
  const listItems = document.querySelectorAll("li");
  listItems.forEach(item => {
    item.addEventListener("mouseenter", function() {
      this.style.backgroundColor = "#f0f0f0";
    });
    item.addEventListener("mouseleave", function() {
      this.style.backgroundColor = "";
    });
  });
});

