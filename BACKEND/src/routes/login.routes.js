import { Router } from "express";
import { getPrivilegios} from "../controllers/login.controller.js";

const router = Router();

router.get("/login", getPrivilegios);

export default router;