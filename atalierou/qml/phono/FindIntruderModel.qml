import QtQuick
import "."
import "../dataModels"

Item {
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var currentItem

    property bool itemDone : false
    property bool checkEnabled : false

    property int score : 0
    property real scorePercent : 0

    property bool starVisibility:false

    signal ended()
    signal startStarAnimation()

    property string audioHelpSource:Session.activityIndex>=0? (Session.activityPath+Session.selectedActivities[Session.activityIndex].exercices[Session.exerciceIndex].helpFile) : ""


    property var responsesModel: _responsesModel

    ListModel {
        id:_responsesModel
    }

    QtObject {
        id: _data
        property int nbItemsPerExercice
        property var exerciceData
        property var exerciceRandomItems : []
    }


    function getShuffleRandomItems()
    {
        // Shuffle array
        _data.exerciceRandomItems.length = 0
        for(var itemIx=0; itemIx<_data.nbItemsPerExercice; itemIx++)
        {
            // get an item randomly
            var randomExoItem = _data.exerciceData.items[Math.floor(Math.random()*_data.exerciceData.items.length)]
            // create activity element randomly
            var randomItems = []
            var usedCorpus = randomExoItem.corpus.map((x) => x);
            for(var eltIdx=0; eltIdx<_data.exerciceData.max-1; eltIdx++)
            {
                var newElt = {

                    corpus:usedCorpus[Math.floor(Math.random()*usedCorpus.length)],
                    isIntruder:false
                }
                usedCorpus.splice(usedCorpus.indexOf(newElt.corpus),1)
                randomItems.push(newElt)
            }
            randomItems.push( {
                corpus:randomExoItem.intruders[Math.floor(Math.random()*randomExoItem.intruders.length)],
                isIntruder:true
            })
            const shuffleArray = array => {
              for (let i = array.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                const temp = array[i];
                array[i] = array[j];
                array[j] = temp;
              }
            }


                for (let i = randomItems.length - 1; i > 0; i--) {
                  const j = Math.floor(Math.random() * (i + 1));
                  const temp = randomItems[i];
                  randomItems[i] = randomItems[j];
                  randomItems[j] = temp;
                }

            _data.exerciceRandomItems.push(randomItems)
        }

    }


    function init() {
        _data.nbItemsPerExercice = Session.selectedActivities[Session.activityIndex].nbItemsPerExercice
        _data.exerciceData = Session.selectedActivities[Session.activityIndex].exercices[Session.exerciceIndex]
        getShuffleRandomItems()
        changeIndex(0)
    }

    function incrScore()
    {
        score++
        scorePercent=score*100/_data.exerciceRandomItems.length
    }

    function changeIndex(index)
    {
        currentIndex = index
        currentItem = _data.exerciceRandomItems[currentIndex]
        responsesModel.clear()
        for (var i = 0; i < currentItem.length; i++)
        {
            var corpus = Session.activitySessionData.selectedCorpus.find(element => element.id === currentItem[i].corpus);
            var corpusImage = Qt.resolvedUrl(Session.activityPath+corpus.image)
            var corpusAudio = Qt.resolvedUrl(Session.activityPath+corpus.sound)
            console.log("image=",corpusImage, " audio=", corpusAudio)
            var modelItem = {

                indexValue : i,
                image : corpusImage,
                audio : corpusAudio,
                isIntruder : currentItem[i].isIntruder,
                checkVisibility:false,
                isValid : false,
                wrongResp : false,
                accessibleLabel : qsTr("accessible.notSelected")
            }
            responsesModel.append(modelItem)
        }

    }

    function clickResult(indexValue)
    {
        if(!itemDone)
        {
            for (var i = 0; i<responsesModel.count; i++)
            {
                responsesModel.get(i).checkVisibility=(i===indexValue)
                responsesModel.get(i).accessibleLabel= (i===indexValue ? qsTr("accessible.selected") : qsTr("accessible.notSelected"))
            }
            checkEnabled=true
        }
    }


    function gotToNextItem()
    {
        if(currentIndex<(_data.exerciceRandomItems.length-1))
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
                for (var i = 0; i<responsesModel.count; i++)
                {
                    if(responsesModel.get(i).checkVisibility)
                    {
                        if(responsesModel.get(i).isIntruder)
                        {
                            responsesModel.get(i).isValid=true
                            starVisibility=true
                            responsesModel.get(i).accessibleLabel= qsTr("accessible.correct")
                        }
                        else
                        {
                            responsesModel.get(i).checkVisibility=false
                            responsesModel.get(i).wrongResp=true
                            responsesModel.get(i).accessibleLabel= qsTr("accessible.wrong")
                        }
                    }
                    else if(responsesModel.get(i).isIntruder)
                    {
                        responsesModel.get(i).checkVisibility=true
                        responsesModel.get(i).accessibleLabel= qsTr("accessible.missing")
                    }
                }
            }
        }
    }
}
