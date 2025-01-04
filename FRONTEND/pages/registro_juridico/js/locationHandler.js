// Location selection logic
import { BASE_URL } from '../../../config.js';
export function setupLocationHandlers() {
    const lugarApiUrl = `${BASE_URL}/lugar`;

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

    async function loadEstados() {
        const estados = await fetchLugarData('Estado', null);
        const estadoSelect = document.getElementById('createEstado');
        estadoSelect.innerHTML = '<option value="">Seleccione un Estado</option>';
        estados.forEach(estado => {
            const option = document.createElement('option');
            option.value = estado.lug_codigo;
            option.text = estado.lug_nombre;
            estadoSelect.appendChild(option);
        });
        
        estadoSelect.onchange = () => loadMunicipios(estadoSelect.value);
    }

    async function loadMunicipios(estadoId) {
        if (!estadoId) {
            document.getElementById('createMunicipio').disabled = true;
            document.getElementById('createParroquia').disabled = true;
            return;
        }

        const municipios = await fetchLugarData('Municipio', estadoId);
        const municipioSelect = document.getElementById('createMunicipio');
        municipioSelect.innerHTML = '<option value="">Seleccione un Municipio</option>';
        municipios.forEach(municipio => {
            const option = document.createElement('option');
            option.value = municipio.lug_codigo;
            option.text = municipio.lug_nombre;
            municipioSelect.appendChild(option);
        });
        municipioSelect.disabled = false;
        municipioSelect.onchange = () => loadParroquias(municipioSelect.value);
        document.getElementById('createParroquia').disabled = true;
    }

    async function loadParroquias(municipioId) {
        if (!municipioId) {
            document.getElementById('createParroquia').disabled = true;
            return;
        }

        const parroquias = await fetchLugarData('Parroquia', municipioId);
        const parroquiaSelect = document.getElementById('createParroquia');
        parroquiaSelect.innerHTML = '<option value="">Seleccione una Parroquia</option>';
        parroquias.forEach(parroquia => {
            const option = document.createElement('option');
            option.value = parroquia.lug_codigo;
            option.text = parroquia.lug_nombre;
            parroquiaSelect.appendChild(option);
        });
        parroquiaSelect.disabled = false;
    }

    // Initialize location handlers
    loadEstados();
}