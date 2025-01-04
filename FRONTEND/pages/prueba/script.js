import { BASE_URL } from '../../config.js';
const apiUrlPrueba = `${BASE_URL}/prueba`;
const apiUrlTipoPieza = `${BASE_URL}/tipoPieza`;
let testTypes = [];
let testTipoPieza = [];
let sortColumn = '';
let sortDirection = 'asc';
let currentPage = 1;
let totalPages = 1;
let limit = 10;

// DOM Elements
const searchInput = document.getElementById("searchInput");
const limitInput = document.getElementById("limitInput");
const searchButton = document.getElementById("searchButton");
const createButton = document.getElementById("createButton");
const testTypeTableBody = document.getElementById("testTypeTableBody");
const createForm = document.getElementById("createForm");
const updateForm = document.getElementById("updateForm");
const paginationContainer = document.getElementById("paginationContainer");

// Bootstrap Modals
const createModal = new bootstrap.Modal(document.getElementById("createModal"));
const updateModal = new bootstrap.Modal(document.getElementById("updateModal"));

// Event Listeners
searchButton.addEventListener("click", fetchData);
createButton.addEventListener("click", () => createModal.show());
createForm.addEventListener("submit", handleCreate);
updateForm.addEventListener("submit", handleUpdate);
limitInput.addEventListener("change", () => {
  limit = parseInt(limitInput.value) || 10;
  currentPage = 1;
  fetchData();
});

// Initial data fetch
fetchData();

async function fetchData() {
  try {
    const searchTerm = searchInput.value;
    const responsePrueba = await fetch(
      `${apiUrlPrueba}?limit=${limit}&page=${currentPage}&search=${searchTerm}&sort=${sortColumn}&direction=${sortDirection}`
    );
    const responseTipoPieza = await fetch(
      `${apiUrlTipoPieza}?limit=${limit}&page=${currentPage}&search=${searchTerm}`
    );
    const data = await responsePrueba.json();
    const dataTipoPieza = await responseTipoPieza.json();
    if (data.status === "success" && dataTipoPieza.status === "success") {
      testTypes = data.data;
      testTipoPieza = dataTipoPieza.data;
      totalPages = data.totalPages;

      // Integrar nombres de tipo de pieza en los datos de prueba
      testTypes.forEach((prueba) => {
        const tipoPieza = testTipoPieza.find(
          (tipo) => tipo.tip_codigo === prueba.fk_tipo_pieza
        );
        if (tipoPieza) {
          prueba.tip_nombre_tipo = tipoPieza.tip_nombre_tipo;
        }
      });

      renderTable();
      setupComboBoxes();
      renderPagination();
    } else {
      console.error(
        "Error al obtener datos:",
        data.message,
        dataTipoPieza.message
      );
    }
  } catch (error) {
    console.error("Error en fetchData:", error);
  }
}

function setupComboBoxes() {
  setupComboBox('createTipoPiezaSearch', 'createTipoPiezaOptions', 'fk_tipo_pieza');
  setupComboBox('updateTipoPiezaSearch', 'updateTipoPiezaOptions', 'updateFkTipoPieza');
}

function setupComboBox(searchInputId, optionsListId, hiddenInputId) {
  const searchInput = document.getElementById(searchInputId);
  const optionsList = document.getElementById(optionsListId);
  const hiddenInput = document.getElementById(hiddenInputId);

  searchInput.addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    const filteredOptions = testTipoPieza.filter(tipo => 
      tipo.tip_nombre_tipo.toLowerCase().includes(searchTerm)
    );
    renderOptions(optionsList, filteredOptions, hiddenInput, searchInput);
  });

  renderOptions(optionsList, testTipoPieza, hiddenInput, searchInput);
}

function renderOptions(optionsList, options, hiddenInput, searchInput) {
  optionsList.innerHTML = '';
  options.forEach(tipo => {
    const li = document.createElement('li');
    li.innerHTML = `<a class="dropdown-item" href="#" data-value="${tipo.tip_codigo}">${tipo.tip_nombre_tipo}</a>`;
    li.querySelector('a').addEventListener('click', function(e) {
      e.preventDefault();
      hiddenInput.value = this.dataset.value;
      searchInput.value = this.textContent;
    });
    optionsList.appendChild(li);
  });
}

