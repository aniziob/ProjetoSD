import express from 'express';
import path from 'path';

// // Gambiarra pra usar __dirname
import { fileURLToPath  } from 'url';
const __dirname = path.dirname(fileURLToPath(import.meta.url));

const routes = express.Router();

//Rotas
routes.get('/itemRegister', function(req, res){
    res.sendFile(path.join(__dirname,"pages/index.html"));
});

routes.get('/okScreen', function(req, res){
    res.sendFile(path.join(__dirname,"pages/okScreen.html"));
});

export { routes };
