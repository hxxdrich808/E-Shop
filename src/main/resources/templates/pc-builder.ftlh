<#import "blocks/template.ftlh" as t>
<@t.template user>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="_csrf" content="${_csrf.token}">
        <meta name="_csrf_header" content="${_csrf.headerName}">
        <title>Конструктор ПК</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script>
            console.log($);
            console.log(jQuery);

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
                            productType: productType.toUpperCase()
                        },
                        success: function(products) {
                            const selectElement = productType.toUpperCase();
                            const selector = document.querySelector(".selector" + productType.toUpperCase())
                            if (selector.hasChildNodes()) {
                                while (selector.firstChild) {
                                    selector.removeChild(selector.firstChild);
                                }
                            }
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

                                    const option2 = document.createElement("option");
                                    option2.value = product.id;
                                    option2.textContent = product.title;
                                    option2.id = productType.toLowerCase();
                                    const selector = document.querySelector(".selector" + productType.toUpperCase());
                                    selector.appendChild(option2);

                                    option.addEventListener("click", function () {
                                        selector.value = product.id;
                                        addToBuild(product.id, productType.toUpperCase(), product.title);
                                    })
                                });

                                selectElement.disabled = false;
                            } else {
                                console.error("Элемент не найден:", productType.toUpperCase());
                            }
                        },
                    });
                }

                function addToBuild(productId, productType, title) {
                    $.ajax({
                        type: "GET",
                        url: `/pcbuilder/addToBuild`,
                        data: {
                            productId: productId,
                            productType: productType.toUpperCase(),
                            cpu: $('#processor').val(),
                            motherboard: $('#motherboard').val(),
                            systemUnit: $('#case').val(),
                            gpu: $('#gpu').val(),
                            cooler: $('#cooler').val(),
                            ram: $('#ram').val(),
                            drive: $('#drive').val(),
                            psu: $('#psu').val()
                        },
                        success: function(response) {
                            console.log(response)
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
                    $.ajax({
                        type: "GET",
                        url: `/pcbuilder/saveBuild`,
                        success: function(response) {
                            createAndDownloadPdf(response);
                            console.log(response)
                            alert("Сборка сохранена!");
                        },
                        error: function(xhr, status, error) {
                            console.error("Ошибка при сохранении сборки:", error);
                        }
                    });
                }

                function downloadBuild(link) {
                    $.ajax({
                        type: "GET",
                        url: `/pcbuilder/download`,
                        success: function (response) {
                            const blob = new Blob([response], { type: 'application/pdf' });
                            const link = document.createElement('a');
                            link.href = window.URL.createObjectURL(blob);
                            link.download = 'build.pdf';
                            link.click();
                        }
                    })
                }

                function createAndDownloadPdf(data) {
                    const { jsPDF } = window.jspdf;
                    const doc = new jsPDF();

                    doc.text("PC configuration:", 10, 10);

                    if (data.cpu) {
                        doc.text("CPU: " + data.cpu, 10, 20);
                    }
                    if (data.motherboard) {
                        doc.text("Motherboard: " + data.motherboard, 10, 30);
                    }
                    if (data.ram) {
                        doc.text("RAM: " + data.ram, 10, 40);
                    }
                    if (data.gpu) {
                        doc.text("GPU: " + data.gpu, 10, 50);
                    }
                    if (data.psu) {
                        doc.text("PSU: " + data.psu, 10, 60);
                    }
                    if (data.systemUnit) {
                        doc.text("Case: " + data.systemUnit, 10, 70);
                    }
                    if (data.cooler) {
                        doc.text("Cooler: " + data.cooler, 10, 80);
                    }
                    if (data.drive) {
                        doc.text("Drive: " + data.drive, 10, 90);
                    }

                    doc.save('build.pdf');
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

                    const saveButton = document.querySelector(".build-btn");
                    saveButton.addEventListener("click", function(event) {
                        console.log("clicked")
                        event.preventDefault();
                        saveBuild();
                    });
                });
            })(jQuery);
        </script>
    </head>
    <body>
    <h1 class="builder-sub">Конструктор ПК</h1>
    <form class="pc-builder-form" id="pc-builder-form" action="/pcbuilder/saveBuild" method="GET">
        <div class="builder-item" id="selectCPU">
            <label class="labelCPU" for="cpu">Процессор</label>
            <img class="arrCPU" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorCPU" id="processor"></select>
        <div class="selectCPU select-item"></div>
        <div class="builder-item" id="selectMOTHERBOARD">
            <label class="labelMOTHERBOARD" for="motherboard">Материнская плата</label>
            <img class="arrMOTHERBOARD" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorMOTHERBOARD" id="motherboard"></select>
        <div class="selectMOTHERBOARD select-item"></div>
        <div class="builder-item" id="selectCASE">
            <label class="labelCASE" for="case">Корпус</label>
            <img class="arrCASE" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorCASE" id="case"></select>
        <div class="selectCASE select-item"></div>
        <div class="builder-item" id="selectGPU">
            <label class="labelGPU" for="gpu">Видеокарта</label>
            <img class="arrGPU" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorGPU" id="gpu"></select>
        <div class="selectGPU select-item"></div>
        <div class="builder-item" id="selectCOOLER">
            <label class="labelCOOLER" for="cooler">Охлаждение процессора</label>
            <img class="arrCOOLER" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorCOOLER" id="cooler"></select>
        <div class="selectCOOLER select-item"></div>
        <div class="builder-item" id="selectRAM">
            <label class="labelRAM" for="ram">Оперативная память</label>
            <img class="arrRAM" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorRAM" id="ram"></select>
        <div class="selectRAM select-item"></div>
        <div class="builder-item" id="selectDRIVE">
            <label class="labelDRIVE" for="drive">Накопитель памяти</label>
            <img class="arrDRIVE" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorDRIVE" id="drive"></select>
        <div class="selectDRIVE select-item"></div>
        <div class="builder-item" id="selectPSU">
            <label class="labelPSU" for="psu">Блок питания</label>
            <img class="arrPSU" src="../static/images/arrow2.svg">
        </div>
        <select class="invisibleSelector selectorPSU" id="psu"></select>
        <div class="selectPSU select-item"></div>
        <button class="build-btn hover" type="submit">Собрать ПК</button>
    </form>
    </body>
</@t.template>
