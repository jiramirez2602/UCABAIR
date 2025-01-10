import { BASE_URL } from '../../config.js';
const API_BASE_URL = `${BASE_URL}`;
let piezaFases = [];
let tipoPiezas = [];
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
searchButton.addEventListener('click', fetchPiezaFase);
createForm.addEventListener('submit', handleCreate);
updateForm.addEventListener('submit', handleUpdate);
limitSelect.addEventListener('change', fetchPiezaFase);

async function initialize() {
    await Promise.all([
        fetchTipoPiezas(),
        fetchFases(),
        fetchPiezaFase()
    ]);
    populateSelects();
}

async function fetchTipoPiezas() {
    try {
        const response = await fetch(`${API_BASE_URL}/tipoPieza`);
        const data = await response.json();
        if (data.status === 'success') {
            tipoPiezas = data.data;
        } else {
            console.error('Error al obtener los tipos de piezas:', data.message);
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

async function fetchPiezaFase() {
    try {
        const searchTerm = searchInput.value;
        const limit = limitSelect.value;
        console.log('Limite:', limit);
        const response = await fetch(`${API_BASE_URL}/tipo_pieza_fase?limit=${limit}&page=1&search=${searchTerm}`);
        const data = await response.json();

        console.log("Datos recibidos de la API:", data);
        if (data.status === 'success') {
            piezaFases = data.data;
            renderTable();
        } else {
            console.error('Error al obtener las piezas con sus fases:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

function populateSelects() {
    const piezaSelects = ['piezaSelect', 'updatePiezaSelect'];
    const faseSelects = ['faseSelect', 'updateFaseSelect'];

    piezaSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un tipo de pieza</option>';
        tipoPiezas.forEach(pieza => {
            select.innerHTML += `<option value="${pieza.tip_codigo}">${pieza.tip_nombre_tipo}</option>`;
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

    const currentUser = JSON.parse(localStorage.getItem("currentUser"));
    const privileges = currentUser.privileges.map((priv) => priv.pri_nombre);
    const canCreate = privileges.includes("tipo_pieza_fase_create");
    const canUpdate = privileges.includes("tipo_pieza_fase_update");
    const canDelete = privileges.includes("tipo_pieza_fase_delete");

    if (!canCreate) {
        createButton.style.display = "none";
    }

    piezaFases.forEach(piezaFase => {
        const tPieza = tipoPiezas.find(t => t.tip_codigo === piezaFase.fk_tipo_pieza);
        const faseConf = fases.find(f => f.fac_codigo === piezaFase.fk_fase_configuracion);

        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${piezaFase.tpf_codigo}</td>
            <td>${tPieza ? tPieza.tip_nombre_tipo : 'Tipo de pieza no encontrado'}</td>
            <td>${faseConf ? faseConf.fac_nombre : 'Fase de configuración no encontrada'}</td>
            <td>
                <div class="d-flex gap-2">
                    ${
                      canUpdate
                        ? `
                    <button class="btn btn-outline-primary update-btn" data-id="${piezaFase.tpf_codigo}">
                        <i class="bi bi-pencil"></i>
                    </button>`
                        : ""
                    }
                    ${
                      canDelete
                        ? `
                    <button class="btn btn-outline-danger delete-btn" data-id="${piezaFase.tpf_codigo}">
                        <i class="bi bi-trash"></i>
                    </button>`
                        : ""
                    }
                </div>
            </td>
        `;
        faseTipoTableBody.appendChild(row);
    });

    // Event listeners for update and delete buttons
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
        fk_tipo_pieza: parseInt(document.getElementById('piezaSelect').value),
        fk_fase_configuracion: parseInt(document.getElementById('faseSelect').value)
    };

    try {
        const response = await fetch(`${API_BASE_URL}/tipo_pieza_fase`, {
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
            fetchPiezaFase();
        } else {
            showAlert('Error al crear la asignación: ' + data.message, 'danger');
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('Error al crear la asignación', 'danger');
    }
}

function showUpdateModal(id) {
    const piezaFase = piezaFases.find(pf => pf.tpf_codigo == id);
    if (piezaFase) {
        document.getElementById('updateCode').value = piezaFase.tpf_codigo;
        document.getElementById('updatePiezaSelect').value = piezaFase.fk_tipo_pieza;
        document.getElementById('updateFaseSelect').value = piezaFase.fk_fase_configuracion;
        updateModal.show();
    }
}

async function handleUpdate(event) {
    event.preventDefault();
    const updatedTipoFase = {
        tpf_codigo: parseInt(document.getElementById('updateCode').value),
        fk_tipo_pieza: parseInt(document.getElementById('updatePiezaSelect').value),
        fk_fase_configuracion: parseInt(document.getElementById('updateFaseSelect').value)
    };
    console.log('Actualizando asignación:', updatedTipoFase);
    try {
        const response = await fetch(`${API_BASE_URL}/tipo_pieza_fase`, {
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
            fetchPiezaFase();
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
            const response = await fetch(`${API_BASE_URL}/tipo_pieza_fase?id=${id}`, {
                method: 'DELETE',
            });
            const data = await response.json();
            if (data.status === 'success') {
                showAlert('Asignación eliminada exitosamente', 'success');
                fetchPiezaFase();
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