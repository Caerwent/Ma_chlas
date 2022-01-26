pragma Singleton
import QtQuick
import FileIO 1.0
import "../scripts/loadJson.js" as JsonLoader
import Qt.labs.settings 1.0
import UserSession 1.0
import ".."

Item {
    id:session
    property var group
    property var user
    property string activityCategory
    property var selectedCorpus
    property var selectedActivities
    property string activityType
    property string activityPath
    property string activityAudioHelp
    property int activityIndex
    property int exerciceIndex
    property int exerciceScore
    property var screens:[]


    function getShuffleRandomItems()
    {
        // Shuffle array
        var shuffled = Session.selectedActivities[Session.activityIndex].items.sort(() => 0.5 - Math.random());

        // Get sub-array of first n elements after shuffled
        var selected = shuffled.slice(0,Session.selectedActivities[Session.activityIndex].nbItemsPerExercice);
        return selected
    }

    function loadUser(indexChild=-1)
    {
        var children = group["children"]? group["children"]:[]
        currentUser.group = group.name
        if(children.length>0 && indexChild>=0 && indexChild<children.length)
        {
            currentUser.name =  children[indexChild].name
            currentUser.image = GlobalConfigModel.config.path+children[indexChild].image
            currentUser.read(GlobalConfigModel.config.path)
            user = currentUser
        }
        /*else {
            currentUser.name=qsTr("me")
            currentUser.image = "qrc:///res/icons/default_child.svg"
        }
        currentUser.read(GlobalConfigModel.config.path)
        user = currentUser*/
    }

    function addScore(score)
    {
        if(user!==undefined)
        {
            if(!user.addScore(activityCategory, activityType, Session.selectedActivities[Session.activityIndex].level, score))
            {
                App.showMessage(qsTr("Error when adding score"))
            }
            else
            {
                if(!user.write())
                {
                    App.showMessage(qsTr("Error when writing score"))
                }
            }
        }
    }

    User {
        id:currentUser
        onError: { msg=>
            App.showError(msg)
        }

        property int levelUnlockedWithScore: 80
        property var scoreActivityNode
        property var scoreTypeNode
        property var scoreLevelNode

        onScoresChanged: {
            updateScoreActivityInfo()
            updateTypeScoreInfo()
            updateLevelScoreInfo()
        }
    }

    onActivityCategoryChanged : {
        updateScoreActivityInfo()
    }

    function updateScoreActivityInfo()
    {
        if(user!==undefined && user.scores!==undefined)
        {
            currentUser.scoreActivityNode=undefined
            currentUser.scoreTypeNode=undefined
            currentUser.scoreLevelNode=undefined
            var nodes = user.scores.getNodes()
            for( var curNode in nodes)
            {
                if(nodes[curNode].name===activityCategory)
                {
                    currentUser.scoreActivityNode=nodes[curNode]
                }
            }
        }
    }

    onActivityTypeChanged : {
        updateTypeScoreInfo()
    }

    function updateTypeScoreInfo()
    {
        if(user!==undefined && currentUser.scoreActivityNode!==undefined)
        {
            var nodes = currentUser.scoreActivityNode.getTreeNodes()
            for( var curNode in nodes)
            {
                if(nodes[curNode].name===activityType)
                {
                    currentUser.scoreTypeNode=nodes[curNode]
                }
            }
        }
    }

    onActivityIndexChanged : {
        updateLevelScoreInfo()
    }
    function updateLevelScoreInfo()
    {
        if(user!==undefined && currentUser.scoreTypeNode!==undefined)
        {
            var nodes = currentUser.scoreTypeNode.getTreeNodes()
            for( var curNode in nodes)
            {
                if(nodes[curNode].level===activityIndex)
                {
                    currentUser.scoreLevelNode = nodes[curNode]
                }
            }
        }
    }

}
