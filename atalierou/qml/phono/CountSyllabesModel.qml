import QtQuick
import "."
import "../dataModels"

Item {
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var syllabe
    property var corpusItem
    property int maxResponses: 0

    property bool syllabeDone : false
    property bool checkEnabled : false

    property int score : 0
    property real scorePercent : 0

    property var items

    property bool starVisibility:false

    signal ended()
    signal startStarAnimation()

    property string imageSource
    property string audioSource

    property var responsesModel: _responsesModel

    onSyllabeChanged: {

        maxResponses= Session.selectedActivities[Session.activityIndex].max
        imageSource = Qt.resolvedUrl(Session.activityPath+corpusItem.image);
        audioSource =Qt.resolvedUrl(Session.activityPath+corpusItem.sound);
    }

    ListModel {
        id:_responsesModel
    }


    function init() {
        items = Session.getShuffleRandomItems()
        changeIndex(0)
    }

    function incrScore()
    {
        score++
        scorePercent=score*100/items.length
    }

    function changeIndex(index)
    {
        currentIndex = index
        corpusItem= Session.selectedCorpus.find(element => element.id === items[currentIndex]);
        syllabe = items[currentIndex]

        responsesModel.clear()
        for (var i = 0; i < maxResponses; i++)
        {

            var modelItem = {

                indexValue : i,
                imgSrc : "qrc:///res/icons/count"+(i+1)+".svg",
                checkVisibility : false,
                isValid : false,
                wrongResp : false
            }
            responsesModel.append(modelItem)
        }

    }

    function clickResult(indexValue)
    {
        if(!syllabeDone)
        {
            for (var i = 0; i<responsesModel.count; i++)
            {
                responsesModel.get(i).checkVisibility=(i===indexValue)
            }
            checkEnabled=true
        }
    }


    function gotToNextItem()
    {
        if(currentIndex<(items.length-1))
        {
            changeIndex(currentIndex+1)
        }
        else
        {
            Session.addScore(scorePercent)
            Session.exerciceScore=scorePercent
            // App.instance.getNavigator().gotToScreen(Screens.score)
            ended()
        }

    }

    function checkResult()
    {
        if(checkEnabled)
        {

            if(syllabeDone)
            {
                check.source="qrc:///res/icons/eye.svg"
                syllabeDone=false
                checkEnabled=false

                if(starVisibility===true)
                {
                    startStarAnimation()
                } else {
                    gotToNextItem()
                }

            }
            else
            {

                syllabeDone=true
                check.source="qrc:///res/icons/next.svg"
                for (var i = 0; i<responsesModel.count; i++)
                {
                    if(responsesModel.get(i).checkVisibility)
                    {
                        if((i+1)===corpusItem.nbSyllabes)
                        {
                            responsesModel.get(i).isValid=true
                            starVisibility=true
                        }
                        else
                        {
                            responsesModel.get(i).checkVisibility=false
                            responsesModel.get(i).wrongResp=true
                        }
                    }
                    else if((i+1)===corpusItem.nbSyllabes)
                    {
                        responsesModel.get(i).checkVisibility=true
                    }
                }
            }
        }
    }
}
