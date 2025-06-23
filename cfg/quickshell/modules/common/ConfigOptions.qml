pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    property QtObject policies: QtObject {
        property int ai: 1 // 0: No | 1: Yes | 2: Local
        property int weeb: 0 // 0: No | 1: Open | 2: Closet
    }

    property QtObject ai: QtObject {
        property string systemPrompt: qsTr("Use casual tone. No user knowledge is to be assumed except basic Linux literacy. Be brief and concise: When explaining concepts, use bullet points (prefer minus sign (-) over asterisk (*)) and highlight keywords in bold to pinpoint the main concepts instead of long paragraphs. You are also encouraged to split your response with h2 headers, each header title beginning with an emoji, like `## 🐧 Linux`. When making changes to the user's config, you must get the config to know what values there are before setting.")
    }

    property QtObject appearance: QtObject {
        property int fakeScreenRounding: 1 // 0: None | 1: Always | 2: When not fullscreen
        property bool transparency: false
        property QtObject palette: QtObject {
            property string type: "auto" // Allowed: auto, scheme-content, scheme-expressive, scheme-fidelity, scheme-fruit-salad, scheme-monochrome, scheme-neutral, scheme-rainbow, scheme-tonal-spot
        }
    }

    property QtObject audio: QtObject {
        // Values in %
        property QtObject protection: QtObject {
            // Prevent sudden bangs
            property bool enable: false
            property real maxAllowedIncrease: 10
            property real maxAllowed: 90 // Realistically should already provide some protection when it's 99...
        }
    }

    property QtObject apps: QtObject {
        property string bluetooth: "better-control -b"
        property string network: "better-control -w"
        property string networkEthernet: "nm-connection-editor"
        property string taskManager: "missioncenter"
        property string terminal: "alacritty" // This is only for shell actions
    }

    property QtObject background: QtObject {
        property bool fixedClockPosition: false
        property real clockX: -500
        property real clockY: -500
    }

    property QtObject bar: QtObject {
        property bool bottom: false // Instead of top
        property bool borderless: false // true for no grouping of items
        property string topLeftIcon: "spark" // Options: distro, spark
        property bool showBackground: true
        property bool verbose: true
        property QtObject resources: QtObject {
            property bool alwaysShowSwap: false
            property bool alwaysShowCpu: true
        }
        property list<string> screenList: [] // List of names, like "eDP-1", find out with 'hyprctl monitors' command
        property QtObject utilButtons: QtObject {
            property bool showScreenSnip: true
            property bool showColorPicker: true
            property bool showMicToggle: false
            property bool showKeyboardToggle: false
            property bool showDarkModeToggle: false
        }
        property QtObject tray: QtObject {
            property bool monochromeIcons: false
        }
        property QtObject workspaces: QtObject {
            property int shown: 10
            property bool showAppIcons: true
            property bool alwaysShowNumbers: false
            property int showNumberDelay: 50 // milliseconds
        }
    }

    property QtObject battery: QtObject {
        property int low: 20
        property int critical: 5
        property bool automaticSuspend: true
        property int suspend: 3
    }

    property QtObject dock: QtObject {
        property real height: 60
        property real hoverRegionHeight: 3
        property bool pinnedOnStartup: false
        property bool hoverToReveal: false // When false, only reveals on empty workspace
        property list<string> pinnedApps: [ // IDs of pinned entries
            "org.kde.dolphin", "kitty",]
    }

    property QtObject language: QtObject {
        property QtObject translator: QtObject {
            property string engine: "auto" // Run `trans -list-engines` for available engines. auto should use google
            property string targetLanguage: "auto" // Run `trans -list-all` for available languages
            property string sourceLanguage: "auto"
        }
    }

    property QtObject networking: QtObject {
        property string userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
    }

    property QtObject osd: QtObject {
        property int timeout: 1000
    }

    property QtObject osk: QtObject {
        property string layout: "qwerty_full"
        property bool pinnedOnStartup: false
    }

    property QtObject overview: QtObject {
        property real scale: 0.18 // Relative to screen size
        property real rows: 2
        property real columns: 5
    }

    property QtObject resources: QtObject {
        property int updateInterval: 3000
    }

    property QtObject search: QtObject {
        property int nonAppResultDelay: 30 // This prevents lagging when typing
        property string engineBaseUrl: "https://www.google.com/search?q="
        property list<string> excludedSites: ["quora.com"]
        property bool sloppy: false // Uses levenshtein distance based scoring instead of fuzzy sort. Very weird.
        property QtObject prefix: QtObject {
            property string action: "/"
            property string clipboard: ";"
            property string emojis: ":"
        }
    }

    property QtObject sidebar: QtObject {
        property QtObject translator: QtObject {
            property int delay: 300 // Delay before sending request. Reduces (potential) rate limits and lag.
        }
        property QtObject booru: QtObject {
            property bool allowNsfw: false
            property string defaultProvider: "yandere"
            property int limit: 20
            property QtObject zerochan: QtObject {
                property string username: "[unset]"
            }
        }
    }

    property QtObject time: QtObject {
        // https://doc.qt.io/qt-6/qtime.html#toString
        property string format: "h:mm AP"
        property string dateFormat: "dddd, dd/MM"
    }

    property QtObject windows: QtObject {
        property bool showTitlebar: true // Client-side decoration for shell apps
        property bool centerTitle: true
    }

    property QtObject hacks: QtObject {
        property int arbitraryRaceConditionDelay: 20 // milliseconds
    }
}
