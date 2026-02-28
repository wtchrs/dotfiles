import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import qs.configs

PanelWindow {
    id: root

    property string layershellNamespace: "quickshell:tray-menu"
    WlrLayershell.namespace: layershellNamespace

    exclusionMode: ExclusionMode.Ignore
    focusable: false
    aboveWindows: true
    color: "transparent"

    anchors {
        left: true
        top: true
    }

    // ----- External bindings -----
    property Item trayItem: null
    property MouseArea iconMouseArea: null

    readonly property SystemTrayItem systemTray: trayItem ? trayItem.systemTray : null

    // ----- state -----
    property bool active: true

    readonly property bool containsMouse:
        (iconMouseArea && iconMouseArea.containsMouse) || popupMouseArea.containsMouse
    readonly property bool isShown: containsMouse && active

    readonly property int borderMargin: Config.border.thickness + Config.border.lineWidth + 2
    readonly property int windowWidth: menuColumn.implicitWidth >= 150 ? menuColumn.implicitWidth : 150

    // Set visible when opacity>0
    visible: popupContent.opacity > 0

    implicitWidth: windowWidth + borderMargin
    implicitHeight: popupContent.implicitHeight

    onContainsMouseChanged: function() {
        if (!containsMouse) {
            active = true
        }
    }

    function windowOriginInScreen(win) {
        if (!win || !win.screen)
            return Qt.point(0, 0)

        const sc = win.screen

        // If win is PanelWindow, it can be calculated acurately with anchors/margins.
        if (("anchors" in win) && ("margins" in win) && ("width" in win) && ("height" in win)) {
            const a = win.anchors
            const m = win.margins
            let x0 = 0
            let y0 = 0

            if (a.left) {
                x0 = m.left
            } else if (a.right) {
                x0 = sc.width - win.width - m.right
            }

            if (a.top) {
                y0 = m.top
            } else if (a.bottom) {
                y0 = sc.height - win.height - m.bottom
            }

            return Qt.point(x0, y0)
        }

        // fallback: if there is normal window x/y, convert it to screen-local.
        if (("x" in win) && ("y" in win)) {
            return Qt.point(win.x - sc.x, win.y - sc.y)
        }

        return Qt.point(0, 0)
    }

    function updatePosition() {
        if (!trayItem || !trayItem.QsWindow || !trayItem.QsWindow.window)
            return

        const parentWin = trayItem.QsWindow.window
        if (!parentWin || !parentWin.screen)
            return

        root.screen = parentWin.screen

        const origin = windowOriginInScreen(parentWin)
        const r = parentWin.itemRect(trayItem)

        let rx = Math.floor(origin.x + r.x)
        let ry = Math.floor(origin.y + r.y)
        let rw = Math.max(1, Math.floor(r.width))
        let rh = Math.max(1, Math.floor(r.height))

        const anchorX = rx + rw - 1
        const anchorY = ry + Math.floor((rh - 1) / 2)

        const winW = Math.max(1, Math.floor(root.implicitWidth))
        const winH = Math.max(1, Math.floor(root.implicitHeight))

        let x = anchorX
        let y = anchorY - Math.floor(winH / 2) + 1

        const sc = root.screen
        if (sc) {
            x = Math.max(0, Math.min(x, sc.width - winW))
            y = Math.max(0, Math.min(y, sc.height - winH))
        }

        root.margins.left = x
        root.margins.top = y
    }

    onIsShownChanged: {
        if (isShown)
            updatePosition()
    }

    // Update position when menu size changes so that center alignment is maintained.
    onImplicitWidthChanged: {
        if (isShown || visible)
            updatePosition()
    }
    onImplicitHeightChanged: {
        if (isShown || visible)
            updatePosition()
    }

    // Attempt to follow changes of TrayItem's geometry/parent window transform.
    Connections {
        target: trayItem
        function onXChanged() { if (root.isShown || root.visible) root.updatePosition() }
        function onYChanged() { if (root.isShown || root.visible) root.updatePosition() }
        function onWidthChanged() { if (root.isShown || root.visible) root.updatePosition() }
        function onHeightChanged() { if (root.isShown || root.visible) root.updatePosition() }
    }

    Connections {
        target: trayItem && trayItem.QsWindow ? trayItem.QsWindow.window : null
        function onWindowTransformChanged() {
            if (root.isShown || root.visible)
                root.updatePosition()
        }
    }

    // ----- Content / interaction -----
    MouseArea {
        id: popupMouseArea
        anchors.fill: parent
        hoverEnabled: true

        Rectangle {
            id: popupContent
            implicitWidth: windowWidth
            implicitHeight: menuColumn.implicitHeight + 10
            color: Config.theme.bg
            radius: 10
            border.color: Config.theme.br
            border.width: 1

            states: [
                State {
                    name: "visible"
                    when: root.isShown
                    PropertyChanges { target: popupContent; opacity: 1; x: borderMargin }
                },
                State {
                    name: "hidden"
                    when: !root.isShown
                    PropertyChanges { target: popupContent; opacity: 0; x: 0 }
                }
            ]

            transitions: [
                Transition {
                    from: "hidden"; to: "visible"
                    NumberAnimation { properties: "x,opacity"; duration: 200; easing.type: Easing.OutCubic }
                },
                Transition {
                    from: "visible"; to: "hidden"
                    NumberAnimation { properties: "x,opacity"; duration: 150; easing.type: Easing.InCubic }
                }
            ]

            Column {
                id: menuColumn
                anchors.fill: parent
                anchors.margins: 5
                spacing: 2

                QsMenuOpener {
                    id: menuOpener
                    menu: root.systemTray ? root.systemTray.menu : null
                }

                Repeater {
                    model: menuOpener.children
                    delegate: Rectangle {
                        width: parent.width
                        height: modelData.isSeparator ? 1 : 24
                        color: itemMouseArea.containsMouse ? "#444" : "transparent"

                        Rectangle {
                            visible: modelData.isSeparator
                            anchors.fill: parent
                            color: Config.theme.br
                        }

                        Item {
                            visible: !modelData.isSeparator
                            anchors.fill: parent
                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 5

                                Item {
                                    width: 16
                                    height: 16
                                    visible: modelData.icon
                                    Image {
                                        source: modelData.icon
                                        width: 16
                                        height: 16
                                    }
                                }

                                Text {
                                    text: modelData.text
                                    color: modelData.enabled ? Config.theme.fg : Config.theme.fgDim
                                    Layout.fillWidth: true
                                }
                            }
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            enabled: modelData.enabled && !modelData.isSeparator
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                modelData.triggered()
                                root.active = false
                            }
                        }
                    }
                }
            }
        }
    }
}
