//@ pragma UseQApplication

import QtQuick
import Quickshell
import "modules"
import "modules/bar"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Scope {
            required property ShellScreen modelData

            Wallpaper {
                screen: modelData
            }

            Bar {
                screen: modelData
            }
        }
    }
}
