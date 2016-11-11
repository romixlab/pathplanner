var cppObjectToMapObject = []

function addPolyline(cppObject) {
    if (cppObjectToMapObject.indexOf(cppObject) !== -1)
        return;

    var mapPolyline = Qt.createQmlObject('import QtLocation 5.3; MapPolyline {line.color: "red"}',
                       map,
                       'DynamicPolyline(.qml)')
    map.addMapItem(mapPolyline)
    cppObjectToMapObject[cppObject] = mapPolyline
    console.log(cppObjectToMapObject[cppObject])
}

function removePolyline(cppObject) {

}

function modifyPolyline(cppObject, points, color, width) {
    var mapPolyline = cppObjectToMapObject[cppObject]
    var coordinates = []
    for (var i = 0; i < points.length; i += 2)
        coordinates.push(QtPositioning.coordinate(points[i], points[i + 1]))
    mapPolyline.path = coordinates
}
