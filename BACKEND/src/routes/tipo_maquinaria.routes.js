import { Router } from "express";
import { getTipoMaquinaria } from "../controllers/tipo_maquinaria.controller.js";

const router = Router();

router.get("/tipoMaquinaria", getTipoMaquinaria);

export default router;