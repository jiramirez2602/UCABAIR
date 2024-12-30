import { Router } from "express";
import { getEmpleados, createEmpleado, updateEmpleado, deleteEmpleado } from "../controllers/empleado.controller.js";

const router = Router();

router.get("/empleados", getEmpleados);
router.post("/empleados", createEmpleado);
router.put("/empleados", updateEmpleado);
router.delete("/empleados", deleteEmpleado);

export default router;
