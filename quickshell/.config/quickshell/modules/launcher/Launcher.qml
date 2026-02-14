import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.configs

PanelWindow {
    id: root
    anchors { top: true; bottom: true; left: true; right: true }

    focusable: true
    exclusionMode: ExclusionMode.Ignore
    aboveWindows: true
    color: Config.launcher.overlayDim
    visible: false

    // --- State ---
    property string query: ""
    property var allApps: []
    property var filteredApps: []
    
    // --- Logic : App Loading ---
    Process {
        id: loadAppsProc
        command: ["bash", "-c", "$HOME/.scripts/quickshell-program-list.sh"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.allApps = JSON.parse(text.trim());
                    filterApps();
                } catch (e) { console.error(e); }
            }
        }
    }

    // --- Logic : Functions ---
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
        if (!root.query) {
            root.filteredApps = root.allApps;
        } else {
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
        listView.currentIndex = 0;
    }

    function launchApp(exec) {
        if (!exec) return;
        const cleaned = exec.replace(/%[fFuUikne]/g, '').trim();
        const argv = cleaned.match(/(?:[^\s"]+|"[^"]*")+/g).map(s => s.replace(/^"(.*)"$/, '$1'));
        Quickshell.execDetached(argv);
        root.visible = false;
        header.text = "";
    }

    // --- Main UI Structure ---
    MouseArea {
        anchors.fill: parent
        onClicked: root.visible = false

        Rectangle {
            id: container
            anchors.centerIn: parent
            
            // Use config
            implicitWidth: Config.launcher.windowWidth
            implicitHeight: Config.launcher.windowHeight
            color: Config.launcher.mainBg
            radius: Config.launcher.cornerRadius
            clip: true

            MouseArea { anchors.fill: parent; onClicked: (mouse) => mouse.accepted = true }

            // Border
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Config.launcher.mainBr
                border.width: 2
                radius: parent.radius
                z: 100
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                LauncherHeader {
                    id: header

                    // Reflect changes in the header to the root state
                    onTextChanged: {
                        root.query = text;
                        root.filterApps();
                    }

                    // Control the list by receiving key events from the header
                    onRequestNext: listView.incrementCurrentIndex()
                    onRequestPrev: listView.decrementCurrentIndex()
                    onRequestLaunch: {
                        if (root.filteredApps[listView.currentIndex]) {
                            root.launchApp(root.filteredApps[listView.currentIndex].exec)
                        }
                    }
                    onRequestClose: root.visible = false
                }

                LauncherList {
                    id: listView
                    appModel: root.filteredApps
                    onItemClicked: (exec) => root.launchApp(exec)
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            loadAppsProc.running = true;
            header.forceInputFocus();
        }
    }
}
