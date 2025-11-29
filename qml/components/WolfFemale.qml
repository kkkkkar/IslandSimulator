import QtQuick 2.0

Animal {
    id: wolfFemale

    property string gender: "female" // Женский пол
    property int reproductionCooldown: 0 // Задержка между размножением

    Component.onCompleted: {
        rate = 3;
        imageSource = "../images/wolfG.png"; // Добавьте изображение волчицы
    }

    // Уменьшаем задержку размножения каждый ход
    function decreaseCooldown() {
        if (reproductionCooldown > 0) {
            reproductionCooldown--;
        }
    }

    // Проверка готовности к размножению
    function canReproduce() {
        return reproductionCooldown === 0;
    }

    // Устанавливаем задержку после размножения
    function setReproductionCooldown() {
        reproductionCooldown = 4; // 4 хода задержки
    }
}
