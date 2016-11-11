import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

ColumnLayout {
    RowLayout {
        width: parent.width
        Layout.preferredWidth: parent.width
        Text {
            text: "Size"
            Layout.alignment: Qt.AlignVCenter
        }
        SpinBox {
            Layout.alignment: Qt.AlignRight
        }
    }
    RowLayout {
        width: parent.width
        Text {
            text: "Size"
            Layout.alignment: Qt.AlignVCenter
        }
        SpinBox {
            id: spinBox
            Layout.alignment: Qt.AlignRight


        }
    }

    RowLayout {
        width: parent.width
        Text {
            text: "Size"
            Layout.alignment: Qt.AlignVCenter
        }
        TextField {
            text: object.sprop
        }
    }

    Binding {
        target: object
        property: "iprop"
        value: spinBox.value
    }
}
