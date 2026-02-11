import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

Item {
    id: root

    required property LauncherConfig config
    property alias text: searchInput.text

    signal requestNext()
    signal requestPrev()
    signal requestLaunch()
    signal requestClose()

    function forceInputFocus() {
        searchInput.forceActiveFocus();
    }

    Layout.fillWidth: true
    Layout.preferredHeight: config.headerHeight
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
            topLeftRadius: root.config.cornerRadius
            topRightRadius: root.config.cornerRadius
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
        height: root.config.itemHeight
        color: root.config.entryBg
        radius: 10

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            Text {
                text: ""
                color: root.config.entryFg
                font.family: root.config.iconFont
                font.pixelSize: 16
            }

            TextInput {
                id: searchInput
                Layout.fillWidth: true
                color: root.config.entryFg
                font.family: root.config.textFont
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
