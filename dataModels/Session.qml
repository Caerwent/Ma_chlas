pragma Singleton
import QtQuick
import FileIO 1.0
import "../scripts/loadJson.js" as JsonLoader
import Qt.labs.settings 1.0
Item {
    id:session
    property var group
    property var child
    property string activityCategory
    property var selectedActivities
    property string activityType
    property string activityPath
    property int activityLevel
    property var screens:[]
}
