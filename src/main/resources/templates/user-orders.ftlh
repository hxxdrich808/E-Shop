<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1>Заказы пользователя #${userId}</h1>

    <#list orders as order>
        <div class="order-block">
            <p>ID заказа: ${order.id}</p>
            <p>Дата: ${order.formattedDate}</p>
            <p>Сумма: ${order.totalPrice} ₽</p>
            <p>Текущий статус: <b>${order.status}</b></p>

            <form action="/orders/updateStatus" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <input type="hidden" name="orderId" value="${order.id}" />

                <label for="status-${order.id}">Изменить статус:</label>
                <select name="status" id="status-${order.id}">
                    <#list statuses as st>
                        <option value="${st}" <#if order.status == st>selected</#if>>${st}</option>
                    </#list>
                </select>

                <button type="submit" class="hover">Обновить статус</button>
            </form>
        </div>
        <hr>
    </#list>

    <a href="/admin" class="btn hover">Назад в админку</a>
</@t.template>
