pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property QtObject theme: QtObject {
        property bool darkMode: true
        property color bg: darkMode ? "#80202020" : "#55dddddd"
        property color fg: darkMode ? "#FFFFFF" : "#333333"
        property color br: darkMode ? "#33FFFFFF" : "#555555"
        property color fgDim: darkMode ? "#A0A0A0" : "#A0A0A0"
        property color surface: darkMode ? "#AA262626" : "#E6F0F0F0"
        property color surfaceActive: darkMode ? "#CC3A3A3A" : "#DDE2E2E2"
        property color overlay: darkMode ? "#66000000" : "#33000000"
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
        property int lineWidth: 1
    }

    property QtObject bar: QtObject {
        property int width: 50
    }

    property QtObject launcher: QtObject {
        property int windowWidth: 400
        property int windowHeight: 640
        property int cornerRadius: 24
        property int itemHeight: 60
        property int padding: 16
        property int helperGap: 8
        property int sectionGap: 12
        property int listTopGap: 12
    }
}
