import { routes } from "./routes.js"
import express from "express"
//const pagamento = require("./models/Pagamento")

// // Gambiarra pra usar __dirname
import path from 'path';
import { fileURLToPath  } from 'url';
const __dirname = path.dirname(fileURLToPath(import.meta.url));

const app = express();

app.use('/', express.static(__dirname))
app.use(express.json())
app.use(routes)

//Rotas
app.get('/cad-pagamento', function(req, res){
    res.render('cad-pagamento');
});

app.post('/add-pagamento', function(req, res){
    pagamento.create({
        nome: req.body.nome,
        valor: req.body.valor
    }).then(function(){
        res.redirect('/pagamento')
        //res.send("Pagamento cadastro com sucesso!")
    }).catch(function(erro){
        res.send("Erro: Pagamento não foi cadastrado com sucesso!" + erro)
    })
    //res.send("Nome: " + req.body.nome + "<br>Valor: " + req.body.valor + "<br>") 
})

app.listen(3333, () => console.log("Server is running!"))