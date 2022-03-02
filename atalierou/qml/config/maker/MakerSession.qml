pragma Singleton
import QtQuick
import FileIO 1.0
import Corpus 1.0
import "../../main"
import "../../dataModels"
import "../../components"
Item {
    enum Mode {
            NewCorpus,
            EditCorpus
        }

    property bool isCreateMode:true


    property var mode: MakerSession.Mode.NewGlobal



    function reset()
    {
        mode= MakerSession.Mode.NewGlobal
        isCreateMode=true
        corpus.reset()
    }

    Corpus {
        id:corpusData
        onError: {
            App.instance.showError(errorMsg)
        }
    }

    property alias corpus: corpusData




}
