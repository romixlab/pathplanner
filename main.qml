import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import QtQuick.Controls.Universal 2.0
import Qt.labs.settings 1.0

import QtLocation 5.3
import QtPositioning 5.2
import QtGraphicalEffects 1.0

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

        MapPolyline {
            id: polyline
            line.width: 3
            line.color: 'cyan'
            opacity: 0.8
//            path: [
//                {latitude: 55.74795553273474, longitude: 37.860303680900216 },
//                {latitude: 55.748722422094595, longitude: 37.86068991899836 },
//                {latitude: 55.751148237045754, longitude: 37.863859217170386 },
//                {latitude: 55.75170757312632, longitude: 37.86638502359739 },
//                {latitude: 55.75085078101032, longitude: 37.868843119147925 },
//                {latitude: 55.74984189672785, longitude: 37.86323012972636 },
//                {latitude: 55.74831336378359, longitude: 37.86134662295146 },
//                {latitude: 55.74790274342821, longitude: 37.86037029887004 }
//            ]
        }

        Component.onCompleted: {
            var origin = QtPositioning.coordinate(55.74662048176102, 37.85956919945818)
            var path = [Qt.point(0, 0), Qt.point(100, 0), Qt.point(100, 100), Qt.point(0, 100)]
            var arc = 111323.872 // m per degree
            var geopath = []
            for (var i in path) {
                var dphi = path[i].y / arc
                var dlambda = path[i].x / (arc * Math.cos(origin.latitude / 360.0 * 2 * Math.PI))
                geopath.push(QtPositioning.coordinate(origin.latitude + dphi, origin.longitude + dlambda))
                console.log(origin.latitude + dphi, origin.longitude + dlambda)
            }
            polyline.path = geopath
        }

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

    RingDial {
        x: parent.width / 2
        y: parent.height / 2
        opacity: 0.8
    }

    Pane {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 8
        width: 300
        Material.elevation: 8
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 6 * 2
        height: window.height

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (listView.currentIndex != index) {
                        listView.currentIndex = index
                        titleLabel.text = model.title
                        stackView.replace(model.source)
                    }
                    drawer.close()
                }
            }

            model: ListModel {
                ListElement { title: "BusyIndicator"; source: "qrc:/pages/BusyIndicatorPage.qml" }
                ListElement { title: "Button"; source: "qrc:/pages/ButtonPage.qml" }
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
