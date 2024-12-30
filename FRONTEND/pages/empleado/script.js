const apiUrl = 'http://localhost:3000/empleados';
const personasApiUrl = 'http://localhost:3000/personasNaturales?limit=10000&page=1&search=';
let employees = [];
let personasNaturales = [];

// DOM Elements
const searchInput = document.getElementById('searchInput');
const limitSelect = document.getElementById('limitSelect');
const searchButton = document.getElementById('searchButton');
const createButton = document.getElementById('createButton');
const employeeTableBody = document.getElementById('employeeTableBody');
const createForm = document.getElementById('createForm');
const updateForm = document.getElementById('updateForm');

// Bootstrap Modals
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
const updateModal = new bootstrap.Modal(document.getElementById('updateModal'));

// Event Listeners
searchButton.addEventListener('click', fetchData);
createButton.addEventListener('click', () => createModal.show());
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitSelect.addEventListener('change', () => {
    currentPage = 1;
    fetchData();
});

// Fetch initial data
fetchData();

async function fetchPersonasNaturales() {
    try {
        const response = await fetch(personasApiUrl);
        const data = await response.json();
        if (data.status === 'success') {
            personasNaturales = data.data;
        } else {
            console.error('Error al obtener datos de personas naturales:', data.message);
        }
    } catch (error) {
        console.error('Error al obtener datos de personas naturales:', error);
    }
}

async function fetchData() {
    try {
        // Asegurar que los datos de personas naturales estén cargados primero
        if (personasNaturales.length === 0) {
            await fetchPersonasNaturales();
        }

        const searchTerm = searchInput.value;
        const limit = limitSelect.value;
        const response = await fetch(`${apiUrl}?limit=${limit}&page=1&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            employees = data.data;
            renderTable();
        } else {
            console.error('Error al obtener datos:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function renderTable() {
    employeeTableBody.innerHTML = '';
    employees.forEach(employee => {
        // Comparación corregida para asegurar la obtención del nombre correcto
        const personaNatural = personasNaturales.find(persona => persona.per_codigo === employee.fk_persona_natural);
        const personaNombreIdentificacion = personaNatural ? `${personaNatural.per_nombre} ${personaNatural.per_identificacion}` : 'Desconocido';
        const exp_profesional = `${employee.emp_exp_profesional} años`;
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${employee.emp_codigo}</td>
            <td> ${exp_profesional} </td>
            <td>${employee.emp_titulacion}</td>
            <td>${personaNombreIdentificacion}</td>
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
