import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.configs

Item {
    id: root

    required property var appModel

    signal itemClicked(string exec)

    property alias currentIndex: listView.currentIndex

    function incrementCurrentIndex() {
        listView.incrementCurrentIndex();
    }

    function decrementCurrentIndex() {
        listView.decrementCurrentIndex();
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: Config.launcher.padding
    Layout.rightMargin: Config.launcher.padding
    Layout.topMargin: Config.launcher.listTopGap
    Layout.bottomMargin: Config.launcher.padding
    clip: true

    ListView {
        id: listView
        anchors.fill: parent
        model: appModel
        clip: true
        spacing: 8
        highlightMoveDuration: 120
        highlightMoveVelocity: -1
        boundsBehavior: Flickable.StopAtBounds
        focus: true

        onCountChanged: {
            if (count === 0) {
                currentIndex = -1;
            } else if (currentIndex < 0) {
                currentIndex = 0;
            }
        }

        delegate: Rectangle {
            id: delegateRoot

            required property var modelData

            width: listView.width
            height: Config.launcher.itemHeight
            radius: 14
            antialiasing: true

            color: ListView.isCurrentItem
                ? Config.theme.surfaceActive
                : mouseArea.containsMouse
                    ? Config.theme.surface
                    : "transparent"
            border.color: ListView.isCurrentItem
                ? Config.theme.br
                : "transparent"
            border.width: ListView.isCurrentItem ? 1 : 0

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter
                    radius: 10
                    color: Config.theme.surface
                    border.color: Config.theme.br
                    border.width: 1
                    antialiasing: true

                    property string resolvedIcon: {
                        if (!delegateRoot.modelData.icon) {
                            return "";
                        }

                        if (typeof delegateRoot.modelData.icon === "string"
                            && delegateRoot.modelData.icon.startsWith("/")) {
                            return delegateRoot.modelData.icon;
                        }

                        return Quickshell.iconPath(delegateRoot.modelData.icon, 20);
                    }

                    Image {
                        anchors.fill: parent
                        anchors.margins: 5
                        source: parent.resolvedIcon
                        visible: parent.resolvedIcon !== ""
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        asynchronous: true
                        cache: true
                        sourceSize.width: 20
                        sourceSize.height: 20
                    }

                    Text {
                        anchors.centerIn: parent
                        text: delegateRoot.modelData.name ? delegateRoot.modelData.name.charAt(0).toUpperCase() : "?"
                        visible: parent.resolvedIcon === ""
                        color: Config.theme.fg
                        font.family: Config.font.text
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        Layout.fillWidth: true
                        text: delegateRoot.modelData.name || ""
                        color: Config.theme.fg
                        font.family: Config.font.text
                        font.pixelSize: 14
                        font.weight: ListView.isCurrentItem ? Font.DemiBold : Font.Medium
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: delegateRoot.modelData.description || ""
                        visible: text.length > 0
                        color: Config.theme.fgDim
                        font.family: Config.font.text
                        font.pixelSize: 11
                        opacity: ListView.isCurrentItem ? 1.0 : 0.85
                        elide: Text.ElideRight
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter
                    visible: delegateRoot.modelData.exec && delegateRoot.modelData.exec.length > 0
                    text: "↵"
                    color: Config.theme.fgDim
                    font.family: Config.font.text
                    font.pixelSize: 12
                    opacity: 0.7
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    listView.currentIndex = index;
                    if (delegateRoot.modelData.exec) {
                        root.itemClicked(delegateRoot.modelData.exec);
                    }
                }
            }
        }
    }

    Item {
        anchors.fill: parent
        visible: listView.count === 0
        z: 2

        Column {
            anchors.centerIn: parent
            width: Math.max(0, Math.min(parent.width - 48, 280))
            spacing: 6

            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: "No matches"
                color: Config.theme.fg
                font.family: Config.font.text
                font.pixelSize: 16
                font.weight: Font.DemiBold
            }

            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: "Try a different search term."
                color: Config.theme.fgDim
                font.family: Config.font.text
                font.pixelSize: 11
                opacity: 0.8
            }
        }
    }
}
