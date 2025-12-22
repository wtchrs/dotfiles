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

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // TOP

            Workspaces {
                Layout.topMargin: 30
            }

            SpecialWorkspaces {
                Layout.topMargin: 20
            }

            ActiveWindowDisplay {
                Layout.fillHeight: true
                Layout.topMargin: 50
                Layout.bottomMargin: 50
            }

            // BOTTOM

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                spacing: 0

                Mpris {
                    Layout.bottomMargin: 20
                }

                Audio {
                    Layout.bottomMargin: 2
                }

                Brightness {
                    Layout.bottomMargin: 2
                }

                Battery {
                    Layout.bottomMargin: 10
                }

                Tray {
                    Layout.bottomMargin: 10
                    barWindow: root
                }

                Clock {}
            }
        }
    }
}
