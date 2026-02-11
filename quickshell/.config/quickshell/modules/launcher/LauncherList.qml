import QtQuick
import QtQuick.Layouts
import Quickshell

ListView {
    id: root

    required property LauncherConfig config
    required property var appModel // Injecting filtered model from outside

    signal itemClicked(string exec)

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 10

    model: appModel
    clip: true

    // Highlight Animation
    highlightMoveDuration: 100
    highlightMoveVelocity: -1

    delegate: Rectangle {
        id: delegateItem
        width: root.width
        height: root.config.itemHeight
        radius: 8
        color: ListView.isCurrentItem ? root.config.selectBg : "transparent"

        // Mouse click handling
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.currentIndex = index
                root.model[index].exec && root.launchApp(root.model[index].exec)
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 15

            // Icon
            Item {
                width: 24; height: 24

                property string resolvedIcon: {
                    if (!modelData.icon) return ""
                    if (modelData.icon.startsWith("/")) return modelData.icon
                    return Quickshell.iconPath(modelData.icon, 24)
                }

                // Show icon if it exists
                Image {
                    anchors.fill: parent
                    source: parent.resolvedIcon
                    visible: source !== ""
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                // Fallback placeholder icon
                Text {
                    anchors.centerIn: parent
                    text: ""
                    font.family: root.config.iconFont
                    visible: parent.resolvedIcon === ""
                    color: ListView.isCurrentItem ? root.config.selectFg : root.config.mainFg
                }
            }

            // Text Content
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: modelData.name
                    Layout.fillWidth: true
                    font.family: root.config.textFont
                    font.pixelSize: 14
                    color: ListView.isCurrentItem
                        ? root.config.selectFg
                        : root.config.mainFg
                }

                Text {
                    text: modelData.description || ""
                    Layout.fillWidth: true
                    font.family: root.config.textFont
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    visible: text !== ""
                    color: ListView.isCurrentItem
                        ? Qt.darker(root.config.selectFg, 1.2)
                        : Qt.darker(root.config.mainFg, 1.3)
                }
            }
        }

        // Helper function for click
        function launchApp(exec) {
             // Emit the signal for convenience
             root.itemClicked(exec);
        }
    }
}
