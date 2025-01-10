import { Router } from "express";
import { getMetodoPago } from "../controllers/metodo_pago.controller.js";

const router = Router();

router.get("/metodoPago", getMetodoPago);

export default router;