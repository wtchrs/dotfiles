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

    width: 50

    color: "transparent"

    Rectangle {
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 10
        }
        color: "#80000000" // 80 is hex for 0.5 opacity

        topRightRadius: 10
        bottomRightRadius: 10
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
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }

        Brightness {
            id: brightness
            anchors {
                bottom: battery.top
                bottomMargin: 10
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
