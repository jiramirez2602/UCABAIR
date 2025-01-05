import { BASE_URL } from '../../config.js';
const apiUrl = `${BASE_URL}/empleado`;
let employees = [];
let sortColumn = '';
let sortDirection = 'asc';
let currentPage = 1;
let totalPages = 1;
let limit = 10;

// DOM Elements
const searchInput = document.getElementById('searchInput');
const limitInput = document.getElementById('limitInput');
const searchButton = document.getElementById('searchButton');
const createButton = document.getElementById('createButton');
const employeeTableBody = document.getElementById('employeeTableBody');
const createForm = document.getElementById('createForm');
const updateForm = document.getElementById('updateForm');
const paginationContainer = document.getElementById('paginationContainer');

// Bootstrap Modals
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
const updateModal = new bootstrap.Modal(document.getElementById('updateModal'));

// Event Listeners
searchButton.addEventListener('click', fetchData);
createButton.addEventListener('click', () => createModal.show());
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitInput.addEventListener('change', () => {
    limit = parseInt(limitInput.value) || 10;
    currentPage = 1;
    fetchData();
});

// Fetch initial data
fetchData();

async function fetchData() {
    try {
        const searchTerm = searchInput.value;
        const response = await fetch(`${apiUrl}?limit=${limit}&page=${currentPage}&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            employees = data.data;
            totalPages = data.totalPages;
            renderTable();
            renderPagination();
        } else {
            console.error('Error al obtener datos:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function renderTable() {
    employeeTableBody.innerHTML = '';
    const sortedEmployees = [...employees].sort((a, b) => {
        if (sortColumn) {
            const aValue = a[sortColumn];
            const bValue = b[sortColumn];
            if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
            if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
            return 0;
        }
        return 0;
    });

    sortedEmployees.forEach(employee => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${employee.emp_codigo}</td>
            <td>${employee.emp_exp_profesional} años</td>
            <td>${employee.emp_titulacion}</td>
            <td>${employee.persona_natural_nombre}</td>
            <td>${employee.usu_nombre}</td>
            <td>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-primary update-btn" data-id="${employee.emp_codigo}">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn btn-outline-danger delete-btn" data-id="${employee.emp_codigo}">
                        <i class="bi bi-trash"></i>
                    </button>
                </div>
            </td>
        `;
        employeeTableBody.appendChild(row);
    });

    // Add event listeners to update and delete buttons
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
        fetchData();
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
            fetchData();
        });
        paginationContainer.appendChild(pageItem);
    }
}

async function handleCreate(event) {
    event.preventDefault();
    const formData = new FormData(createForm);
    const newEmployee = Object.fromEntries(formData.entries());

    try {
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newEmployee),
        });
        const data = await response.json();
        if (data.status === 'success') {
            alert('Empleado creado exitosamente');
            createModal.hide();
            createForm.reset();
            fetchData();
        } else {
            alert('Error al crear el empleado: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al crear el empleado');
    }
}

function showUpdateModal(id) {
    const employee = employees.find(e => e.emp_codigo == id);
    if (employee) {
        document.getElementById('updateCodigo').value = employee.emp_codigo;
        document.getElementById('updateExpProfesional').value = employee.emp_exp_profesional;
        document.getElementById('updateTitulacion').value = employee.emp_titulacion;
        document.getElementById('updateFkPersonaNatural').value = employee.fk_persona_natural;
        document.getElementById('updateUsuNombre').value = employee.usu_nombre;
        document.getElementById('updateUsuContrasena').value = ''; // Clear password field for security
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const formData = new FormData(updateForm);
    const updatedEmployee = Object.fromEntries(formData.entries());

    try {
        const response = await fetch(apiUrl, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedEmployee),
        });
        const data = await response.json();
        if (data.status === 'success') {
            alert('Empleado actualizado exitosamente');
            updateModal.hide();
            fetchData();
        } else {
            alert('Error al actualizar el empleado: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al actualizar el empleado');
    }
}

async function handleDelete(id) {
    if (confirm('¿Está seguro de que desea eliminar este empleado?')) {
        try {
            const response = await fetch(`${apiUrl}?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                alert('Empleado eliminado exitosamente');
                fetchData();
            } else {
                alert('Error al eliminar el empleado: ' + data.message);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error al eliminar el empleado');
        }
    }
}