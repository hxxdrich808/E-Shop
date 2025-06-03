<#macro template user>
    <!doctype html>
    <html lang="ru">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="../../static/css/style.css">
        <title>E-Shop</title>
    </head>
    <body>
    <nav class="navbar">
        <div class="navbar-box">
            <a href="/">
                <span class="navbar-brand">E-Shop</span>
            </a>
            <div class="navbar-right">
                <div class="pc-builder hover">
                    <a href="/pcbuilder" class="btn btn-primary">Конструктор ПК</a>
                </div>
                <#if user.email??>
                    <div class="avatar-icon hover">
                        <span class="avatar-letter">${user.name?substring(0, 1)}</span>
                        <div class="avatar-logout">
                            <#if user.email??>
                                <form action="/profile" method="get">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                    <input type="submit" value="">
                                </form>
                            <#else>
                                <a href="/login">Войти</a>
                            </#if>
                        </div>
                    </div>
                <#else>
                    <button class="btn-login" type="button"
                            onclick="window.location.href = '/login'">
                        Войти
                    </button>
                </#if>
            </div>
        </div>
    </nav>
    <div class="content-container">
        <#nested/>
    </div>
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-left">
                <a href="/">
                    <span class="footer-brand">E-Shop</span>
                </a>
                <a class="footer-item" href="/">Каталог</a>
                <a class="footer-item" href="/pcbuilder">Конструктор ПК</a>
                <#if user.email??>
                    <form class="footer-item" action="/profile" method="get">
                        <input type="hidden" name="_csrf" value="${_csrf.token}">
                        <input type="submit" value="">
                        <span>Личный кабинет</span>
                    </form>
                    <#else>
                    <a class="footer-item" type="button" href="/login">
                        Личный кабинет
                    </a>
                </#if>
            </div>
            <div class="footer-right">
                <a class="footer-item" href="tel:+79870076664">+7 (987) 007-66-64</a>
            </div>
        </div>
        <div class="copyright">Copyright © 2024, E-Shop, Все права защищены</div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"
            integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
            crossorigin="anonymous"></script>
    </body>
    </html>
</#macro>
