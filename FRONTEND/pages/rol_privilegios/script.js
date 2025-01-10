import { BASE_URL } from '../../config.js';
const API_BASE_URL = `${BASE_URL}`;
let rolPrivilegios = [];
let roles = [];
let privilegios = [];
let currentPage = 1;
let totalPages = 1;
let sortColumn = '';
let sortDirection = 'asc';

// Elementos del DOM
const searchInput = document.getElementById('searchInput');
const limitInput = document.getElementById('limitInput');
const searchButton = document.getElementById('searchButton');
const rolPrivilegioTableBody = document.getElementById('rolPrivilegioTableBody');
const createForm = document.getElementById('createForm');
const updateForm = document.getElementById('updateForm');
const paginationContainer = document.getElementById('paginationContainer');

// Modales de Bootstrap
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
const updateModal = new bootstrap.Modal(document.getElementById('updateModal'));

// Event Listeners
document.addEventListener('DOMContentLoaded', initialize);
searchButton.addEventListener('click', fetchRolPrivilegios);
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitInput.addEventListener('change', () => {
    currentPage = 1;
    fetchRolPrivilegios();
});

async function initialize() {
    await Promise.all([
        fetchRoles(),
        fetchPrivilegios(),
        fetchRolPrivilegios()
    ]);
    populateSelects();
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

async function fetchPrivilegios() {
    try {
        const response = await fetch(`${API_BASE_URL}/privilegios`);
        const data = await response.json();
        if (data.status === 'success') {
            privilegios = data.data;
        } else {
            console.error('Error al obtener privilegios:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchRolPrivilegios() {
    try {
        const searchTerm = searchInput.value;
        const limit = limitInput.value;
        const response = await fetch(`${API_BASE_URL}/rol_privilegio?limit=${limit}&page=${currentPage}&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            rolPrivilegios = data.data;
            totalPages = data.totalPages;
            renderTable();
            renderPagination();
        } else {
            console.error('Error al obtener rol-privilegios:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function populateSelects() {
    const rolSelects = ['rolSelect', 'updateRolSelect'];
    const privilegioSelects = ['privilegioSelect', 'updatePrivilegioSelect'];

    rolSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un rol</option>';
        roles.forEach(rol => {
            select.innerHTML += `<option value="${rol.rol_codigo}">${rol.rol_nombre}</option>`;
        });
    });

    privilegioSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un privilegio</option>';
        privilegios.forEach(privilegio => {
            select.innerHTML += `<option value="${privilegio.pri_codigo}">${privilegio.pri_nombre}</option>`;
        });
    });
}

function renderTable() {
    rolPrivilegioTableBody.innerHTML = '';
    const currentUser = JSON.parse(localStorage.getItem("currentUser"));
    const privileges = currentUser.privileges.map((priv) => priv.pri_nombre);
    const canCreate = privileges.includes("rol_privilegios_create");
    const canDelete = privileges.includes("rol_privilegios_delete");

    if (!canCreate) {
        createButton.style.display = "none";
    }

    const sortedData = [...rolPrivilegios].sort((a, b) => {
        if (sortColumn) {
            const aValue = a[sortColumn];
            const bValue = b[sortColumn];
            if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
            if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
            return 0;
        }
        return 0;
    });

    sortedData.forEach(rolPrivilegio => {
        const rol = roles.find(r => r.rol_codigo === rolPrivilegio.fk_rol);
        const privilegio = privilegios.find(p => p.pri_codigo === rolPrivilegio.fk_privilegio);
        
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${rolPrivilegio.rp_codigo}</td>
            <td>${rolPrivilegio.rol_nombre}</td>
            <td>${rolPrivilegio.pri_nombre}</td>
            <td>
                <div class="d-flex gap-2">
                    ${
                      canDelete
                        ? `
                    <button class="btn btn btn-outline-danger delete-btn" data-id="${rolPrivilegio.rp_codigo}">
                        <i class="bi bi-trash"></i>
                    </button>`
                        : ""
                    }
                </div>
            </td>
        `;
        rolPrivilegioTableBody.appendChild(row);
    });

    // Event listeners para botones de acción
    document.querySelectorAll('.update-btn').forEach(btn => {
        btn.addEventListener('click', () => showUpdateModal(btn.dataset.id));
    });
    document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', () => handleDelete(btn.dataset.id));
    });
}

document.querySelectorAll('.sortable').forEach(header => {
    header.addEventListener('click', () => {
        const column = header.dataset.column;
        if (sortColumn === column) {
            sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            sortColumn = column;
            sortDirection = 'asc';
        }
        renderTable();
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
            fetchRolPrivilegios();
        });
        paginationContainer.appendChild(pageItem);
    }
}

async function handleCreate(event) {
    event.preventDefault();
    const newRolPrivilegio = {
        fk_rol: parseInt(document.getElementById('rolSelect').value),
        fk_privilegio: parseInt(document.getElementById('privilegioSelect').value)
    };

    try {
        const response = await fetch(`${API_BASE_URL}/rol_privilegio`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newRolPrivilegio),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Asignación creada exitosamente', 'success');
            createModal.hide();
            createForm.reset();
            fetchRolPrivilegios();
        } else {
            showAlert('Error al crear la asignación: ' + data.message, 'danger');
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('Error al crear la asignación', 'danger');
    }
}

function showUpdateModal(id) {
    const rolPrivilegio = rolPrivilegios.find(rp => rp.codigo == id);
    if (rolPrivilegio) {
        document.getElementById('updateCode').value = rolPrivilegio.codigo;
        document.getElementById('updateRolSelect').value = rolPrivilegio.fk_rol;
        document.getElementById('updatePrivilegioSelect').value = rolPrivilegio.fk_privilegio;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const updatedRolPrivilegio = {
        codigo: parseInt(document.getElementById('updateCode').value),
        fk_rol: parseInt(document.getElementById('updateRolSelect').value),
        fk_privilegio: parseInt(document.getElementById('updatePrivilegioSelect').value)
    };

    try {
        const response = await fetch(`${API_BASE_URL}/rol_privilegio`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedRolPrivilegio),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Asignación actualizada exitosamente', 'success');
            updateModal.hide();
            fetchRolPrivilegios();
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
            const response = await fetch(`${API_BASE_URL}/rol_privilegio?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                showAlert('Asignación eliminada exitosamente', 'success');
                fetchRolPrivilegios();
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