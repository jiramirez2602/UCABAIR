/*import jasperService from '../services/jasper.service.js';

const jasperController = {
  getReports: async (req, res) => {
    try {
      const reports = await jasperService.getReportList();
      res.json(reports);
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error('Error al obtener la lista de reportes:', error);
      res.status(500).json({ error: 'Error al obtener la lista de reportes' });
    }
  },

  getReport: async (req, res) => {
    try {
      const reportUri = req.params.reportUri;
      const reportData = await jasperService.getReport(reportUri);
      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader('Content-Disposition', `attachment; filename="${reportUri.split('/').pop()}.pdf"`);
      res.send(reportData);
    } catch (error) {
      // eslint-disable-next-line no-console
      console.error('Error al obtener el reporte:', error);
      res.status(500).json({ error: 'Error al obtener el reporte' });
    }
  }
};

export default jasperController;*/