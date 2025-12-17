import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
    }

    implicitWidth: 60

    color: "transparent"

    Rectangle {
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 10
            leftMargin: 10
        }
        color: "#A0000000" // First two hex digits are the alpha channel.

        radius: 10
        antialiasing: true

        // TOP

        Workspaces {
            id: workspaces
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            anchors.topMargin: 30
        }

        SpecialWorkspaces {
            id: specialWorkspaces
            anchors {
                top: workspaces.bottom
                horizontalCenter: parent.horizontalCenter
            }
            anchors.topMargin: 20
        }

        ActiveWindowDisplay {
            id: activeWindow
            anchors {
                top: specialWorkspaces.bottom
                horizontalCenter: parent.horizontalCenter
            }
            anchors.topMargin: 55
        }

        // BOTTOM

        Mpris {
            anchors {
                bottom: audio.top
                bottomMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
        }

        Audio {
            id: audio
            anchors {
                bottom: brightness.top
                bottomMargin: 2
                horizontalCenter: parent.horizontalCenter
            }
        }

        Brightness {
            id: brightness
            anchors {
                bottom: battery.top
                bottomMargin: 2
                horizontalCenter: parent.horizontalCenter
            }
        }

        Battery {
            id: battery
            anchors {
                bottom: tray.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }

        Tray {
            id: tray
            anchors {
                bottom: clock.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            barWindow: root
        }

        Clock {
            id: clock
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
