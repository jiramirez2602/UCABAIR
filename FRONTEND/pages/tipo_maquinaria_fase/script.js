import { BASE_URL } from '../../config.js';
const API_BASE_URL = `${BASE_URL}`;
let maquinariaFases = [];
let tipoMaquinaria = [];
let fases = [];

// Elementos del DOM
const searchInput = document.getElementById('searchInput');
const limitSelect = document.getElementById('limitSelect');
const searchButton = document.getElementById('searchButton');
const faseTipoTableBody = document.getElementById('faseTipoTableBody');
const createForm = document.getElementById('createForm');
const updateForm = document.getElementById('updateForm');

// Modales de Bootstrap
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
const updateModal = new bootstrap.Modal(document.getElementById('updateModal'));

// Event Listeners
document.addEventListener('DOMContentLoaded', initialize);
searchButton.addEventListener('click', fetchMaquinariaFase);
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitSelect.addEventListener('change', fetchMaquinariaFase);

async function initialize() {
    await Promise.all([
        fetchTipoMaquinarias(),
        fetchFases(),
        fetchMaquinariaFase()
    ]);
    populateSelects();
}

async function fetchTipoMaquinarias() {
    try {
        const response = await fetch(`${API_BASE_URL}/tipoMaquinaria`);
        const data = await response.json();
        if (data.status === 'success') {
            tipoMaquinaria = data.data;
            console.log('Tipos de maquinaria:', tipoMaquinaria);
        } else {
            console.error('Error al obtener los tipos de maquinaria:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchFases() {
    try {
        const response = await fetch(`${API_BASE_URL}/faseConfiguracion?limit=9999999`);
        const data = await response.json();
        if (data.status === 'success') {
            fases = data.data;
        } else {
            console.error('Error al obtener las fases de configuración:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchMaquinariaFase() {
    try {
        const searchTerm = searchInput.value;
        const limit = limitSelect.value;
        const response = await fetch(`${API_BASE_URL}/tipo_maquinaria_fase?limit=${limit}&page=1&search=${searchTerm}`);
        const data = await response.json();

        console.log("Datos recibidos de la API:", data);
        if (data.status === 'success') {
            maquinariaFases = data.data;
            renderTable();
        } else {
            console.error('Error al obtener las maquinarias con sus fases:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function populateSelects() {
    const maquinariaSelects = ['maquinariaSelect', 'updateMaquinariaSelect'];
    const faseSelects = ['faseSelect', 'updateFaseSelect'];

    maquinariaSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un tipo de maquinaria</option>';
        tipoMaquinaria.forEach(maquina => {
            select.innerHTML += `<option value="${maquina.tim_codigo}">${maquina.tim_nombre}</option>`;
        });
    });

    faseSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione una fase de configuración</option>';
        fases.forEach(fase => {
            select.innerHTML += `<option value="${fase.fac_codigo}">${fase.fac_nombre}</option>`;
        });
    });
}

function renderTable() {
    faseTipoTableBody.innerHTML = '';

    maquinariaFases.forEach(maquinariaFase => {
        const tMaquinaria = tipoMaquinaria.find(t => t.tim_codigo === maquinariaFase.fk_tipo_maquinaria);
        const faseConf = fases.find(f => f.fac_codigo === maquinariaFase.fk_fase_configuracion);
        
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${maquinariaFase.tmc_codigo}</td>
            <td>${tMaquinaria ? tMaquinaria.tim_nombre : 'Tipo de maquinaria no encontrado'}</td>
            <td>${faseConf ? faseConf.fac_nombre : 'Fase de configuración no encontrada'}</td>
            <td>
            <div class="d-flex gap-2">
                <button class="btn btn-outline-primary update-btn" data-id="${maquinariaFase.tmc_codigo}">
                    <i class="bi bi-pencil"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${maquinariaFase.tmc_codigo}">
                    <i class="bi bi-trash"></i>
                </button>
                </div>
            </td>
        `;
        faseTipoTableBody.appendChild(row);
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
    const newTipoFase = {
        fk_tipo_maquinaria: parseInt(document.getElementById('maquinariaSelect').value),
        fk_fase_configuracion: parseInt(document.getElementById('faseSelect').value)
    };

    try {
        const response = await fetch(`${API_BASE_URL}/tipo_maquinaria_fase`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newTipoFase),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Asignación creada exitosamente', 'success');
            createModal.hide();
            createForm.reset();
            fetchMaquinariaFase();
        } else {
            showAlert('Error al crear la asignación: ' + data.message, 'danger');
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('Error al crear la asignación', 'danger');
    }
}

function showUpdateModal(id) {
    const maquinariaFase = maquinariaFases.find(mf => mf.tmc_codigo == id);
    if (maquinariaFase) {
        document.getElementById('updateCode').value = maquinariaFase.tmc_codigo;
        document.getElementById('updateMaquinariaSelect').value = maquinariaFase.fk_tipo_maquinaria;
        document.getElementById('updateFaseSelect').value = maquinariaFase.fk_fase_configuracion;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const updatedTipoFase = {
        tmc_codigo: parseInt(document.getElementById('updateCode').value),
        fk_tipo_maquinaria: parseInt(document.getElementById('updateMaquinariaSelect').value),
        fk_fase_configuracion: parseInt(document.getElementById('updateFaseSelect').value)
    };
    console.log('Actualizando asignación:', updatedTipoFase);
    try {
        const response = await fetch(`${API_BASE_URL}/tipo_maquinaria_fase`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(updatedTipoFase),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Asignación actualizada exitosamente', 'success');
            updateModal.hide();
            fetchMaquinariaFase();
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
            const response = await fetch(`${API_BASE_URL}/tipo_maquinaria_fase?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                showAlert('Asignación eliminada exitosamente', 'success');
                fetchMaquinariaFase();
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