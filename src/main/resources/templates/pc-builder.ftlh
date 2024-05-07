<#import "blocks/template.ftlh" as t>
<@t.template user>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Конструктор ПК</title>
</head>
<body>
<h1>Конструктор ПК</h1>
<form action="/build" method="POST">
    <div>
        <label for="processor">Процессор:</label>
        <select id="processor" name="processor">
            <!-- Здесь будут варианты выбора процессора -->
        </select>
    </div>
    <div>
        <label for="motherboard">Материнская плата:</label>
        <select id="motherboard" name="motherboard">
            <!-- Здесь будут варианты выбора материнской платы -->
        </select>
    </div>
    <div>
        <label for="case">Корпус:</label>
        <select id="case" name="case">
            <!-- Здесь будут варианты выбора корпуса -->
        </select>
    </div>
    <div>
        <label for="gpu">Видеокарта:</label>
        <select id="gpu" name="gpu">
            <!-- Здесь будут варианты выбора видеокарты -->
        </select>
    </div>
    <div>
        <label for="cpuCooler">Охлаждение процессора:</label>
        <select id="cpuCooler" name="cpuCooler">
            <!-- Здесь будут варианты выбора охлаждения процессора -->
        </select>
    </div>
    <div>
        <label for="ram">Оперативная память:</label>
        <select id="ram" name="ram">
            <!-- Здесь будут варианты выбора оперативной памяти -->
        </select>
    </div>
    <div>
        <label for="storage">Накопитель памяти:</label>
        <select id="storage" name="storage">
            <!-- Здесь будут варианты выбора накопителя памяти -->
        </select>
    </div>
    <div>
        <label for="powerSupply">Блок питания:</label>
        <select id="powerSupply" name="powerSupply">
            <!-- Здесь будут варианты выбора блока питания -->
        </select>
    </div>
    <button type="submit">Собрать ПК</button>
</form>
</body>
</html>
</@t.template>