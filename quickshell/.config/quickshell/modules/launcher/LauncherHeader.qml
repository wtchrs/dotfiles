import QtQuick
import QtQuick.Layouts
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
    implicitHeight: Config.launcher.padding
        + searchField.implicitHeight
        + Config.launcher.helperGap
        + guideText.implicitHeight
        + Config.launcher.sectionGap
    clip: true

    ColumnLayout {
        id: headerLayout
        x: Config.launcher.padding
        y: Config.launcher.padding
        width: parent.width - (Config.launcher.padding * 2)
        height: parent.implicitHeight - Config.launcher.padding - Config.launcher.sectionGap
        spacing: Config.launcher.helperGap

        Rectangle {
            id: searchField
            Layout.fillWidth: true
            implicitHeight: 48
            Layout.preferredHeight: implicitHeight
            radius: 14
            color: Config.theme.surface
            border.color: Config.theme.br
            border.width: 1
            antialiasing: true

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 12

                Rectangle {
                    Layout.preferredWidth: 26
                    Layout.preferredHeight: 26
                    Layout.alignment: Qt.AlignVCenter
                    radius: 8
                    color: Config.theme.surfaceActive
                    border.color: Config.theme.br
                    border.width: 1
                    antialiasing: true

                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: Config.theme.fgDim
                        font.family: Config.font.icon
                        font.pixelSize: 14
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    TextInput {
                        id: searchInput
                        anchors.fill: parent
                        color: Config.theme.fg
                        font.family: Config.font.text
                        font.pixelSize: 14
                        verticalAlignment: TextInput.AlignVCenter
                        clip: true
                        focus: true
                        selectByMouse: true

                        Keys.onPressed: (event) => {
                            if (event.key === Qt.Key_Down) {
                                root.requestNext();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Up) {
                                root.requestPrev();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.requestLaunch();
                                event.accepted = true;
                            } else if (event.key === Qt.Key_Escape) {
                                root.requestClose();
                                event.accepted = true;
                            }
                        }
                    }

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Search applications"
                        color: Config.theme.fgDim
                        font.family: Config.font.text
                        font.pixelSize: 14
                        visible: searchInput.text.length === 0
                        opacity: 0.7
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Text {
            id: guideText
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            text: "↑/↓ navigate · Enter launch · Esc close"
            color: Config.theme.fgDim
            font.family: Config.font.text
            font.pixelSize: 11
            opacity: 0.65
        }
    }
}
