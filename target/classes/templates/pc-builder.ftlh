<#import "blocks/template.ftlh" as t>
<@t.template user>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Конструктор ПК</title>
        <!-- Подключение jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            console.log($); // Должен вывести функцию jQuery
            console.log(jQuery); // Должен вывести функцию jQuery

            function enableFields() {
                const fields = document.querySelectorAll('#pc-builder-form select, #pc-builder-form button[type="button"]');
                fields.forEach(field => field.disabled = false);
            }
        </script>
        <script>
            (function($) {
                function showCompatibleProducts(productType) {
                    $.ajax({
                        type: "GET",
                        url: `/pcbuilder/compatibleProduct`,
                        data: {
                            productType: productType.toUpperCase() // Передаем строковое значение
                        },
                        success: function(products) {
                            const selectElement = productType.toUpperCase();
                            if (selectElement) {
                                selectElement.innerHTML = "";
                                products.forEach(product => {
                                    const option = document.createElement("div");
                                    option.id = product.id;
                                    option.classList = "build-item hover";
                                    const image = document.createElement("div");
                                    let path = "/images/" + product.previewImageId;
                                    image.style = "background-image: url('" + path + "')";
                                    image.classList = "item-img";
                                    const productInfo = document.createElement("div");
                                    productInfo.classList = "item-info";
                                    const name = document.createElement("div");
                                    name.textContent = "Название: " + product.title;
                                    name.classList = "item-name";
                                    const price = document.createElement("div");
                                    price.textContent = "Цена: " + product.price;
                                    price.classList = "item-price";
                                    const element = document.querySelector(".select" + selectElement);
                                    element.appendChild(option);
                                    option.appendChild(image);
                                    option.appendChild(productInfo);
                                    productInfo.appendChild(name);
                                    productInfo.appendChild(price);

                                    option.addEventListener("click", function () {
                                        addToBuild(product.id, productType.toUpperCase(), product.title);
                                    })

                                    // const addButton = document.createElement("button");
                                    // addButton.textContent = "Добавить в сборку";
                                    // addButton.addEventListener("click", function() {
                                    //     addToBuild(product.id, productType.toUpperCase());
                                    // });
                                    // element.parentElement.appendChild(addButton); // Добавляем кнопку рядом с select
                                });

                                selectElement.disabled = false;
                            } else {
                                console.error("Элемент не найден:", productType.toUpperCase());
                            }
                        },
                    });
                }

                function addToBuild(productId, productType, title) {
                    // const csrfToken = document.querySelector('input[name="_csrf"]').value;
                    $.ajax({
                        type: "POST",
                        url: `/pcbuilder/addToBuild`,
                        data: {
                            productId: productId,
                            productType: productType.toUpperCase()
                        },
                        // headers: {
                        //     'X-CSRF-Token': csrfToken
                        // },
                        success: function(response) {
                            const text = document.querySelector(".label" + productType.toUpperCase());
                            const chosen = document.createElement("div");
                            chosen.textContent = title;
                            if (text.childNodes.length > 1) {
                                text.removeChild(text.childNodes[1]);
                            }
                            if (text.textContent[text.textContent.length - 1] !== ":")
                            text.textContent = text.innerHTML + ":"
                            text.appendChild(chosen);
                            alert("Продукт добавлен в сборку!");
                        },
                        error: function(xhr, status, error) {
                            console.log(xhr, status)
                            console.error("Ошибка при добавлении продукта в сборку:", error);
                        }
                    });
                }

                function saveBuild() {
                    const build = {
                        cpu: $('#processor').val(),
                        motherboard: $('#motherboard').val(),
                        systemUnit: $('#case').val(),
                        gpu: $('#gpu').val(),
                        cooler: $('#cpuCooler').val(),
                        ram: $('#ram').val(),
                        drive: $('#storage').val(),
                        psu: $('#powerSupply').val()
                    };

                    $.ajax({
                        type: "POST",
                        url: `/pcbuilder/saveBuild`, // Обновленный URL
                        data: JSON.stringify(build),
                        contentType: "application/json",
                        success: function(response) {
                            alert("Сборка сохранена!");
                        },
                        error: function(xhr, status, error) {
                            console.error("Ошибка при сохранении сборки:", error);
                        }
                    });
                }

                document.addEventListener("DOMContentLoaded", function() {
                    const selectButtons = document.querySelectorAll('div[id^="select"]');
                    selectButtons.forEach(button => {
                        button.addEventListener("click", function() {
                            const productType = this.id.replace("select", "").toLowerCase();
                            const select = document.querySelector(".select" + productType.toUpperCase())
                            const arrow = document.querySelector(".arr" + productType.toUpperCase())
                            if (select.hasChildNodes()) {
                                while (select.firstChild) {
                                    select.removeChild(select.firstChild);
                                }
                                arrow.setAttribute("style", "transform: rotate(0)");
                            } else {
                                console.log(productType)
                                showCompatibleProducts(productType);
                                arrow.setAttribute("style", "transform: rotate(180deg)");
                            }
                        });
                    });

                    const saveButton = document.querySelector('button[type="submit"]');
                    saveButton.addEventListener("click", function(event) {
                        event.preventDefault();
                        saveBuild();
                    });
                });
            })(jQuery);
        </script>
    </head>
    <body>
    <h1 class="builder-sub">Конструктор ПК</h1>
