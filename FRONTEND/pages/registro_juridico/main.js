import { setupFormHandler } from './js/formHandler.js';
import { setupLocationHandlers } from './js/locationHandler.js';
import { setupToast } from './js/toastHandler.js';

document.addEventListener('DOMContentLoaded', () => {
    const showToast = setupToast();
    setupLocationHandlers();
    setupFormHandler(showToast);
});