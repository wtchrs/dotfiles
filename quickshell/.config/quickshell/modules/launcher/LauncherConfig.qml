import QtQuick

QtObject {
    // --- Layout Constants ---
    property int windowWidth: 400
    property int windowHeight: 640
    property int cornerRadius: 24
    property int itemHeight: 45
    property int headerHeight: 180

    // --- Nord Palette Colors ---
    property color mainBg: "#DD2E3440"
    property color mainFg: "#D8DEE9"
    property color mainBr: "#4C566A"
    
    property color selectBg: "#434C5E"
    property color selectFg: "#8FBCBB"
    
    property color entryBg: "#BB3B4252"
    property color entryFg: "#ECEFF4"

    property color overlayDim: "#44000000"

    // --- Fonts ---
    property string iconFont: "Symbols Nerd Font"
    property string textFont: "Sarasa Mono K Nerd Font"
}
