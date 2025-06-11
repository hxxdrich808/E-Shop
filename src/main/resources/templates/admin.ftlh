<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 class="admin-sub">Панель администратора</h1>
    <table class="table">
        <tr>
            <th scope="col">Email</th>
            <th scope="col">Номер телефона</th>
            <th scope="col">Активность</th>
            <th scope="col">Роли</th>
            <th scope="col">Бан</th>
            <th scope="col">Редактирование</th>
            <th scope="col">Подробная информация</th>
            <th scope="col">Заказы</th>
        </tr>
        <#list users as user>
            <tr>
                <td>${user.email}</td>
                <td class="admin-phone">${user.phoneNumber}</td>
                <td><#if user.active>true<#else>false</#if></td>
                <td><#list user.roles as role>${role}</#list></td>
                <td>
                    <form action="/admin/user/ban/${user.id}" method="post">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <input type="submit" class="ban-btn hover" value="Бан">
                    </form>
                </td>
                <td><a class="underlined" href="/admin/user/edit/${user.id}">Редактировние</a></td>
                <td><a class="underlined" href="/user/${user.id}">Подробная информация</a></td>
                <td><a class="underlined" href="orders/listUserOrders/${user.id}">Просмотр</a></td>
<#--                <td>-->
<#--                    <form action="orders/listUserOrders/${user.id}" method="get">-->
<#--                        <a class="underlined" href="/user/${user.id}">Подробная информация</a>-->
<#--                    </form>-->
<#--                </td>-->
            </tr>
        <#else>
            <h3>Пользователей нет</h3>
        </#list>
    </table>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const phones = document.getElementsByClassName("admin-phone")
            for (let i of phones) {
                i.textContent = formatPhoneNumber(i.innerHTML)
            }
        });

        function formatPhoneNumber(phoneNumber) {
            const cleaned = ('' + phoneNumber).replace(/\D/g, '');
            const hasPlus = cleaned.charAt(0) === '+';
            let formattedNumber;
            if (hasPlus) {
                const match = cleaned.match(/^\+(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})$/);
                if (match) {
                    formattedNumber = '+' + match[1] + ' (' + match[2] + ') ' + match[3] + '-' + match[4] + '-' + match[5];
                } else {
                    formattedNumber = phoneNumber;
                }
            } else {
                const match = cleaned.match(/^(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})$/);
                if (match) {
                    formattedNumber = '+' + match[1] + ' (' + match[2] + ') ' + match[3] + '-' + match[4] + '-' + match[5];
                } else {
                    formattedNumber = phoneNumber;
                }
            }
            return formattedNumber;
        }
    </script>
</@t.template>