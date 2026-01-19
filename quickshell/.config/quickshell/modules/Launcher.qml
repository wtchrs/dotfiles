import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    focusable: true

    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    color: "#44000000"

    // States
    property string query: ""
    property int selectedIndex: 0
    property var allApps: []
    property var filteredApps: []

    // --- Nord Palette ---
    readonly property var colors: ({
        "main_bg": "#DD2E3440",
        "main_fg": "#D8DEE9",
        "main_br": "#4C566A",
        "select_bg": "#434C5E",
        "select_fg": "#8FBCBB",
        "entry_bg": "#BB3B4252",
        "entry_fg": "#ECEFF4"
    })

    // --- Find and parse .desktop files ---
    Process {
        id: loadAppsProc
        command: ["bash", "-c", "$HOME/.scripts/quickshell-program-list.sh"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const rawResult = text.trim();
                try {
                    console.log('Fetch program list...')
                    root.allApps = JSON.parse(rawResult);
                } catch (e) {
                    console.error('Failed to fetch program list.', e);
                }
                filterApps();
            }
        }
    }

    function fuzzyScore(query, text) {
        if (!query || !text)
            return -1;

        query = query.toLowerCase();
        text = text.toLowerCase();

        let score = 0;
        let tIndex = 0;
        let lastMatch = -1;

        for (let qIndex = 0; qIndex < query.length; qIndex++) {
            const qc = query[qIndex];
            let found = false;

            while (tIndex < text.length) {
                if (text[tIndex] === qc) {
                    // base match
                    score += 10;

                    // consecutive match bonus
                    if (lastMatch === tIndex - 1)
                        score += 15;

                    // early match bonus
                    score += Math.max(0, 20 - tIndex);

                    lastMatch = tIndex;
                    tIndex++;
                    found = true;
                    break;
                }
                tIndex++;
            }

            if (!found)
                return -1; // Fail subsequence match
        }

        return score;
    }

    function relevanceScore(query, app) {
        const name = app.name.toLowerCase();
        const desc = (app.description || "").toLowerCase();
        const q = query.toLowerCase();

        // Exact match
        if (name === q)
            return 1000;

        let score = 0;

        // Prefix match
        if (name.startsWith(q))
            score += 200;

        const nameScore = fuzzyScore(q, name);
        const descScore = fuzzyScore(q, desc);

        if (nameScore < 0 && descScore < 0)
            return -1;

        if (nameScore > 0)
            score += nameScore * 3;

        if (descScore > 0)
            score += descScore;

        return score;
    }

    function filterApps() {
        selectedIndex = 0;

        if (!query || query.length === 0) {
            filteredApps = allApps.slice();
            return;
        }

        const q = query.toLowerCase();

        filteredApps = allApps
            .map(app => {
                return {
                    app: app,
                    score: relevanceScore(q, app)
                };
            })
            .filter(e => e.score >= 0)
            .sort((a, b) => b.score - a.score)
            .map(e => e.app);
    }

    function launchApp(exec) {
        // Sanitize exec command (remove parameter %u, %f and etc)
        const cleaned = exec.replace(/%[fFuUikne]/g, '').trim();
        const argv = cleaned.match(/(?:[^\s"]+|"[^"]*")+/g)
            .map(s => s.replace(/^"(.*)"$/, '$1'));

        Quickshell.execDetached(argv);
        root.visible = false;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false

        // --- UI Layout ---
        Rectangle {
            id: ui
            anchors.centerIn: parent
            implicitWidth: 400
            implicitHeight: 640
            color: root.colors.main_bg
            radius: 24
            clip: true

            MouseArea {
                anchors.fill: parent
                onClicked: (mouse) => { mouse.accepted = true; }
            }

            // border
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: root.colors.main_br
                border.width: 2
                radius: parent.radius
                z: 100
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Input Bar (including image)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.topMargin: 2
                    Layout.leftMargin: 2
                    Layout.rightMargin: 2
                    Layout.preferredHeight: 180
                    color: "transparent"

                    Image {
                        id: img
                        anchors.fill: parent
                        source: Quickshell.env("HOME") + "/Pictures/wallpapers/wallpaper.jpg"
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0.9
                        visible: false
                    }

                    MultiEffect {
                        source: img
                        anchors.fill: img
                        maskEnabled: true
                        maskSource: maskRect
                    }

                    Item {
                        id: maskRect

                        anchors {
                            fill: img
                            top: img.top
                            bottom: img.bottom
                            left: img.left
                            right: img.right
                        }

                        layer.enabled: true
                        visible: false

                        Rectangle {
                            anchors.fill: maskRect
                            topLeftRadius: ui.radius
                            topRightRadius: ui.radius
                            color: "black"
                        }
                    }

                    Rectangle {
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            right: parent.right
                            margins: 15
                            bottomMargin: 20
                        }
                        height: 45
                        color: root.colors.entry_bg
                        radius: 10
                        border.color: "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            anchors.rightMargin: 15

                            Text {
                                text: ""
                                color: root.colors.entry_fg
                                font.family: "Symbols Nerd Font"
                                font.pixelSize: 16
                            }

                            TextInput {
                                id: searchInput
                                Layout.fillWidth: true
                                color: root.colors.entry_fg
                                font.family: "Sarasa Mono K Nerd Font"
                                font.pixelSize: 14
                                focus: true
                                verticalAlignment: TextInput.AlignVCenter

                                onTextChanged: {
                                    root.query = text;
                                    filterApps();
                                }

                                Keys.onPressed: (event) => {
                                    if (event.key === Qt.Key_Down) {
                                        root.selectedIndex = Math.min(root.selectedIndex + 1, root.filteredApps.length - 1);
                                    } else if (event.key === Qt.Key_Up) {
                                        root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                                    } else if (event.key === Qt.Key_Return) {
                                        if (root.filteredApps[root.selectedIndex]) {
                                            launchApp(root.filteredApps[root.selectedIndex].exec);
                                        }
                                    } else if (event.key === Qt.Key_Escape) {
                                        root.visible = false;
                                    }
                                }
                            }
                        }
                    }
                }

                // List View
                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 10
                    model: root.filteredApps
                    clip: true
                    currentIndex: root.selectedIndex

                    delegate: Rectangle {
                        width: listView.width
                        height: 45
                        radius: 8
                        color: index === root.selectedIndex ? root.colors.select_bg : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 15
                            spacing: 15

                            // TODO: Icon placeholder
                            Text {
                                text: ""
                                font.family: "Symbols Nerd Font"
                                color: index === root.selectedIndex ? root.colors.select_fg : root.colors.main_fg
                            }

                            Text {
                                text: modelData.name
                                color: index === root.selectedIndex ? root.colors.select_fg : root.colors.main_fg
                                font.family: "Sarasa Mono K Nerd Font"
                                font.pixelSize: 14
                                Layout.fillWidth: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: launchApp(modelData.exec)
                        }
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            searchInput.forceActiveFocus();
        }
    }
}
