// userRouter.js
import { Router } from 'express';
import { getUsuariosSinCliente } from '../controllers/usuario.controller.js';

const router = Router();

router.get('/usuarios', getUsuariosSinCliente);

export default router;
