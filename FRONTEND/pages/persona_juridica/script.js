import { BASE_URL } from '../../config.js';
const API_URL = `${BASE_URL}/personasJuridicas`;
const lugarApiUrl = `${BASE_URL}/lugar`;
let currentData = [];
let currentPage = 1;
let totalPages = 1;
let sortColumn = '';
let sortDirection = 'asc';

// Elementos del DOM
const tableBody = document.getElementById("tableBody");
const searchInput = document.getElementById("searchInput");
const limitInput = document.getElementById("limitInput");
const searchButton = document.getElementById("searchButton");
const createButton = document.getElementById("createButton");
const createForm = document.getElementById("createForm");
const updateForm = document.getElementById("updateForm");
const paginationContainer = document.getElementById("paginationContainer");

// Modales de Bootstrap
const createModal = new bootstrap.Modal(document.getElementById("createModal"));
const updateModal = new bootstrap.Modal(document.getElementById("updateModal"));

// Event Listeners
searchButton.addEventListener("click", fetchData);
createButton.addEventListener("click", () => {
  loadEstados('create');
  createModal.show();
});
createForm.addEventListener("submit", handleCreate);
updateForm.addEventListener("submit", handleUpdate);
limitInput.addEventListener("change", () => {
  currentPage = 1;
  fetchData();
});

document.querySelectorAll('th.sortable').forEach(th => {
  th.addEventListener('click', () => {
    const column = th.dataset.column;
    if (sortColumn === column) {
      sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
      sortColumn = column;
      sortDirection = 'asc';
    }
    document.querySelectorAll('th.sortable').forEach(th => th.classList.remove('desc', 'asc'));
    th.classList.add(sortDirection);
    renderTable();
  });
});

// Make functions globally available
window.showUpdateModal = showUpdateModal;
window.handleDelete = handleDelete;

// Carga inicial de datos
fetchData();

async function fetchLugarData(tipoLugar, idLugarPadre) {
  const url = `${lugarApiUrl}?tipoLugar=${tipoLugar}&idLugarPadre=${idLugarPadre || ''}`;
  try {
    const response = await fetch(url);
    const data = await response.json();
    return data.data;
  } catch (error) {
    console.error('Error al obtener datos:', error);
    return [];
  }
}

async function loadEstados(modalType) {
  const estados = await fetchLugarData('Estado', null);
  const estadoSelect = document.getElementById(`${modalType}Estado`);
  estadoSelect.innerHTML = '<option value="">Seleccione un Estado</option>';
  estados.forEach(estado => {
    const option = document.createElement('option');
    option.value = estado.lug_codigo;
    option.text = estado.lug_nombre;
    estadoSelect.appendChild(option);
  });
  
  estadoSelect.onchange = () => loadMunicipios(estadoSelect.value, modalType);
}

async function loadMunicipios(estadoId, modalType) {
  if (!estadoId) {
    document.getElementById(`${modalType}Municipio`).disabled = true;
    document.getElementById(`${modalType}Parroquia`).disabled = true;
    return;
  }

  const municipios = await fetchLugarData('Municipio', estadoId);
  const municipioSelect = document.getElementById(`${modalType}Municipio`);
  municipioSelect.innerHTML = '<option value="">Seleccione un Municipio</option>';
  municipios.forEach(municipio => {
    const option = document.createElement('option');
    option.value = municipio.lug_codigo;
    option.text = municipio.lug_nombre;
    municipioSelect.appendChild(option);
  });
  municipioSelect.disabled = false;
  municipioSelect.onchange = () => loadParroquias(municipioSelect.value, modalType);
  document.getElementById(`${modalType}Parroquia`).disabled = true;
}

async function loadParroquias(municipioId, modalType) {
  if (!municipioId) {
    document.getElementById(`${modalType}Parroquia`).disabled = true;
    return;
  }

  const parroquias = await fetchLugarData('Parroquia', municipioId);
  const parroquiaSelect = document.getElementById(`${modalType}Parroquia`);
  parroquiaSelect.innerHTML = '<option value="">Seleccione una Parroquia</option>';
  parroquias.forEach(parroquia => {
    const option = document.createElement('option');
    option.value = parroquia.lug_codigo;
    option.text = parroquia.lug_nombre;
    parroquiaSelect.appendChild(option);
  });
  parroquiaSelect.disabled = false;
}

async function fetchData() {
  try {
    const searchTerm = searchInput.value;
    const limit = limitInput.value;
    const response = await fetch(
      `${API_URL}?limit=${limit}&page=${currentPage}&search=${searchTerm}`
    );
    const data = await response.json();

    if (data.status === "success") {
      currentData = data.data;
      totalPages = data.totalPages;
      renderTable();
      renderPagination();
    }
  } catch (error) {
    console.error("Error al obtener datos:", error);
    alert("Error al obtener los datos");
  }
}

