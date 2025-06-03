<#import "blocks/template.ftlh" as t>
<@t.template user>
    <h3 class="user-sub">Подробная информация о пользователе ${user.name}</h3>
    <div class="user-info">
        <b>Номер телефона: </b> <span class="user-phone">${user.phoneNumber}</span>
    </div>
    <div class="user-info">
        <b>Email: </b> ${user.email}<br>
    </div>
    <#if errorMessage??>
        <h2 style="color: red">${errorMessage}</h2>
    </#if>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const phone = document.querySelector(".user-phone")
            phone.textContent = formatPhoneNumber(phone.innerHTML)
        });

        function formatPhoneNumber(phoneNumber) {
            const cleaned = ('' + phoneNumber).replace(/\D/g, '');
            const hasPlus = cleaned.charAt(0) === '+';
            let formattedNumber;
            if (hasPlus) {
                const match = cleaned.match(/^\+(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})$/);
                if (match) {
                    formattedNumber = '+' + match[1] + ' (' + match[2] + ') ' + match[3] + '-' + match[4] + '-' + match[5];
                } else {
                    formattedNumber = phoneNumber;
                }
            } else {
                const match = cleaned.match(/^(\d{1})(\d{3})(\d{3})(\d{2})(\d{2})$/);
                if (match) {
                    formattedNumber = '+' + match[1] + ' (' + match[2] + ') ' + match[3] + '-' + match[4] + '-' + match[5];
                } else {
                    formattedNumber = phoneNumber;
                }
            }
            return formattedNumber;
        }
    </script>
</@t.template>
