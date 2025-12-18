import QtQuick
import Quickshell.Hyprland

Item {
    id: root
    width: 50
    implicitHeight: titleText.width
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
                PropertyChanges { target: titleWrapper; x: -titleWrapper.implicitHeight }
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

            width: Math.min(titleText.implicitWidth, 180)
            clip: true
            elide: Text.ElideRight

            transform: [
                Rotation { angle: 90 },
                Translate { x: (root.width + titleText.implicitHeight) / 2 }
            ]
        }
    }
}
