// MainPage.qml
import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: mainPage

    PageHeader {
        title: "Симулятор Острова"
    }

    // Функция для проверки валидности ввода
    function validateInput() {
        // Проверяем, что элементы уже созданы
        if (!rabbitInput || !wolfMaleInput || !wolfFemaleInput ||!errorLabel ) {
            return false;
        }
        var rabbits = parseInt(rabbitInput.text) || 0;
        var maleWolves = parseInt(wolfMaleInput.text) || 0;
        var femaleWolves = parseInt(wolfFemaleInput.text) || 0;
        var total = rabbits + maleWolves + femaleWolves;
        var maxCells = 140; // 10x14 клеток

        if (total === 0) {
            errorLabel.text = "Добавьте хотя бы одного животного!";
            return false;
        }

        if (total > maxCells * 0.3) { // Не больше 30% от всех клеток
            errorLabel.text = "Слишком много животных! Максимум " + Math.floor(maxCells * 0.3);
            return false;
        }

        errorLabel.text = "";
        return true;
    }

    Column {
        anchors {
            top: parent.top
            topMargin: Theme.itemSizeLarge
            left: parent.left
            right: parent.right
            margins: Theme.paddingLarge
        }
        spacing: Theme.paddingLarge

        Label {
            text: "Начальная популяция"
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.highlightColor
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Информация об ограничениях
        Rectangle {
            width: parent.width
            height: Theme.itemSizeSmall
            color: Theme.rgba(Theme.secondaryHighlightColor, 0.3)
            radius: Theme.paddingSmall

            Label {
                anchors.centerIn: parent
                text: "Остров: 10×14 клеток (макс: 42 животных)"
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
            }
        }

        // Кролики
        Column {
            width: parent.width
            spacing: Theme.paddingSmall

            Label {
                text: "Кролики:"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
            }

            TextField {
                id: rabbitInput
                width: parent.width
                placeholderText: "Введите число (0-20)"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 20 }
                text: "4"

                onTextChanged: validateInput()
            }
        }

        // Волки-самцы
        Column {
            width: parent.width
            spacing: Theme.paddingSmall

            Label {
                text: "Волки:"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
            }

            TextField {
                id: wolfMaleInput
                width: parent.width
                placeholderText: "Введите число (0-10)"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 10 }
                text: "2"

                onTextChanged: validateInput()
            }
        }

        // Волки-самки
        Column {
            width: parent.width
            spacing: Theme.paddingSmall

            Label {
                text: "Волчицы:"
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
            }

            TextField {
                id: wolfFemaleInput
                width: parent.width
                placeholderText: "Введите число (0-10)"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 10 }
                text: "2"

                onTextChanged: validateInput()
            }
        }

        // Информация о текущем количестве
        Rectangle {
            width: parent.width
            height: Theme.itemSizeSmall
            color: Theme.rgba(Theme.highlightBackgroundColor, 0.5)
            radius: Theme.paddingSmall

            Label {
                id: totalCountPreview
                anchors.centerIn: parent
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor

                function updateText() {
                    var total = (parseInt(rabbitInput.text) || 0) +
                                (parseInt(wolfMaleInput.text) || 0) +
                                (parseInt(wolfFemaleInput.text) || 0);
                    text = "Всего животных: " + total + "/42";
                }

                Component.onCompleted: updateText()
            }

            Connections {
                target: rabbitInput
                onTextChanged: totalCountPreview.updateText()
            }
            Connections {
                target: wolfMaleInput
                onTextChanged: totalCountPreview.updateText()
            }
            Connections {
                target: wolfFemaleInput
                onTextChanged: totalCountPreview.updateText()
            }
        }

        // Сообщение об ошибке
        Label {
            id: errorLabel
            width: parent.width
            wrapMode: Text.Wrap
            color: "red"
            font.pixelSize: Theme.fontSizeSmall
            visible: text !== ""
        }

        // Кнопка запуска
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Запустить симуляцию"
            enabled: errorLabel.text === "" &&
                    (parseInt(rabbitInput.text) || 0) +
                    (parseInt(wolfMaleInput.text) || 0) +
                    (parseInt(wolfFemaleInput.text) || 0) > 0

            onClicked: {
                if (validateInput()) {
                    pageStack.push(Qt.resolvedUrl("SimulationPage.qml"), {
                        initialRabbits: parseInt(rabbitInput.text) || 0,
                        initialMaleWolves: parseInt(wolfMaleInput.text) || 0,
                        initialFemaleWolves: parseInt(wolfFemaleInput.text) || 0
                    });
                }
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "О программе"
            onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
        }
    }
}
