import QtQuick
import "."
import "../../dataModels"
import Puzzle 1.0 as Puzzle
import UIUtils 1.0 as UIUtils
Item {
    property int currentIndex
    property int currentLevelIndex: Session.activityIndex
    property var currentItem

    property bool itemDone : false

    property int score : 0
    property real scorePercent : 0


    property bool starVisibility:false


    signal ended()
    signal startStarAnimation()


    Puzzle.SlidingPuzzleModel {
        id:puzzleModel
        easyMode:true
        size:3
        onIsResolvedChanged: {
            if(puzzleModel.isResolved)
            {
                itemDone=true
                starVisibility=true
            }
        }
    }
    property var imgModel: _imgModel

    ListModel {
        id:_imgModel
    }

    QtObject {
        id: _data
        property int maxImgSize
        property int nbItemsPerExercice
        property var exerciceData
        property var exerciceRandomItems : []
    }


    function getShuffleRandomItems()
    {
        // Shuffle array
        _data.exerciceRandomItems.length = 0
         var tmpItems = _data.exerciceData.items.map((x) => {
                                                         return {
                                                       blankRow:x.blankRow,
                                                       blankCol:x.blankCol,
                                                       corpus:x.corpus.map((y)=>y)
                                                     }});
        for(var itemIx=0; itemIx<tmpItems.length; itemIx++)
        {
            tmpItems[itemIx].corpus = tmpItems[itemIx].corpus.map((x) => x);
        }

        for(var itemIx=0; itemIx<_data.nbItemsPerExercice; itemIx++)
        {
            // get an item randomly
            var randomExoItem = tmpItems[Math.floor(Math.random()*tmpItems.length)]
            // create activity element randomly


            var randomCorpusIdx =Math.floor(Math.random()*randomExoItem.corpus.length)
            var randomCorpusId = randomExoItem.corpus[randomCorpusIdx]
            var corpus = Session.activitySessionData.selectedCorpus.find(element => element.id === randomCorpusId);
            var corpusImage = Qt.resolvedUrl(Session.activityPath+corpus.image)
                var newElt = {
                    image:corpusImage,
                    blankRow:randomExoItem.blankRow ? randomExoItem.blankRow : 0,
                    blankCol:randomExoItem.blankCol ? randomExoItem.blankCol : 0
                }

            randomExoItem.corpus.splice(randomCorpusIdx,1)


            _data.exerciceRandomItems.push(newElt)
        }

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
        puzzleModel.createPuzzle(_data.maxImgSize, currentItem.blankRow,currentItem.blankCol)
        updateModel()
        itemDone=false
    }
    function move(row, col)
    {
        return puzzleModel.move(row, col)
    }

    function moveEnded()
    {
        updateModel()
    }
    function gotToNextItemWhenStarAnimationEnded()
    {

        _gotToNextItem()
    }

    function gotToNextItem()
    {
        if(puzzleModel.isResolved)
        {
            startStarAnimation()
        }
        else
        {
            _gotToNextItem()
        }
    }

    function _gotToNextItem()
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

    function updateModel()
    {
        _imgModel.clear()
        var blankValue = puzzleModel.getPuzzleEmptyValue()

        for (var i=0;i<puzzleModel.size;i++)
        {
            for (var j=0;j<puzzleModel.size;j++)
            {
                var blankElt = puzzleModel.getPuzzleValue(i,j)===blankValue;
                var canMoveCell = puzzleModel.canMove(i, j)

                _imgModel.append( {
                                    row: i,
                                    col: j,
                                    coord : puzzleModel.getPermutation(i, j),
                                    isBlank : blankElt,
                                    canMove :  !blankElt && canMoveCell
                                })
            }
        }
    }


    function init(maxImgSize) {
        _data.maxImgSize = maxImgSize
        _data.nbItemsPerExercice = Session.selectedActivities[Session.activityIndex].nbItemsPerExercice
        _data.exerciceData = Session.selectedActivities[Session.activityIndex].exercices[Session.exerciceIndex]
        getShuffleRandomItems()
        changeIndex(0)
    }
}
