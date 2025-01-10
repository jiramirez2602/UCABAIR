import { Router } from "express";
import { getTasasCambio } from "../controllers/tasa_cambio.controller.js";

const router = Router();

router.get("/tasaCambio", getTasasCambio);

export default router;