import express from "express";
import modeloAvionRoutes from "./routes/modelo_avion.routes.js";
import pruebaRouter from './routes/prueba.routes.js'; 
import tipoPiezaRouter from './routes/tipo_pieza.routes.js'; 
import lugarRouter from './routes/lugar.routes.js'; 
import personaNaturalRouter from './routes/persona_natural.routes.js'; 
import empleadoRouter from './routes/empleado.routes.js'; 
import personaJuridicaRouter from './routes/persona_juridica.routes.js'; 
import loginRouter from './routes/login.routes.js'; 
import registroRouter from './routes/registro.routes.js'; 
import rolRouter from './routes/rol.routes.js'; 
import usuarioRouter from './routes/usuario.routes.js'; 
import rolUsuarioRouter from './routes/rol_usuario.routes.js'; 
import privilegioRouter from './routes/privilegio.routes.js'; 
import privilegioRolRouter from './routes/rol_privilegio.routes.js';
import faseConfiguracionRouter from './routes/fase_configuracion.routes.js'; 
import tipoPiezaFase from './routes/tipo_pieza_fase.routes.js'; 
import tipoMaquinaria from './routes/tipo_maquinaria.routes.js';
import tipoMaquinariaFase from './routes/tipo_maquinaria_fase.routes.js';
import cargos from './routes/cargo.routes.js'; 
import cargoFase from './routes/cargo_fase.routes.js';
import morgan from "morgan";
import { PORT } from "./config.js";
import cors from "cors"; 
import { pool } from "./db.js"; 

const app = express();

app.use(morgan("dev"));

// middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());
app.use((req, res, next) => { res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin'); next(); });

// Función para realizar el test de conexión
async function testDatabaseConnection() {
  const client = await pool.connect();
  try {
    await client.query("SELECT 1");
    // eslint-disable-next-line no-console
    console.log("Test de conexión a la base de datos exitoso");
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error("Error al intentar conectar a la base de datos:", err);
    throw err;
  } finally {
    client.release();  // Liberar la conexión de vuelta al pool
  }
}

// Ejecutar el test de conexión al iniciar el servidor
testDatabaseConnection().then(() => {
  // Rutas
  app.use(loginRouter); 
  app.use(registroRouter); 
  app.use(modeloAvionRoutes);
  app.use(pruebaRouter);
  app.use(tipoPiezaRouter);
  app.use(lugarRouter);
  app.use(personaNaturalRouter);
  app.use(empleadoRouter);
  app.use(personaJuridicaRouter);  
  app.use(rolRouter);  
  app.use(usuarioRouter);  
  app.use(rolUsuarioRouter);  
  app.use(privilegioRouter);  
  app.use(privilegioRolRouter);  
  app.use(faseConfiguracionRouter);
  app.use(tipoPiezaFase);
  app.use(tipoMaquinaria);
  app.use(tipoMaquinariaFase);
  app.use(cargos);
  app.use(cargoFase);

  app.listen(PORT, () => {
    // eslint-disable-next-line no-console
    console.log("Server on port", PORT);
  });
}).catch((err) => {
    // eslint-disable-next-line no-console
  console.error("No se pudo establecer la conexión a la base de datos. El servidor no se iniciará.", err);
  process.exit(1); // Salir del proceso con un error
});
