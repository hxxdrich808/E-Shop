<#import "blocks/template.ftlh" as t>
<@t.template user>

    <h1 class="profile-sub">Мои заказы</h1>

    <#if orders?size == 0>
        <p>У вас пока нет заказов.</p>
    <#else>
        <#list orders as order>
            <div class="order-block" style="margin-bottom: 32px; padding: 20px; border-radius: 10px; background: #222;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <b>Заказ #${order.id}</b>
                    <span style="
                            font-weight: bold;
                    <#if order.status == 'NEW'>color:#239dff;
                    <#elseif order.status == 'COMPLETED'>color:#28c76f;
                    <#elseif order.status == 'CANCELLED'>color:#aaa;
                    <#else>color:#fff;</#if>
                            ">
                        ${order.status}
                    </span>
                </div>
                <div style="margin-top:6px;">Дата: ${order.formattedDate}</div>
                <div>Сумма: <b>${order.totalPrice} ₽</b></div>
                <div style="margin: 10px 0 8px 0; font-size: 1.02em;">
                    <b>Доставка:</b>
                    <ul style="margin:0 0 0 20px; padding:0;">
                        <li>ФИО: ${order.customerFullName!''}</li>
                        <li>Телефон: ${order.customerPhone!''}</li>
                        <li>Адрес: ${order.address!''}</li>
                        <li>Почтовый индекс: ${order.postalCode!''}</li>
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
                <hr style="margin: 16px 0 0 0; border-color: #333;">
            </div>
        </#list>
    </#if>

    <a class="btn hover" href="/profile">Назад</a>

</@t.template>
