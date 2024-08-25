document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault();

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    if (username && password) {
        this.submit(); // Submit the form
    } else {
        alert("Please fill in both fields.");
    }
});
