<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1>Корзина</h1>

    <#if cart.items?size gt 0>
        <table class="cart-table">
            <thead>
            <tr>
                <th class="cart-th">Товар</th>
                <th class="cart-th">Цена</th>
<#--                <th class="cart-th">Количество</th>-->
                <th class="cart-th">Сумма</th>
                <th class="cart-th">Действия</th>
            </tr>
            </thead>
            <tbody>
            <#list cart.items as item>
                <tr class="cart-row">
                    <td class="cart-td">${item.product.title}</td>
                    <td class="cart-td">${item.product.price} ₽</td>
<#--                    <td class="cart-td">${item.quantity}</td>-->
                    <td class="cart-td">${item.product.price * item.quantity} ₽</td>
                    <td class="cart-td cart-actions">
                        <div class="cart-actions-flex">
                            <form action="/cart/increment/${item.product.id}" method="post">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <button type="submit" class="cart-btn-count plus">+</button>
                            </form>

                            <span>${item.quantity}</span>

                            <form action="/cart/decrement/${item.product.id}" method="post">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <button type="submit" class="cart-btn-count minus">-</button>
                            </form>

                            <form action="/cart/remove/${item.product.id}" method="post">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <button type="submit" class="cart-btn-count remove">Удалить</button>
                            </form>
                        </div>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>

    <#--        <table>-->
<#--            <thead>-->
<#--            <tr>-->
<#--                <th>Товар</th>-->
<#--                <th>Цена</th>-->
<#--                <th>Количество</th>-->
<#--                <th>Сумма</th>-->
<#--                <th>Действия</th>-->
<#--            </tr>-->
<#--            </thead>-->
<#--            <tbody>-->
<#--            <#list cart.items as item>-->
<#--                <tr>-->
<#--                    <td>${item.product.title}</td>-->
<#--                    <td>${item.product.price} ₽</td>-->
<#--                    <td>${item.quantity}</td>-->
<#--                    <td>${item.product.price * item.quantity} ₽</td>-->
<#--                    <td>-->
<#--                        <form action="/cart/increment/${item.product.id}" method="post" style="display:inline;">-->
<#--                            <input type="hidden" name="_csrf" value="${_csrf.token}">-->
<#--                            <button type="submit">+</button>-->
<#--                        </form>-->

<#--                        <form action="/cart/decrement/${item.product.id}" method="post" style="display:inline;">-->
<#--                            <input type="hidden" name="_csrf" value="${_csrf.token}">-->
<#--                            <button type="submit">-</button>-->
<#--                        </form>-->

<#--                        <form action="/cart/remove/${item.product.id}" method="post" style="display:inline;">-->
<#--                            <input type="hidden" name="_csrf" value="${_csrf.token}">-->
<#--                            <button type="submit">Удалить</button>-->
<#--                        </form>-->
<#--                    </td>-->
<#--                </tr>-->
<#--            </#list>-->
<#--            </tbody>-->
<#--        </table>-->

        <h3>Итого: ${totalPrice} ₽</h3>

        <form class="order-box" action="/order/create" method="post">
            <input type="hidden" name="_csrf" value="${_csrf.token}">

            <label class="order-input-label">ФИО:<br>
                <input class="order-input" type="text" name="customerFullName" required placeholder="Введите ФИО">
            </label>

            <label class="order-input-label">Телефон:<br>
                <input class="order-input" type="tel" name="customerPhone" required placeholder="8XXXXXXXXXX">
            </label>

            <label class="order-input-label">Адрес доставки:<br>
                <input class="order-input" type="text" name="address" required minlength="7"
                       pattern=".{7,}" placeholder="Москва, ул. Ленина 13">
                <small>Формат: Город, улица и номер дома (например, Москва, ул. Ленина 13)</small>
            </label>

            <label class="order-input-label">Почтовый индекс:<br>
                <input class="order-input" type="text" name="postalCode" required placeholder="101000">
            </label>

            <button type="submit" class="btn order-btn hover">Оформить заказ</button>
        </form>

    <#else>
        <img class="empty-cart-img" src="../static/images/sad.png" />
        <h3 class="empty-cart-sub">Ваша корзина пуста</h3>
        <p class="empty-cart-par">Перейдите в наш каталог и выберите товары!</p>
        <a href="/" class="cart-products-btn">Перейти в каталог</a>
    </#if>
</@t.template>
