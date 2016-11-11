import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0

import QtLocation 5.3
import QtPositioning 5.2

import "polyline.js" as PolyLineLogic
//import ru.marsworks 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    visibility: Window.Maximized
    title: qsTr("Hello World")

    Settings {
        id: settings
        property string style: "Universal"
    }

    header: ToolBar {
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/drawer.png"
                }
                onClicked: drawer.open()
            }

            Label {
                id: titleLabel
                text: "Path Planner"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/menu.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Settings"
                        onTriggered: settingsPopup.open()
                    }
                    MenuItem {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }


    Map {
        id: map
        objectName: "qmlMap"
        anchors.fill: parent
        plugin: Plugin {
            id: mapPlugin
            name: "osm"
            PluginParameter {
                name: "osm.mapping.host";
                value: "http://a.tile.openstreetmap.org/"
            }
        }
        activeMapType: map.supportedMapTypes[7]

        zoomLevel: 19

        function addPolyline(cppObject) {
            PolyLineLogic.addPolyline(cppObject)
        }

        function removePolyline(cppObject) {
            PolyLineLogic.removePolyline(cppObject)
        }

        function modifyPolyline(cppObject, points, color, width) {
            PolyLineLogic.modifyPolyline(cppObject, points, color, width)
        }

//        MapPolyline {
//            id: polyline
//            line.width: 3
//            line.color: 'cyan'
//            opacity: 0.8
////            path: [
////                {latitude: 55.74795553273474, longitude: 37.860303680900216 },
////                {latitude: 55.748722422094595, longitude: 37.86068991899836 },
////                {latitude: 55.751148237045754, longitude: 37.863859217170386 },
////                {latitude: 55.75170757312632, longitude: 37.86638502359739 },
////                {latitude: 55.75085078101032, longitude: 37.868843119147925 },
////                {latitude: 55.74984189672785, longitude: 37.86323012972636 },
////                {latitude: 55.74831336378359, longitude: 37.86134662295146 },
////                {latitude: 55.74790274342821, longitude: 37.86037029887004 }
////            ]
//        }

//        Component.onCompleted: {
//            var origin = QtPositioning.coordinate(55.74662048176102, 37.85956919945818)
//            var path = [Qt.point(0, 0), Qt.point(100, 0), Qt.point(100, 100), Qt.point(0, 100)]
//            var arc = 111323.872 // m per degree
//            var geopath = []
//            for (var i in path) {
//                var dphi = path[i].y / arc
//                var dlambda = path[i].x / (arc * Math.cos(origin.latitude / 360.0 * 2 * Math.PI))
//                geopath.push(QtPositioning.coordinate(origin.latitude + dphi, origin.longitude + dlambda))
//                console.log(origin.latitude + dphi, origin.longitude + dlambda)
//            }
//            polyline.path = geopath
//        }

    }

    Button {
        x: 10
        y: 10
        text: "Moscow"
        onClicked: map.center = QtPositioning.coordinate(55.74728018894019, 37.860291607752856)
    }

    Button {
        x: 10
        y: 50
        text: "C"
        onClicked: console.log(map.center.latitude, map.center.longitude)
    }

//    RingDial {
//        x: 100
//        y: 100
//        radius: 50
//        opacity: 0.8
//    }

    QtObject {
        id: someObject
        property bool bprop: true
        property int iprop: 77
        property string sprop: "valu12e"

        onBpropChanged: console.log("bprop changed to", bprop)
        onIpropChanged: console.log("iprop changed to", iprop)
        onSpropChanged: console.log("sprop changed to", sprop)

//        function info() {
//            return '{"properties": [{"property": "bprob", "text": "Boolean"},
//                                  {"property": "iprop", "text": "Integer"},
//                                  {"property": "sprop", "text": "String"}]}'
//        }
    }


    Pane {
        id: propertiesPane
        anchors.top: parent.top
        anchors.bottom: plusButton.top
        anchors.right: parent.right
        anchors.margins: 8
        width: 300
        Material.elevation: 8

        ListView {
            anchors.fill: parent
            clip: true
            delegate: Column {
                width: parent.width
                spacing: 10
                Item {
                    width: parent.width
                    height: 24
                    Text {
                        text: title
                        font.bold: true
                        font.pointSize: 10
                        anchors.centerIn: parent
                    }

                    Rectangle {
                        width: parent.width
                        height: 2
                        y: 22
                        color: Material.accent
                    }
                }

                Loader {
                    source: qmlFile
                    width: parent.width
                    property QtObject object: someObject
                }
            }

            model: ListModel {
                ListElement {
                    title: "Some object"
                    qmlFile: "PointParameters.qml"
                    //targetObject: someObject
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }


    }

    Button {
        id: plusButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        text:"+"
        highlighted: true
        onClicked: drawer.open()
    }

    function onCreateLinearFill() {
        console.log("Creating linear fill objects")
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 5 * 2
        height: window.height

        ListView {
            id: drawerListView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                id: control
                width: parent.width
                //text: model.title
                highlighted: ListView.isCurrentItem
                contentItem: Row {
                    spacing: 10
                    Text {
                        text: "O"
                    }

                    Text {
                        text: model.title
                    }
                }

                onClicked: {
                    console.log(control.source)
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "Line"; source: "qrc:/pages/BusyIndicatorPage.qml" }
                ListElement { title: "Polyline"; source: "qrc:/pages/ButtonPage.qml" }
                ListElement { title: "MakePossible Curve" }
                //ListElement { title: "Linear Fill"; action: onCreateLinearFill() }
            }

            Component.onCompleted: {
                drawerListView.model.append({title: "Test", action123: 123})
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Popup {
        id: settingsPopup
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        height: settingsColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            Label {
                text: "Settings"
                font.bold: true
            }

            RowLayout {
                spacing: 10

                Label {
                    text: "Style:"
                }

                ComboBox {
                    id: styleBox
                    property int styleIndex: -1
                    model: ["Default", "Material", "Universal"]
                    Component.onCompleted: {
                        styleIndex = find(settings.style, Qt.MatchFixedString)
                        if (styleIndex !== -1)
                            currentIndex = styleIndex
                    }
                    Layout.fillWidth: true
                }
            }

            Label {
                text: "Restart required"
                color: "#e41e25"
                opacity: styleBox.currentIndex !== styleBox.styleIndex ? 1.0 : 0.0
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton
                    text: "Ok"
                    onClicked: {
                        settings.style = styleBox.displayText
                        settingsPopup.close()
                    }

                    Material.foreground: Material.primary
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton
                    text: "Cancel"
                    onClicked: {
                        styleBox.currentIndex = styleBox.styleIndex
                        settingsPopup.close()
                    }

                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }
}
