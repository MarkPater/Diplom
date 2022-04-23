import QtQuick 2.9
import QtQuick.Controls 2.1
import Qt.labs.platform 1.1

Button {
    id: root
    highlighted: true
    Material.elevation: 5
    Material.background: root.clButton
    onClicked: {
        fileDialog.open()
    }

    property color clButton: "#00000000"
    signal imageSelected(url imageUrl)

    FileDialog {
        id: fileDialog
        title: "Please choose an image"
        nameFilters: [ "Image files (*.jpg *.jpeg *.png *.webp *.jfif *.bmp)" ]
        folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        onAccepted: {
            root.imageSelected(file)
        }
    }
}