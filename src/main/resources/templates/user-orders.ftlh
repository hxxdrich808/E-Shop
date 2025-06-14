<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 style="margin-bottom:32px;">
        Заказы пользователя #${userId}
    </h1>

    <#if orders?size == 0>
        <div style="padding:36px 0;text-align:center;font-size:1.15em;">Заказов нет.</div>
    <#else>
        <div style="display: flex; flex-direction: column; gap: 32px;">
            <#list orders as order>
                <div class="order-block" style="
                background: #21252b;
                border-radius: 14px;
                padding: 24px 28px 20px 28px;
                box-shadow: 0 4px 18px 0 rgba(20,24,31,.09);
                position: relative;
                border: 1.5px solid #272b30;
            ">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                    <span>
                        <b style="font-size:1.12em;">Заказ #${order.id}</b>
                        <span style="color:#aaa;font-size:0.98em;margin-left:10px;">
                            ${order.formattedDate}
                        </span>
                    </span>
                        <span style="
                                font-weight:600;
                        <#if order.status == 'NEW'>color:#239dff;
                        <#elseif order.status == 'COMPLETED'>color:#28c76f;
                        <#elseif order.status == 'CANCELLED'>color:#aaa;
                        <#else>color:#fff;</#if>
                                font-size:1.05em;">
                        ${order.status}
                    </span>
                    </div>

                    <div style="display: flex; flex-wrap: wrap; gap: 24px;">
                        <div style="flex: 2;">
                            <div style="margin-bottom:7px;">
                                <b>Сумма:</b> <span style="font-size:1.05em">${order.totalPrice} ₽</span>
                            </div>
                            <div style="margin-bottom:6px;">
                                <b>Доставка:</b>
                                <ul style="margin:0 0 0 20px; padding:0;">
                                    <li>ФИО: <span>${order.customerFullName!''}</span></li>
                                    <li>Телефон: <span>${order.customerPhone!''}</span></li>
                                    <li>Адрес: <span>${order.address!''}</span></li>
                                    <li>Почтовый индекс: <span>${order.postalCode!''}</span></li>
                                </ul>
                            </div>
                            <div>
                                <b>Товары:</b>
                                <ul style="margin: 0 0 0 20px;">
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
                        <div style="flex: 1; min-width:200px;">
                            <form action="/orders/updateStatus" method="post" style="margin-top:8px;background:#23272f;padding:16px 14px;border-radius:8px;">
                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                <input type="hidden" name="userId" value="${user.id}">
                                <input type="hidden" name="orderId" value="${order.id}" />

                                <label for="status-${order.id}" style="font-weight:600;">Изменить статус:</label>
                                <select name="status" id="status-${order.id}" style="margin: 8px 0 12px 0; padding:5px 10px; border-radius:4px;">
                                    <#list statuses as st>
                                        <option value="${st}" <#if order.status == st>selected</#if>>${st}</option>
                                    </#list>
                                </select>
                                <br>
                                <button type="submit" class="hover" style="padding: 7px 18px; border-radius:6px;">Обновить статус</button>
                            </form>
                        </div>
                    </div>
                </div>
            </#list>
        </div>
    </#if>

    <a href="/admin" class="btn hover" style="margin-top: 36px;">Назад в админку</a>
</@t.template>
