pragma Singleton
import QtQuick
import FileIO 1.0
import "../scripts/loadJson.js" as JsonLoader
import Qt.labs.settings 1.0
import "."
import "../main"
import GlobalConfigData 1.0
Item {
    id:globalConfig
    property bool isEmbedded:GlobalConfigData.isEmbedded
    property string externalFile:GlobalConfigData.externalConfigFile
    property string language:GlobalConfigData.language


    onIsEmbeddedChanged: {
        if(isEmbedded!==GlobalConfigData.isEmbedded)
            GlobalConfigData.isEmbedded=isEmbedded
    }
    onExternalFileChanged: {
        if(externalFile!==GlobalConfigData.externalConfigFile)
            GlobalConfigData.externalConfigFile=externalFile
    }
    onLanguageChanged: {
        if(language!==GlobalConfigData.language)
            GlobalConfigData.language=language
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
        if(isEmbedded)
            loadEmbeddedConfig()
        else
        {
            externalConfigFile.source=externalFile

            var response = externalConfigFile.read();
            var newConfig= JSON.parse(response);

            if(! FileFormatChecker.checkFileVersion(newConfig.fileFormatVersion, "1.0","1.0"))
            {
                console.error(qsTr("Incompatible file format ")+externalConfigFile.source+qsTr("\nShould be 1.0"))

            }

            if(newConfig.path.startsWith("."))
            {
                newConfig.path="file://"+externalConfigFile.getPath()
            }
            config=newConfig

        }
    }



}