function renderTable() {
  testTypeTableBody.innerHTML = "";
  const sortedTestTypes = [...testTypes].sort((a, b) => {
    if (sortColumn) {
      const aValue = a[sortColumn];
      const bValue = b[sortColumn];
      if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
      return 0;
    }
    return 0;
  });

  sortedTestTypes.forEach((testType) => {
    const row = document.createElement("tr");
    row.innerHTML = `
            <td>${testType.pru_codigo}</td>
            <td>${testType.pru_nombre}</td>
            <td>${testType.pru_descripcion}</td>
            <td>${testType.pru_duracion_estimada}</td>
            <td>${testType.tip_nombre_tipo}</td>
            <td>
                <div class="d-flex gap-2">
                    <button class="btn btn-outline-primary update-btn" data-id="${testType.pru_codigo}">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button class="btn btn-outline-danger delete-btn" data-id="${testType.pru_codigo}">
                        <i class="bi bi-trash"></i>
                    </button>
                </div>
            </td>
        `;
    testTypeTableBody.appendChild(row);
  });

  // Add event listeners to update and delete buttons
  document.querySelectorAll(".update-btn").forEach((btn) => {
    btn.addEventListener("click", () => showUpdateModal(btn.dataset.id));
  });
  document.querySelectorAll(".delete-btn").forEach((btn) => {
    btn.addEventListener("click", () => handleDelete(btn.dataset.id));
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
  const newTestType = Object.fromEntries(formData.entries());

  try {
    const response = await fetch(apiUrlPrueba, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(newTestType),
    });
    const data = await response.json();
    if (data.status === "success") {
      alert("Tipo de prueba creado exitosamente");
      createModal.hide();
      createForm.reset();
      fetchData();
    } else {
      alert("Error al crear el tipo de prueba: " + data.message);
    }
  } catch (error) {
    console.error("Error:", error);
    alert("Error al crear el tipo de prueba");
  }
}

function showUpdateModal(id) {
  const testType = testTypes.find((t) => t.pru_codigo == id);
  if (testType) {
    document.getElementById("updateCodigo").value = testType.pru_codigo;
    document.getElementById("updateNombre").value = testType.pru_nombre;
    document.getElementById("updateDescripcion").value = testType.pru_descripcion;
    document.getElementById("updateDuracionEstimada").value = testType.pru_duracion_estimada;
    document.getElementById("updateFkTipoPieza").value = testType.fk_tipo_pieza;
    document.getElementById("updateTipoPiezaSearch").value = testType.tip_nombre_tipo;
    updateModal.show();
  }
}

async function handleUpdate(event) {
  event.preventDefault();
  const formData = new FormData(updateForm);
  const updatedTestType = Object.fromEntries(formData.entries());

  try {
    const response = await fetch(apiUrlPrueba, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(updatedTestType),
    });
    const data = await response.json();
    if (data.status === "success") {
      alert("Tipo de prueba actualizado exitosamente");
      updateModal.hide();
      fetchData();
    } else {
      alert("Error al actualizar el tipo de prueba: " + data.message);
    }
  } catch (error) {
    console.error("Error:", error);
    alert("Error al actualizar el tipo de prueba");
  }
}

async function handleDelete(id) {
  if (confirm("¿Está seguro de que desea eliminar este tipo de prueba?")) {
    try {
      const response = await fetch(`${apiUrlPrueba}?id=${id}`, {
        method: "DELETE",
      });
      const data = await response.json();
      if (data.status === "success") {
        alert("Tipo de prueba eliminado exitosamente");
        fetchData();
      } else {
        alert("Error al eliminar el tipo de prueba: " + data.message);
      }
    } catch (error) {
      console.error("Error:", error);
      alert("Error al eliminar el tipo de prueba");
    }
  }
}

