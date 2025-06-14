<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h4 class="products-sub">Магазины по всей России</h4>

    <div style="display: flex; align-items: flex-start; width: 100%;">

        <!-- Левая колонка: фильтры -->
        <div class="filters-panel">
            <h3>Фильтры</h3>
            <form method="get" class="filter-form">

                <label for="type">Тип товара:</label>
                <select id="type" name="type">
                    <option value="">Все типы</option>
                    <#list ProductType as pt>
                        <option value="${pt}" <#if type?? && pt == type>selected</#if>>${pt}</option>
                    </#list>
                </select>

                <label for="manufacturer">Производитель:</label>
                <select id="manufacturer" name="manufacturer">
                    <option value="">Все производители</option>
                    <#list Manufacturers as mfr>
                        <option value="${mfr}" <#if manufacturer?? && manufacturer == mfr>selected</#if>>${mfr}</option>
                    </#list>
                </select>

                <label>
                    <input type="checkbox" name="inStock"
                           <#if inStock?? && inStock == "on">checked</#if>
                    > Только в наличии
                </label>

                <label>Цена:</label>
                <input type="number" name="minPrice" placeholder="Мин. цена" value="${minPrice!''}">
                <input type="number" name="maxPrice" placeholder="Макс. цена" value="${maxPrice!''}">

                <button type="submit">Фильтровать</button>
                <a href="/" class="reset-filters">Сбросить фильтры</a>
            </form>
        </div>

        <!-- Правая часть: поиск, сортировка и карточки товаров -->
        <div style="flex:1; display: flex; flex-direction: column;">
            <!-- Поиск -->
            <form class="search-form input-box" style="margin-top: 24px;">
                <div class="products-input">
                    <input type="text" name="searchWord" placeholder="Поиск по товарам"
                           <#if searchWord??>value="${searchWord}"</#if> class="products-search form-control"
                           id="searchWord">
                </div>
                <button type="submit" class="search-products hover">
                    <img src="../static/images/loop.svg" alt="Поиск">
                </button>
            </form>

            <!-- Сортировка -->
            <div class="sort-panel">
                <span>Сортировать:</span>
                <button type="button" class="sort-btn" id="sort-price-asc">По цене ↑</button>
                <button type="button" class="sort-btn" id="sort-price-desc">По цене ↓</button>
                <button type="button" class="sort-btn" id="sort-rating-desc">По рейтингу</button>
            </div>

            <!-- Карточки товаров -->
            <div class="card-columns" id="products-container">
                <#list Products as product>
                    <div class="product-card product-link-container" id="${product.id}" data-price="${product.price}">
                        <span style="display: none" id="${product.id}title">${product.title}</span>
                        <a href="/Product/${product.id}" class="product-link">
                            <div class="product-image-box"
                                 style="background-image: url('/images/${product.previewImageId}')"></div>
                            <div class="card-body">
                                <h5 class="card-title">${product.title}</h5>
                                <p class="card-text">${product.price} ₽</p>
                            </div>
                        </a>
                    </div>
                <#else>
                    <h1 style="text-align: center">Не найдено</h1>
                </#list>
            </div>
        </div>
    </div>

    <script>
        // Поиск по товарам (на лету)
        document.addEventListener('DOMContentLoaded', function () {
            const input = document.querySelector('.products-search');
            const searchForm = document.querySelector(".search-form");
            searchForm.addEventListener("submit", (event) => {
                event.preventDefault();
                const products = document.getElementsByClassName("product-card");
                const value = input.value.toLowerCase();
                for (let i of products) {
                    const title = document.getElementById(i.id + "title").innerHTML.toLowerCase().trim();
                    if (title.includes(value)) {
                        i.classList.remove("none-product");
                    } else {
                        i.classList.add("none-product");
                    }
                }
            });

            // Сортировка по цене
            function sortProducts(byAsc) {
                const container = document.getElementById("products-container");
                const cards = Array.from(container.getElementsByClassName("product-card"));
                cards.sort((a, b) => {
                    const pa = parseFloat(a.getAttribute("data-price"));
                    const pb = parseFloat(b.getAttribute("data-price"));
                    return byAsc ? pa - pb : pb - pa;
                });
                cards.forEach(card => container.appendChild(card));
            }

            document.getElementById('sort-price-asc').onclick = function() { sortProducts(true); };
            document.getElementById('sort-price-desc').onclick = function() { sortProducts(false); };
        });
    </script>

</@t.template>
