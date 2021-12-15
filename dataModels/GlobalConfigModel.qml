pragma Singleton
import QtQuick
import FileIO 1.0
import "../scripts/loadJson.js" as JsonLoader
import Qt.labs.settings 1.0

Item {
    id:globalConfig
    property bool isEmbedded:true
    property string externalFile:""
    property string language:"fr-FR"
    Settings {
        id: settings
        property alias isEmbedded: globalConfig.isEmbedded
        property alias externalFile: globalConfig.externalFile
        property alias language: globalConfig.language
    }


    property var config

    FileIO {
               id:externalConfigFile
               onError: msg => console.log(msg)
           }

    function loadEmbeddedConfig()
    {
        JsonLoader.loadJSON("qrc:/res/data/config.json", resp=>{
                    config=resp
                                console.log("globalConfig loadEmbeddedConfig")
                 } );
    }

    Component.onCompleted: {
        console.log("globalConfig onCompleted")
        load()


    }

    function load()
    {
        console.log("globalConfig load")
        if(settings.isEmbedded)
            loadEmbeddedConfig()
        else
        {
            externalConfigFile.source=settings.externalFile

            var response = externalConfigFile.read();
            var newConfig= JSON.parse(response);
            if(newConfig.path.startsWith("."))
            {
                newConfig.path="file://"+externalConfigFile.getPath()
            }
            config=newConfig

        }
    }


}
