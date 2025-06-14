<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1>Корзина</h1>

    <#if cart.items?size gt 0>
        <table>
            <thead>
            <tr>
                <th>Товар</th>
                <th>Цена</th>
                <th>Количество</th>
                <th>Сумма</th>
                <th>Действия</th>
            </tr>
            </thead>
            <tbody>
            <#list cart.items as item>
                <tr>
                    <td>${item.product.title}</td>
                    <td>${item.product.price} ₽</td>
                    <td>${item.quantity}</td>
                    <td>${item.product.price * item.quantity} ₽</td>
                    <td>
                        <form action="/cart/increment/${item.product.id}" method="post" style="display:inline;">
                            <input type="hidden" name="_csrf" value="${_csrf.token}">
                            <button type="submit">+</button>
                        </form>

                        <form action="/cart/decrement/${item.product.id}" method="post" style="display:inline;">
                            <input type="hidden" name="_csrf" value="${_csrf.token}">
                            <button type="submit">-</button>
                        </form>

                        <form action="/cart/remove/${item.product.id}" method="post" style="display:inline;">
                            <input type="hidden" name="_csrf" value="${_csrf.token}">
                            <button type="submit">Удалить</button>
                        </form>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>

        <h3>Итого: ${totalPrice} ₽</h3>

        <form action="/order/create" method="post" style="max-width: 420px; margin-top: 28px;">
            <input type="hidden" name="_csrf" value="${_csrf.token}">

            <label>ФИО:<br>
                <input type="text" name="customerFullName" required placeholder="Введите ФИО">
            </label><br><br>

            <label>Телефон:<br>
                <input type="tel" name="customerPhone" required placeholder="8XXXXXXXXXX">
            </label><br><br>

            <label>Адрес доставки:<br>
                <input type="text" name="address" required minlength="7"
                       pattern=".{7,}" placeholder="Москва, ул. Ленина 13">
                <small>Формат: Город, улица и номер дома (например, Москва, ул. Ленина 13)</small>
            </label><br><br>

            <label>Почтовый индекс:<br>
                <input type="text" name="postalCode" required placeholder="101000">
            </label><br><br>

            <button type="submit" class="btn hover">Оформить заказ</button>
        </form>

    <#else>
        <h3>Корзина пуста</h3>
    </#if>
</@t.template>
