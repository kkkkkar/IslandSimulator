
import QtQuick 2.0

Item {
    id: animal

    property int x_pos: 0
    property int y_pos: 0
    property string imageSource: ""
    property int maxX: 0 // размеры поля, передаются из simulationPage
    property int maxY: 0 //

    Image {
        id: animalImage
        anchors.fill: parent
        source: parent.imageSource
        visible: imageSource !== "" // Показываем только если есть изображение
        fillMode: Image.PreserveAspectFit

    }

    function move() {
        var directions = [
            {dx: 0, dy: 0}, {dx: 0, dy: -1}, {dx: 0, dy: 1},
            {dx: 1, dy: 0}, {dx: 1, dy: -1}, {dx: 1, dy: 1},
            {dx: -1, dy: 0}, {dx: -1, dy: -1}, {dx: -1, dy: 1}
        ];

        var direction = directions[Math.floor(Math.random() * directions.length)];
        var newX = x_pos + direction.dx;
        var newY = y_pos + direction.dy;

        if (newX >= 0 && newX < maxX && newY >= 0 && newY < maxY) {
            x_pos = newX;
            y_pos = newY;
            return true;
        }
         return false;
    }
}
