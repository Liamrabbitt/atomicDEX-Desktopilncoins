import QtQuick 2.12

import "../Components"
import "../Constants"
import Dex.Themes 1.0 as Dex

Item
{
    id: root

    enum LineType
    {
        Portfolio,
        Wallet,
        DEX,         // DEX == Trading page
        Addressbook,
        Support
    }

    property bool   isExpanded: containsMouse
    property real   lineHeight: 44
    property var    currentLineType: Main.LineType.Portfolio
    property alias  _selectionCursor: _selectionCursor
    property bool   containsMouse: mouseArea.containsMouse

    signal lineSelected(var lineType)
    signal settingsClicked()
    signal privacySwitched(var checked)

    width: isExpanded ? 200 : 80
    height: parent.height

    // Background Rectangle
    Rectangle
    {
        anchors.fill: parent
        color: Dex.CurrentTheme.sidebarBgColor
    }

    // Animation when changing width.
    Behavior on width
    {
        NumberAnimation { duration: 300; targets: [width, _selectionCursor.width]; properties: "width" }
    }

    // Selection Cursor
    AnimatedRectangle
    {
        id: _selectionCursor

        y:
        {
            if (currentLineType === Main.LineType.Support) return bottom.y + lineHeight + bottom.spacing;
            else return center.y + currentLineType * (lineHeight + center.spacing);
        }

        anchors.left: parent.left
        anchors.leftMargin: 12
        radius: 18
        width: parent.width - 14
        height: lineHeight

        opacity: .7

        gradient: Gradient
        {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.125; color: Dex.CurrentTheme.sidebarCursorStartColor }
            GradientStop { position: 0.933; color: Dex.CurrentTheme.sidebarCursorEndColor }
        }

        Behavior on y
        {
            NumberAnimation { duration: 180 }
        }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        Top
        {
            id: top
            width: parent.width
            height: 180
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16
        }

        Center
        {
            id: center
            width: parent.width
            anchors.top: top.bottom
            anchors.topMargin: 69.5
            onLineSelected:
            {
                if (currentLineType === lineType)
                    return;
                currentLineType = lineType;
                root.lineSelected(lineType);
            }
        }

        Bottom
        {
            id: bottom
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 62

            onSupportLineSelected:
            {
                if (currentLineType === lineType)
                    return;
                currentLineType = lineType;
                root.lineSelected(lineType);
            }
            onSettingsClicked: root.settingsClicked()
        }

        VerticalLine
        {
            height: parent.height
            anchors.right: parent.right
        }
    }
}