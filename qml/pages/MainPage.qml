import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: mainPage

    // Заголовок страницы
    PageHeader {
        id: header
        title: "Симулятор острова"
    }

    // Колонка с элементами
    Column {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: Theme.paddingLarge
        }
        spacing: Theme.paddingLarge

        // Кнопка запуска симуляции
        Button {
            id: startButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Запустить симуляцию"

            onClicked: {
                // Переход на страницу симуляции
                pageStack.push(Qt.resolvedUrl("SimulationPage.qml"))
            }
        }

        // Кнопка "О программе"
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "О программе"

            onClicked: {
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }
}
