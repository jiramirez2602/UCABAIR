const apiUrl = 'http://localhost:3000/modeloAviones';
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
            <td>${model.moa_codigo}</td>
            <td>${model.moa_nombre}</td>
            <td>${model.moa_descripcion}</td>
            <td>${model.moa_longitud}</td>
            <td>${model.moa_envergadura}</td>
            <td>${model.moa_altura}</td>
            <td>${model.moa_peso_vacio}</td>
            <td>
<div class="d-flex gap-2">
    <button class="btn btn-outline-primary update-btn" data-id="${model.moa_codigo}">
        <i class="bi bi-pencil"></i>
    </button>
    <button class="btn btn-outline-danger delete-btn" data-id="${model.moa_codigo}">
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
            alert('Modelo de avión creado exitosamente');
            createModal.hide();
            createForm.reset();
            fetchData();
        } else {
            alert('Error al crear el modelo de avión: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al crear el modelo de avión');
    }
}

function showUpdateModal(id) {
    const model = models.find(m => m.moa_codigo == id);
    if (model) {
        document.getElementById('updateCodigo').value = model.moa_codigo;
        document.getElementById('updateNombre').value = model.moa_nombre;
        document.getElementById('updateDescripcion').value = model.moa_descripcion;
        document.getElementById('updateLongitud').value = model.moa_longitud;
        document.getElementById('updateEnvergadura').value = model.moa_envergadura;
        document.getElementById('updateAltura').value = model.moa_altura;
        document.getElementById('updatePesoVacio').value = model.moa_peso_vacio;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const formData = new FormData(updateForm);
    const updatedModel = Object.fromEntries(formData.entries());

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
            alert('Modelo de avión actualizado exitosamente');
            updateModal.hide();
            fetchData();
        } else {
            alert('Error al actualizar el modelo de avión: ' + data.message);
        }
    } catch (error) {
        console.error('Error:', error);
        alert('Error al actualizar el modelo de avión');
    }
}

async function handleDelete(id) {
    if (confirm('¿Está seguro de que desea eliminar este modelo de avión?')) {
        try {
            const response = await fetch(`${apiUrl}?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                alert('Modelo de avión eliminado exitosamente');
                fetchData();
            } else {
                alert('Error al eliminar el modelo de avión: ' + data.message);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Error al eliminar el modelo de avión');
        }
    }
}



