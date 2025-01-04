import { Router } from 'express';
import {
  getRolPrivilegios,
  createRolPrivilegio,
  updateRolPrivilegio,
  deleteRolPrivilegio
} from '../controllers/rol_privilegio.controller.js';

const router = Router();

router.get('/rol_privilegio', getRolPrivilegios);
router.post('/rol_privilegio', createRolPrivilegio);
router.put('/rol_privilegio', updateRolPrivilegio);
router.delete('/rol_privilegio', deleteRolPrivilegio);

export default router;
