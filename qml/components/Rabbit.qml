import QtQuick 2.0

Animal {
    id: rabbit

    Component.onCompleted: {
        imageSource = "../images/littlerabbit.png";
    }

    // Метод размножения
    function reproduce() {

        // Шанс размножения 10% каждый ход
        if (Math.random() < 0.07) {
            return { x: x_pos, y: y_pos }; // Возвращаем позицию для нового кролика
        }
        return null;
    }

}
