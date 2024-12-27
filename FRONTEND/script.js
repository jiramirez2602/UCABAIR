// Simulated user roles and privileges
const userRoles = {
    admin: ['modelo_avion', 'prueba'],
    manager: ['purchase', 'sale'],
    worker: ['manufacturing']
};

// Simulated user database
const users = {
    admin: { password: 'admin123', role: 'admin' },
    manager: { password: 'manager123', role: 'manager' },
    worker: { password: 'worker123', role: 'worker' }
};

// Login form submission
const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        if (users[username] && users[username].password === password) {
            localStorage.setItem('currentUser', JSON.stringify({ username, role: users[username].role }));
            window.location.href = 'pages/inicio/index.html';
        } else {
            alert('Usuario o contraseña inválidos');
        }
    });
}

// Generate menu based on user role
function generateMenu() {
    const currentUser = JSON.parse(localStorage.getItem('currentUser'));
    if (!currentUser) {
        window.location.href = 'index.html';
        return;
    }

    const menu = document.getElementById('menu');
    if (menu) {
        const userPrivileges = userRoles[currentUser.role];
        userPrivileges.forEach(privilege => {
            const li = document.createElement('li');
            li.className = 'nav-item';
            const a = document.createElement('a');
            a.className = 'nav-link';
            a.href = `../${privilege}/index.html`;
            a.textContent = privilege.charAt(0).toUpperCase() + privilege.slice(1);
            a.textContent = a.textContent.replace(/_/g, " ");
            li.appendChild(a);
            menu.appendChild(li);
        });
    }
}

// Logout functionality
const logoutBtn = document.getElementById('logoutBtn');
if (logoutBtn) {
    logoutBtn.addEventListener('click', function() {
        localStorage.removeItem('currentUser');
        window.location.href = '../../index.html';
    });
}

// Call generateMenu on dashboard load
if (window.location.pathname.includes('pages/inicio/index.html')) {
    generateMenu();
}