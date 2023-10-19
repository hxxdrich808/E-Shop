<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1>BUYSELL</h1><hr>
    <h3>Подробная информация о пользователе ${user.name}</h3>
    <b>Номер телефона: </b> ${user.phoneNumber}<br>
    <b>Email: </b> ${user.email}<br>
    <#if errorMessage??>
        <h2 style="color: red">${errorMessage}</h2>
    </#if>
</@t.template>