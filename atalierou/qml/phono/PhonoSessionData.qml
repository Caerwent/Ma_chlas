import QtQuick
import "../main"
import "../dataModels"
Item {
    property var selectedCorpus
    property string activityAudioHelp

    function reset()
    {
        selectedCorpus=undefined
        activityAudioHelp=undefined
    }

    function loadFromJson(activityType, jsonData)
    {
        activityAudioHelp = jsonData.helpFile ? Qt.resolvedUrl(Session.activityPath+jsonData.helpFile) : "qrc:/res/data/sounds/help_"+Session.activityCategory+"_"+activityType+".mp3"
        selectedCorpus = jsonData.corpus
        return true
    }
}
