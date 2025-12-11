import QtQuick 2.0

Animal {
    id: wolf

    property string gender: "not defined" //
    property int lifetime: 20 // Время жизни волчицы
    property bool isAlive: true

    Component.onCompleted: {
        rate = 3;// зачем это?
        if (gender == "female")
            imageSource = "../images/wolfG.png";
        else if (gender == "male")
            imageSource = "../images/wolfB.png";
        else
            console.log("ошибка: пол волка не определен")
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

}

