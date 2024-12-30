import { Router } from "express";
import { getPersonasNaturales, createPersonaNatural, updatePersonaNatural, deletePersonaNatural } from "../controllers/persona_natural.controller.js";

const router = Router();

router.get("/personasNaturales", getPersonasNaturales);
router.post("/personasNaturales", createPersonaNatural);
router.put("/personasNaturales", updatePersonaNatural);
router.delete("/personasNaturales", deletePersonaNatural);

export default router;
