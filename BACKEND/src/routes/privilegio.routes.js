import { Router } from 'express';
import { getPrivilegios } from '../controllers/privilegio.controller.js';

const router = Router();

router.get('/privilegios', getPrivilegios);

export default router;
