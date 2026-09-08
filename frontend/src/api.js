// Detecta la URL base definida en .env o usa localhost por defecto
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://192.168.1.42:8080';

export default API_BASE_URL;