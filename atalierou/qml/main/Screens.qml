pragma Singleton
import QtQuick

QtObject {
    property string home: "qrc:/qml/main/home.qml"
    property string config: "qrc:/qml/config/config.qml"
    property string configDetails: "qrc:/qml/config/ConfigDetails.qml"
    property string main:"qrc:/qml/main/main.ql"
    property string children:"qrc:/qml/selection/Children.qml"
    property string activitiesGroupChoice:"qrc:/qml/selection/ActivitiesGroupChoice.qml"
    property string activityChoice:"qrc:/qml/selection/ActivityChoice.qml"
    property string activityChoiceLevel:"qrc:/qml/selection/ActivityChoiceLevel.qml"
    property string countSyllabes:"qrc:/qml/phono/CountSyllabes.qml"
    property string findSoundOrSyllabe:"qrc:/qml/phono/FindSoundOrSyllabe.qml"
    property string findIntruder:"qrc:/qml/phono/FindIntruder.qml"
    property string score:"qrc:/qml/main/ScoreScreen.qml"

    property string configMaker:"qrc:/qml/config/maker/MakerInitSession.qml"
    property string configMakerCorpus:"qrc:/qml/config/maker/MakerCorpus.qml"
    property string configMakerCorpusEdit:"qrc:/qml/config/maker/MakerCorpusEdit.qml"
}
