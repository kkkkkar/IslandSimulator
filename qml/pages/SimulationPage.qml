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

                        animalsContainer.checkReproduction();
                    }
                }

                function checkReproduction() {
                    var newRabbits = [];

                    for (var i = 0; i < animals.length; i++) {
                        var rabbit = animals[i];
                        if (rabbit && rabbit.reproduce) {
                            var reproductionResult = rabbit.reproduce();
                            if (reproductionResult !== null) {
                                // Находим свободную соседнюю клетку
                                var freeSpot = findFreeSpot(reproductionResult.x, reproductionResult.y);
                                if (freeSpot) {
                                    newRabbits.push(freeSpot);
                                }
                            }
                        }
                    }
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
