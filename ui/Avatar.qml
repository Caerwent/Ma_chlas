import QtQuick
import QtQuick.Controls
import UIUtils 1.0 as UIUtils
import "."
import "../dataModels"


    Card {
        id:card
        property var child
        property alias isSelectable:card.selectable
        property bool isSmall:false

        onIsSmallChanged: {
            card.padding = isSmall ? 2 : 10
        }

        onChildChanged:
        {
            label = child ? child.name : ""
            imgSource = child ? GlobalConfigModel.config.path+child.image : ""
        }

        onSelected:
        {
            Session.child = child
            App.instance.getNavigator().gotToScreen(Screens.games)
        }



    }

