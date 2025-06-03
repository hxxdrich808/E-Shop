<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 class="login-sub">Авторизация</h1>
    <form class="login-form" action="/login" method="post">
        <input class="login-input" type="email" name="username" placeholder="Эл. почта">
        <input class="login-input" type="password" name="password" placeholder="Пароль">
        <input type="hidden" name="_csrf" value="${_csrf.token}">
        <input class="login-btn hover" type="submit" value="Вход"/>
    </form>
    <a class="register-link" href="/registration">Зарегистрироваться</a>
</@t.template>
