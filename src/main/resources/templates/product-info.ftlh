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
            <div class="info-item product-item-name">
                ${product.title}
            </div>
            <div class="info-item product-item-amount">
                Наличие: ${product.amount}
            </div>
            <div class="info-item product-item-price">
                ${product.price} ₽
            </div>

            <form action="/cart/addFromProduct/${product.id}" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <button type="submit" class="add-to-cart-btn">
                    <img src="../../static/images/cart.png" />
                    <span>В корзину</span>
                </button>
            </form>

            <#if user.isAdmin()>
                <form class="delete-product" action="/Product/delete/${product.id}" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                    <input class="delete-btn hover" type="submit" value="Удалить товар"/>
                </form>
            </#if>

            <div class="product-details-box">
                <button class="btn btn-details" type="button" style="margin:10px 0;">
                    <span class="btn-details-name">Характеристики</span>
                    <img class="btn-details-action" src="../static/images/arrow.svg"/>
                </button>

                <div class="product-details" style="display:none;">
                    <div class="info-item info-item-border">
                        <b class="info-item-name">Производитель</b>${product.manufacturer}
                    </div>
                    <div class="info-item info-item-border">
                        <b class="info-item-name">Описание товара</b>${product.description}
                    </div>
                    <div class="info-item none-info info-item-border" id="socket">
                        <b class="info-item-name">Сокет</b>${productCompatibility.socket}
                    </div>
                    <div class="info-item none-info info-item-border" id="ddr">
                        <b class="info-item-name">DDR</b>${productCompatibility.ddr}
                    </div>
                    <div class="info-item none-info info-item-border" id="gddr">
                        <b class="info-item-name">GDDR</b>${productCompatibility.gddr}
                    </div>
                    <div class="info-item none-info info-item-border" id="format">
                        <b class="info-item-name">Формат</b>${productCompatibility.format}
                    </div>
                </div>
            </div>
<#--            <div class="product-buttons">-->
<#--                <form action="/cart/addFromProduct/${product.id}" method="post">-->
<#--                    <input type="hidden" name="_csrf" value="${_csrf.token}">-->
<#--                    <button type="submit" class="add-to-cart-btn">-->
<#--                        <img src="../../static/images/cart.png" />-->
<#--                        <span>В корзину</span>-->
<#--                    </button>-->
<#--                </form>-->

<#--                <#if user.isAdmin()>-->
<#--                    <form class="delete-product" action="/Product/delete/${product.id}" method="post">-->
<#--                        <input type="hidden" name="_csrf" value="${_csrf.token}">-->
<#--                        <input class="delete-btn hover" type="submit" value="Удалить товар"/>-->
<#--                    </form>-->
<#--                </#if>-->
<#--            </div>-->
        </div>
    </div>
    <div class="reviews-section">
        <div class="user-review">
            <h3 class="reviews-sub">Отзывы</h3>
            <#if user??>
                <form class="review-form" action="/Product/${product.id}/review"  method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                    <div class="set-stars-row">
                        <label for="rating">Ваша оценка:</label>
                        <div class="stars">
                            <#list 5..1 as i>  <!-- меняем порядок -->
                                <input type="radio" id="star${i}" name="rating" value="${i}" required>
                                <label for="star${i}">★</label>
                            </#list>
                        </div>
                    </div>
                    <textarea name="comment" maxlength="350" required placeholder="Ваш отзыв (до 350 символов)"></textarea>
                    <button type="submit" class="send-btn">Оставить отзыв</button>
                </form>
            <#else>
                <div>Для отправки отзыва <a href="/login">войдите</a> на сайт</div>
            </#if>
        </div>
        <div class="reviews-list">
            <#if reviews?size == 0>
                <div>Нет отзывов</div>
            <#else>
                <#list reviews as review>
                    <div class="review-block">
                        <div class="review-author">
                            <div class="review-author-avatar">${review.author.name[0]?upper_case}</div>
                            <b>${review.author.name}</b>
                            <span>
                                <#list 1..review.rating as _>★</#list>
                            </span>
                        </div>
                        <p class="review-date">${review.getFormattedCreatedDate()}</p>
                        <div>${review.comment}</div>
                    </div>
                </#list>
            </#if>
        </div>
    </div>

    <script>
        // Слайдер картинок
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

        // document.addEventListener('DOMContentLoaded', function() {
            const left = document.querySelector(".info-arr-left");
            const right = document.querySelector(".info-arr-right");
            // const button = document.querySelector(".buy-btn");
            const detailsBtn = document.querySelector(".btn-details");
            const detailsBox = document.querySelector(".product-details");
            const detailsArrow = document.querySelector(".btn-details-action")

            left.addEventListener("click", () => { sliderLeft(); })
            right.addEventListener("click", () => { sliderRight(); })

            <#--button.addEventListener("click", () => {-->
            <#--    const messageText = "Здравствуйте! Я хочу приобрести товар ${product.title}%0AАртикул: ${product.id}";-->
            <#--    window.open("https://t.me/hxxdrichXD?text=" + messageText);-->
            <#--})-->

            // Показать/скрыть характеристики
            detailsBtn.addEventListener("click", function() {
                if (detailsBox.style.display === "none" || detailsBox.style.display === "") {
                    detailsBox.style.display = "block";
                    // detailsBtn.textContent = "Скрыть";
                    detailsArrow.setAttribute('style', "transform: rotate(270deg);")
                } else {
                    detailsBox.style.display = "none";
                    // detailsBtn.textContent = "Подробнее";
                    detailsArrow.setAttribute('style', "transform: rotate(90deg);")
                }
            });

            // Включаем нужные поля совместимости
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
                case "CASE":
                    document.getElementById("format").classList.remove("none-info");
                    break;
            }
        // });
    </script>
</@t.template>
