import { Router } from 'express';
import {
  getPersonasJuridicas,
  createPersonaJuridica,
  updatePersonaJuridica,
  deletePersonaJuridica,
  getProveedores,
} from '../controllers/persona_juridica.controller.js';

const router = Router();

router.get('/personasJuridicas', getPersonasJuridicas);
router.post('/personasJuridicas', createPersonaJuridica);
router.put('/personasJuridicas', updatePersonaJuridica);
router.delete('/personasJuridicas', deletePersonaJuridica); 
router.get('/proveedores', getProveedores); 

export default router;
