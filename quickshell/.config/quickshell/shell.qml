//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import "modules"
import "modules/bar"
import "modules/screenborder"
import "modules/launcher"

ShellRoot {
    id: root
    property color color: "#FF000000"

    Variants {
        model: Quickshell.screens

        Scope {
            id: screenScope
            required property ShellScreen modelData

            Wallpaper { screen: modelData }
            ScreenBorder { screen: modelData }
            Launcher { id: appLauncher; screen: modelData }

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
