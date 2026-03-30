pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string device: "intel_backlight"
    property int brightnessRaw: -1
    property int actualBrightnessRaw: -1
    property int maxBrightnessRaw: -1
    property int brightness: 0
    property bool ready: false
    property bool everReady: false

    readonly property string basePath: `/sys/class/backlight/${root.device}`

    function parseRawValue(text) {
        const value = parseInt(String(text || "").trim(), 10)
        return isNaN(value) ? -1 : value
    }

    function clampPercent(value) {
        return Math.max(0, Math.min(100, value))
    }

    function updateDerivedBrightness() {
        const sourceRaw = root.actualBrightnessRaw >= 0 ? root.actualBrightnessRaw : root.brightnessRaw
        if (sourceRaw < 0 || root.maxBrightnessRaw <= 0) {
            root.ready = false
            return
        }

        root.brightness = root.clampPercent(Math.round((sourceRaw / root.maxBrightnessRaw) * 100))
        root.ready = true
        root.everReady = true
    }

    function setDevice(nextDevice) {
        const normalized = String(nextDevice || "").trim()
        if (normalized === "" || normalized === root.device)
            return

        root.device = normalized
    }

    function refresh() {
        actualBrightnessFile.reload()
        brightnessFile.reload()
        maxBrightnessFile.reload()
    }

    function increase() {
        if (!incBrightnessProc.running)
            incBrightnessProc.running = true
    }

    function decrease() {
        if (!decBrightnessProc.running)
            decBrightnessProc.running = true
    }

    onDeviceChanged: {
        root.actualBrightnessRaw = -1
        root.brightnessRaw = -1
        root.maxBrightnessRaw = -1
        root.ready = false
        root.refresh()
    }

    Component.onCompleted: root.refresh()

    FileView {
        id: actualBrightnessFile
        path: `${root.basePath}/actual_brightness`
        watchChanges: true
        printErrors: false
        onLoaded: {
            root.actualBrightnessRaw = root.parseRawValue(actualBrightnessFile.text())
            root.updateDerivedBrightness()
        }
        onTextChanged: {
            root.actualBrightnessRaw = root.parseRawValue(actualBrightnessFile.text())
            root.updateDerivedBrightness()
        }
        onLoadFailed: {
            root.actualBrightnessRaw = -1
            root.updateDerivedBrightness()
        }
        onFileChanged: actualBrightnessFile.reload()
    }

    FileView {
        id: brightnessFile
        path: `${root.basePath}/brightness`
        watchChanges: true
        printErrors: false
        onLoaded: {
            root.brightnessRaw = root.parseRawValue(brightnessFile.text())
            root.updateDerivedBrightness()
        }
        onTextChanged: {
            root.brightnessRaw = root.parseRawValue(brightnessFile.text())
            root.updateDerivedBrightness()
        }
        onLoadFailed: {
            root.brightnessRaw = -1
            root.updateDerivedBrightness()
        }
        onFileChanged: brightnessFile.reload()
    }

    FileView {
        id: maxBrightnessFile
        path: `${root.basePath}/max_brightness`
        watchChanges: true
        printErrors: false
        onLoaded: {
            root.maxBrightnessRaw = root.parseRawValue(maxBrightnessFile.text())
            root.updateDerivedBrightness()
        }
        onTextChanged: {
            root.maxBrightnessRaw = root.parseRawValue(maxBrightnessFile.text())
            root.updateDerivedBrightness()
        }
        onLoadFailed: {
            root.maxBrightnessRaw = -1
            root.updateDerivedBrightness()
        }
        onFileChanged: maxBrightnessFile.reload()
    }

    Process {
        id: incBrightnessProc
        command: ["brightnessctl", "-d", root.device, "set", "1%+"]
        running: false
        onExited: root.refresh()
    }

    Process {
        id: decBrightnessProc
        command: ["brightnessctl", "-d", root.device, "set", "1%-"]
        running: false
        onExited: root.refresh()
    }
}
