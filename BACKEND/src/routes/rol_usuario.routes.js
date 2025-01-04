import { Router } from 'express';
import {
  getUsuarioRoles,
  createUsuarioRol,
  updateUsuarioRol,
  deleteUsuarioRol
} from '../controllers/rol_usuario.controller.js';

const router = Router();

router.get('/usuario_rol', getUsuarioRoles);
router.post('/usuario_rol', createUsuarioRol);
router.put('/usuario_rol', updateUsuarioRol);
router.delete('/usuario_rol', deleteUsuarioRol);

export default router;
