import { Router } from 'express';
import {
  getTipoPiezaFase,
  createTipoPiezaFase,
  updateTipoPiezaFase,
  deleteTipoPiezaFase
} from '../controllers/tipo_pieza_fase.controller.js';

const router = Router();

router.get('/tipo_pieza_fase', getTipoPiezaFase);
router.post('/tipo_pieza_fase', createTipoPiezaFase);
router.put('/tipo_pieza_fase', updateTipoPiezaFase);
router.delete('/tipo_pieza_fase', deleteTipoPiezaFase);

export default router;
