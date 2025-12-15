import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: simulationPage

    // Панель статистики
    Rectangle {
        id: statsPanel
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.paddingMedium
            right: parent.right
            rightMargin: Theme.paddingMedium
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
                    font.pixelSize: Theme.fontSizeExtraSmall
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
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.primaryColor
                }

                Label {
                    id: wolfMaleCountLabel
                    text: "0"
                    font.pixelSize: Theme.fontSizeLarge // Крупнее
                    color: "#8B4513" // Коричневый
                    font.bold: true
                }
            }

            // Счетчик волков (жен)
            Column {
                spacing: Theme.paddingSmall

                Label {
                    text: "Волчицы 🐺♀:"
                    font.pixelSize: Theme.fontSizeExtraSmall
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
                    font.pixelSize: Theme.fontSizeExtraSmall
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


    // Основной контейнер
    Column {
        anchors {
            top: parent.top
            topMargin: Theme.itemSizeExtraLarge
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: Theme.paddingLarge

        // Контейнер для сетки клеток с отступами
        Item {
            id: gridContainer
            width: parent.width
            height: parent.height - backButton.height - parent.spacing

            Grid {
                id: cellsGrid
                anchors.centerIn: parent
                rows: 14
                columns: 10
                spacing: 2

                property real cellSize: Math.min(
                    (parent.width - (columns - 1) * spacing) / columns,
                    (parent.height - (rows - 1) * spacing) / rows
                )

                property real startX: (parent.width - (columns * cellSize + (columns - 1) * spacing)) / 2
                property real startY: (parent.height - (rows * cellSize + (rows - 1) * spacing)) / 2

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
            }

            // Контейнер для животных
            Item {
                id: animalsContainer
                anchors.fill: parent

                property var animals: []

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
                            updateStats(); // Обновляем статистику

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
                            updateStats(); // Обновляем статистику
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

                // функция поедания зайцев волками
                // функция поедания зайцев волками
                function checkWolfEating() {
                    var wolves = getAllWolves();
                    var rabbits = getAllRabbits();
                    var rabbitsEaten = [];

                    for (var i = 0; i < wolves.length; i++) {
                        var wolf = wolves[i];

                        // Проверяем, жив ли волк
                        if (!wolf.isAlive) continue;

                        // Ищем зайца рядом
                        for (var j = 0; j < rabbits.length; j++) {
                            var rabbit = rabbits[j];

                            // Проверяем, являются ли соседями
                            if (areNeighbors(wolf, rabbit)) {
                                console.log("Волк рядом с зайцем:", wolf.x_pos, wolf.y_pos, "заяц:", rabbit.x_pos, rabbit.y_pos);

                                // НЕПОСРЕДСТВЕННО перемещаем волка на клетку зайца
                                wolf.x_pos = rabbit.x_pos;
                                wolf.y_pos = rabbit.y_pos;

                                // Устанавливаем флаг, что волк уже сделал ход
                                wolf.hasMovedForEating = true;

                                // Обновляем позицию волка ВИЗУАЛЬНО
                                updateAnimalPosition(wolf);

                                // Волк ест зайца
                                if (wolf.eatRabbit) {
                                    wolf.eatRabbit();
                                }

                                // Помечаем зайца на удаление
                                rabbitsEaten.push(j);

                                console.log("Волк съел зайца в клетке:", rabbit.x_pos, rabbit.y_pos);
                                break; // Волк может съесть только одного зайца за ход
                            }
                        }
                    }
                    return rabbitsEaten;
                }

                // Функция удаления съеденных зайцев
                function removeEatenRabbits(rabbitIndices) {
                    // Сортируем индексы по убыванию для правильного удаления
                    rabbitIndices.sort(function(a, b) { return b - a; });

                    for (var i = 0; i < rabbitIndices.length; i++) {
                        var index = rabbitIndices[i];
                        if (index >= 0 && index < getAllRabbits().length) {
                            var rabbits = getAllRabbits();
                            var globalIndex = findAnimalIndex(rabbits[index]);

                            if (globalIndex !== -1) {
                                var rabbit = animals[globalIndex];
                                if (rabbit) {
                                    rabbit.destroy(); // Удаляем визуально
                                }
                                animals.splice(globalIndex, 1); // Удаляем из массива
                            }
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
                            // Волк умер
                            deadWolves.push(i);
                            console.log("Волк умер от старости");
                        }
                    }

                    // Удаляем умерших волков
                    removeDeadWolves(deadWolves);
                }

                // Функция удаления умерших волков
                function removeDeadWolves(wolfIndices) {
                    wolfIndices.sort(function(a, b) { return b - a; });

                    for (var i = 0; i < wolfIndices.length; i++) {
                        var index = wolfIndices[i];
                        if (index >= 0 && index < animals.length) {
                            var wolf = animals[index];
                            if (wolf) {
                                wolf.destroy();
                            }
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
                                if (Math.random() < 0.35) {
                                    console.log("Волки размножаются!");
                                    var newx = getRandomInt(1,10)
                                    var newy = getRandomInt(1, 14)
                                    newWolves.push({x: newx, y: newy});
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

                    animal.x = cellsGrid.startX + animal.x_pos * (cellsGrid.cellSize + cellsGrid.spacing);
                    animal.y = cellsGrid.startY + animal.y_pos * (cellsGrid.cellSize + cellsGrid.spacing);

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

                function countTotalAnimals() {
                    return animals.length;
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
                    interval: 1100
                    running: true
                    repeat: true
                    onTriggered: {

                        // Волки едят зайцев
                        var rabsToKill = animalsContainer.checkWolfEating();

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
                                    animalsContainer.updateAnimalPosition(animal);
                                }
                            }
                        }

                        // Удаляем съеденных зайцев
                        animalsContainer.removeEatenRabbits(rabsToKill); // хз тут ли

                        // Уменьшаем время жизни волков
                        animalsContainer.decreaseWolfLifetimes();

                        animalsContainer.checkReproduction();

                        animalsContainer.checkWolfReproduction();

                        // Обновляем счетчики
                        animalsContainer.updateStats();
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

                Component.onCompleted: {

                    // Создаем начальных кроликов
                    createRabbit(5, 5);
                    createRabbit(5, 7);

                    // Создаем начальных волков
                    createWolf(1,1, "male");
                    createWolf(6,6, "male");

                    // Создаем начальных волков
                    createWolf(1,3, "female");
                    createWolf(9,10, "female");

                    // Инициализируем счетчики
                    updateStats();
                }
            }
        }


        // Кнопки управления скоростью анимации
        Row {
            anchors {
                top: statsPanel.bottom
                topMargin: Theme.paddingMedium // Отступ сверху
                left: parent.left
                leftMargin: Theme.paddingMedium // Отступ слева
                right: parent.right
                rightMargin: Theme.paddingMedium // Отступ справа
            }

            Button {
                id: slower
                text: "Медленнее ⏪"
                preferredWidth: Screen.width / 3.5
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
                preferredWidth: Screen.width / 3.5
                anchors.left: slower.right
                onClicked: {
                    movementTimer.running = !movementTimer.running
                }
            }

            Button {
                id: faster
                text: "Быстрее ⏩"
                preferredWidth: Screen.width / 3.5
                anchors.left: pauseButton.right
                onClicked: {
                    if (movementTimer.interval > 500) {
                        movementTimer.interval -= 300
                    }
                }
            }
        }
        // Кнопка возврата
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
}
