//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import "modules"
import "modules/bar"
import "modules/border"

ShellRoot {
    id: root
    property color color: "#FF000000"

    Variants {
        model: Quickshell.screens

        Scope {
            id: screenScope
            required property ShellScreen modelData

            Wallpaper {
                screen: modelData
            }

            Bar {
                screen: modelData
                barColor: root.color
                lineColor: "#FF555555"
            }

            Border {
                borderColor: root.color
            }

            Launcher {
                id: appLauncher
                visible: false
            }

            IpcHandler {
                target: "appLauncher"

                function toggle(): void {
                    console.log('Active Screen', Quickshell.activeScreen)
                    console.log('screenScope', screenScope.modelData)
                    // if (Quickshell.activeScreen === screenScope.modelData) {
                    if (screenScope.modelData) {
                        appLauncher.visible = !appLauncher.visible;
                    } else {
                        appLauncher.visible = false;
                    }
                    console.log('appLauncher.visible', appLauncher.visible)
                }

                function close(): void {
                    appLauncher.visible = false;
                }
            }
        }
    }
}