function renderTable() {
  tableBody.innerHTML = "";
  
  const currentUser = JSON.parse(localStorage.getItem("currentUser"));
  const privileges = currentUser.privileges.map((priv) => priv.pri_nombre);
  const canCreate = privileges.includes("persona_juridica_create");
  const canUpdate = privileges.includes("persona_juridica_update");
  const canDelete = privileges.includes("persona_juridica_delete");

  if (!canCreate) {
    createButton.style.display = "none";
  }

  const sortedData = [...currentData].sort((a, b) => {
    if (sortColumn) {
      const aValue = a[sortColumn];
      const bValue = b[sortColumn];
      if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
      return 0;
    }
    return 0;
  });

  sortedData.forEach((item) => {
    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${item.per_codigo}</td>
      <td>${item.per_nombre}</td>
      <td>${item.per_identificacion}</td>
      <td>${item.per_direccion}</td>
      <td>${formatDate(item.per_fecha_registro)}</td>
      <td>${item.pej_pagina_web}</td>
      <td>${item.lug_nombre}</td>
      <td>
        <div class="d-flex gap-2">
          ${
            canUpdate
              ? `
                  <button class="btn btn-outline-primary btn-sm me-2" onclick="showUpdateModal(${item.per_codigo})">
          <i class="bi bi-pencil"></i>
        </button>`
              : ""
          }
          ${
            canDelete
              ? `
          <button class="btn btn-outline-danger btn-sm" onclick="handleDelete(${item.per_codigo})">
          <i class="bi bi-trash"></i>
        </button>`
              : ""
          }
        </div>
      </td>
    `;
    tableBody.appendChild(row);
  });

  // Add event listeners to update and delete buttons
  document.querySelectorAll(".update-btn").forEach((btn) => {
    btn.addEventListener("click", () => showUpdateModal(btn.dataset.id));
  });
  document.querySelectorAll(".delete-btn").forEach((btn) => {
    btn.addEventListener("click", () => handleDelete(btn.dataset.id));
  });
}

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

function formatDate(dateString) {
  return new Date(dateString).toLocaleDateString("es-ES");
}

async function handleCreate(event) {
  event.preventDefault();
  const formData = {
    nombre: document.getElementById("nombre").value,
    identificacion: document.getElementById("identificacion").value,
    direccion: document.getElementById("direccion").value,
    fecha_registro: document.getElementById("fecha_registro").value,
    pagina_web: document.getElementById("pagina_web").value,
    fk_lugar: parseInt(document.getElementById("createParroquia").value),
  };

  try {
    const response = await fetch(API_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formData),
    });
    const data = await response.json();

    if (data.status === "success") {
      alert("Persona jurídica creada exitosamente");
      createModal.hide();
      createForm.reset();
      fetchData();
    } else {
      alert("Error al crear: " + data.message);
    }
  } catch (error) {
    console.error("Error al crear:", error);
    alert("Error al crear la persona jurídica");
  }
}

function showUpdateModal(id) {
  const item = currentData.find((x) => x.per_codigo === id);
  if (item) {
    document.getElementById("updateCodigo").value = item.per_codigo;
    document.getElementById("updateNombre").value = item.per_nombre;
    document.getElementById("updateIdentificacion").value = item.per_identificacion;
    document.getElementById("updateDireccion").value = item.per_direccion;
    document.getElementById("updateFechaRegistro").value = item.per_fecha_registro.split("T")[0];
    document.getElementById("updatePaginaWeb").value = item.pej_pagina_web;
    
    // Cargar los datos de lugar
    loadEstados('update').then(() => {
      document.getElementById("updateEstado").value = item.estado_id;
      loadMunicipios(item.estado_id, 'update').then(() => {
        document.getElementById("updateMunicipio").value = item.municipio_id;
        loadParroquias(item.municipio_id, 'update').then(() => {
          document.getElementById("updateParroquia").value = item.fk_lugar;
        });
      });
    });
    
    updateModal.show();
  }
}

async function handleUpdate(event) {
  event.preventDefault();
  const formData = {
    codigo: parseInt(document.getElementById("updateCodigo").value),
    nombre: document.getElementById("updateNombre").value,
    identificacion: document.getElementById("updateIdentificacion").value,
    direccion: document.getElementById("updateDireccion").value,
    fecha_registro: document.getElementById("updateFechaRegistro").value,
    pagina_web: document.getElementById("updatePaginaWeb").value,
    fk_lugar: parseInt(document.getElementById("updateParroquia").value),
  };

  try {
    const response = await fetch(API_URL, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formData),
    });
    const data = await response.json();

    if (data.status === "success") {
      alert("Persona jurídica actualizada exitosamente");
      updateModal.hide();
      fetchData();
    } else {
      alert("Error al actualizar: " + data.message);
    }
  } catch (error) {
    console.error("Error al actualizar:", error);
    alert("Error al actualizar la persona jurídica");
  }
}

async function handleDelete(id) {
  if (confirm("¿Está seguro de que desea eliminar esta persona jurídica?")) {
    try {
      const response = await fetch(`${API_URL}?id=${id}`, {
        method: "DELETE",
      });
      const data = await response.json();

      if (data.status === "success") {
        alert("Persona jurídica eliminada exitosamente");
        fetchData();
      } else {
        alert("Error al eliminar: " + data.message);
      }
    } catch (error) {
      console.error("Error al eliminar:", error);
      alert("Error al eliminar la persona jurídica");
    }
  }
}