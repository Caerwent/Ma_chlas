import QtQuick
import "."
import "../dataModels"

Item {
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var currentItem
    property var corpusItem;

    property bool itemDone : false
    property bool checkEnabled : false

    property int score : 0
    property real scorePercent : 0

    property bool starVisibility:false

    signal ended()
    signal startStarAnimation()

    property string imageSource
    property string audioSource
    property string audioHelpCompSource
    property string audioHelpSource:Session.activityAudioHelp

    property var items

    property var responsesModel: _responsesModel

    onCurrentItemChanged: {
        imageSource = Qt.resolvedUrl(Session.activityPath+corpusItem.image)
        audioSource =Qt.resolvedUrl(Session.activityPath+corpusItem.sound)
        var newAudioHelpCompFile =  Qt.resolvedUrl(Session.activityPath+currentItem.helpFile)
        if(newAudioHelpCompFile.toString()===audioHelpCompSource)
        {
            // force signal to be emitted again
            audioHelpCompSourceChanged()
        }
        else {
             audioHelpCompSource = newAudioHelpCompFile
        }
    }

    ListModel {
        id:_responsesModel
    }


    function getShuffleRandomItems()
    {
        // Shuffle array
        var shuffled = Session.selectedActivities[Session.activityIndex].items.sort(() => 0.5 - Math.random());

        // Get sub-array of first n elements after shuffled
        var selected = shuffled.slice(0,Session.selectedActivities[Session.activityIndex].nbItemsPerExercice);
        return selected
    }


    function init() {
        items = getShuffleRandomItems()
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
        corpusItem= Session.selectedCorpus.find(element => element.id === items[currentIndex].corpus);
        currentItem = items[currentIndex]
        responsesModel.clear()
        for (var i = 0; i < corpusItem.nbSyllabes; i++)
        {
            var modelItem = {

                indexValue : i,
                checkVisibility : false,
                isValid : false,
                wrongResp : false
            }
            responsesModel.append(modelItem)
        }

    }

    function clickResult(indexValue)
    {
        if(!itemDone)
        {
            responsesModel.get(indexValue).checkVisibility= ! responsesModel.get(indexValue).checkVisibility
            var nothingChecked=true
            for (var i = 0; i<responsesModel.count; i++)
            {
                if(responsesModel.get(i).checkVisibility===true)
                {
                    nothingChecked=false
                    break
                }
            }

            checkEnabled=!nothingChecked
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
            ended()

        }

    }

    function checkResult()
    {
        if(checkEnabled)
        {

            if(itemDone)
            {
                check.source="qrc:///res/icons/eye.svg"
                itemDone=false
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

                itemDone=true
                check.source="qrc:///res/icons/next.svg"
                var atLeastOneError = false;
                for (var i = 0; i<responsesModel.count; i++)
                {
                    if(responsesModel.get(i).checkVisibility)
                    {
                        if(currentItem.value.includes((i+1)))
                        {
                            responsesModel.get(i).isValid=true
                        }
                        else
                        {
                            responsesModel.get(i).checkVisibility=false
                            responsesModel.get(i).wrongResp=true
                            atLeastOneError=true
                        }
                    }
                    else if(currentItem.value.includes((i+1)))
                    {
                        responsesModel.get(i).checkVisibility=true
                        atLeastOneError=true
                    }
                }
                if(!atLeastOneError)
                {
                    starVisibility=true
                }
            }
        }
    }
}
