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
            card.labelSize = isSmall ? 8 : 16
        }

        onChildChanged:
        {
            label = child ? child.name : ""
            imgSource = child ? GlobalConfigModel.config.path+child.image : ""
        }


    }

