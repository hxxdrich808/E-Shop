<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 style="text-align: center">Личный кабинет</h1>
    <hr>
    <br>
    <div style="text-align: center">
        <img src="/static/images/avatar.png"
             style="border:2px solid black; border-radius: 20px" height="120">
        <br>
        <br>
        <h2>${user.name}</h2>
        <br>
        Электронная почта: <b>${user.email}</b>
        <br>
        Номер телефона: <b>${user.phoneNumber}</b>
        <br>
        <br>
        <#if user.isAdmin()>
            <a class="btn btn-dark mb-3" style="text-align: center; width: 100%"
               href="/admin">
                Панель администратора
            </a>
            <br>
            <hr>
            <a class="btn btn-dark mt-3 mb-3" style="text-align: center; width: 100%"
               data-toggle="collapse" href="#collapseExample" role="button"
               aria-expanded="true" aria-controls="collapseExample">
                Добавить новый товар
            </a>
            <div class="collapse mb-3" id="collapseExample" style="">
                <form action="/Product/create" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <div>
                            <label for="productType">Категория товара</label>
                            <select class="form-control" id="productType" name="productType">
                                <#list ProductType as type>
                                    <option value="${type}">${type}</option>
                                </#list>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="productName">Название товара</label>
                        <input type="text" required class="form-control"
                               id="productName" name="title">
                    </div>
                    <div class="form-group">
                        <label for="price">Цена товара</label>
                        <div class="input-group mb-3">
                            <input type="number" required class="form-control" id="price" name="price">
                            <div class="input-group-append">
                                <span class="input-group-text">₽</span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="description">Описание товара</label>
                        <textarea required class="form-control" id="description" name="description"></textarea>
                    </div>
                    <div class="form-group">
                        <div class="custom-file">
                            <input required type="file" name="file1" id="file1">
                            <label class="custom-file-label" for="file1">Первая фотография к товару</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-file">
                            <input type="file" name="file2" id="file2">
                            <label class="custom-file-label" for="file2">Вторая фотография к товару</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-file">
                            <input type="file" name="file3" id="file3">
                            <label class="custom-file-label" for="file3">Третья фотография к товару</label>
                        </div>
                    </div>
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>

                    <button type="submit" style="width: 100%" class="btn btn-dark">Добавить</button>
                </form>
            </div>
        </#if>
        <hr>
        <div>
            <form action="/logout" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                <button type="submit" style="text-align: center; width: 100%" class="btn btn-danger mb-2">
                    Выйти из аккаунта
                </button>
            </form>
        </div>
    </div>
</@t.template>
