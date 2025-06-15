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
                <#-- Вычисляем средний рейтинг для каждого продукта -->
                    <#assign avgRating = 0.0>
                    <#if product.reviews?? && product.reviews?size gt 0>
                        <#assign sum = 0>
                        <#list product.reviews as r>
                            <#assign sum = sum + r.rating>
                        </#list>
                        <#assign avgRating = sum / product.reviews?size>
                    </#if>
                    <div class="product-card product-link-container"
                         id="${product.id}"
                         data-price="${product.price}"
                         data-rating="${avgRating}">
                        <span style="display: none" id="${product.id}title">${product.title}</span>
                        <a href="/Product/${product.id}" class="product-link">
                            <div class="product-image-box"
                                 style="background-image: url('/images/${product.previewImage.id?c}')"></div>
                            <div class="card-body">
                                <h5 class="card-title">${product.title}</h5>
                                <p class="card-text">${product.price} ₽</p>
                                <p>Рейтинг: ${avgRating?string("0.0")}</p>
                            </div>
                        </a>
                        <!-- Кнопка добавить в корзину -->
                        <form action="/cart/add/${product.id}" method="post" style="margin: 12px;">
                            <input type="hidden" name="_csrf" value="${_csrf.token}">
                            <button type="submit" class="add-to-cart-btn">
                                🛒 В корзину
                            </button>
                        </form>
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

            // ---- Toggle сортировка ----
            const container = document.getElementById("products-container");
            const originalOrder = Array.from(container.children);

            // Функция сброса сортировки
            function resetProductsOrder() {
                originalOrder.forEach(card => container.appendChild(card));
            }

            // Удалить active со всех кнопок
            function clearActiveSort() {
                document.querySelectorAll('.sort-btn').forEach(btn => btn.classList.remove('active'));
            }

            // Toggle для каждой сортировки
            let activeSort = null;

            function toggleSort(type) {
                if (activeSort === type) {
                    // Сбросить сортировку
                    resetProductsOrder();
                    clearActiveSort();
                    activeSort = null;
                } else {
                    let cards = Array.from(container.getElementsByClassName("product-card"));
                    if (type === 'price-asc') {
                        cards.sort((a, b) => parseFloat(a.getAttribute("data-price")) - parseFloat(b.getAttribute("data-price")));
                    } else if (type === 'price-desc') {
                        cards.sort((a, b) => parseFloat(b.getAttribute("data-price")) - parseFloat(a.getAttribute("data-price")));
                    } else if (type === 'rating-desc') {
                        cards.sort((a, b) => parseFloat(b.getAttribute("data-rating")) - parseFloat(a.getAttribute("data-rating")));
                    }
                    cards.forEach(card => container.appendChild(card));
                    clearActiveSort();
                    document.getElementById('sort-' + type).classList.add('active');
                    activeSort = type;
                }
            }

            // Привязываем кнопки
            document.getElementById('sort-price-asc').onclick = function() { toggleSort('price-asc'); };
            document.getElementById('sort-price-desc').onclick = function() { toggleSort('price-desc'); };
            document.getElementById('sort-rating-desc').onclick = function() { toggleSort('rating-desc'); };

        });
    </script>
</@t.template>
