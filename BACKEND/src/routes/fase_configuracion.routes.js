import { Router } from "express";
import { getFaseConfiguracion, createFaseEjecucion, deleteFaseEjecucion, updateFaseConfiguracion } from "../controllers/fase_configuracion.controller.js";

const router = Router();

router.get("/faseConfiguracion", getFaseConfiguracion);
router.post("/faseConfiguracion", createFaseEjecucion);
router.put("/faseConfiguracion", updateFaseConfiguracion);
router.delete("/faseConfiguracion", deleteFaseEjecucion);

export default router;