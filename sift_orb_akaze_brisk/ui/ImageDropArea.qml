import QtQuick 2.9
import QtQuick.Layouts 1.3

DropArea {
    id: root
    onEntered: (drag) => {
        drag.accepted = drag.hasUrls
        if (drag.accepted) {
            root.initBackground(true, 250)
        }
    }
    onExited: (drag) => {
        root.initBackground(false, 250)
    }   
    onDropped: (drop) => {
        root.imageDropped(drop.urls[0])
        drop.accept()
    }

    property real backgroundRadius: 0
    signal imageDropped(string imageUrl)

    Rectangle {
        id: dropAreaBackground
        anchors.fill: parent
        color: "#DE222222"
        radius: root.backgroundRadius
        opacity: backgroundVisible ? 1 : 0

        property int animationDuration: 250
        property bool backgroundVisible: false

        Behavior on opacity {
            NumberAnimation {
                duration: dropAreaBackground.animationDuration
                easing.type: Easing.InOutQuad
            }
        }

        RowLayout {
            id: backgroundContentLayout
            anchors.fill: parent
            spacing: 16

            Text {
                id: dropImageTitle
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: "#B3FFFFFF"
                wrapMode: Text.WordWrap
                text: "Drop image here"
            }
        }
    }

    function initBackground(visible, duration) {
        dropAreaBackground.animationDuration = duration
        dropAreaBackground.backgroundVisible = visible
    }
}
