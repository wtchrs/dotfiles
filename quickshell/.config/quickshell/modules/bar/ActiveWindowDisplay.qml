import QtQuick
import Quickshell.Hyprland

Item {
    id: root
    implicitWidth: 50
    implicitHeight: 10
    clip: true

    readonly property bool isWindowOnCurrentWorkspace: Hyprland.activeToplevel
        && Hyprland.focusedWorkspace
        && Hyprland.activeToplevel.workspace.id === Hyprland.focusedWorkspace.id

    Item {
        id: titleWrapper
        width: root.width
        implicitHeight: titleText.width

        states: [
            State {
                name: "empty"
                when: !root.isWindowOnCurrentWorkspace || Hyprland.activeToplevel.title === ""
                PropertyChanges { target: titleWrapper; x: -titleWrapper.width }
            },
            State {
                name: "visible"
                when: root.isWindowOnCurrentWorkspace && Hyprland.activeToplevel.title !== ""
                PropertyChanges { target: titleWrapper; x: 0 }
            }
        ]

        transitions: [
            Transition {
                from: "*"; to: "*"
                SequentialAnimation {
                    NumberAnimation {
                        properties: "x";
                        duration: 200;
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]

        Text {
            id: titleText
            text: Hyprland.activeToplevel?.title || ""

            font.pixelSize: 14
            font.family: "Sarasa Mono K Nerd Font"
            font.bold: true
            color: "#FFFFFF"

            width: root.height
            clip: true
            elide: Text.ElideRight

            transform: [
                Rotation { angle: 90 },
                Translate { x: (root.width + titleText.implicitHeight) / 2 }
            ]
        }
    }
}
