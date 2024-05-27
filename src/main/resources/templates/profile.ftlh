<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h1 class="profile-sub">Личный кабинет</h1>
    <div class="profile-row">
        <div class="profile-info">
            <div class="profile-info-row">
                <div class="profile-icon hover">
                    <span class="profile-letter">${user.name?substring(0, 1)}</span>
                </div>
                <h2 class="profile-name">${user.name}</h2>
            </div>
            <div class="profile-contacts">
                <span>Электронная почта:</span><b>${user.email}</b>
            </div>
            <div class="profile-contacts">
                <span>Номер телефона:</span><b>${user.phoneNumber}</b>
            </div>
            <#if user.isAdmin()>
                <div class="profile-admin hover">
                    <a
                       href="/admin">
                        Панель администратора
                    </a>
                </div>
            </#if>
            <div class="profile-logout hover">
                <form action="/logout" method="post">
                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                    <button type="submit" style="text-align: center; width: 100%" class="btn btn-danger mb-2">
                        Выйти из аккаунта
                    </button>
                </form>
            </div>
        </div>
        <#if user.isAdmin()>
            <div class="profile-add">
                <h3>Добавить новый товар</h3>
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
<#--                            <label for="productName">Название товара</label>-->
                            <input type="text" required class="form-control"
                                   id="productName" name="title" placeholder="Название товара">
                        </div>
                        <div class="form-group">
<#--                            <label for="price">Цена товара</label>-->
                            <div class="input-group mb-3">
                                <input type="number" required class="form-control" id="price" name="price" placeholder="Цена товара">
                                <div class="input-group-append">
                                    <span class="input-group-text">₽</span>
                                </div>
                            </div>
                        </div>
                        <div class="profile-textarea">
<#--                            <label for="description">Описание товара</label>-->
                            <textarea class="form-group" required class="form-control" id="description" name="description" placeholder="Описание товара"></textarea>
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
                        <button type="submit" class="profile-add-item hover">Добавить</button>
                    </form>
                </div>
            </div>
        </#if>
    </div>
    <script>
        function toggleCompatibilityFields() {
            console.log('Функция toggleCompatibilityFields вызвана');
            const compatibilityFields = document.getElementById('compatibilityFields');
            const productType = document.getElementById('productType').value.trim().toUpperCase();
            const compatibleTypes = ['CPU', 'MOTHERBOARD', 'CASE', 'GPU', 'RAM', 'DRIVE', 'PSU'];

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
