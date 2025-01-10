document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('reportForm');
    const messageDiv = document.getElementById('message');
    const reportSelect = document.getElementById('reportSelect');

    // Cargar la lista de reportes al iniciar
    loadReportList();

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const reportUri = reportSelect.value;
        if (reportUri) {
            downloadReport(reportUri);
        } else {
            messageDiv.innerHTML = '<div class="alert alert-warning">Por favor, seleccione un reporte.</div>';
        }
    });

    async function loadReportList() {
        try {
            const response = await fetch('/api/jasper/reports');
            if (!response.ok) {
                throw new Error('Failed to fetch report list');
            }
            const reports = await response.json();
            reportSelect.innerHTML = '<option value="">Seleccione un reporte</option>';
            reports.forEach(report => {
                const option = document.createElement('option');
                option.value = report.uri;
                option.textContent = report.label;
                reportSelect.appendChild(option);
            });
        } catch (error) {
            console.error('Error:', error);
            messageDiv.innerHTML = '<div class="alert alert-danger">Error al cargar la lista de reportes.</div>';
        }
    }

    async function downloadReport(reportUri) {
        messageDiv.innerHTML = '<div class="alert alert-info">Generando reporte...</div>';

        try {
            const response = await fetch(`/api/jasper/report${reportUri}`);
            if (!response.ok) {
                throw new Error('Failed to generate report');
            }
            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            a.download = `${reportUri.split('/').pop()}_report.pdf`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);

            messageDiv.innerHTML = '<div class="alert alert-success">Reporte descargado exitosamente!</div>';
        } catch (error) {
            console.error('Error:', error);
            messageDiv.innerHTML = '<div class="alert alert-danger">Error al descargar el reporte. Por favor, intente de nuevo.</div>';
        }
    }
});