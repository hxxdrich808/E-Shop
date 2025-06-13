<#import "blocks/template.ftlh" as t>
<@t.template user>

    <h1 class="profile-sub">Мои заказы</h1>

    <#if orders?size == 0>
        <p>У вас пока нет заказов.</p>
    <#else>
        <#list orders as order>
            <div class="order-block">
                <p>Заказ #${order.id}</p>
                <p>Дата: ${order.date?string("dd.MM.yyyy HH:mm")}</p>
                <p>Сумма: ${order.totalPrice} ₽</p>
                <p>Статус: ${order.status}</p>

                <hr/>
            </div>
        </#list>
    </#if>

    <a class="btn hover" href="/profile">Назад</a>

</@t.template>
