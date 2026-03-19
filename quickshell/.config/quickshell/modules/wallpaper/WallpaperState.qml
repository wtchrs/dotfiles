pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string wallpaperPath: Quickshell.env("HOME") + "/Pictures/wallpapers/wallpaper.jpg"
    property int reloadSerial: 0
    property string source: root.pathToUrl(root.wallpaperPath, root.reloadSerial)

    function pathToUrl(path, serial) {
        const normalized = String(path || "")
        const encodedPath = normalized.split("/").map(part => encodeURIComponent(part)).join("/")
        return `file://${encodedPath}?reload=${serial}`
    }

    function reload() {
        root.reloadSerial += 1
    }

    function setPath(path) {
        const nextPath = String(path || "").trim()
        if (nextPath === "")
            return

        const changed = nextPath !== root.wallpaperPath
        root.wallpaperPath = nextPath
        if (!changed)
            root.reload()
    }

    Process {
        id: wallpaperReloadNotifyProc
        command: [
            "notify-send",
            "-a",
            "Quickshell",
            "-i",
            WallpaperState.wallpaperPath,
            "Wallpaper reloaded"
        ]
        running: false
    }

    IpcHandler {
        target: "wallpaper"

        function reload(): void {
            root.reload()
            if (!wallpaperReloadNotifyProc.running)
                wallpaperReloadNotifyProc.running = true
        }
    }
}
