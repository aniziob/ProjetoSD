var nameInput = document.getElementById("name")
var price = document.getElementById("price")
var description = document.getElementById("description")
var imageLink = document.getElementById("imageLink")
var button = document.getElementById("submit")

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

function makeButtonClickable(){
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
    
    var carrinho = []
    $('.add-cart-btn').on('click', async function(e) {
        const url = "http://localhost:8001/buy_itens"
        const tagInput = document.getElementById(`qty-input-${e.target.id}`)
        const body = {
            ids: [e.target.id],
            quantitys: [tagInput.value]
        }
        // console.log(e.target.id)
        make_post_promisse(url,body)

        // Mostrar itens comprados
        const itens = await make_get_promise("http://localhost:8001/buy_item")
        var html = ""
        itens.id.forEach(element => {
            if(itens.is_buyed[element]){
                html += 
                `<div class="item">
                <div class="description">
                <span>${itens.name[element]}</span>
                </div>

                <div class="image">
                <img src= "${itens.img_link[element]}" alt="">
                </div>

                    <div class="description">
                        <span>${itens.description[element]}</span>
                        </div>

                        <div class="quantity">
                    <input id="qty-input" type="text" name="name" value="${itens.quantity_purchased[element]}">
                    </div>

                    <div class="total-price">Final price: R$:${itens.price[element]*itens.quantity_purchased[element]}</div>
                    </div>`
            }
        });
        const tagItens = document.getElementById("buyed-itens")
        tagItens.innerHTML = html
    });
}

async function getItens(f){
  const itens = await make_get_promise("http://localhost:8001/buy_item")
  var html = ""
  itens.id.forEach(element => {
    html += 
    `<div class="item">
            <div class="buttons">
                <span id="${element}" class="add-cart-btn"></span>
            </div>

            <div class="description">
                <span>${itens.name[element]}</span>
            </div>

            <div class="image">
                <img src= "${itens.img_link[element]}" alt="">
            </div>

            <div class="description">
                <span>${itens.description[element]}</span>
            </div>

            <div class="quantity">
            <button class="plus-btn" type="button" name="button">
                <img src="./pages/plus.svg" alt="">
            </button>
            <input id="qty-input-${element}" type="text" name="name" value="1">
            <button class="minus-btn" type="button" name="button">
                <img src="./pages/minus.svg" alt="">
            </button>
            </div>

            <div class="total-price">Price(per unit): R$:${itens.price[element]}</div>
        </div>`
  });
  const tagItens = document.getElementById("itens")
  tagItens.innerHTML = html
  f()
}

getItens(makeButtonClickable)


