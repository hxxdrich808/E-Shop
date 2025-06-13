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

        <a href="/order/create" class="btn hover">Оформить заказ</a>

    <#else>
        <h3>Корзина пуста</h3>
    </#if>
</@t.template>
