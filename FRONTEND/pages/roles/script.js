import { BASE_URL } from '../../config.js';
const apiUrl = `${BASE_URL}/roles`;
let roles = [];
let sortColumn = '';
let sortDirection = 'asc';
let currentPage = 1;
let totalPages = 1;
let limit = 10;

// Elementos del DOM
const searchInput = document.getElementById('searchInput');
const limitInput = document.getElementById('limitInput');
const searchButton = document.getElementById('searchButton');
const roleTableBody = document.getElementById('roleTableBody');
const createForm = document.getElementById('createForm');
const updateForm = document.getElementById('updateForm');
const paginationContainer = document.getElementById('paginationContainer');

// Modales de Bootstrap
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
const updateModal = new bootstrap.Modal(document.getElementById('updateModal'));

// Event Listeners
searchButton.addEventListener('change', fetchRoles);
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitInput.addEventListener('change', () => {
    limit = parseInt(limitInput.value) || 10;
    currentPage = 1;
    fetchRoles();
});

// Carga inicial de datos
fetchRoles();

async function fetchRoles() {
    try {
        const searchTerm = searchInput.value;
        const response = await fetch(`${apiUrl}?limit=${limit}&page=${currentPage}&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            roles = data.data;
            totalPages = data.totalPages;
            renderTable();
            renderPagination();
        } else {
            console.error('Error al obtener roles:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function renderTable() {
    roleTableBody.innerHTML = '';
    const sortedRoles = [...roles].sort((a, b) => {
        if (sortColumn) {
            const aValue = a[sortColumn];
            const bValue = b[sortColumn];
            if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
            if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
            return 0;
        }
        return 0;
    });

    sortedRoles.forEach(role => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${role.rol_codigo}</td>
            <td>${role.rol_nombre}</td>
            <td>${role.rol_descripcion}</td>
            <td>
                <button class="btn btn-sm btn-outline-primary update-btn" data-id="${role.rol_codigo}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${role.rol_codigo}">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        `;
        roleTableBody.appendChild(row);
    });

    // Agregar event listeners a los botones de actualizar y eliminar
    document.querySelectorAll('.update-btn').forEach(btn => {
        btn.addEventListener('click', () => showUpdateModal(btn.dataset.id));
    });
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', () => handleDelete(btn.dataset.id));
    });
}

// Add event listeners to sortable columns
document.querySelectorAll('th.sortable').forEach(th => {
    th.addEventListener('click', () => {
        const column = th.dataset.column;
        if (sortColumn === column) {
            sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            sortColumn = column;
            sortDirection = 'asc';
        }
        document.querySelectorAll('th.sortable').forEach(th => th.classList.remove('desc'));
        if (sortDirection === 'desc') {
            th.classList.add('desc');
        }
        fetchRoles();
    });
});

function renderPagination() {
    paginationContainer.innerHTML = '';
    for (let i = 1; i <= totalPages; i++) {
        const pageItem = document.createElement('li');
        pageItem.classList.add('page-item');
        if (i === currentPage) {
            pageItem.classList.add('active');
        }
        pageItem.innerHTML = `<a class="page-link" href="#">${i}</a>`;
        pageItem.addEventListener('click', (e) => {
            e.preventDefault();
            currentPage = i;
            fetchRoles();
        });
        paginationContainer.appendChild(pageItem);
    }
}

async function handleCreate(event) {
    event.preventDefault();
    const newRole = {
        nombre: document.getElementById('createName').value,
        descripcion: document.getElementById('createDescription').value
    };

    try {
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newRole),
        });
        const data = await response.json();
        if (data.status === 'success') {
            alert('Rol creado exitosamente');
            createModal.hide();
            createForm.reset();
            fetchRoles();
        } else {
            alert('Error al crear el rol: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al crear el rol');
    }
}

function showUpdateModal(id) {
    const role = roles.find(r => r.rol_codigo == id);
    if (role) {
        document.getElementById('updateCode').value = role.rol_codigo;
        document.getElementById('updateName').value = role.rol_nombre;
        document.getElementById('updateDescription').value = role.rol_descripcion;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const updatedRole = {
        codigo: document.getElementById('updateCode').value,
        nombre: document.getElementById('updateName').value,
        descripcion: document.getElementById('updateDescription').value
    };

    try {
        const response = await fetch(apiUrl, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedRole),
        });
        const data = await response.json();
        if (data.status === 'success') {
            alert('Rol actualizado exitosamente');
            updateModal.hide();
            fetchRoles();
        } else {
            alert('Error al actualizar el rol: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al actualizar el rol');
    }
}

async function handleDelete(id) {
    if (confirm('¿Está seguro de que desea eliminar este rol?')) {
        try {
            const response = await fetch(`${apiUrl}?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                alert('Rol eliminado exitosamente');
                fetchRoles();
            } else {
                alert('Error al eliminar el rol: ' + data.message);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error al eliminar el rol');
        }
    }
}