    <#import "blocks/template.ftlh" as t>
    <@t.template user>
        <h4 class="info-sub">Подробная информация о товаре</h4>
        <div class="info-row">
            <div class="info-slider">
                <img class="info-arr-left" src="../static/images/arrow.svg">
                <#list images as img>
                    <div class="info-img-box" style="background-image: url('/images/${img.id}')"></div>
                </#list>
                <img class="info-arr-right" src="../static/images/arrow.svg">
            </div>
            <div class="info-box">
                <div class="info-item">
                    <b>Название товара: </b>${product.title}
                </div>
                <div class="info-item">
                    <b>Производитель: </b>${product.manufacturer}
                </div>
                <div class="info-item">
                    <b>Наличие: </b>${product.amount}
                </div>
                <div class="info-item">
                    <b>Описание товара: </b>${product.description}
                </div>
                <div class="info-item none-info" id="socket">
                    <b>Сокет: </b>${productCompatibility.socket}
                </div>
                <div class="info-item none-info" id="ddr">
                    <b>DDR: </b>${productCompatibility.ddr}
                </div>
                <div class="info-item none-info" id="gddr">
                    <b>GDDR: </b>${productCompatibility.gddr}
                </div>
                <div class="info-item none-info" id="format">
                    <b>Формат: </b>${productCompatibility.format}
                </div>
                <div class="info-item">
                    <b>Цена товара: </b>${product.price} ₽
                </div>
                <button class="buy-btn hover">Купить</button>
                <#if user.isAdmin()>
                    <form class="delete-product" action="/Product/delete/${product.id}" method="post">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <input class="delete-btn hover" type="submit" value="Удалить товар"/>
                    </form>
                </#if>
            </div>
        </div>
        <script>
            const sliderLeft = () => {
                const images = document.getElementsByClassName("info-img-box");
                let index;
                for (let i = 0; i < images.length; i++) {
                    if (!images[i].classList.contains("None")) {
                        index = i;
                        images[i].classList.add("None");
                    }
                }
                if (images[index - 1]) {
                    images[index - 1].classList.remove("None");
                } else {
                    images[images.length - 1].classList.remove("None");
                }
            }

            const sliderRight = () => {
                const images = document.getElementsByClassName("info-img-box");
                let index;
                for (let i = 0; i < images.length; i++) {
                    if (!images[i].classList.contains("None")) {
                        index = i;
                        images[i].classList.add("None");
                    }
                }
                if (images[index + 1]) images[index + 1].classList.remove("None");
                else images[0].classList.remove("None");
            }

            const images = document.getElementsByClassName("info-img-box");
            for (let i = 1; i < images.length; i++) {
                images[i].classList.add("None");
            }

            document.addEventListener('DOMContentLoaded', function() {
                const left = document.querySelector(".info-arr-left");
                const right = document.querySelector(".info-arr-right");
                const button = document.querySelector(".buy-btn");

                left.addEventListener("click", () => {
                    sliderLeft();
                })

                right.addEventListener("click", () => {
                    sliderRight();
                })

                button.addEventListener("click", () => {
                    const messageText = "Здравствуйте! Я хочу приобрести товар ${product.title}%0AАртикул: ${product.id}";
                    window.open("https://t.me/hxxdrichXD?text=" + messageText);
                })

                switch ("${product.productType}") {
                    case "CPU":
                        document.getElementById("socket").classList.remove("none-info");
                        break;

                    case "MOTHERBOARD":
                        document.getElementById("socket").classList.remove("none-info");
                        document.getElementById("ddr").classList.remove("none-info");
                        document.getElementById("gddr").classList.remove("none-info");
                        document.getElementById("format").classList.remove("none-info");
                        break;

                    case "RAM":
                        document.getElementById("ddr").classList.remove("none-info");
                        break;

                    case "GPU":
                        document.getElementById("gddr").classList.remove("none-info");
                        break;

                    case "PSU":
                        document.getElementById("format").classList.remove("none-info");
                        break;

                    case "CASE":
                        document.getElementById("format").classList.remove("none-info");
                        break;
                }
            });
        </script>
    </@t.template>
