import { Router } from "express";
import { getEmpleadosConUsuarios, createEmpleadoConUsuario, updateEmpleadoConUsuario, deleteEmpleadoConUsuario } from "../controllers/empleado.controller.js";

const router = Router();

router.get("/empleado", getEmpleadosConUsuarios);
router.post("/empleado", createEmpleadoConUsuario);
router.put("/empleado", updateEmpleadoConUsuario);
router.delete("/empleado", deleteEmpleadoConUsuario);

export default router;
