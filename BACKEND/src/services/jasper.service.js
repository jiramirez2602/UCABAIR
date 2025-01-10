/*import axios from 'axios';

const jasperServerUrl = 'http://localhost:8080/jasperserver-pro/';
const jasperServerUser = 'jasperadmin';
const jasperServerPassword = 'jasperadmin';

const jasperService = {
  getReportList: async () => {
    try {
      const response = await axios.get(`${jasperServerUrl}/rest_v2/resources`, {
        params: {
          type: 'reportUnit',
          folderUri: '/reports'
        },
        auth: {
          username: jasperServerUser,
          password: jasperServerPassword
        }
      });
      return response.data.resourceLookup;
    } catch (error) {
      console.error('Error en el servicio al obtener la lista de reportes:', error);
      throw error;
    }
  },

  getReport: async (reportUri) => {
    try {
      const response = await axios.get(`${jasperServerUrl}/rest_v2/reports${reportUri}`, {
        params: {
          outputFormat: 'pdf'
        },
        responseType: 'arraybuffer',
        auth: {
          username: jasperServerUser,
          password: jasperServerPassword
        }
      });
      return response.data;
    } catch (error) {
      console.error('Error en el servicio al obtener el reporte:', error);
      throw error;
    }
  }
};

export default jasperService;*/