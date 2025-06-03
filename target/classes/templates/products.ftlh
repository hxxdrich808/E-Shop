<#import "blocks/template.ftlh" as t>
<@t.template user>
<h4 class="products-sub">Магазины по всей России</h4>
<form class="search-form input-box">
        <div class="products-input">
            <input type="text" name="searchWord" placeholder="Поиск по товарам"
                   <#if searchWord??>value="${searchWord}"</#if> class="products-search form-control"
                   id="searchWord">
        </div>
        <button type="submit" class="search-products hover">
            <img src="../static/images/loop.svg" alt="Поиск">
        </button>
    </form>
    <div class="card-columns">
        <#list Products as product>
            <div class="product-card product-link-container" id=${product.id}>
                <span style="display: none" id=${product.id + "title"}>${product.title}</span>
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
    <script>
            document.addEventListener('DOMContentLoaded', function () {
                const input = document.querySelector('.products-search');
                const searchForm = document.querySelector(".search-form")
                searchForm.addEventListener("submit", () => {
                    event.preventDefault()
                    const products = document.getElementsByClassName("product-card")
                    for (let i of products) {
                        const title = document.getElementById(i.id + "title").innerHTML.toLowerCase().trim();
                        const value = input.value.toLowerCase()
                        if (title.includes(value)) {
                            i.classList.remove("none-product")
                            // console.log(1)
                        } else {
                            i.classList.add("none-product")
                        }
                    }
                });
            });
    </script>
    </@t.template>
