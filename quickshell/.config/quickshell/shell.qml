//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import "modules"
import "modules/bar"

ShellRoot {
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
