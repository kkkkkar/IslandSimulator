import QtQuick 2.0

Animal {
    id: wolf

    property string gender: "not defined"
    property int lifetime: 20
    property bool isAlive: true
    property var targetRabbit: null // Цель для преследования
    property bool isRunningAfterRabbit: false
    property bool hasMovedForEating: false

    Component.onCompleted: {
        if (gender == "female")
            imageSource = "../images/wolfG.png";
        else if (gender == "male")
            imageSource = "../images/wolfB.png";
        else
            console.log("ошибка: пол волка не определен");
    }
    // Уменьшаем время жизни каждый ход
    function decreaseLifetime() {
        if (isAlive) {
            lifetime--;
            if (lifetime <= 0) {
                isAlive = false;
                return true; // Волк умер
            }
        }
        return false;
    }

    // Волк поедает зайца и получает +5 к жизни
        function eatRabbit() {
            lifetime += 5;
            console.log("Волк поел зайца! Новая жизнь:", lifetime);
        }

        // Движение волка с учетом преследования
            function chaseMove() {
                if (!isAlive) return false;

                // Если есть цель и она еще жива
                if (targetRabbit && targetRabbit.x_pos !== undefined) {
                    x_pos = targetRabbit.x_pos;
                    y_pos = targetRabbit.y_pos;
                    targetRabbit = null;
                    isRunningAfterRabbit = false;
                    return true;
                } else {
                    // Обычное случайное движение
                    targetRabbit = null;
                    isRunningAfterRabbit = false;
                    return move();
                }
            }

}

