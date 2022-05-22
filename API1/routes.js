import { Router } from "express";


const router = Router();

// Banco de dados na perpectiva de um usuário
var name = [];
var price = [];
var description = [];
var img_link = [];
var ids = [];
var is_buyed = [];
var quantity_purchased = [];

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
    return res.json(body);
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
    
    // return res.status(200);
    return res.status(200).json({
        "msg": "Registro feito com sucesso!"
    });
});


// Modifica um atributo de um item no banco de dados
router.post("/buy_itens", (req, res) => {
    const buyed_ids = req.body.ids;
    const quantitys = req.body.quantitys;

    console.log(buyed_ids);
    console.log(quantitys);

    // function setIsBuyedAndQty(id, qty) {
    //     is_buyed[id] = true;
    //     quantity_purchased[id] = qty;
    // };
    // function setQuantitys(qty) {
    //     quantity_purchased[id] = qty;
    // };
    // buyed_ids.forEach(setIsBuyedAndQty);
    for (let i = 0; i < buyed_ids.length; i++) {
        
        const  id = buyed_ids[i];

        is_buyed[id] = true;
        quantity_purchased[id] = quantitys[i];
    }

    return res.status(200).json({
        "msg": "Itens comprados com sucesso!"
    });
});


export { router };
