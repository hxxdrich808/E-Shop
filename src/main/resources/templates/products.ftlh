<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h4>Магазины по всей России</h4>
    <div class="form-row">
        <div class="form-group col-md-2">
            <label for="searchCity">Город</label>
            <select id="searchCity" class="form-control">
                <option value="">Город не выбран</option>
                <option value="Москва">Москва</option>
                <option value="Красноярск">Красноярск</option>
                <option value="Казань">Казань</option>
            </select>
        </div>
        <div class="form-group col-md-10">
            <label for="searchWord">Поиск по объявлениям</label>
            <input type="text" name="searchWord" <#if searchWord??>value="${searchWord}"</#if> class="form-control"
                   id="searchWord">
        </div>
        <button style="width: 100%" type="submit" class="btn btn-dark">Поиск</button>
    </div>
    <hr>
    <div class="card-columns">
        <#list Products as product>
            <div class = "product-link-container">
                <a href="/Product/${product.id}" class="product-link">
                    <div class="card text-white bg-dark my-3 product">
                        <img src="/images/${product.previewImageId}"
                             class="card-img-top">
                        <div class="card-body">
                            <h5 class="card-title">${product.title}</h5>
                            <p class="card-text">${product.price} ₽</p>
                        </div>
                    </div>
                </a>
            </div>
        <#else>
            <h1 style="text-align: center">Не найдено</h1>
        </#list>
    </div>
    <hr>
</@t.template>