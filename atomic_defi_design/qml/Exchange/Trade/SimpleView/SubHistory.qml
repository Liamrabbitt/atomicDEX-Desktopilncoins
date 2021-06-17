//! Qt Imports
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

//! 3rdParty Imports
import Qaterial 1.0 as Qaterial

//! Project Imports
import "../../../Components"
import "../../../Constants"   //> Style
import "../Orders" as Orders
import "Main.js" as Main

Item {
    id: _subHistoryRoot
    anchors.fill: parent
    readonly property date default_min_date: new Date("2019-01-01")
    readonly property date default_max_date: new Date(new Date().setDate(new Date().getDate() + 30))
    property var list_model_proxy: API.app.orders_mdl.orders_proxy_mdl
    property bool displayFilter: false
    function update() {
        list_model_proxy.is_history = true
        applyTickerFilter()
        applyDateFilter()
        applyAllFiltering()
    }
    
    function applyTickerFilter() {  
        applyTickerFilter2(combo_base.currentTicker, combo_rel.currentTicker)
    }

    function applyTickerFilter2(ticker1, ticker2) {
        list_model_proxy.set_coin_filter(ticker1 + "/" + ticker2)
    }

    function applyDateFilter() {
        list_model_proxy.filter_minimum_date = min_date.date

        if(max_date.date < min_date.date)
            max_date.date = min_date.date

        list_model_proxy.filter_maximum_date = max_date.date
    }
    function applyFilter() {
        applyTickerFilter()
        applyDateFilter()

    }
    function applyAllFiltering() {
        list_model_proxy.apply_all_filtering()
    }
    ColumnLayout // Header
    {
        id: _swapCardHeader

        height: parent.height
        width: parent.width
        spacing: 20
        Item {
            width: parent.width
            Layout.preferredHeight: 60
            Qaterial.AppBarButton {
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 10
                x: 320
                icon.source: _subHistoryRoot.displayFilter? Qaterial.Icons.close : Qaterial.Icons.filter
                onClicked: {
                   console.log("clicked")
                    _subHistoryRoot.displayFilter = !_subHistoryRoot.displayFilter
                }
            }
            Column {
                padding: 20
                spacing: 5
                DefaultText // Title
                {
                    text: qsTr("History")
                    font.pixelSize: Style.textSize1
                }

                DefaultText // Description
                {
                    anchors.topMargin: 12
                    font.pixelSize: Style.textSizeSmall4
                    text: qsTr("Display all history created")
                }
            }
            
        }
        HorizontalLine
        {
            height: 2
            Layout.fillWidth: true
        }
        Item {
            id: main_order
            Layout.fillHeight: true
            Layout.fillWidth: true
            property bool is_history: true
            
            Component.onCompleted: {
                _subHistoryRoot.list_model_proxy.is_history = is_history
            }
            List {
                id: order_list_view
            }
            DexRectangle {
                anchors.fill: parent 
                color: theme.dexBoxBackgroundColor
                opacity: .8
                visible: _subHistoryRoot.displayFilter
                border.width: 0
            }
            DexRectangle {
                width: parent.width
                height: _subHistoryRoot.displayFilter? 330 : 60
                visible: height>100
                sizeAnimation: true
                color: theme.dexBoxBackgroundColor
                radius: 0
                y: -20
                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    leftPadding: 15 
                    rightPadding: 15
                    visible: parent.height>250
                    DexLabel {
                        text: qsTr("Filter settings")
                        topPadding: 10
                        leftPadding: 10
                        font: _font.body1
                    }
                    RowLayout {
                        width: main_order.width - 30
                        height: 35
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 0
                        DexLabel {
                            text: qsTr("Base Ticker")
                            leftPadding: 10
                            font: _font.body2
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            opacity: .6
                        }
                        DefaultSweetComboBox {
                            id: combo_base
                            model: API.app.portfolio_pg.global_cfg_mdl.all_proxy
                            onCurrentTickerChanged: applyTickerFilter()
                            height: 60
                            valueRole: "ticker"
                            textRole: 'ticker'
                        }
                        
                    }
                    RowLayout {
                        width: main_order.width - 30
                        height: 35
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5
                        DexLabel {
                            text: qsTr("Rel Ticker")
                            leftPadding: 10
                            font: _font.body2
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            opacity: .6
                        }
                        DefaultSweetComboBox {
                            id: combo_rel
                            model: API.app.portfolio_pg.global_cfg_mdl.all_proxy//combo_base.model
                            onCurrentTickerChanged: applyTickerFilter()
                            height: 60
                            valueRole: "ticker"
                            textRole: 'ticker'

                        }
                        
                    }
                    spacing: 10
                    Qaterial.TextFieldDatePicker {
                        id: min_date
                        title: qsTr("From")
                        from: default_min_date
                        to: default_max_date
                        date: default_min_date
                        onAccepted: applyDateFilter()
                        width: parent.width - 50
                        height: 60
                        opacity: .8
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Qaterial.TextFieldDatePicker {
                        id: max_date
                        enabled: min_date.enabled
                        title: qsTr("To")
                        from: min_date.date
                        to: default_max_date
                        date: default_max_date
                        onAccepted: applyDateFilter()
                        width: parent.width - 50
                        rightInset: 0
                        height: 60
                        opacity: .8
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Item {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 60
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        spacing: 10
                        DexAppButton {
                            height: 35
                            width: 120 
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Cancel")
                            onClicked: {
                                _subHistoryRoot.displayFilter = false
                            }
                        }
                        DexAppButton {
                            height: 35
                            width: 130 
                            anchors.verticalCenter: parent.verticalCenter
                            backgroundColor: Qaterial.Colors.lightGreen700
                            text: qsTr("Apply filter")
                            onClicked: {
                                _subHistoryRoot.displayFilter = false
                                _subHistoryRoot.applyFilter()
                                _subHistoryRoot.applyAllFiltering()
                            }
                        }
                    }
                }
            }
            
        }
        HorizontalLine
        {
            height: 2
            Layout.fillWidth: true
        }
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 15
            DexLabel // Title
            {
                text: order_list_view.count+" "+qsTr("Orders in history")
                anchors.horizontalCenter: parent.horizontalCenter
                y: -10
                //anchors.verticalCenterOffset: -4
            }
        }
        
    }
}