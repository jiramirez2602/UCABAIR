import { Router } from "express";
import { getModeloAviones, createModeloAvion, updateModeloAvion, deleteModeloAvion } from "../controllers/modelo_avion.controller.js";

const router = Router();

router.get("/modeloAviones", getModeloAviones);
router.post("/modeloAviones", createModeloAvion);
router.put("/modeloAviones", updateModeloAvion);
router.delete("/modeloAviones", deleteModeloAvion);

export default router;