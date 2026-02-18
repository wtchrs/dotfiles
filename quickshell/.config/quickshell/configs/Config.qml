pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property QtObject theme: QtObject {
        property color bg: "#000000" // background
        property color fg: "#FFFFFF" // foregroude
        property color br: "#555555" // border
        property color fgDim: "#A0A0A0" // inactive
    }

    property QtObject font: QtObject {
        property string icon: "Symbols Nerd Font"
        property string text: "Sarasa Mono K"
    }

    property QtObject shadow: QtObject {
        property real blur: 0.8
        property color color: "#90000000"
        property int verticalOffset: 2
        property int horizontalOffset: 2
    }

    // Screen border
    property QtObject border: QtObject {
        property int thickness: 5
        property int radius: 20

        // Inner outline
        property int lineWidth: 2
    }

    property QtObject bar: QtObject {
        property int width: 50
    }

    property QtObject launcher: QtObject {
        // Layout Constants
        property int windowWidth: 400
        property int windowHeight: 640
        property int cornerRadius: 24
        property int itemHeight: 45
        property int headerHeight: 180

        // Nord Palette Colors
        property color mainBg: "#DD2E3440"
        property color mainFg: "#D8DEE9"
        property color mainBr: "#4C566A"

        property color selectBg: "#434C5E"
        property color selectFg: "#8FBCBB"

        property color entryBg: "#BB3B4252"
        property color entryFg: "#ECEFF4"

        property color overlayDim: "#44000000"
    }
}
