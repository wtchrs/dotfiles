import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import qs.configs

Item {
    id: root

    property alias text: searchInput.text

    signal requestNext()
    signal requestPrev()
    signal requestLaunch()
    signal requestClose()

    function forceInputFocus() {
        searchInput.forceActiveFocus();
    }

    Layout.fillWidth: true
    Layout.preferredHeight: Config.launcher.headerHeight
    Layout.margins: 2

    // Background Image
    Image {
        id: img
        anchors.fill: parent
        source: Quickshell.env("HOME") + "/Pictures/wallpapers/wallpaper.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.9
        visible: false
    }

    // Image Masking (Rounded Corners)
    MultiEffect {
        source: img
        anchors.fill: img
        maskEnabled: true
        maskSource: maskRect
    }

    Item {
        id: maskRect
        anchors.fill: img
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            topLeftRadius: Config.launcher.cornerRadius
            topRightRadius: Config.launcher.cornerRadius
            color: "black"
        }
    }

    // Search Bar
    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 15
            bottomMargin: 20
        }
        height: Config.launcher.itemHeight
        color: Config.launcher.entryBg
        radius: 10

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            Text {
                text: ""
                color: Config.launcher.entryFg
                font.family: Config.font.icon
                font.pixelSize: 16
            }

            TextInput {
                id: searchInput
                Layout.fillWidth: true
                color: Config.launcher.entryFg
                font.family: Config.font.text
                font.pixelSize: 14
                focus: true
                verticalAlignment: TextInput.AlignVCenter
                clip: true

                // Deligate keyboard navigation logic to signals
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Down) root.requestNext();
                    else if (event.key === Qt.Key_Up) root.requestPrev();
                    else if (event.key === Qt.Key_Return) root.requestLaunch();
                    else if (event.key === Qt.Key_Escape) root.requestClose();
                }
            }
        }
    }
}
