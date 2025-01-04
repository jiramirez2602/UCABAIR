import { Router } from 'express';
import {
  getCargoFase,
  createCargoFase,
  updateCargoFase,
  deleteCargoFase
} from '../controllers/cargo_fase.controller.js';

const router = Router();

router.get('/cargo_fase', getCargoFase);
router.post('/cargo_fase', createCargoFase);
router.put('/cargo_fase', updateCargoFase);
router.delete('/cargo_fase', deleteCargoFase);

export default router;
