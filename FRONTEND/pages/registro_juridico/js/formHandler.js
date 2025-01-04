import { API_CONFIG } from './config.js';

export function setupFormHandler(showToast) {
    document.getElementById('registrationForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const tipoId = document.getElementById('tipo_identificacion').value;
        const rif = document.getElementById('rif').value;

        const formData = {
            per_nombre: document.getElementById('per_nombre').value,
            per_direccion: document.getElementById('per_direccion').value,
            per_identificacion: `${tipoId}-${rif}`,
            pej_pagina_web: document.getElementById('pej_pagina_web').value,
            fk_lugar: document.getElementById('createParroquia').value,
            usu_nombre: document.getElementById('usu_nombre').value,
            usu_contrasena: document.getElementById('usu_contrasena').value,
            cli_monto_acreditado: parseFloat(document.getElementById('cli_monto_acreditado').value)
        };

        try {
            const response = await fetch(API_CONFIG.BASE_URL + API_CONFIG.ENDPOINTS.LEGAL_ENTITY, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            const result = await response.json();

            if (result.status === 'success') {
                showToast('Éxito', result.message);
                document.getElementById('registrationForm').reset();
            } else {
                showToast('Error', result.details || result.message, true);
            }
        } catch (error) {
            showToast('Error', 'Error al conectar con el servidor', true);
            console.error('Error:', error);
        }
    });
}