<#--    <input class="csrf" type="hidden" name="_csrf" value="${_csrf.token}">-->
<#--    <button class="start-build hover" onclick="enableFields()">Начать сборку</button>-->
    <form class="pc-builder-form" id="pc-builder-form" action="/build" method="POST">
        <div class="builder-item" id="selectCPU">
            <label class="labelCPU" for="cpu">Процессор</label>
            <img class="arrCPU" src="../static/images/arrow2.svg">
        </div>
        <div class="selectCPU select-item"></div>
        <div class="builder-item" id="selectMOTHERBOARD">
            <label class="labelMOTHERBOARD" for="motherboard">Материнская плата</label>
            <img class="arrMOTHERBOARD" src="../static/images/arrow2.svg">
        </div>
        <div class="selectMOTHERBOARD select-item"></div>
        <div class="builder-item" id="selectCASE">
            <label class="labelCASE" for="case">Корпус</label>
            <img class="arrCASE" src="../static/images/arrow2.svg">
        </div>
        <div class="selectCASE select-item"></div>
        <div class="builder-item" id="selectGPU">
            <label class="labelGPU" for="gpu">Видеокарта</label>
            <img class="arrGPU" src="../static/images/arrow2.svg">
        </div>
        <div class="selectGPU select-item"></div>
        <div class="builder-item" id="selectCOOLER">
            <label class="labelCOOLER" for="cooler">Охлаждение процессора</label>
            <img class="arrCOOLER" src="../static/images/arrow2.svg">
        </div>
        <div class="selectCOOLER select-item"></div>
        <div class="builder-item" id="selectRAM">
            <label class="labelRAM" for="ram">Оперативная память</label>
            <img class="arrRAM" src="../static/images/arrow2.svg">
        </div>
        <div class="selectRAM select-item"></div>
        <div class="builder-item" id="selectDRIVE">
            <label class="labelDRIVE" for="drive">Накопитель памяти</label>
            <img class="arrDRIVE" src="../static/images/arrow2.svg">
        </div>
        <div class="selectDRIVE select-item"></div>
        <div class="builder-item" id="selectPSU">
            <label class="labelPSU" for="psu">Блок питания</label>
            <img class="arrPSU" src="../static/images/arrow2.svg">
        </div>
        <div class="selectPSU select-item"></div>
        <button class="build-btn hover" type="submit" disabled>Собрать ПК</button>
    </form>
    </body>
</@t.template>
