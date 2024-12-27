import express from "express";
import modeloAvionRoutes from "./routes/modelo_avion.routes.js";
import pruebaRouter from './routes/prueba.routes.js'; 
import tipoPiezaRouter from './routes/tipo_pieza.routes.js'; 
import morgan from "morgan";
import { PORT } from "./config.js";
import cors from "cors"; // Configuración de CORS
const app = express();

app.use(morgan("dev"));

// middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());
app.use((req, res, next) => { res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin'); next(); });

// Rutas
app.use(modeloAvionRoutes);
app.use(pruebaRouter);
app.use(tipoPiezaRouter);

app.listen(PORT);
// eslint-disable-next-line no-console
console.log("Server on port", PORT);