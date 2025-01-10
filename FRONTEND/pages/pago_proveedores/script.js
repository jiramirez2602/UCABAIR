import { BASE_URL } from '../../config.js';
const apiUrl = `${BASE_URL}/pagoProveedores`;
let solicitudes = [];
let tasaCambio = [];
let metodoPago = [];

// DOM Elements
const searchInput = document.getElementById('searchInput');
const limitSelect = document.getElementById('limitSelect');
const searchButton = document.getElementById('searchButton');
const modelTableBody = document.getElementById('modelTableBody');
const createForm = document.getElementById('createForm');

// Modales de Bootstrap
const createModal = new bootstrap.Modal(document.getElementById('createModal'));
let selectedComCodigo = null;

// Event Listeners
createForm.addEventListener('submit', handleCreate);
searchButton.addEventListener('click', fetchData);
limitSelect.addEventListener('change', () => {
    currentPage = 1;
    fetchData();
});

async function initialize() {
    await Promise.all([
        fetchTasaCambio(),
        fetchMetodoPago()
    ]);
    populateSelects();
}

// Initial data fetch
fetchData();

async function fetchTasaCambio() {
    try {
        const response = await fetch(`${BASE_URL}/tasaCambio`);
        const data = await response.json();
        if (data.status === 'success') {
            tasaCambio = data.data;
        } else {
            console.error('Error al obtener las tasas de cambio:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchMetodoPago() {
    try {
        const response = await fetch(`${BASE_URL}/metodoPago?limit=9999999`);
        const data = await response.json();
        if (data.status === 'success') {
            metodoPago = data.data;
        } else {
            console.error('Error al obtener los metodos de pago:', data.message);
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

async function fetchData() {
    try {
        const searchTerm = searchInput.value;
        const limit = limitSelect.value;
        const response = await fetch(`${apiUrl}?limit=${limit}&page=&search=${searchTerm}`);
        const data = await response.json();
        if (data.status === 'success') {
            solicitudes = data.data;
            console.log(solicitudes);
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
    solicitudes.forEach(soli => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${soli.per_nombre}</td>
            <td>${soli.mat_nombre}</td>
            <td>${soli.dec_cantidad}</td>
            <td>${soli.dec_precio_unit}</td>
            <td>${soli.com_fecha_hora}</td>
            <td>${soli.com_monto_total}</td>
            <td>${soli.com_numero_compra}</td>
            <td>${soli.sed_nombre}</td>
            <td>
                <div class="d-flex gap-2">
                    ${
                      /*canUpdate
                        ? */`
                    <button class="btn btn-outline-primary update-btn" data-id="${soli.com_codigo}">
                        <i class="bi bi-pencil"> Pagar</i>
                    </button>`
                        /*: ""*/
                    }

                </div>
            </td>
        `;
        modelTableBody.appendChild(row);
    });

    // Registrar el evento para los botones de pago después de renderizar la tabla
    document.querySelectorAll('.update-btn').forEach(button => {
        button.addEventListener('click', (event) => {
            selectedComCodigo = event.target.getAttribute('data-id');
            createModal.show();
        });
    });
}

function populateSelects() {
    const tasaSelects = ['tasaSelect'];
    const metodoSelects = ['metodoSelect'];

    tasaSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un tipo de tasa de cambio</option>';
        tasaCambio.forEach(tasa => {
            select.innerHTML += `<option value="${tasa.tac_codigo}">${tasa.tac_nombre}</option>`;
        });
    });

    metodoSelects.forEach(selectId => {
        const select = document.getElementById(selectId);
        select.innerHTML = '<option value="">Seleccione un metodo de pago</option>';
        metodoPago.forEach(metodo => {
            select.innerHTML += `<option value="${metodo.met_codigo}">${metodo.met_tipo}</option>`;
        });
    });
}

async function handleCreate(event) {
    event.preventDefault();
    const newTipoFase = {
        monto: parseInt(document.getElementById('monto').value),
        fk_tasa: parseInt(document.getElementById('tasaSelect').value),
        fk_metodo: parseInt(document.getElementById('metodoSelect').value),
        com_codigo: selectedComCodigo  // Agregar el código de compra seleccionado
    };

    try {
        const response = await fetch(`${apiUrl}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(newTipoFase),
        });
        const data = await response.json();
        if (data.status === 'success') {
            showAlert('Pago exitoso', 'success');
            createModal.hide();
            createForm.reset();
            fetchData();  // Corregido para llamar a fetchData() en lugar de fetchTasaCambio()
        } else {
            showAlert('Error al crear la asignación: ' + data.message, 'danger');
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('Error al crear la asignación', 'danger');
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
