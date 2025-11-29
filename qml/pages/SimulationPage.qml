import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: simulationPage

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
                rows: 18
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
                            return (row + col) % 2 === 0 ? "#77b570" : "#98FB98";
                        }
                        border.color: "#2E8B57"
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

                        } else {
                            console.log("Ошибка: не удалось создать объект кролика");
                        }
                        return rabbit;
                    } else {
                        console.log("Ошибка загрузки компонента:", component.errorString());
                        return null;
                    }
                }

                function createWolf(x, y) {
                    console.log("Создаем волка в позиции:", x, y);
                    var component = Qt.createComponent("../components/WolfMale.qml");

                    if (component.status === Component.Ready) {
                        var wolf = component.createObject(animalsContainer, {
                            "x_pos": x,
                            "y_pos": y,
                            "maxX": cellsGrid.columns,
                            "maxY": cellsGrid.rows,
                            "width": cellsGrid.cellSize,
                            "height": cellsGrid.cellSize
                        });

                        if (wolf) {
                            updateAnimalPosition(wolf);
                            animals.push(wolf);
                            console.log("Волк создан");
                        }
                        return wolf;
                    } else {
                        console.log("Ошибка загрузки компонента Wolf.qml:", component.errorString());
                        return null;
                    }
                }

                function createWolfFemale(x, y) {
                    console.log("Создаем волчицу в позиции:", x, y);
                    var component = Qt.createComponent("../components/WolfFemale.qml");

                    if (component.status === Component.Ready) {
                        var wolfFemale = component.createObject(animalsContainer, {
                            "x_pos": x,
                            "y_pos": y,
                            "maxX": cellsGrid.columns,
                            "maxY": cellsGrid.rows,
                            "width": cellsGrid.cellSize,
                            "height": cellsGrid.cellSize
                        });

                        if (wolfFemale) {
                            updateAnimalPosition(wolfFemale);
                            animals.push(wolfFemale);
                            console.log("Волчица создана");
                        }
                        return wolfFemale;
                    } else {
                        console.log("Ошибка загрузки компонента WolfFemale.qml:", component.errorString());
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

                // Функция проверки размножения волков
                function checkWolfReproduction() {
                    var maleWolves = getWolvesByGender("male");
                    var femaleWolves = getWolvesByGender("female");
                    var newWolves = [];

                    // Для каждой волчицы ищем волка в соседних клетках
                    for (var i = 0; i < femaleWolves.length; i++) {
                        var female = femaleWolves[i];

                        // Проверяем, может ли волчица размножаться
                        if (!female.canReproduce || !female.canReproduce()) continue;

                        // Ищем волка в соседних клетках
                        for (var j = 0; j < maleWolves.length; j++) {
                            var male = maleWolves[j];

                            // Проверяем, может ли волк размножаться
                            if (!male.canReproduce || !male.canReproduce()) continue;

                            // Проверяем, находятся ли в соседних клетках
                            if (areNeighbors(female, male)) {
                                // Шанс размножения 25%
                                if (Math.random() < 0.25) {
                                    console.log("Волки размножаются!");
                                    var freeSpot = findFreeSpot(female.x_pos, female.y_pos);
                                    if (freeSpot) {
                                        newWolves.push(freeSpot);

                                        // Устанавливаем задержку размножения
                                        female.setReproductionCooldown();
                                        male.setReproductionCooldown();

                                        break; // Одна волчица может размножиться только с одним волком за ход
                                    }
                                }
                            }
                        }
                    }

                    // Создаем новых волков
                    for (var k = 0; k < newWolves.length; k++) {
                        // Случайно выбираем пол нового волка
                        if (Math.random() < 0.5) {
                            createWolf(newWolves[k].x, newWolves[k].y);
                        } else {
                            createWolfFemale(newWolves[k].x, newWolves[k].y);
                        }
                    }
                }

                // Функция проверки, находятся ли животные в соседних клетках
                function areNeighbors(animal1, animal2) {
                    var dx = Math.abs(animal1.x_pos - animal2.x_pos);
                    var dy = Math.abs(animal1.y_pos - animal2.y_pos);
                    return (dx <= 1 && dy <= 1 && !(dx === 0 && dy === 0));
                }

                // Функция уменьшения задержки размножения у всех волков
                function decreaseWolfCooldowns() {
                    var wolves = getAllWolves();
                    for (var i = 0; i < wolves.length; i++) {
                        if (wolves[i].decreaseCooldown) {
                            wolves[i].decreaseCooldown();
                        }
                    }
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


                // Функция для поиска ближайшего зайца (для будущей реализации погони)
//                function findNearestRabbit(wolfX, wolfY) {
//                    var rabbits = getAllRabbits();
//                    var nearestRabbit = null;
//                    var minDistance = Infinity;

//                    for (var i = 0; i < rabbits.length; i++) {
//                        var rabbit = rabbits[i];
//                        var distance = Math.sqrt(
//                            Math.pow(rabbit.x_pos - wolfX, 2) +
//                            Math.pow(rabbit.y_pos - wolfY, 2)
//                        );

//                        if (distance < minDistance) {
//                            minDistance = distance;
//                            nearestRabbit = rabbit;
//                        }
//                    }

//                    return nearestRabbit;
//                }

                function updateAnimalPosition(animal) {
                    if (!animal) return;

                    animal.x = cellsGrid.startX + animal.x_pos * (cellsGrid.cellSize + cellsGrid.spacing);
                    animal.y = cellsGrid.startY + animal.y_pos * (cellsGrid.cellSize + cellsGrid.spacing);

                }

                // Таймер для движения
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        for (var i = 0; i < animalsContainer.animals.length; i++) {
                            console.log("тайм сработал, животных: ", animalsContainer.animals.length)
                            var animal = animalsContainer.animals[i];
                            if (animal && animal.move) {
                                if (animal.move()) {
                                    animalsContainer.updateAnimalPosition(animal);
                                }
                            }
                        }
                        animalsContainer.decreaseWolfCooldowns();

                        animalsContainer.checkReproduction();

                        animalsContainer.checkWolfReproduction();
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
                    createRabbit(2, 3);
                    createRabbit(5, 7);

                    // Создаем начальных волков
                    createWolf(1,1);
                    createWolf(9,16);

                    // Создаем начальных волков
                    createWolfFemale(1,3);
                    createWolfFemale(9,10);
                }
            }
        }

        // Кнопка возврата
        Button {
            id: backButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Назад"
            onClicked: pageStack.pop()
        }

    }

    Component.onCompleted: {
        console.log("SimulationPage загружена");
    }
}
