import { router } from './routes.js';
import cors from 'cors';

import express from 'express';

const app = express();
app.use( cors() );
app.use( express.json() );
app.use( router );


app.listen(8002,() =>{
    console.log("Servidor Iniciado na porta 8002: http://localhost:8002");
})
