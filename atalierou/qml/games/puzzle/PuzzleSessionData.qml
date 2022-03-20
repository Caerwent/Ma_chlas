import QtQuick
import "../../main"
import "../../dataModels"
Item {
    property var selectedCorpus

    function reset()
    {
        selectedCorpus=undefined
    }

    function loadFromJson(activityType, jsonData)
    {
        selectedCorpus = jsonData.corpus
        return true
    }
}
