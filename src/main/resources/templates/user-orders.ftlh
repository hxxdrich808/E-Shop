<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1>Заказы пользователя #${userId}</h1>

    <#list orders as order>
        <div class="order-block">
            <p>ID: ${order.id}</p>
            <p>Дата: ${order.date?string("dd.MM.yyyy HH:mm")}</p>
            <p>Сумма: ${order.totalPrice} ₽</p>
            <p><strong>Текущий статус:</strong> <span class="status">${order.status}</span></p>

            <form action="/orders/updateStatus" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <input type="hidden" name="orderId" value="${order.id}" />

                <label for="status-${order.id}">Статус:</label>
                <select name="status" id="status-${order.id}">
                    <#list statuses as st>
                        <option value="${st}" <#if order.status == st>selected</#if>>
                            ${st.displayName}
                        </option>
                    </#list>
                </select>

                <button type="submit" class="hover">Обновить статус</button>
            </form>
        </div>
    </#list>

    <a href="/admin" class="btn hover">Назад</a>
</@t.template>
