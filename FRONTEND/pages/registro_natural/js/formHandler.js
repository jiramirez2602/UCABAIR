// Form submission and validation logic
import { BASE_URL } from '../../../config.js';
export function setupFormHandler(showToast) {
    const registrationUrl = `${BASE_URL}/registrar/cliente/natural`;

    document.getElementById('registrationForm').addEventListener('submit', async (e) => {
        e.preventDefault();

        const tipoId = document.getElementById('tipo_identificacion').value;
        const numId = document.getElementById('numero_identificacion').value;

        const formData = {
            per_nombre: document.getElementById('per_nombre').value,
            per_direccion: document.getElementById('per_direccion').value,
            per_identificacion: `${tipoId}-${numId}`,
            pen_segundo_nombre: document.getElementById('pen_segundo_nombre').value,
            pen_primer_apellido: document.getElementById('pen_primer_apellido').value,
            pen_segundo_apellido: document.getElementById('pen_segundo_apellido').value,
            pen_fecha_nac: document.getElementById('pen_fecha_nac').value,
            fk_lugar: document.getElementById('createParroquia').value,
            usu_nombre: document.getElementById('usu_nombre').value,
            usu_contrasena: document.getElementById('usu_contrasena').value,
            cli_monto_acreditado: parseFloat(document.getElementById('cli_monto_acreditado').value)
        };

        try {
            const response = await fetch(registrationUrl, {
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