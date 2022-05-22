var nameInput = document.getElementById("name")
var price = document.getElementById("price")
var description = document.getElementById("description")
var imageLink = document.getElementById("imageLink")
var button = document.getElementById("submit")

function registerItem(){
    const body = {
        name: nameInput.value,
        price: price.value,
        description: description.value,
        img_link: imageLink.value
    }
    make_post_promisse("http://localhost:8001/register_item", body)
}

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

button.addEventListener("click",registerItem)
