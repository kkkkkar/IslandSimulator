// qml/components/Rabbit.qml
import QtQuick 2.0

Animal {
    id: rabbit

    property int reproductionRate: 3
    property int age: 0

    Component.onCompleted: {
        rate = 2;
        imageSource = "../images/rabbit.png";
    }

    // Метод размножения
    function reproduce() {

        // Шанс размножения 10% каждый ход
        if (Math.random() < 0.1) {
            //console.log("Кролик размножается!");
            return { x: x_pos, y: y_pos }; // Возвращаем позицию для нового кролика
        }
        return null;
    }

}
