import { BASE_URL } from '../../config.js';
const apiUrl = `${BASE_URL}/personasNaturales`;
const lugarApiUrl = `${BASE_URL}/lugar`;
let personas = [];
let currentPage = 1;
let totalPages = 1;
let sortColumn = '';
let sortDirection = 'asc';

// DOM Elements
const searchInput = document.getElementById("searchInput");
const limitInput = document.getElementById("limitInput");
const searchButton = document.getElementById("searchButton");
const createButton = document.getElementById("createButton");
const personaTableBody = document.getElementById("personaTableBody");
const createForm = document.getElementById("createForm");
const updateForm = document.getElementById("updateForm");
const paginationContainer = document.getElementById("paginationContainer");

// Bootstrap Modals
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
  limit = parseInt(limitInput.value) || 10;
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

// Initial data fetch
fetchData();

// Lugar functions
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
      `${apiUrl}?limit=${limit}&page=${currentPage}&search=${searchTerm}`
    );
    const data = await response.json();
    if (data.status === "success") {
      personas = data.data;
      totalPages = data.totalPages;
      renderTable();
      renderPagination();
    } else {
      console.error("Error al obtener datos:", data.message);
    }
  } catch (error) {
    console.error("Error:", error);
  }
}

function renderTable() {
  personaTableBody.innerHTML = "";
  
  const currentUser = JSON.parse(localStorage.getItem("currentUser"));
  const privileges = currentUser.privileges.map((priv) => priv.pri_nombre);
  const canCreate = privileges.includes("persona_natural_create");
  const canUpdate = privileges.includes("persona_natural_update");
  const canDelete = privileges.includes("persona_natural_delete");

  if (!canCreate) {
    createButton.style.display = "none";
  }

  const sortedData = [...personas].sort((a, b) => {
    if (sortColumn) {
      const aValue = a[sortColumn];
      const bValue = b[sortColumn];
      if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
      return 0;
    }
    return 0;
  });

  sortedData.forEach((persona) => {
    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${persona.per_codigo}</td>
      <td>
        ${persona.per_nombre}
        ${persona.pen_segundo_nombre || ""}
        ${persona.pen_primer_apellido ? persona.pen_primer_apellido : ""}
        ${persona.pen_segundo_apellido ? persona.pen_segundo_apellido : ""}
      </td>
      <td>${persona.per_identificacion}</td>
      <td>${persona.per_direccion}</td>
      <td>${persona.pen_fecha_nac}</td>
      <td>${persona.per_fecha_registro}</td>
      <td>${persona.lug_nombre}</td>
      <td>
        <div class="d-flex gap-2">
          ${
            canUpdate
              ? `<button class="btn btn-outline-primary update-btn" data-id="${persona.per_codigo}">
                   <i class="bi bi-pencil"></i>
                 </button>`
              : ""
          }
          ${
            canDelete
              ? `<button class="btn btn-outline-danger delete-btn" data-id="${persona.per_codigo}">
                   <i class="bi bi-trash"></i>
                 </button>`
              : ""
          }
        </div>
      </td>
    `;
    personaTableBody.appendChild(row);
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

function showUpdateModal(id) {
  const persona = personas.find((p) => p.per_codigo == id);
  if (persona) {
    document.getElementById("updateCodigo").value = persona.per_codigo;
    document.getElementById("updateNombre").value = persona.per_nombre;
    document.getElementById("updateSegundoNombre").value = persona.pen_segundo_nombre;
    document.getElementById("updatePrimerApellido").value = persona.pen_primer_apellido;
    document.getElementById("updateSegundoApellido").value = persona.pen_segundo_apellido;

    // Separate the identificacion into tipo_identificacion and numero_identificacion
    const [tipo, numero] = persona.per_identificacion.split("-");
    document.getElementById("updateTipoIdentificacion").value = tipo;
    document.getElementById("updateNumeroIdentificacion").value = numero;

    document.getElementById("updateDireccion").value = persona.per_direccion;
    document.getElementById("updateFechaNac").value = persona.pen_fecha_nac;
    document.getElementById("updateFechaRegistro").value = persona.per_fecha_registro;
    
    // Cargar los datos de lugar
    loadEstados('update').then(() => {
      document.getElementById("updateEstado").value = persona.estado_id;
      loadMunicipios(persona.estado_id, 'update').then(() => {
        document.getElementById("updateMunicipio").value = persona.municipio_id;
        loadParroquias(persona.municipio_id, 'update').then(() => {
          document.getElementById("updateParroquia").value = persona.fk_lugar;
        });
      });
    });

    updateModal.show();
  }
}

async function handleCreate(event) {
  event.preventDefault();
  const formData = new FormData(createForm);

  // Concatenate tipo_identificacion and numero_identificacion
  const tipo = formData.get("tipo_identificacion");
  const numero = formData.get("numero_identificacion");
  const identificacion = `${tipo}-${numero}`;

  // Add the concatenated identification to formData
  formData.set("identificacion", identificacion);

  // Remove the individual fields from formData
  formData.delete("tipo_identificacion");
  formData.delete("numero_identificacion");

  // Agregar el lugar seleccionado
  formData.set("fk_lugar", document.getElementById("createParroquia").value);

  const newPersona = Object.fromEntries(formData.entries());
  console.log(newPersona);

  try {
    const response = await fetch(apiUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(newPersona),
    });
    const data = await response.json();
    if (data.status === "success") {
      alert("Persona natural creada exitosamente");
      const createModalElement = document.getElementById("createModal");
      const modalInstance = bootstrap.Modal.getInstance(createModalElement);
      modalInstance.hide();
      createForm.reset();
      fetchData();
    } else {
      alert("Error al crear la persona natural: " + data.message);
    }
  } catch (error) {
    console.error("Error:", error);
    alert("Error al crear la persona natural");
  }
}

async function handleUpdate(event) {
  event.preventDefault();
  const formData = new FormData(updateForm);

  // Concatenate tipo_identificacion and numero_identificacion
  const tipo = formData.get("tipo_identificacion");
  const numero = formData.get("numero_identificacion");
  const identificacion = `${tipo}-${numero}`;

  // Add the concatenated identification to formData
  formData.set("identificacion", identificacion);

  // Remove the individual fields from formData
  formData.delete("tipo_identificacion");
  formData.delete("numero_identificacion");

  // Actualizar el lugar seleccionado
  formData.set("fk_lugar", document.getElementById("updateParroquia").value);

  const updatedPersona = Object.fromEntries(formData.entries());

  try {
    const response = await fetch(apiUrl, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(updatedPersona),
    });
    const data = await response.json();
    if (data.status === "success") {
      alert("Persona natural actualizada exitosamente");
      const updateModalElement = document.getElementById("updateModal");
      const modalInstance = bootstrap.Modal.getInstance(updateModalElement);
      modalInstance.hide();
      fetchData();
    } else {
      alert("Error al actualizar la persona natural: " + data.message);
    }
  } catch (error) {
    console.error("Error:", error);
    alert("Error al actualizar la persona natural");
  }
}

async function handleDelete(id) {
  if (confirm("¿Está seguro de que desea eliminar esta persona natural?")) {
    try {
      const response = await fetch(`${apiUrl}?id=${id}`, {
        method: "DELETE",
      });
      const data = await response.json();
      if (data.status === "success") {
        alert("Persona natural eliminada exitosamente");
        fetchData();
      } else {
        alert("Error al eliminar la persona natural: " + data.message);
      }
    } catch (error) {
      console.error("Error:", error);
      alert("Error al eliminar la persona natural");
    }
  }
}

