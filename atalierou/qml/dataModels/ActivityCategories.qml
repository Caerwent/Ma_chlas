pragma Singleton
import QtQuick
import "../main"

Item {
    function getIconFromCategory(category)
    {
        if(category==="phono")
            return "qrc:/res/icons/phono.svg"
        else if(category==="numbers")
            return "qrc:/res/icons/numbers.svg"
        else if(category==="puzzle")
            return "qrc:/res/icons/puzzle.svg"
        else return null
    }

    function getAccessibleFromCategory(category)
    {
        if(category==="phono")
            return qsTr("accessibility.category_phono")
        else if(category==="numbers")
            return qsTr("accessibility.category_numbers")
        else if(category==="puzzle")
            return qsTr("accessibility.category_puzzle")
        else return null
    }


    function getIconFromType(type)
    {
        if(type==="countSyllabes")
            return "qrc:/res/icons/countSyllabes.svg"
        else if(type==="findSoundOrSyllabe")
            return "qrc:/res/icons/findSyllabes.svg"
        else if(type==="findIntruder")
            return "qrc:/res/icons/findIntruder.svg"
        else if(type==="slidingPuzzle")
            return "qrc:/res/icons/puzzle_sliding.svg"
        else return null
    }

    function getAccessibleFromType(type)
    {
        if(type==="countSyllabes")
            return qsTr("accessibility.countSyllabes")
        else if(type==="findSoundOrSyllabe")
            return qsTr("accessibility.findSoundOrSyllabe")
        else if(type==="findIntruder")
            return qsTr("accessibility.findIntruder")
        else if(type==="slidingPuzzle")
            return qsTr("accessibility.slidingPuzzle")
        else return null
    }

    function getScreenFromType(type)
    {
        if(type==="countSyllabes")
            return Screens.countSyllabes
        else if(type==="findSoundOrSyllabe")
            return Screens.findSoundOrSyllabe
        else if(type==="findIntruder")
            return Screens.findIntruder
        else if(type==="slidingPuzzle")
            return Screens.slidingPuzzle
        else return null
    }

    function getColorStringFromLevel(level)
    {
        if(level<=1)
            return "#62fa57"
        else if(level===2)
            return "#dffa57"
        else if(level===3)
            return "#f5743d"
        else if(level>=4)
        {
            return "#f00a0a"
        }
    }

}
