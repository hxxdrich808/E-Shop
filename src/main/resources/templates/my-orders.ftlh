<#import "blocks/template.ftlh" as t>
<@t.template user>

    <h1 class="profile-sub">Мои заказы</h1>

    <a class="btn hover" href="/profile" style="margin-bottom: 36px; width: fit-content">Назад</a>

    <#if orders?size == 0>
        <p>У вас пока нет заказов.</p>
    <#else>
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
                <div><b>Сумма: </b><span>${order.totalPrice} ₽</span></div>
                <hr/>
                <div style="margin: 10px 0 8px 0; font-size: 1.02em;">
                    <b>Доставка:</b>
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
        </#list>
    </#if>

</@t.template>
