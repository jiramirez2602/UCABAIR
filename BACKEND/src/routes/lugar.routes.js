import { Router } from "express";
import { getLugares } from "../controllers/lugar.controller.js";

const router = Router();

router.get("/lugar", getLugares);

export default router;