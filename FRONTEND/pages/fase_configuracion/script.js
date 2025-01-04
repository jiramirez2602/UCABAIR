import { BASE_URL } from '../../config.js';
const apiUrl = `${BASE_URL}/faseConfiguracion`;
let models = [];

// DOM Elements
const searchInput = document.getElementById('searchInput');
const limitSelect = document.getElementById('limitSelect');
const searchButton = document.getElementById('searchButton');
const createButton = document.getElementById('createButton');
const modelTableBody = document.getElementById('modelTableBody');
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
// Initial data fetch
fetchData();

async function fetchData() {
    try {
        const searchTerm = searchInput.value;
        const limit = limitSelect.value;
        const response = await fetch(`${apiUrl}?limit=${limit}&page=&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            models = data.data;
            renderTable();
        } else {
            console.error('Error al obtener datos:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function renderTable() {
    modelTableBody.innerHTML = '';
    models.forEach(model => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${model.fac_codigo}</td>
            <td>${model.fac_nombre}</td>
            <td>${model.fac_descripcion}</td>
            <td>${model.fac_duracion}</td>
            <td>${model.moa_nombre}</td>
            <td>${model.zon_nombre}</td>
            <td>
<div class="d-flex gap-2">
    <button class="btn btn-outline-primary update-btn" data-id="${model.fac_codigo}">
        <i class="bi bi-pencil"></i>
    </button>
    <button class="btn btn-outline-danger delete-btn" data-id="${model.fac_codigo}">
        <i class="bi bi-trash"></i>
    </button>
</div>
            </td>
        `;
        modelTableBody.appendChild(row);
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
    const newModel = Object.fromEntries(formData.entries());

    console.log(newModel);

    try {
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newModel),
        });
        const data = await response.json();
        if (data.status === 'success') {
            alert('Fase de configuración creado exitosamente');
            createModal.hide();
            createForm.reset();
            fetchData();
        } else {
            alert('Error al crear la Fase de configuración: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al crear la Fase de configuración');
    }
}

function showUpdateModal(id) {
    const model = models.find(m => m.fac_codigo == id);
    if (model) {
        document.getElementById('updateCodigo').value = model.fac_codigo;
        document.getElementById('updateNombre').value = model.fac_nombre;
        document.getElementById('updateDescripcion').value = model.fac_descripcion;
        document.getElementById('updateDuracion').value = model.fac_duracion;
        document.getElementById('updateModelo').value = parseFloat(model.moa_codigo) || 0;
        document.getElementById('updateZona').value = parseFloat(model.zon_codigo) || 0;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const formData = new FormData(updateForm);
    const updatedModel = Object.fromEntries(formData.entries());

    console.log(updatedModel);

    try {
        const response = await fetch(apiUrl, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedModel),
        });
        const data = await response.json();
        if (data.status === 'success') {
            alert('Fase de configuración actualizado exitosamente');
            updateModal.hide();
            fetchData();
        } else {
            alert('Error al actualizar la Fase de configuración: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al actualizar la Fase de configuración.');
    }
}

async function handleDelete(id) {
    if (confirm('¿Está seguro de que desea eliminar esta Fase de configuración?')) {
        try {
            const response = await fetch(`${apiUrl}?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                alert('Fase de configuración eliminada exitosamente');
                fetchData();
            } else {
                alert('Error al eliminar la Fase de configuración: ' + data.message);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error al eliminar la Fase de configuración');
        }
    }
}



