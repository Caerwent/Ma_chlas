pragma Singleton
import QtQuick
import FileIO 1.0
import "../scripts/loadJson.js" as JsonLoader
import Qt.labs.settings 1.0
Item {
    id:session
    property var classRoom
    property var child
    property var game
    property var screens:[]
}
