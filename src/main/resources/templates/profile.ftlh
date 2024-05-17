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
                                <option value="CHOOSE">Выберите категорию</option>
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
                    <div id="compatibilityFields" style="display: none;">
                        <div class="form-group">
                            <label for="chipset">Чипсет</label>
                            <input type="text" class="form-control" id="chipset" name="chipset">
                        </div>
                        <div class="form-group">
                            <label for="socket">Сокет</label>
                            <input type="text" class="form-control" id="socket" name="socket">
                        </div>
                        <div class="form-group">
                            <label for="ddr">DDR</label>
                            <input type="text" class="form-control" id="ddr" name="ddr">
                        </div>
                        <div class="form-group">
                            <label for="gddr">GDDR</label>
                            <input type="text" class="form-control" id="gddr" name="gddr">
                        </div>
                        <div class="form-group">
                            <label for="m2slot">M2 Слот</label>
                            <input type="text" class="form-control" id="m2slot" name="m2slot">
                        </div>
                        <div class="form-group">
                            <label for="format">Формат</label>
                            <input type="text" class="form-control" id="format" name="format">
                        </div>
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
    <script>
        function toggleCompatibilityFields() {
            console.log('Функция toggleCompatibilityFields вызвана');
            const compatibilityFields = document.getElementById('compatibilityFields');
            const productType = document.getElementById('productType').value.trim().toUpperCase();
            const compatibleTypes = ['CPU', 'MOTHERBOARD', 'CASE', 'GPU', 'RAM', 'DRIVE'];

            console.log('Выбранный тип продукта:', productType);
            if (compatibleTypes.includes(productType)) {
                compatibilityFields.style.display = 'block';
                console.log('Поля совместимости отображены');
            } else {
                compatibilityFields.style.display = 'none';
                console.log('Поля совместимости скрыты');
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const productTypeElement = document.getElementById('productType');
            productTypeElement.addEventListener('change', toggleCompatibilityFields);
            toggleCompatibilityFields(); // Проверка начального состояния
        });
    </script>
</@t.template>
