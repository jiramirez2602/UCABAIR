import { Router } from "express";
import { registrarClienteNatural, registrarClienteJuridico } from "../controllers/registro.controller.js";

const router = Router();

router.post("/registrar/cliente/natural", registrarClienteNatural);
router.post("/registrar/cliente/juridico", registrarClienteJuridico);

export default router;
