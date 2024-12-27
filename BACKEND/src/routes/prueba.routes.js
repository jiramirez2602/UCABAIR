import { Router } from "express";
import { getPrueba, createPrueba, updatePrueba, deletePrueba } from "../controllers/prueba.controller.js";

const router = Router();

router.get("/prueba", getPrueba);
router.post("/prueba", createPrueba);
router.put("/prueba", updatePrueba);
router.delete("/prueba", deletePrueba);

export default router;