import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "../main"
import "../components"
import "../dataModels"
import "../scripts/loadJson.js" as JsonLoader

ScreenTemplate {
    id:activities

    titleText: qsTr("Activity choice")

    AppScrollView {
        id:screen


        Flow {
            id: activityGrid
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            flow:Flow.LeftToRight
            spacing: 10*UIUtils.UI.dp

            Repeater {
                model: ListModel {
                    id: activityModel


                }

                delegate: Component {
                    id: activityDelegate
                    Card {
                        id:activity
                        width: 150*UIUtils.UI.dp-10*UIUtils.UI.dp
                        height: 150*UIUtils.UI.dp-10*UIUtils.UI.dp
                        selectable:true
                        padding:10
                        imgSource:ActivityCategories.getIconFromType(type)
                        onSelected:
                        {
                                screen.loadActivities(configFile, type)

                        }



                         Accessible.role: Accessible.Button
                         Accessible.name: ActivityCategories.getAccessibleFromType(ActivityCategories)
                         Accessible.onPressAction: {
                                activity.selected()
                            }


                    }


                }
            }
        }



        function updateFromSession()
        {
            activityModel.clear();
            console.log("Activities updateFromSession")
            var listData = Session.group.activities
            if(listData!==undefined)
            {
                            for (var i in listData) {
                                if(listData[i]["category"]===Session.activityCategory)
                                {
                                activityModel.append(
                                            {
                                                activityIndex: i,
                                                configFile:listData[i]["config"],
                                                type:listData[i]["type"],

                                            }
                                                      )
                                }
                            }
            }
        }

        Component.onCompleted: {
            console.log("Activities onCompleted")
            updateFromSession()
        }

        function loadActivities(configFile, activityType)
        {
            Session.loadJSON(GlobalConfigModel.config.path + configFile, resp=>{
                                    Session.activityPath = resp.path
                                    if(resp.path.startsWith("."))
                                    {
                                        Session.activityPath=GlobalConfigModel.config.path+resp.path.substring(2)
                                    }

                                    var supportedFileFormat = FileFormatChecker.getSupportedActivityFileFormatMinMaxArray(Session.activityCategory, activityType)
                                    if(!FileFormatChecker.checkFileVersion(resp.fileFormatVersion, supportedFileFormat[0],supportedFileFormat[1]))
                                    {
                                        App.instance.showError(qsTr("Incompatible file format ")+GlobalConfigModel.config.path + configFile+qsTr("\nShould be between ")+supportedFileFormat[0]+qsTr(" and ")+supportedFileFormat[1])
                                    }

                                    Session.activityAudioHelp = resp.helpFile ? Qt.resolvedUrl(Session.activityPath+resp.helpFile) : "qrc:/res/data/sounds/help_"+Session.activityCategory+"_"+Session.activityType+".mp3"
                                    Session.selectedCorpus = resp.corpus
                                    Session.selectedActivities = resp.levels ? resp.levels
                                                               .sort(function(a, b) {
                                                                   return a.level - b.level}) : []
                                    Session.activityType = activityType
                                    App.instance.getNavigator().gotToScreen(Screens.activityChoiceLevel)
                                }

         );
        }

}

}
