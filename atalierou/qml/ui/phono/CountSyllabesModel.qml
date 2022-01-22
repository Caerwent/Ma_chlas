import QtQuick
import "."
import ".."
import "../../dataModels"

Item {
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var syllabe

    property bool syllabeDone : false
    property bool checkEnabled : false

    property int score : 0
    property real scorePercent : 0

    property var items

    property bool startVisibility:false

    signal ended()
    signal startStarAnimation()

    property var imageSource
    property var audioSource

    property var responsesModel: _responsesModel

    onSyllabeChanged: {
        imageSource = Qt.resolvedUrl(Session.activityPath+items[currentIndex].image);
        audioSource =Qt.resolvedUrl(Session.activityPath+items[currentIndex].sound);
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

        syllabe = items[currentIndex]

        responsesModel.clear()
        for (var i = 0; i < syllabe.max; i++)
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
        console.log("checkResult")
        if(checkEnabled)
        {

            if(syllabeDone)
            {
                check.source="qrc:///res/icons/eye.svg"
                syllabeDone=false
                checkEnabled=false

                if(startVisibility===true)
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
                        if((i+1)===syllabe.value)
                        {
                            responsesModel.get(i).isValid=true
                            startVisibility=true
                        }
                        else
                        {
                            responsesModel.get(i).checkVisibility=false
                            responsesModel.get(i).wrongResp=true
                        }
                    }
                    else if((i+1)===syllabe.value)
                    {
                        responsesModel.get(i).checkVisibility=true
                    }
                }
            }
        }
    }
}
