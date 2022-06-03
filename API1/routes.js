import { Router } from "express";


const router = Router();

const url_teste = "https://m.media-amazon.com/images/I/51aI1NrfVHL._AC_SX679_.jpg"


// Banco de dados para apenas um usuário
// Array de itens
var name = ["Remédio 1", "Remédio 2"];
var price = [1.0, 2.0];
var description = ["Medicamento 1 (totalmente não NFT)", "Medicamento 2"];
var img_link = [url_teste, url_teste];
var ids = [0, 1];
var is_buyed = [false, false];
var quantity_purchased = [0, 0];

var next_id = ids.length;


// Retorna banco de dados inteiro
router.get("/buy_item",(req, res) =>{
    var body = {
        "id": ids,
        "name": name,
        "price": price,
        "description": description,
        "img_link": img_link,
        "is_buyed": is_buyed,
        "quantity_purchased": quantity_purchased,
    };
    return res.status(200).json(body);
})


// Registra um item no banco de dados
router.post("/register_item", (req, res) => {
    const body = req.body;
    console.log(req.body);
    
    // Coloca dentro do array as informações da requisição
    ids.push(next_id);
    name.push(body.name);
    price.push(body.price);
    description.push(body.description);
    img_link.push(body.img_link);
    is_buyed.push(false);
    quantity_purchased.push(0);

    next_id += 1;
    
    return res.status(200).json({
        "msg": "Registro feito com sucesso!"
    });
});


// Modifica um atributo de um item no banco de dados
router.post("/buy_itens", (req, res) => {
    const buyed_ids = req.body.ids;
    const quantities = req.body.quantities;

    console.log(`ids: ${buyed_ids}`);
    console.log(`quantities: ${quantities}`);

    // function setIsBuyedAndQty(id, qty) {
    //     is_buyed[id] = true;
    //     quantity_purchased[id] = qty;
    // };
    // function setQuantities(qty) {
    //     quantity_purchased[id] = qty;
    // };
    // buyed_ids.forEach(setIsBuyedAndQty);
    for (let i = 0; i < buyed_ids.length; i++) {
        
        // id do item atual que vai ser modificado
        const id = buyed_ids[i];

        // modifica o item com id = buyed_ids[i]
        is_buyed[id] = true;
        quantity_purchased[id] = quantities[i];
    }

    return res.status(200).json({
        "msg": "Itens comprados com sucesso!"
    });
});


export { router };
