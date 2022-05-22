import { router } from './routes.js';

import express from 'express';
import cors from 'cors';
// import bodyParser from 'body-parser';


const app = express();
app.use( cors() );
app.use( express.json() );
app.use( router );
// app.use(bodyParser.json());



app.listen(8001, () => {
    console.log("Servidor Iniciado na porta 8001: http://localhost:8001");
})
