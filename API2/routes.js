import { Router } from "express";
import fetch from "node-fetch";

const make_post_promisse = (url, body) => {
    return new Promise((resolve, reject) => {

        const request_info = {
            method: "POST",

            body: JSON.stringify(body),

            headers: {
                "Content-type": "application/json; charset=UTF-8"
            }
        }
        console.log(request_info.body);
        fetch(url, request_info)
            .then(response => response.json())
            .then(data => resolve(data));

    });
};

const router = Router();


router.post("/register_item", (req, res) => {
    // const body = {
    //     name: "API2",
    //     price: "API2",
    //     description: "API2",
    //     img_link: "API2"
    // };
    
    const body = req.body;

    make_post_promisse("http://localhost:8001/register_item", body)

    return res.status(200).json({
        "msg": "Registro de item encaminhado para o banco de dados"
    });
});

export { router };
