    <#import "blocks/template.ftlh" as t>
    <@t.template user>
        <h1>eshop</h1><hr>
        <h4>Подробная информация о товаре</h4>
        <#list images as img>
            <img src="/images/${img.id}" height="60px"/><br><br>
        </#list>
        <b>Название товара: </b>${product.title}<br>
        <b>Описание товара: </b>${product.description}<br>
        <b>Цена товара: </b>${product.price}<br>
        <hr>
        <#if user.isAdmin()>
            <form action="/Product/delete/${product.id}" method="post">
                <input type="hidden" name="_csrf" value="${_csrf.token}">
                <input type="submit" value="Удалить товар"/>
            </form>
        </#if>
    </@t.template>