import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import qs.configs

PopupWindow {
    id: root

    // WlrLayershell.namespace: "quickshell:blur"

    property Rectangle trayItem: null
    property MouseArea iconMouseArea: null

    property bool active: true

    readonly property bool containsMouse: iconMouseArea.containsMouse || popupMouseArea.containsMouse
    readonly property bool isShown: containsMouse && active
    readonly property int borderMargin: Config.border.thickness + Config.border.lineWidth + 2
    readonly property int windowWidth: menuColumn.implicitWidth >= 150 ? menuColumn.implicitWidth : 150

    visible: popupContent.opacity > 0

    onContainsMouseChanged: function() {
        if (!containsMouse) {
            active = true;
        }
    }

    implicitWidth: windowWidth + borderMargin
    implicitHeight: popupContent.implicitHeight
    color: "transparent"

    anchor {
        window: barWindow
        item: trayItem
        edges: Edges.Right
        gravity: Edges.Right
    }

    MouseArea {
        id: popupMouseArea
        anchors.fill: parent
        hoverEnabled: true

        Rectangle {
            id: popupContent
            implicitWidth: windowWidth
            implicitHeight: menuColumn.implicitHeight + 10
            color: Config.theme.bg
            radius: 10
            border.color: Config.theme.br
            border.width: 1

            states: [
                State {
                    name: "visible"
                    when: root.isShown
                    PropertyChanges { target: popupContent; opacity: 1; x: borderMargin }
                },
                State {
                    name: "hidden"
                    when: !root.isShown
                    PropertyChanges { target: popupContent; opacity: 0; x: 0 }
                }
            ]

            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    NumberAnimation { properties: "x,opacity"; duration: 200; easing.type: Easing.OutCubic }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    NumberAnimation { properties: "x,opacity"; duration: 150; easing.type: Easing.InCubic }
                }
            ]


            Column {
                id: menuColumn
                anchors.fill: parent
                anchors.margins: 5
                spacing: 2

                QsMenuOpener {
                    id: menuOpener
                    menu: systemTray.menu
                }

                Repeater {
                    model: menuOpener.children
                    delegate: Rectangle {
                        width: parent.width
                        height: modelData.isSeparator ? 1 : 24
                        color: itemMouseArea.containsMouse ? "#444" : "transparent"

                        Rectangle {
                            visible: modelData.isSeparator
                            anchors.fill: parent
                            color: Config.theme.br
                        }

                        Item {
                            visible: !modelData.isSeparator
                            anchors.fill: parent
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 5

                                Item {
                                    width: 16
                                    height: 16
                                    visible: modelData.icon
                                    Image {
                                        source: modelData.icon
                                        width: 16
                                        height: 16
                                    }
                                }

                                Text {
                                    text: modelData.text
                                    color: modelData.enabled ? Config.theme.fg : Config.theme.fgDim
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            enabled: modelData.enabled && !modelData.isSeparator
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                modelData.triggered()
                                root.active = false
                            }
                        }
                    }
                }
            }
        }
    }
}
