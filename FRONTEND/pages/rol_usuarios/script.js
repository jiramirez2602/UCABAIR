import { BASE_URL } from '../../config.js';
const API_BASE_URL = `${BASE_URL}`;
let userRoles = [];
let users = [];
let roles = [];

// Elementos del DOM
const searchInput = document.getElementById('searchInput');
const limitSelect = document.getElementById('limitSelect');
const searchButton = document.getElementById('searchButton');
const userRoleTableBody = document.getElementById('userRoleTableBody');
const createForm = document.getElementById('createForm');
const updateForm = document.getElementById('updateForm');

// Modales de Bootstrap
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
const updateModal = new bootstrap.Modal(document.getElementById('updateModal'));

// Event Listeners
document.addEventListener('DOMContentLoaded', initialize);
searchButton.addEventListener('click', fetchUserRoles);
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitSelect.addEventListener('change', fetchUserRoles);

async function initialize() {
    await Promise.all([
        fetchUsers(),
        fetchRoles(),
        fetchUserRoles()
    ]);
    populateSelects();
}

async function fetchUsers() {
    try {
        const response = await fetch(`${API_BASE_URL}/usuarios`);
        const data = await response.json();
        if (data.status === 'success') {
            users = data.data;
        } else {
            console.error('Error al obtener usuarios:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchRoles() {
    try {
        const response = await fetch(`${API_BASE_URL}/roles?limit=9999999`);
        const data = await response.json();
        if (data.status === 'success') {
            roles = data.data;
        } else {
            console.error('Error al obtener roles:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchUserRoles() {
    try {
        const searchTerm = searchInput.value;
        const limit = limitSelect.value;
        const response = await fetch(`${API_BASE_URL}/usuario_rol?limit=${limit}&page=1&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            userRoles = data.data;
            renderTable();
        } else {
            console.error('Error al obtener usuario-roles:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function populateSelects() {
    const userSelects = ['userSelect', 'updateUserSelect'];
    const roleSelects = ['roleSelect', 'updateRoleSelect'];

    userSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un usuario</option>';
        users.forEach(user => {
            select.innerHTML += `<option value="${user.usu_codigo}">${user.usu_nombre}</option>`;
        });
    });

    roleSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un rol</option>';
        roles.forEach(role => {
            select.innerHTML += `<option value="${role.rol_codigo}">${role.rol_nombre}</option>`;
        });
    });
}

function renderTable() {
    userRoleTableBody.innerHTML = '';
    userRoles.forEach(userRole => {
        const user = users.find(u => u.usu_codigo === userRole.fk_usuario);
        const role = roles.find(r => r.rol_codigo === userRole.fk_rol);
        
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${userRole.usr_codigo}</td>
            <td>${user ? user.usu_nombre : 'Usuario no encontrado'}</td>
            <td>${role ? role.rol_nombre : 'Rol no encontrado'}</td>
            <td>
            <div class="d-flex gap-2">
                <button class="btn btn-outline-primary update-btn" data-id="${userRole.usr_codigo}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${userRole.usr_codigo}">
                    <i class="bi bi-trash"></i>
                </button>
            </div>
            </td>
        `;
        userRoleTableBody.appendChild(row);
    });

    // Event listeners para botones de acción
    document.querySelectorAll('.update-btn').forEach(btn => {
        btn.addEventListener('click', () => showUpdateModal(btn.dataset.id));
    });
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', () => handleDelete(btn.dataset.id));
    });
}

async function handleCreate(event) {
    event.preventDefault();
    const newUserRole = {
        fk_usuario: parseInt(document.getElementById('userSelect').value),
        fk_rol: parseInt(document.getElementById('roleSelect').value)
    };

    try {
        const response = await fetch(`${API_BASE_URL}/usuario_rol`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newUserRole),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Asignación creada exitosamente', 'success');
            createModal.hide();
            createForm.reset();
            fetchUserRoles();
        } else {
            showAlert('Error al crear la asignación: ' + data.message, 'danger');
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('Error al crear la asignación', 'danger');
    }
}

function showUpdateModal(id) {
    const userRole = userRoles.find(ur => ur.usr_codigo == id);
    if (userRole) {
        document.getElementById('updateCode').value = userRole.usr_codigo;
        document.getElementById('updateUserSelect').value = userRole.fk_usuario;
        document.getElementById('updateRoleSelect').value = userRole.fk_rol;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const updatedUserRole = {
        usr_codigo: parseInt(document.getElementById('updateCode').value),
        fk_usuario: parseInt(document.getElementById('updateUserSelect').value),
        fk_rol: parseInt(document.getElementById('updateRoleSelect').value)
    };

    try {
        const response = await fetch(`${API_BASE_URL}/usuario_rol`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedUserRole),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Asignación actualizada exitosamente', 'success');
            updateModal.hide();
            fetchUserRoles();
        } else {
            showAlert('Error al actualizar la asignación: ' + data.message, 'danger');
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('Error al actualizar la asignación', 'danger');
    }
}

async function handleDelete(id) {
    if (confirm('¿Está seguro de que desea eliminar esta asignación?')) {
        try {
            const response = await fetch(`${API_BASE_URL}/usuario_rol?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                showAlert('Asignación eliminada exitosamente', 'success');
                fetchUserRoles();
            } else {
                showAlert('Error al eliminar la asignación: ' + data.message, 'danger');
            }
        } catch (error) {
            console.error('Error:', error);
            showAlert('Error al eliminar la asignación', 'danger');
        }
    }
}

function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3`;
    alertDiv.role = 'alert';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    document.body.appendChild(alertDiv);
    setTimeout(() => alertDiv.remove(), 3000);
}

// Inicializar la aplicación
initialize();