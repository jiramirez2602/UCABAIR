import { Router } from "express";
import { getTipoPieza} from "../controllers/tipo_pieza.controller.js";

const router = Router();

router.get("/tipoPieza", getTipoPieza);

export default router;