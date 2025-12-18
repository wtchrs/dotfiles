import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

PopupWindow {
    id: root

    property Rectangle trayItem: null
    property MouseArea iconMouseArea: null

    property bool active: true
    readonly property bool containsMouse: iconMouseArea.containsMouse || popupMouseArea.containsMouse
    readonly property bool isShown: containsMouse && active
    visible: popupContent.opacity > 0

    onContainsMouseChanged: function() {
        if (!containsMouse) {
            active = true;
        }
    }

    implicitWidth: popupContent.width + 1
    implicitHeight: popupContent.height + 20
    color: "#00000000"

    anchor {
        window: barWindow
        item: trayItem
        edges: Edges.Right
        gravity: Edges.Right
        rect.x: 40
    }

    Rectangle {
        id: popupContent
        width: menuColumn.implicitWidth >= 150 ? menuColumn.implicitWidth : 150
        height: menuColumn.implicitHeight + 10
        color: "#A0000000"
        radius: 10
        border.color: "#AAA"
        border.width: 1
        opacity: 0

        states: [
            State {
                name: "visible"
                when: root.isShown
                PropertyChanges { target: popupContent; opacity: 1; y: 10 }
            },
            State {
                name: "hidden"
                when: !root.isShown
                PropertyChanges { target: popupContent; opacity: 0; y: 20 }
            }
        ]

        transitions: [
            Transition {
                from: "hidden"; to: "visible"
                NumberAnimation { properties: "y,opacity"; duration: 200; easing.type: Easing.OutCubic }
            },
            Transition {
                from: "visible"; to: "hidden"
                NumberAnimation { properties: "y,opacity"; duration: 150; easing.type: Easing.InCubic }
            }
        ]


        MouseArea {
            id: popupMouseArea
            anchors.fill: parent
            hoverEnabled: true

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
                            color: "#555"
                        }

                        Item {
                            visible: !modelData.isSeparator
                            RowLayout {
                                anchors.topMargin: 3
                                anchors.fill: parent
                                anchors.leftMargin: 5

                                Text {
                                    text: modelData.text
                                    color: modelData.enabled ? "white" : "gray"
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
