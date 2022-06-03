const nameInput = document.getElementById("name");
const price = document.getElementById("price");
const description = document.getElementById("description");
const imageLink = document.getElementById("imageLink");
const button = document.getElementById("submit");




function make_post_promisse (url, body) {
    return new Promise((resolve, reject) => {

        const request_info = {
            method: "POST",

            body: JSON.stringify(body),

            headers: {
                "Content-type": "application/json; charset=UTF-8",
                "Access-Control-Allow-Origin": '*',
                "Access-Control-Allow-Credentials": 'true'
            }
        }
        console.log(request_info.body);
        fetch(url, request_info)
            .then(response => response.json())
            .then(data => resolve(data));

    });
};



const make_get_promise = (url) => {
    return new Promise((resolve, reject) => {
        fetch(url)
            .then(response => {
                return response.json()
            })
            .then(data => {
                return resolve(data)
            });
    });
}



function makeButtonClickable() {

    // Adiciona iteratividade no botão -
    $('.minus-btn').on('click', function(e) {
        e.preventDefault();
        var $this = $(this);
        var $input = $this.closest('div').find('input');
        var value = parseInt($input.val());
        
        if (value > 1) {
            value = value - 1;
        } else {
            value = 0;
        }
        
        $input.val(value);
    });
    
    // Adiciona iteratividade no botão +
    $('.plus-btn').on('click', function(e) {
        e.preventDefault();
        var $this = $(this);
        var $input = $this.closest('div').find('input');
        var value = parseInt($input.val());
        
        if (value < 100) {
            value = value + 1;
        } else {
            value =100;
        }
        
        $input.val(value);
    });
    
    // Adiciona iteratividade no botão add-cart
    $('.add-cart-btn').on('click', async function(e) {
        const tagInput = document.getElementById(`qty-input-${e.target.id}`);

        const url = "http://localhost:8001/buy_itens";
        const body = {
            ids: [e.target.id],
            quantities: [tagInput.value]
        };
        // console.log(e.target.id)
        await make_post_promisse(url, body); // Faz a requisição de compra dos itens

        // Mostrar itens comprados
        const itens = await make_get_promise("http://localhost:8001/buy_item");
        var html = "";
        itens.id.filter(id => itens.is_buyed[id]).forEach(item_id => {
            html += 
            `<div class="item">
                <div class="description">
                    <span>${itens.name[item_id]}</span>
                </div>

                <div class="image">
                    <img src= "${itens.img_link[item_id]}" alt="">
                </div>

                <div class="description">
                    <span>${itens.description[item_id]}</span>
                </div>

                <div class="quantity">
                    <input id="qty-input" type="text" name="name" value="${itens.quantity_purchased[item_id]}">
                </div>

                <div class="total-price">Final price: R$:${itens.price[item_id]*itens.quantity_purchased[item_id]}</div>
            </div>`
        });
        const tagItens = document.getElementById("buyed-itens");
        tagItens.innerHTML = html;
    });
}



async function getItens(callback_function) {
  const itens = await make_get_promise("http://localhost:8001/buy_item");
  var html = "";
  itens.id.forEach(item_id => {
    html += 
    `<div class="item">
        <div class="buttons">
            <span id="${item_id}" class="add-cart-btn"></span>
        </div>

        <div class="description">
            <span>${itens.name[item_id]}</span>
        </div>

        <div class="image">
            <img src= "${itens.img_link[item_id]}" alt="">
        </div>

        <div class="description">
            <span>${itens.description[item_id]}</span>
        </div>

        <div class="quantity">
            <button class="plus-btn" type="button" name="button">
                <img src="../img/plus.svg" alt="">
            </button>
            <input id="qty-input-${item_id}" type="text" name="name" value="1">
            <button class="minus-btn" type="button" name="button">
                <img src="../img/minus.svg" alt="">
            </button>
        </div>

        <div class="total-price">
            <p>Price(per unit)</p>
            <span>R$:${itens.price[item_id]}</span>
        </div>
    </div>`
  });
  const tagItens = document.getElementById("itens");
  tagItens.innerHTML = html;

  callback_function();
}

const callback = makeButtonClickable;
getItens(callback);


