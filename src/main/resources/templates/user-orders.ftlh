<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 style="margin-bottom:32px;">
        Заказы пользователя #${userId}
    </h1>

    <a href="/admin" class="btn hover" style="margin-bottom: 36px; width: fit-content">Назад в админку</a>

    <#if orders?size == 0>
        <div style="padding:36px 0;text-align:center;font-size:1.15em;">Заказов нет.</div>
    <#else>
        <div style="display: flex; flex-direction: column; gap: 32px;">
            <#list orders as order>
                <div class="order-block">
                    <div class="order-top">
                        <span>
                            <b style="font-size:1.12em;">Заказ #${order.id}</b>
                            <span style="color:#aaa;font-size:0.98em;margin-left:10px;">
                                ${order.formattedDate}
                            </span>
                        </span>
                            <span style="
                                    font-weight: 600;
                            <#if order.status == 'NEW'>color: #239dff;
                            <#elseif order.status == 'COMPLETED'>color: #28c76f;
                            <#elseif order.status == 'CANCELLED'>color: #aaa;
                            <#else>color:#fff;</#if>
                                    font-size: 18px;">
                            ${order.status}
                        </span>
                    </div>

                    <div style="display: flex; flex-wrap: wrap; gap: 24px;">
                        <div style="flex: 2;">
                            <div>
                                <b>Сумма: </b><span>${order.totalPrice} ₽</span>
                            </div>
                            <hr/>
                            <div style="margin-bottom:6px;">
                                <ul>
                                    <li><b>ФИО: </b><span>${order.customerFullName!''}</span></li>
                                    <li><b>Телефон: </b><span>${order.customerPhone!''}</span></li>
                                    <li><b>Адрес: </b><span>${order.address!''}</span></li>
                                    <li><b>Почтовый индекс: </b><span>${order.postalCode!''}</span></li>
                                </ul>
                            </div>
                            <hr/>
                            <div>
                                <b>Товары:</b>
                                <ul>
                                    <#list order.items as item>
                                        <li>
                                            ${item.product.title} —
                                            <b>${item.quantity} шт.</b>
                                            × ${item.product.price} ₽
                                            <span style="color: #aaa;">= ${item.product.price * item.quantity} ₽</span>
                                        </li>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                        <div style="flex: 1; min-width:200px; max-width: 400px">
                            <form action="/orders/updateStatus" method="post">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <input type="hidden" name="userId" value="${user.id}">
                                <input type="hidden" name="orderId" value="${order.id}" />

                                <label for="status-${order.id}" style="font-weight:600;">Изменить статус:</label>
                                <select class="order-select" name="status" id="status-${order.id}">
                                    <#list statuses as st>
                                        <option value="${st}" <#if order.status == st>selected</#if>>${st}</option>
                                    </#list>
                                </select>
                                <br>
                                <button type="submit" class="hover update-status-btn">Обновить статус</button>
                            </form>
                        </div>
                    </div>
                </div>
            </#list>
        </div>
    </#if>
</@t.template>
