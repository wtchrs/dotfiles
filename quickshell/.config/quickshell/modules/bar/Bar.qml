import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
    }

    property int barWidth: 50

    implicitWidth: barWidth
    color: "transparent"

    Rectangle {
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 10
        }
        color: "transparent"

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
