pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Networking

Singleton {
    id: root

    property bool enabled: true
    property int restartBackoff: 1000

    property string deviceType: "disconnected"
    property string interfaceName: ""
    property int signalStrength: 0
    property bool connected: false
    property bool refreshQueued: false
    property bool monitorConnected: false
    property string connectedNetworkName: ""
    property string lastStatusError: ""

    readonly property var devices: Networking.devices?.values ?? []
    readonly property var wifiDevice: {
        const deviceList = root.devices
        return deviceList.find(device => device && device.type === DeviceType.Wifi) || null
    }
    readonly property var wifiNetworks: {
        const device = root.wifiDevice
        return device && device.networks ? (device.networks.values ?? []) : []
    }
    readonly property var connectedWifiNetwork: {
        const networks = root.wifiNetworks
        return networks.find(network => network && network.connected) || null
    }

    function clampPercent(value) {
        if (!isFinite(value))
            return 0
        return Math.max(0, Math.min(100, value))
    }

    function splitStatusRow(line) {
        const first = line.indexOf(":")
        if (first === -1)
            return null

        const second = line.indexOf(":", first + 1)
        if (second === -1)
            return null

        const third = line.indexOf(":", second + 1)
        if (third === -1)
            return null

        return {
            device: line.slice(0, first),
            type: line.slice(first + 1, second),
            state: line.slice(second + 1, third),
            connection: line.slice(third + 1)
        }
    }

    function applyDisconnectedState() {
        root.connected = false
        root.deviceType = "disconnected"
        root.interfaceName = ""
        root.connectedNetworkName = ""
        root.signalStrength = 0
    }

    function applyWifiState() {
        const device = root.wifiDevice
        const network = root.connectedWifiNetwork
        if (!device || !network || !device.connected || !network.connected)
            return false

        root.connected = true
        root.deviceType = "wifi"
        root.interfaceName = String(device.name || "")
        root.connectedNetworkName = String(network.name || "")
        root.signalStrength = root.clampPercent(Math.round(Number(network.signalStrength || 0) * 100))
        return true
    }

    function applyStatusSnapshot(text) {
        if (root.applyWifiState())
            return

        const trimmed = String(text || "").trim()
        if (trimmed === "") {
            root.applyDisconnectedState()
            return
        }

        let ethernetRow = null
        let wifiRow = null

        for (const rawLine of trimmed.split("\n")) {
            const line = String(rawLine || "").trim()
            if (line === "")
                continue

            const row = root.splitStatusRow(line)
            if (!row || row.state !== "connected")
                continue

            if (row.type === "ethernet" && !ethernetRow) {
                ethernetRow = row
                continue
            }

            if (row.type === "wifi" && !wifiRow)
                wifiRow = row
        }

        if (ethernetRow) {
            root.connected = true
            root.deviceType = "ethernet"
            root.interfaceName = ethernetRow.device
            root.connectedNetworkName = ethernetRow.connection
            root.signalStrength = 100
            return
        }

        if (wifiRow) {
            root.connected = true
            root.deviceType = "wifi"
            root.interfaceName = wifiRow.device
            root.connectedNetworkName = wifiRow.connection
            root.signalStrength = root.clampPercent(root.signalStrength)
            return
        }

        root.applyDisconnectedState()
    }

    function scheduleRefresh() {
        if (statusProc.running) {
            root.refreshQueued = true
            return
        }

        root.refreshQueued = false
        statusProc.running = true
    }

    function drainRefreshQueue() {
        if (!root.refreshQueued || statusProc.running)
            return

        root.refreshQueued = false
        statusProc.running = true
    }

    function syncLiveState() {
        if (root.applyWifiState())
            return

        root.scheduleRefresh()
    }

    function start() {
        if (!root.enabled)
            return

        if (!monitorProc.running)
            monitorProc.running = true
    }

    function stop() {
        restartTimer.stop()
        root.monitorConnected = false
        if (monitorProc.running)
            monitorProc.running = false
    }

    onEnabledChanged: {
        if (root.enabled)
            root.start()
        else
            root.stop()
    }

    Component.onCompleted: {
        root.start()
        root.scheduleRefresh()
    }

    Timer {
        id: restartTimer
        interval: root.restartBackoff
        repeat: false
        onTriggered: root.start()
    }

    Connections {
        target: Networking.devices
        ignoreUnknownSignals: true

        function onValuesChanged() {
            root.syncLiveState()
        }
    }

    Connections {
        target: root.wifiDevice
        ignoreUnknownSignals: true

        function onConnectedChanged() {
            root.syncLiveState()
        }

        function onNameChanged() {
            root.syncLiveState()
        }

        function onStateChanged() {
            root.syncLiveState()
        }
    }

    Connections {
        target: root.wifiDevice && root.wifiDevice.networks ? root.wifiDevice.networks : null
        ignoreUnknownSignals: true

        function onValuesChanged() {
            root.syncLiveState()
        }
    }

    Connections {
        target: root.connectedWifiNetwork
        ignoreUnknownSignals: true

        function onConnectedChanged() {
            root.syncLiveState()
        }

        function onStateChanged() {
            root.syncLiveState()
        }

        function onSignalStrengthChanged() {
            root.syncLiveState()
        }
    }

    Process {
        id: monitorProc
        command: ["nmcli", "monitor"]
        running: false

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                const line = String(data || "").trim()
                if (line !== "")
                    root.scheduleRefresh()
            }
        }

        onStarted: {
            root.monitorConnected = true
        }

        onExited: {
            root.monitorConnected = false
            if (root.enabled)
                restartTimer.restart()
        }
    }

    Process {
        id: statusProc
        command: ["nmcli", "-t", "-f", "DEVICE,TYPE,STATE,CONNECTION", "dev", "status"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                root.lastStatusError = ""
                root.applyStatusSnapshot(text)
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                const errorText = String(text || "").trim()
                if (errorText !== "")
                    root.lastStatusError = errorText
            }
        }

        onExited: root.drainRefreshQueue()
    }
}
