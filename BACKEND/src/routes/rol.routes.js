import express from 'express';
import {
  getRoles,
  createRol,
  updateRol,
  deleteRol
} from '../controllers/rol.controller.js';

const router = express.Router();

// Rutas para CRUD de ROL
router.get('/roles', getRoles);
router.post('/roles', createRol);
router.put('/roles', updateRol);
router.delete('/roles', deleteRol);

export default router;
