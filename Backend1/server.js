const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const session = require('express-session');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Session Middleware
app.use(session({
    secret: 'secret-key', // Replace with a strong secret in production
    resave: false,
    saveUninitialized: true,
}));

// Serve the login page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'login.html'));
});

// Handle login form submission
app.post('/login', (req, res) => {
    const { username, password } = req.body;

    // Dummy login validation (replace with actual authentication)
    if (username === "admin" && password === "admin123") {
        // Set session variable
        req.session.loggedIn = true;
        res.redirect('/dashboard');
    } else {
        res.send('Invalid credentials. Please <a href="/">try again</a>.');
    }
});

// Middleware to protect dashboard route
function isAuthenticated(req, res, next) {
    if (req.session.loggedIn) {
        next();
    } else {
        res.redirect('/');
    }
}

// Serve the dashboard page after login
app.get('/dashboard', isAuthenticated, (req, res) => {
    res.sendFile(path.join(__dirname, 'views', 'dashboard.html'));
});

// Logout route
app.get('/logout', (req, res) => {
    req.session.destroy();
    res.redirect('/');
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
