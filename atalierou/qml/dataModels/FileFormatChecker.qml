pragma Singleton
import QtQuick

QtObject {

    function checkFileVersion(fileVersion, requieredMinVersion, requieredMaxVersion) {
        var charsMin = requieredMinVersion.split('.')
        var charsMax = requieredMaxVersion.split('.')
        var regExpString = "^(["+charsMin[0]+"-"+charsMax[0]+"])\\.(["+charsMin[1]+"-"+charsMax[1]+"])\\.(\\d+)"
        var fileVersionRG = new RegExp(regExpString)
        return fileVersionRG.test(fileVersion)
    }

    function getSupportedActivityFileFormatMinMaxArray(activityCategory, activityType)
    {
        if(activityCategory==="phono" && activityType==="countSyllabes")
        {
            return ["1.0","1.0"]
        } else if(activityCategory==="phono" && activityType==="findSoundOrSyllabe")
        {
            return ["1.0","1.0"]
        } else if(activityCategory==="phono" && activityType==="findIntruder")
        {
            return ["1.0","1.0"]
        }
        else if(activityCategory==="puzzle" && activityType==="slidingPuzzle")
        {
           return ["1.0","1.0"]
        }

    }
}
