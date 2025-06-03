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
                <span>Номер телефона:</span><b class="profile-phone">${user.phoneNumber}</b>
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
                        <div class="select-box">
                            <select class="form-select" id="productType" name="productType">
                                <option value="CHOOSE">Выберите категорию</option>
                                <#list ProductType as type>
                                    <option value="${type}">${type}</option>
                                </#list>
                            </select>
                        </div>
                        <div class="form-group">
                            <input type="text" required class="form-control"
                                   id="productName" name="title" placeholder="Название товара">
                        </div>
                        <div class="form-group">
                            <input type="text" required class="form-control"
                                   id="manufacturer" name="manufacturer" placeholder="Производитель">
                        </div>
                        <div class="form-group">
                            <input type="text" required class="form-control"
                                   id="amount" name="amount" placeholder="Наличие">
                        </div>
                        <div class="form-group">
                            <input type="number" required class="form-control" id="price" name="price" placeholder="Цена товара">
                            <span class="input-icon">₽</span>
                        </div>
                        <div class="profile-textarea">
                            <textarea class="form-group form-textarea" required id="description" name="description" placeholder="Описание товара"></textarea>
                        </div>
                        <div id="compatibilityFields" style="display: none;">
                            <div class="form-group">
                                <input type="text" class="form-control" id="chipset" name="chipset" placeholder="Чипсет">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" id="socket" name="socket" placeholder="Сокет">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" id="ddr" name="ddr" placeholder="DDR">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" id="gddr" name="gddr" placeholder="GDDR">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" id="m2slot" name="m2slot" placeholder="M2 Слот">
                            </div>
                            <div class="form-group mb10">
                                <input type="text" class="form-control" id="format" name="format" placeholder="Формат">
                            </div>
                        </div>
                        <div class="form-group-file">
                            <div class="custom-file">
                                <input class="input-file" required type="file" name="file1" id="file1">
                                <label class="custom-file-label file1" for="file1">Первая фотография к товару</label>
                                <img class="input-icon-img" src="../static/images/file.svg">
                            </div>
                        </div>
                        <div class="form-group-file">
                            <div class="custom-file">
                                <input class="input-file" type="file" name="file2" id="file2">
                                <label class="custom-file-label file2" for="file2">Вторая фотография к товару</label>
                                <img class="input-icon-img" src="../static/images/file.svg">
                            </div>
                        </div>
                        <div class="form-group-file">
                            <div class="custom-file">
                                <input class="input-file" type="file" name="file3" id="file3">
                                <label class="custom-file-label file3" for="file3">Третья фотография к товару</label>
                                <img class="input-icon-img" src="../static/images/file.svg">
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
            toggleCompatibilityFields();

            const files = document.getElementsByClassName("input-file")
            for (let i of files) {
                i.addEventListener("change", () => {
                    const label = document.querySelector("." + i.id)
                    if (event.target.files.length > 0) {
                        label.textContent = event.target.files[0].name;
                        label.classList.add("white-text");
                    }
                })
            }

            const phone = document.querySelector(".profile-phone")
            phone.textContent = formatPhoneNumber(${user.phoneNumber})

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
        });
    </script>
</@t.template>
