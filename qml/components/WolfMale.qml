import QtQuick 2.0

Animal {
    id: wolf

    property string gender: "male" // Мужской пол
    property int reproductionCooldown: 0

    Component.onCompleted: {
        rate = 3;
        imageSource = "../images/wolfB.png";
    }

    // Пока двигается хаотично, как Animal
    // Позже переопределим move() для погони за зайцами

    function decreaseCooldown() {
            if (reproductionCooldown > 0) {
                reproductionCooldown--;
            }
        }

        function canReproduce() {
            return reproductionCooldown === 0;
        }

        function setReproductionCooldown() {
            reproductionCooldown = 4;
        }
}
