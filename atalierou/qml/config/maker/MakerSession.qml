pragma Singleton
import QtQuick
import FileIO 1.0
import Corpus 1.0
import "../../main"
import "../../dataModels"
import "../../components"
Item {
    enum Mode {
            NewGlobal,
            EditGlobal,
            NewActivity,
            EditActivity,
            NewCorpus,
            EditCorpus
        }

    property bool isCreateMode:true
    property var config

    property var mode: MakerSession.Mode.NewGlobal



    function reset()
    {
        mode= MakerSession.Mode.NewGlobal
        isCreateMode=true
        config = undefined
        corpus.reset()
    }

    QtObject {
        id:sessionData

        property string configRootFilename

    }
    Corpus {
        id:corpusData
    }
    property alias corpus: corpusData

    FileIO {
               id:externalConfigFile
               onError: msg => console.log(msg)
           }

    function loadRootConfig(rootConfigFile)
    {
        console.log("MakerSession load")

            externalConfigFile.source=rootConfigFile

            var response = externalConfigFile.read();
            var newConfig= JSON.parse(response);

            if(! FileFormatChecker.checkFileVersion(response.fileFormatVersion, "1.0","1.0"))
            {
                App.instance.showError(qsTr("Incompatible file format ")+externalConfigFile.source+qsTr("\nShould be 1.0"))

            }

            if(newConfig.path.startsWith("."))
            {
                newConfig.path="file://"+externalConfigFile.getPath()
            }
            config=newConfig


    }

}
