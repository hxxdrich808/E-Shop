<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h4 class="products-sub">Магазины по всей России</h4>
    <div class="input-box">
        <div class="products-input">
            <input type="text" name="searchWord" placeholder="Поиск по объявлениям" <#if searchWord??>value="${searchWord}"</#if> class="form-control"
                   id="searchWord">
        </div>
        <button type="submit" class="hover">
            <img src="../static/images/loop.svg" alt="Поиск">
        </button>
    </div>
    <div class="card-columns">
        <#list Products as product>
            <div class="product-link-container">
                <a href="/Product/${product.id}" class="product-link">
                    <div class="product-image-box" style="background-image: url('/images/${product.previewImageId}')"></div>
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
</@t.template>
