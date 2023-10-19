<#macro template user>
    <!doctype html>
    <html lang="ru">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="stylesheet" href="C:\Users\hxxdrichXD\IdeaProjects\E-Shop\src\main\resources\static\css\style.css">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css"
              integrity="sha384-zCbKRCUGaJDkqS1kPbPd7TveP5iyJE0EjAuZQTgFLD2ylzuqKfdKlfG/eSrtxUkn"
              crossorigin="anonymous">

        <title>E-Shop</title>
    </head>
    <body>
    <nav class="navbar navbar-dark bg-dark">
        <div class="container-fluid">
            <a href="/">
                <span class="navbar-brand mb-0 h1">E-Shop</span>
            </a>
            <#if user.email??>
                <div class="dropdown text-end">

                    <div class="avatar-icon">
                        <span class="avatar-letter">${user.name?substring(0, 1)}</span>
                        <div class="avatar-logout">
                            <#if user.email??>
                                <form action="/profile" method="get">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                    <input type="submit" value="Личный кабинет">
                                </form>
                                <form action="/cart" method="post">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                    <input type="submit" value="Корзина">
                                </form>
                                <form action="/logout" method="post">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                    <input type="submit" value="Выйти">
                                </form>
                            <#else>
                                <a href="/login">Войти</a>
                            </#if>
                        </div>
                    </div>
                </div>
            <#else>
                <button class="btn btn-light my-2 my-sm-0" type="button"
                        onclick="window.location.href = '/login'">
                    Войти
                </button>
            </#if>
        </div>
    </nav>
    <div class="container mt-4">
        <#nested/>
    </div>

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"
            integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"
            integrity="sha384-smHYKdLADwkXOn1EmN1qk/HfnUcbVRZyYmZ4qpPea6sjB/pTJ0euyQp0Mk8ck+5T"
            crossorigin="anonymous"></script>
    <script>
        $(document).ready(function () {
            $(".avatar-icon").hover(function () {
                $(".avatar-logout").show();
            }, function () {
                $(".avatar-logout").hide();
            });
        });
    </script>

    <style>
        .product-link-container:hover {
            transform: scale(1.02);
        }

        .product-link-container {
            height: fit-content;
            width: fit-content;
            transition: transform 0.5s;
            transform: scale(1);
            color: #000 !important;
            text-decoration: none;
        }

        .avatar-icon {
            width: 48px;
            height: 48px;
            background-color: #ffffff;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 30px;
            color: #000000;
            animation: fadeIn 1.5s;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        .avatar-letter {
            text-align: center;
            cursor: pointer;
            text-transform: uppercase;
        }

        .avatar-logout {
            display: none;
            position: absolute;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 10px;
            top: 40px;
            right: 0;
            border-radius: 5px;
        }


        .avatar-logout {
            transition: opacity 0.3s, visibility 0.3s;
        }

        .avatar-logout:hover {
            opacity: 1;
            visibility: visible;
        }

    </style>
    </body>
    </html>
</#macro>
