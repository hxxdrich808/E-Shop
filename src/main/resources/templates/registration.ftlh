<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 class="login-sub">Регистрация</h1>
    <form class="login-form" action="/registration" method="post">
        <input class="login-input" type="text" name="name" placeholder="Имя пользователя">
        <input class="login-input" type="email" name="email" placeholder="Эл. почта">
        <input class="login-input" type="text" name="phoneNumber" placeholder="Номер телефона">
        <input class="login-input" type="password" name="password" placeholder="Пароль">
        <input type="hidden" name="_csrf" value="${_csrf.token}">
        <input class="login-btn hover" type="submit" value="Зарегистрироваться"/>
    </form>
    <#if errorMsg??>
        <h2 style="color: red">${errorMsg}</h2>
    </#if>
</@t.template>
