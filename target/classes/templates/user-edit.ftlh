<#import "blocks/template.ftlh" as t>
<@t.template user>
    <link rel="stylesheet" href="../../../static/css/style.css">
    <h1 style="text-align: center">Редактирование пользователя ${user.name}</h1>
    <form class="user-edit-form" action="/admin/user/edit" method="post">
        <#list roles as role>
            <div class="user-edit-input">
                <label><input class="role-checkbox" id=${role} type="checkbox" name="${role}" ${user.roles?seq_contains(role)?string("checked", "")}>${role}</label>
            </div>
        </#list>
        <input type="hidden" value="${user.id}" name="userId">
        <input type="hidden" value="${_csrf.token}" name="_csrf">
        <button type="submit" class="user-edit-btn">Сохранить</button>
    </form>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const checkboxes = document.getElementsByClassName("role-checkbox")
            for (let i of checkboxes) {
                i.addEventListener("change", () => {
                    for (let j of checkboxes) {
                        if (j.id !== i.id) {
                            j.checked = false
                            i.checked = true
                        }
                    }
                })
            }
        });
    </script>
</@t.template>
