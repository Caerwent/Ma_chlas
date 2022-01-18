pragma Singleton
import QtQuick
import "../ui"
Item {
    function getIconFromCategory(category)
    {
        if(category==="phono")
            return "qrc:/res/icons/phono.svg"
        else if(category==="numbers")
            return "qrc:/res/icons/numbers.svg"
        else return null
    }

    function getIconFromType(type)
    {
        if(type==="countSyllabes")
            return "qrc:/res/icons/countSyllabes.svg"
        else if(type==="findSoundOrSyllabe")
            return "qrc:/res/icons/findSyllabes.svg"
        else return null
    }

    function getScreenFromType(type)
    {
        if(type==="countSyllabes")
            return Screens.countSyllabes
        else if(type==="findSoundOrSyllabe")
            return Screens.findSoundOrSyllabe
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
