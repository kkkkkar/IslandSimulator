import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: simulationPage


    // Параметры начальной популяции
    property int initialRabbits: 4
    property int initialMaleWolves: 2
    property int initialFemaleWolves: 2


    // Основной контейнер
    Column {
        id: mainContainer
        anchors {
            left: parent.left
            right: parent.right
        }
        width: parent.width
        height: parent.height
        spacing: Theme.paddingLarge

        // Панель статистики
        Rectangle {
        id: statsPanel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }
        height: Theme.itemSizeExtraLarge
        color: Theme.rgba(Theme.secondaryHighlightColor, 0.9)
        radius: Theme.paddingMedium


        Row {
            anchors {
                left: parent.left
                leftMargin: Theme.paddingMedium
                rightMargin: Theme.paddingMedium
                verticalCenter: parent.verticalCenter
            }
            spacing: Theme.paddingLarge

            // Счетчик кроликов
            Column {
                spacing: Theme.paddingSmall

                Label {
                    text: "Кролики 🐇:"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }

                Label {
                    id: rabbitCountLabel
                    text: "0"
                    font.pixelSize: Theme.fontSizeLarge
                    color: "#2E8B57"
                    font.bold: true
                }
            }

            // Счетчик волков (муж)
            Column {
                spacing: Theme.paddingSmall

                Label {
                    text: "Волки 🐺♂:"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }

                Label {
                    id: wolfMaleCountLabel
                    text: "0"
                    font.pixelSize: Theme.fontSizeLarge
                    color: "#8B4513" // Коричневый
                    font.bold: true
                }
            }

            // Счетчик волков (жен)
            Column {
                spacing: Theme.paddingSmall

                Label {
                    text: "Волчицы 🐺♀:"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }

                Label {
                    id: wolfFemaleCountLabel
                    text: "0"
                    font.pixelSize: Theme.fontSizeLarge
                    color: "#A0522D" // Светло-коричневый
                    font.bold: true
                }
            }

            // Общее количество животных
            Column {
                spacing: Theme.paddingSmall

                Label {
                    text: "Всего:"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.primaryColor
                }

                Label {
                    id: totalCountLabel
                    text: "0"
                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.highlightColor
                    font.bold: true
                }
            }
        }
    }

        // Кнопки управления скоростью анимации
        Row {
        id: changeSpeed
        anchors {
            top: statsPanel.bottom
            left: parent.left
            right: parent.right
            margins: Theme.paddingMedium
        }
        height: Theme.itemSizeMedium
        spacing: Theme.paddingMedium

        Button {
            id: slower
            text: "Медленнее ⏪"
            width: (parent.width - 2 * parent.spacing) / 3
            onClicked: {
                if (movementTimer.interval < 2000) {
                    movementTimer.interval += 300
                }
            }
        }

        // Кнопка паузы
        Button {
            id: pauseButton
            text: movementTimer.running ? "пауза⏸️" : "воспр▶️"
            width: (parent.width - 2 * parent.spacing) / 3
            onClicked: {
                movementTimer.running = !movementTimer.running
            }
        }

        Button {
            id: faster
            text: "Быстрее ⏩"
            width: (parent.width - 2 * parent.spacing) / 3
            onClicked: {
                if (movementTimer.interval > 500) {
                    movementTimer.interval -= 300
                }
            }
        }
    }

        // Контейнер для сетки
        Grid {
        id: cellsGrid
                anchors.top: changeSpeed.bottom
                rows: 14
                columns: 10
                spacing: 2
                anchors.bottom: backButton.top

                property real cellSize: Math.min(
                    (parent.width - (columns - 1) * spacing) / columns,
                    (parent.height - (rows - 1) * spacing) / rows
                )

                Repeater {
                    model: cellsGrid.columns * cellsGrid.rows

                    Rectangle {
                        width: cellsGrid.cellSize
                        height: cellsGrid.cellSize

                        color: {
                            var row = Math.floor(index / cellsGrid.columns);
                            var col = index % cellsGrid.columns;
                            return (row + col) % 2 === 0 ? "#83d487" : "#98FB98";
                        }
                        border.color: "#81d6a6"
                        border.width: 1
                        radius: 2
                    }
                }
                // Контейнер для животных
                Item {
                        id: animalsContainer
                        anchors.fill: cellsGrid

                        property var animals: []

                        // Свойства для контроля популяции
                        property int maxAnimals: Math.floor(cellsGrid.columns * cellsGrid.rows * 0.9) // 90% от всех клеток
                        property bool simulationStopped: false
                        property string stopReason: ""

                        // История численности (максимум 500 точек)
                        property var rabbitHistory: []
                        property var wolfHistory: []

                        // Функция сброса истории (вызывать при старте новой симуляции)
                        function resetHistory() {
                            rabbitHistory = []
                            wolfHistory = []
                        }

                        // Функция записи текущего состояния
                        function recordSnapshot() {
                            rabbitHistory.push(countRabbits())
                            wolfHistory.push(countMaleWolves() + countFemaleWolves())
                            // Ограничиваем длину, чтобы не переполнить память
                            if (rabbitHistory.length > 500) {
                                rabbitHistory.shift()
                                wolfHistory.shift()
                            }
                        }

                        function countTotalAnimals() {
                            return animals.length;
                        }

                        // Функция проверки перенаселения или вымирания вида
                        function checkOverpopulation() {
                            var totalAnimals = countTotalAnimals();
                            var rabbits = countRabbits()
                            var wolves = countFemaleWolves() + countMaleWolves()

                            if (totalAnimals >= maxAnimals) {
                                simulationStopped = true;
                                stopPanel.visible = true;
                                backButton.visible = false;
                                stopReason = "Перенаселение острова! Животных: " + totalAnimals + "/" + maxAnimals;
                                movementTimer.running = false;
                                console.log("Симуляция остановлена: " + stopReason);
                                return true;
                            }

                            // Проверка на вымирание
                            if (countRabbits() === 0 || (countMaleWolves() === 0 && countFemaleWolves() === 0)) {
                                simulationStopped = true;
                                stopPanel.visible = true;
                                backButton.visible = false;
                                if (countRabbits() === 0) {
                                    stopReason = "Вымирание кроликов! Осталось волков: " + wolves;
                                }
                                else {
                                    stopReason = "Вымирание волков! Осталось кроликов: " + rabbits;
                                }

                                movementTimer.running = false;
                                console.log("Симуляция остановлена: " + stopReason);
                                return true;
                            }

                            return false;
                        }


                        function createRabbit(x, y) {
                            console.log("Создаем кролика в позиции:", x, y);
                            var component = Qt.createComponent("../components/Rabbit.qml");

                            if (component.status === Component.Ready) {
                                var rabbit = component.createObject(animalsContainer, {
                                    "x_pos": x,
                                    "y_pos": y,
                                    "maxX": cellsGrid.columns,
                                    "maxY": cellsGrid.rows,
                                    "cellSize": cellsGrid.cellSize,
                                    "width": cellsGrid.cellSize,
                                    "height": cellsGrid.cellSize
                                });

                                if (rabbit) {
                                    updateAnimalPosition(rabbit);
                                    animals.push(rabbit);
                                    updateStats();

                                } else {
                                    console.log("Ошибка: не удалось создать объект кролика");
                                }
                                return rabbit;
                            } else {
                                console.log("Ошибка загрузки компонента:", component.errorString());
                                return null;
                            }
                        }
                        function createWolf (x, y, gender) {
                            console.log("Создаем волка в позиции:", x, y, ", пол: ", gender);
                            var component = Qt.createComponent("../components/Wolf.qml");

                            if (component.status === Component.Ready) {
                                var wolf = component.createObject(animalsContainer, {
                                    "x_pos": x,
                                    "y_pos": y,
                                    "gender": gender,
                                    "maxX": cellsGrid.columns,
                                    "maxY": cellsGrid.rows,
                                    "width": cellsGrid.cellSize,
                                    "height": cellsGrid.cellSize
                                });

                                if (wolf) {
                                    updateAnimalPosition(wolf);
                                    animals.push(wolf);
                                    updateStats();
                                    console.log("Волк ", gender, " создан");
                                }
                                return wolf;
                            } else {
                                console.log("Ошибка загрузки компонента Wolf.qml:", component.errorString());
                                return null;
                            }
                        }


                        // Функция для получения всех волков (обоих полов)
                        function getAllWolves() {
                            var wolves = [];
                            for (var i = 0; i < animals.length; i++) {
                                var animal = animals[i];
                                if (animal && (animal.gender === "male" || animal.gender === "female")) {
                                    wolves.push(animal);
                                }
                            }
                            return wolves;
                        }

                        // Функция для получения волков определенного пола
                        function getWolvesByGender(gender) {
                            var wolves = [];
                            for (var i = 0; i < animals.length; i++) {
                                var animal = animals[i];
                                if (animal && animal.gender === gender) {
                                    wolves.push(animal);
                                }
                            }
                            return wolves;
                        }

                        function checkWolfChasing() {
                            var wolves = getAllWolves();
                            var rabbits = getAllRabbits();
                            var rabbitsToEat = [];   // массив объектов кроликов, которых нужно съесть

                            for (var i = 0; i < wolves.length; i++) {
                                var wolf = wolves[i];
                                if (!wolf.isAlive) continue;

                                for (var j = 0; j < rabbits.length; j++) {
                                    var rabbit = rabbits[j];
                                    if (!rabbit) continue;

                                    if (areNeighbors(wolf, rabbit)) {
                                        wolf.x_pos = rabbit.x_pos;
                                        wolf.y_pos = rabbit.y_pos;
                                        wolf.hasMovedForEating = true;
                                        updateAnimalPosition(wolf);
                                        if (wolf.eatRabbit) wolf.eatRabbit();

                                        if (rabbitsToEat.indexOf(rabbit) === -1) {
                                            rabbitsToEat.push(rabbit);
                                        }
                                        break;   // волк съедает только одного кролика за ход
                                    }
                                }
                            }
                            return rabbitsToEat;
                        }

                        function removeEatenRabbits(rabbitsToEat) {
                            for (var i = 0; i < rabbitsToEat.length; i++) {
                                var rabbit = rabbitsToEat[i];
                                var index = animals.indexOf(rabbit);
                                if (index !== -1) {
                                    rabbit.destroy();
                                    animals.splice(index, 1);
                                }
                            }
                        }
                        // Функция уменьшения времени жизни у волков
                        function decreaseWolfLifetimes() {
                            var wolves = getAllWolves();
                            var deadWolves = [];
                            for (var i = 0; i < wolves.length; i++) {
                                var wolf = wolves[i];
                                if (wolf.decreaseLifetime && wolf.decreaseLifetime()) {
                                    deadWolves.push(wolf);           // сохраняем объект
                                    console.log("Волк умер от старости");
                                }
                            }
                            removeDeadWolves(deadWolves);
                        }
                        // Функция удаления умерших волков
                        function removeDeadWolves(deadWolves) {
                            for (var i = 0; i < deadWolves.length; i++) {
                                var wolf = deadWolves[i];
                                var index = animals.indexOf(wolf);   // ищем индекс в общем массиве
                                if (index !== -1) {
                                    wolf.destroy();
                                    animals.splice(index, 1);
                                }
                            }
                        }


                        // Вспомогательная функция для поиска индекса животного в общем массиве
                        function findAnimalIndex(animalToFind) {
                            for (var i = 0; i < animals.length; i++) {
                                if (animals[i] === animalToFind) {
                                    return i;
                                }
                            }
                            return -1;
                        }

                        // Функция проверки размножения волков
                        function checkWolfReproduction() {
                            var maleWolves = getWolvesByGender("male");
                            var femaleWolves = getWolvesByGender("female");
                            var newWolves = [];

                            // Для каждой волчицы ищем волка в соседних клетках
                            for (var i = 0; i < femaleWolves.length; i++) {
                                var female = femaleWolves[i];

                                if (!female.isAlive) continue;

                                // Ищем волка в соседних клетках
                                for (var j = 0; j < maleWolves.length; j++) {
                                    var male = maleWolves[j];

                                    if (!male.isAlive) continue;

                                    // Проверяем, находятся ли в соседних клетках
                                    if (areNeighbors(female, male)) {
                                        if (Math.random() < 0.7) {
                                            console.log('female.x_pos - ', female.x_pos, ', male.x_pos - ', male.x_pos, ', cellsGrid.cellSize - ', cellsGrid.cellSize);
                                            var pos = findRandomFreeSpot()
                                            if (pos) {
                                                var newx = pos.x
                                                var newy = pos.y
                                                newWolves.push({x: newx, y: newy});
                                                console.log("Волки размножаются!");
                                                showHeart((female.x_pos + male.x_pos) / 2 * (cellsGrid.cellSize + cellsGrid.spacing), (female.y_pos + male.y_pos) / 2 * (cellsGrid.cellSize + cellsGrid.spacing));

                                            }
                                            else {
                                                console.log("Не удалось разместить нового волка, нет свободных клеток");
                                            }

                                            break; // Одна волчица может размножиться только с одним волком за ход

                                        }
                                    }
                                }
                            }

                            // Создаем новых волков
                            for (var k = 0; k < newWolves.length; k++) {
                                // Случайно выбираем пол нового волка
                                if (Math.random() < 0.5) {
                                    createWolf(newWolves[k].x, newWolves[k].y, "male");
                                } else {
                                    createWolf(newWolves[k].x, newWolves[k].y, "female");
                                }
                            }
                        }

                        function showHeart(cellX, cellY) {
                            // Создаём изображение сердечка
                            var heart = Qt.createQmlObject(
                                'import QtQuick 2.0; Image {' +
                                '   source: "../images/heart.png";' +
                                '   width: ' + cellsGrid.cellSize + ';' +
                                '   height: ' + cellsGrid.cellSize + ';' +
                                '   z: 10;' +
                                '   opacity: 1;' +
                                '   Behavior on opacity { NumberAnimation { duration: 200 } }' +
                                '}',
                                animalsContainer,
                                "heartEffect"
                            );

                            // Позиционируем сердечко
                            heart.x = cellX;
                            heart.y = cellY;

                            // Анимация исчезновения и удаление
                            var deleteTimer = Qt.createQmlObject(
                                'import QtQuick 2.0; Timer { interval: 1500; running: true; onTriggered: parent.destroy() }',
                                heart,
                                "heartTimer"
                            );
                            // Дополнительно: плавно уменьшаем прозрачность перед удалением
                            heart.opacity = 0;
                        }
                        function getRandomInt(min, max) {
                            min = Math.ceil(min);
                            max = Math.floor(max);
                            return Math.floor(Math.random() * (max - min + 1)) + min;
                        }

                        // Функция проверки, находятся ли животные в соседних клетках
                        function areNeighbors(animal1, animal2) {
                            var dx = Math.abs(animal1.x_pos - animal2.x_pos);
                            var dy = Math.abs(animal1.y_pos - animal2.y_pos);
                            return ((dx <= 1 && dy == 0) || (dx == 0 && dy <= 1));
                        }



                        // Функция для получения всех кроликов
                        function getAllRabbits() {
                            var rabbits = [];
                            for (var i = 0; i < animals.length; i++) {
                                var animal = animals[i];
                                // Проверяем, является ли животное кроликом по наличию метода reproduce
                                if (animal && animal.reproduce) {
                                    rabbits.push(animal);
                                }
                            }
                            return rabbits;
                        }


                        function updateAnimalPosition(animal) {
                            if (!animal) return;
                            // Валидация координат, чтобы животное не вышло за поле
                            animal.x_pos = Math.max(0, Math.min(animal.x_pos, cellsGrid.columns - 1));
                            animal.y_pos = Math.max(0, Math.min(animal.y_pos, cellsGrid.rows - 1));

                            animal.x = animal.x_pos * (cellsGrid.cellSize + cellsGrid.spacing);
                            animal.y = animal.y_pos * (cellsGrid.cellSize + cellsGrid.spacing);

                        }

                        // Функции для подсчета кроликов
                        function countRabbits() {
                            var count = 0;
                            for (var i = 0; i < animals.length; i++) {
                                if (animals[i] && animals[i].reproduce) {
                                    count++;
                                }
                            }
                            return count;
                        }

                        function countMaleWolves() {
                            var count = 0;
                            for (var i = 0; i < animals.length; i++) {
                                if (animals[i] && animals[i].gender === "male") {
                                    count++;
                                }
                            }
                            return count;
                        }

                        function countFemaleWolves() {
                            var count = 0;
                            for (var i = 0; i < animals.length; i++) {
                                if (animals[i] && animals[i].gender === "female") {
                                    count++;
                                }
                            }
                            return count;
                        }



                        // Функция обновления счетчиков
                        function updateStats() {
                            rabbitCountLabel.text = countRabbits();
                            wolfMaleCountLabel.text = countMaleWolves();
                            wolfFemaleCountLabel.text = countFemaleWolves();
                            totalCountLabel.text = countTotalAnimals();
                        }



                        // Таймер для движения
                        Timer {
                            id: movementTimer
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: {
                                if (animalsContainer.simulationStopped) {
                                    console.log("Симуляция остановлена, таймер не работает");
                                    return;
                                }

                                console.log("Ход симуляции, животных:", animalsContainer.animals.length);



                                // Волки едят зайцев
                                // волки преследуют зайцев
                                var rabsToKill = animalsContainer.checkWolfChasing();

                                // звери двигаются
                                for (var i = 0; i < animalsContainer.animals.length; i++) {
                                    var animal = animalsContainer.animals[i];

                                    // Пропускаем, если это волк, который уже сделал ход при поедании
                                    if (animal && animal.gender && animal.hasMovedForEating) {
                                        // Сбрасываем флаг для следующего хода
                                        animal.hasMovedForEating = false;
                                        continue;
                                    }

                                    if (animal && animal.move) {
                                        if (animal.move()) {
                                            // тут для кролика проверить не занята ли animal.x_pos и animal.y_pos,
                                            //если занята волком, то заново вызывать функцию
                                            //чтобы найти свободную координату, или стоять на месте?
                                            animalsContainer.updateAnimalPosition(animal);
                                        }
                                    }
                                }

                                // Удаляем съеденных зайцев
                                animalsContainer.removeEatenRabbits(rabsToKill);

                                // Уменьшаем время жизни волков
                                animalsContainer.decreaseWolfLifetimes();

                                animalsContainer.checkReproduction();

                                animalsContainer.checkWolfReproduction();

                                // Обновляем счетчики
                                animalsContainer.updateStats();

                                // Записываем данные для графиков
                                animalsContainer.recordSnapshot();

                                // Проверяем условия остановки
                                if (animalsContainer.checkOverpopulation()) {
                                    console.log("Симуляция остановлена автоматически");
                                }
                            }
                        }


                        function checkReproduction() {
                            var newRabbits = [];

                            // Проверяем размножение только у кроликов
                            var rabbits = getAllRabbits();
                            for (var i = 0; i < rabbits.length; i++) {
                                var rabbit = rabbits[i];
                                var reproductionResult = rabbit.reproduce();
                                if (reproductionResult !== null) {
                                    var freeSpot = findFreeSpot(reproductionResult.x, reproductionResult.y);
                                    if (freeSpot) {
                                        newRabbits.push(freeSpot);
                                    }
                                }
                            }

                            // Создаем новых кроликов
                            for (var j = 0; j < newRabbits.length; j++) {
                                createRabbit(newRabbits[j].x, newRabbits[j].y);
                            }
                        }

                        function findFreeSpot(x, y) {
                            var directions = [
                                {dx: -1, dy: -1}, {dx: 0, dy: -1}, {dx: 1, dy: -1},
                                {dx: -1, dy: 0},                     {dx: 1, dy: 0},
                                {dx: -1, dy: 1},  {dx: 0, dy: 1},  {dx: 1, dy: 1}
                            ];

                            // Перемешиваем направления для случайности
                            directions.sort(function() { return 0.5 - Math.random() });

                            for (var i = 0; i < directions.length; i++) {
                                var newX = x + directions[i].dx;
                                var newY = y + directions[i].dy;

                                if (newX >= 0 && newX < cellsGrid.columns && newY >= 0 && newY < cellsGrid.rows) {
                                    if (isCellFree(newX, newY)) {
                                        return { x: newX, y: newY };
                                    }
                                }
                            }
                            return null;
                        }

                        // Проверка, свободна ли клетка
                        function isCellFree(x, y) {
                            for (var i = 0; i < animals.length; i++) {
                                var animal = animals[i];
                                if (animal.x_pos === x && animal.y_pos === y) {
                                    return false;
                                }
                            }
                            return true;
                        }

                        function createInitialAnimals() {
                            resetHistory();
                            console.log("Создаем начальных животных:",
                                       initialRabbits, "кроликов,",
                                       initialMaleWolves, "волков-самцов,",
                                       initialFemaleWolves, "волков-самок");

                            // Создаем кроликов в случайных позициях
                            for (var i = 0; i < initialRabbits; i++) {
                                var pos = findRandomFreeSpot();
                                if (pos) {
                                    createRabbit(pos.x, pos.y);
                                } else {
                                    console.log("Не удалось разместить кролика, нет свободных клеток");
                                }
                            }

                            // Создаем волков-самцов
                            for (var j = 0; j < initialMaleWolves; j++) {
                                pos = findRandomFreeSpot();
                                if (pos) {
                                    createWolf(pos.x, pos.y, "male");
                                } else {
                                    console.log("Не удалось разместить волка-самца, нет свободных клеток");
                                }
                            }

                            // Создаем волков-самок
                            for (var k = 0; k < initialFemaleWolves; k++) {
                                pos = findRandomFreeSpot();
                                if (pos) {
                                    createWolf(pos.x, pos.y, "female");
                                } else {
                                    console.log("Не удалось разместить волка-самку, нет свободных клеток");
                                }
                            }

                            // Проверяем, что создали хотя бы некоторых животных
                            if (animals.length === 0) {
                                console.log("Не удалось создать ни одного животного!");
                                // Создаем хотя бы одного кролика в центре
                                createRabbit(Math.floor(cellsGrid.columns/2), Math.floor(cellsGrid.rows/2));
                            }
                        }

                        // Функция поиска случайной свободной клетки
                        function findRandomFreeSpot() {
                            var maxAttempts = 100; // Чтобы не зацикливаться
                            for (var attempt = 0; attempt < maxAttempts; attempt++) {
                                var x = Math.floor(Math.random() * cellsGrid.columns);
                                var y = Math.floor(Math.random() * cellsGrid.rows);

                                if (isCellFree(x, y)) {
                                    return { x: x, y: y };
                                }
                            }

                            // Если не нашли свободную клетку, ищем первую попавшуюся
                            for (x = 0; x < cellsGrid.columns; x++) {
                                for (y = 0; y < cellsGrid.rows; y++) {
                                    if (isCellFree(x, y)) {
                                        return { x: x, y: y };
                                    }
                                }
                            }

                            return null; // Все клетки заняты
                        }

                        Component.onCompleted: {
                            console.log("Animals container готов");
                            createInitialAnimals();
                            updateStats();
                            resetHistory();
                        }
                    }


            }

        // Панель остановки симуляции
        Rectangle {
            id: stopPanel
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: Theme.paddingMedium
            }
            height: Theme.itemSizeLarge * 1.5
            color: Theme.rgba(Theme.highlightBackgroundColor, 0.95)
            radius: Theme.paddingMedium
            visible: animalsContainer.simulationStopped // Привязываемся к свойству animalsContainer

            Row {
                anchors {
//                    verticalCenter: parent.verticalCenter
//                    left: parent.left
//                    leftMargin: Theme.paddingMedium
//                    right: parent.right
//                    rightMargin: Theme.paddingMedium
                    fill: parent
                    margins: Theme.paddingSmall
                }
                spacing: Theme.paddingSmall //medium

                // Иконка предупреждения
                Icon {
                    source: "image://theme/icon-m-warning"
                    height: Theme.iconSizeMedium
                    width: height
                    color: Theme.highlightColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Текстовый блок
                Column {
                    spacing: Theme.paddingSmall
                    width: parent.width - (Theme.iconSizeMedium + Theme.paddingMedium * 3 + 2 * Theme.itemSizeMedium)
                    anchors.verticalCenter: parent.verticalCenter

                    Label {
                        width: parent.width
                        text: animalsContainer.simulationStopped ? "СИМУЛЯЦИЯ ОСТАНОВЛЕНА" : ""
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.highlightColor
                        font.bold: true
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                    }

                    Label {
                        width: parent.width
                        text: animalsContainer.stopReason
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.primaryColor
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        horizontalAlignment: Text.AlignLeft
                    }
                }

                // Кнопка "График"
                    Button {
                        text: "График"
                        width: Theme.itemSizeMedium
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            var dialog = graphDialogComponent.createObject(simulationPage, {
                                rabbitData: animalsContainer.rabbitHistory,
                                wolfData: animalsContainer.wolfHistory
                            })
                            dialog.open()
                        }
                    }

                // Кнопка OK
                Button {
                    id: okButton
                    text: "OK"
                    width: Theme.itemSizeMedium
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        animalsContainer.simulationStopped = false; // Сбрасываем флаг
                        pageStack.pop(); // Вернуться на главную
                    }
                }
            }
        }

        // Кнопка возврата если simstopped то невидима
        Button {
            id: backButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            text: "Назад"
            onClicked: pageStack.pop()
        }

    }

    Component.onCompleted: {
        console.log("SimulationPage загружена");

    }

    /// далее код для графиков

    Component {
        id: graphDialogComponent

        Dialog {
            id: graphDialog
            //title: "Динамика популяции"

            property variant rabbitData: []
            property variant wolfData: []

            canAccept: false  // Убираем кнопку ОК, оставляем только кнопку закрытия

            // Поиск максимального значения для масштабирования
            function getMaxValue() {
                var max = 0
                for (var i = 0; i < rabbitData.length; i++) {
                    if (rabbitData[i] > max) max = rabbitData[i]
                    if (wolfData[i] > max) max = wolfData[i]
                }
                return max === 0 ? 1 : max
            }

            Column {
                width: parent.width
                spacing: Theme.paddingMedium
                //padding: Theme.paddingMedium

                Label {
                    text: "Динамика популяции"
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    id: graphArea
                    width: parent.width - 2 * Theme.paddingMedium
                    height: 300
                    color: "white"
                    border.color: Theme.primaryColor
                    border.width: 1
                    radius: 5

                    Canvas {
                        id: canvas
                        anchors.fill: parent

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()
                            ctx.clearRect(0, 0, width, height)

                            var dataR = graphDialog.rabbitData
                            var dataW = graphDialog.wolfData
                            if (dataR.length === 0) return

                            var maxVal = graphDialog.getMaxValue()
                            var stepX = width / (dataR.length - 1)
                            var h = height

                            // Рисуем оси
                            //ctx.strokeStyle = Theme.primaryColor
                            ctx.strokeStyle = "black"
                            ctx.fillStyle = "black"
                            ctx.lineWidth = 1
                            ctx.beginPath()
                            ctx.moveTo(0, h)
                            ctx.lineTo(width, h)
                            ctx.moveTo(0, 0)
                            ctx.lineTo(0, h)
                            ctx.stroke()

                            // Рисуем горизонтальные линии сетки
                            ctx.beginPath()
                            ctx.strokeStyle = "#cccccc"
                            ctx.lineWidth = 0.5
                            for (var val = 1; val <= 5; val++) {
                                var y = h - (val * maxVal / 5) / maxVal * h
                                ctx.moveTo(0, y)
                                ctx.lineTo(width, y)
                                ctx.stroke()
                            }
                            // Рисуем линию кроликов (зелёная)
                            ctx.beginPath()
                            ctx.strokeStyle = "#2E8B57"
                            ctx.lineWidth = 2
                            var first = true
                            for (var i = 0; i < dataR.length; i++) {
                                var x = i * stepX
                                var y = h - (dataR[i] / maxVal) * h
                                if (first) {
                                    ctx.moveTo(x, y)
                                    first = false
                                } else {
                                    ctx.lineTo(x, y)
                                }
                            }
                            ctx.stroke()

                            // Рисуем линию волков (красная)
                            ctx.beginPath()
                            ctx.strokeStyle = "#CD5C5C"
                            ctx.lineWidth = 2
                            first = true
                            for (i = 0; i < dataW.length; i++) {
                                x = i * stepX
                                y = h - (dataW[i] / maxVal) * h
                                if (first) {
                                    ctx.moveTo(x, y)
                                    first = false
                                } else {
                                    ctx.lineTo(x, y)
                                }
                            }
                            ctx.stroke()

                            // Подписи значений (минимум/максимум)
                            ctx.fillStyle = "black"
                            ctx.font = "30px sans-serif"
                            ctx.fillText("0", 2, h - 2)
                            ctx.fillText(maxVal, 2, 30)
                            //ctx.fillText("Время:" + dataR.length, width - 160, h - 2)
                        }
                    }
                }
                // Легенда
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Theme.paddingMedium

                    Rectangle {
                          width: Theme.iconSizeSmall
                          height: 2
                          color: "#2E8B57"
                          anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                         text: "Кролики"
                         font.pixelSize: Theme.fontSizeSmall
                         color: Theme.primaryColor
                    }
                    Rectangle {
                         width: Theme.iconSizeSmall
                         height: 2
                         color: "#CD5C5C"
                         anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: "Волки"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.primaryColor
                    }
                }

                Button {
                    text: "Закрыть"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: graphDialog.close()
                }
            }
        }
    }
}
