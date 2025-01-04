import { Router } from "express";
import { getCargos } from "../controllers/cargo.controller.js";

const router = Router();

router.get("/cargos", getCargos);

export default router;