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
        onError: msg => App.instance? App.instance.showError(msg) : console.log(msg)
    }

    function loadEmbeddedConfig()
    {
        JsonLoader.loadJSON("qrc:/res/data/config.json", resp=>{
                                config = resp
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
                if(App.instance!==undefined)
                {
                    App.instance.showWarning(qsTr("Incompatible file format ")+externalConfigFile.source+qsTr("\nShould be 1.0"))
                } else
                {
                    console.error(qsTr("Incompatible file format ")+externalConfigFile.source+qsTr("\nShould be 1.0"))
                }
            }

            if(newConfig.path.startsWith("."))
            {
                newConfig.path="file://"+externalConfigFile.getPath()
            }

            if(checkConfig(newConfig))
                config=newConfig
        }
    }

    function checkConfig(aConfig)
    {
        if(aConfig.groups===undefined || aConfig.groups.length<=0)
        {
            if(App.instance!==undefined)
            {
                App.instance.showWarning(qsTr("Config: no groups defined"))
            } else
            {
                console.error(qsTr("Config: no groups defined"))
            }
            return false
        } else {

            for(var idxGpr=0;idxGpr<aConfig.groups.length; i++)
            {
                if(aConfig.groups[idxGpr].activities===undefined || aConfig.groups[idxGpr].activities<=0)
                {
                    if(App.instance!==undefined)
                    {
                        App.instance.showWarning(qsTr("Config: group %1 has no activity", aConfig.groups[idxGpr].name))
                    } else
                    {
                        console.error(qsTr("Config: group %1 has no activity", aConfig.groups[idxGpr].name))
                    }
                    return false
                }
                else
                {
                    if(!checkActivity(aConfig.groups[idxGpr]))
                        return false
                }
            }
        }
        return true
    }

    function isBlank(str) {
        return (!str || /^\s*$/.test(str));
    }

    function checkActivity(aActivity)
    {
        if(aActivity.config===undefine || isBlank(aActivity.config))
        {
            if(App.instance!==undefined)
            {
                App.instance.showWarning(qsTr("Config: an activity hasn't config"))
            } else
            {
                console.error(qsTr("Config: an activity hasn't config"))
            }
            return false
        }
        if(aActivity.category===undefine || isBlank(aActivity.category))
        {
            if(App.instance!==undefined)
            {
                App.instance.showWarning(qsTr("Config: an activity hasn't category"))
            } else
            {
                console.error(qsTr("Config: an activity hasn't category"))
            }
            return false
        }
        if(aActivity.type===undefine || isBlank(aActivity.type))
        {
            if(App.instance!==undefined)
            {
                App.instance.showWarning(qsTr("Config: an activity hasn't type"))
            } else
            {
                console.error(qsTr("Config: an activity hasn't type"))
            }
            return false
        }
    }



}
