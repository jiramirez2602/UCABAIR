import { Router } from "express";
import { getSolicitudes, createPago } from "../controllers/pago_proveedores.controller.js";

const router = Router();

router.get("/pagoProveedores", getSolicitudes);
router.post("/pagoProveedores", createPago);

export default router;