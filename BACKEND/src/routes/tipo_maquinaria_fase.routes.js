import { Router } from 'express';
import {
  getTipoMaquinariaFase,
  createTipoMaquinariaFase,
  updateTipoMaquinariaFase,
  deleteTipoMaquinariaFase
} from '../controllers/tipo_maquinaria_fase.controller.js';

const router = Router();

router.get('/tipo_maquinaria_fase', getTipoMaquinariaFase);
router.post('/tipo_maquinaria_fase', createTipoMaquinariaFase);
router.put('/tipo_maquinaria_fase', updateTipoMaquinariaFase);
router.delete('/tipo_maquinaria_fase', deleteTipoMaquinariaFase);

export default router;
