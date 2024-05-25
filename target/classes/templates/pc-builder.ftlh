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
                            console.log(productType)
                            const selectElement = productType.toUpperCase();
                            console.log(selectElement)
                            if (selectElement) {
                                selectElement.innerHTML = "";
                                /*TODO переписать с ботом строки 34 - 50. из-за фикса с передачей типа продукта слетает вся логика последующих строк
                                нужно чтобы код после туду выводил продукты по переданному selectElement */
                                products.forEach(product => {
                                    const option = document.createElement("option");
                                    option.value = product.id;
                                    option.textContent = product.title;
                                    selectElement.createElement(option);

                                    const addButton = document.createElement("button");
                                    addButton.textContent = "Добавить в сборку";
                                    addButton.addEventListener("click", function() {
                                        addToBuild(product.id, productType.toUpperCase());
                                    });
                                    selectElement.parentElement.createElement(addButton);
                                });

                                selectElement.disabled = false;
                            } else {
                                console.error("Элемент не найден:", productType.toUpperCase());
                            }
                        },
                    });
                }

                function addToBuild(productId, productType) {
                    $.ajax({
                        type: "POST",
                        url: `/pcbuilder/addToBuild`,
                        data: {
                            productId: productId,
                            productType: productType.toUpperCase()
                        },
                        success: function(response) {
                            alert("Продукт добавлен в сборку!");
                        },
                        error: function(xhr, status, error) {
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
                    const selectButtons = document.querySelectorAll('button[id^="select"]');
                    selectButtons.forEach(button => {
                        button.addEventListener("click", function() {
                            const productType = this.id.replace("select", "").toLowerCase();
                            showCompatibleProducts(productType);
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
    <h1>Конструктор ПК</h1>
    <button onclick="enableFields()">Начать сборку</button>
    <form id="pc-builder-form" action="/build" method="POST">
        <div>
            <label for="cpu">Процессор:</label>
            <button type="button" id="selectCPU" disabled>Выбрать</button>
        </div>
        <div>
            <label for="motherboard">Материнская плата:</label>
            <button type="button" id="selectMotherboard" disabled>Выбрать</button>
        </div>
        <div>
            <label for="case">Корпус:</label>
            <button type="button" id="selectCase" disabled>Выбрать</button>
        </div>
        <div>
            <label for="gpu">Видеокарта:</label>
            <button type="button" id="selectGpu" disabled>Выбрать</button>
        </div>
        <div>
            <label for="cooler">Охлаждение процессора:</label>
            <button type="button" id="selectCooler" disabled>Выбрать</button>
        </div>
        <div>
            <label for="ram">Оперативная память:</label>
            <button type="button" id="selectRAM" disabled>Выбрать</button>
        </div>
        <div>
            <label for="drive">Накопитель памяти:</label>
            <button type="button" id="selectDrive" disabled>Выбрать</button>
        </div>
        <div>
            <label for="psu">Блок питания:</label>
            <button type="button" id="selectPSU" disabled>Выбрать</button>
        </div>
        <button type="submit" disabled>Собрать ПК</button>
    </form>
    </body>
</@t.template>
