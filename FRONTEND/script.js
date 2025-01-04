// Login form submission
import { BASE_URL } from './config.js';
const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        try {
            const response = await fetch(`${BASE_URL}/login?username=${username}&password=${password}`);
            const data = await response.json();

            if (data.status === 'success') {
                localStorage.setItem('currentUser', JSON.stringify({ username, privileges: data.data }));
                window.location.href = 'pages/inicio/index.html';
            } else {
                alert('Usuario o contraseña inválidos');
            }
        } catch (error) {
            alert('Error al iniciar sesión. Por favor, intente nuevamente.');
            console.error('Error:', error);
        }
    });
}

// Generate menu based on user privileges
function generateMenu() {
    const currentUser = JSON.parse(localStorage.getItem('currentUser'));
    if (!currentUser) {
        window.location.href = 'index.html';
        return;
    }

    const menu = document.getElementById('menu');
    if (menu) {
        const userPrivileges = currentUser.privileges;
        userPrivileges.forEach(privilege => {
            const li = document.createElement('li');
            li.className = 'nav-item';
            const a = document.createElement('a');
            a.className = 'nav-link';
            a.href = `../${privilege.pri_nombre}/index.html`;
            a.textContent = privilege.pri_nombre.charAt(0).toUpperCase() + privilege.pri_nombre.slice(1).replace(/_/g, " ");
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