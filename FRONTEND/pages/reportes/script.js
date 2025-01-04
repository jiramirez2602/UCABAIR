document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('reportForm');
    const messageDiv = document.getElementById('message');

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        const reportType = document.getElementById('reportType').value;
        downloadReport(reportType);
    });

    async function downloadReport(reportType) {
        messageDiv.innerHTML = '<div class="alert alert-info">Generating report...</div>';

        try {
            // Simulating an API call to Jasper Reports server
            const response = await fetch(`https://your-jasper-server.com/api/reports/${reportType}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer YOUR_API_TOKEN'
                },
                body: JSON.stringify({ format: 'pdf' })
            });

            if (!response.ok) {
                throw new Error('Failed to generate report');
            }

            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            a.download = `${reportType}_report.pdf`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);

            messageDiv.innerHTML = '<div class="alert alert-success">Report downloaded successfully!</div>';
        } catch (error) {
            console.error('Error:', error);
            messageDiv.innerHTML = '<div class="alert alert-danger">Failed to download report. Please try again.</div>';
        }
    }
});