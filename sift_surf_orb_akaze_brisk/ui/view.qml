import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1

import io.qt.textproperties 1.0

ApplicationWindow {
    id: root
    width: 1240
    height: 620
    visible: true
    Material.theme: Material.Dark
    Material.accent: Material.Blue

    readonly property real btnWidth:    160
    readonly property color clText:     "#FF90CAF9"
    readonly property color clButton:   "#FF607D8B"
    property string firstImageUrl:      ""
    property string secondImageUrl:     ""

    Bridge {
        id: bridge
    }

    RowLayout {
        id: mainRowLayout
        anchors.fill: parent

        ColumnLayout {
            id: featuresLayout
            spacing: 2
            Layout.leftMargin: 32
            Layout.topMargin: 32

            Text {
                id: algorithmlabel
                Layout.bottomMargin: 12
                color: root.clText
                font.pointSize: 18
                text: "Recognition algorithm:"
            }

            RadioButton {
                id: siftButton
                text: "SIFT"
                checked: true
                onToggled: {
                    bridge.setDetector(text)
                }
            }

            RadioButton {
                id: orbButton
                text: "ORB"
                onToggled: {
                    bridge.setDetector(text)
                }
            }

            RadioButton {
                id: akazeButton
                text: "AKAZE"
                onToggled: {
                    bridge.setDetector(text)
                }
            }

            RadioButton {
                id: briskButton
                text: "BRISK"
                onToggled: {
                    bridge.setDetector(text)
                }
            }

            Text {
                id: chooseImagesLabel
                Layout.topMargin: 34
                Layout.bottomMargin: 12
                color: root.clText
                font.pointSize: 18
                text: "Choose images:"
            }

            FileDialogButton {
                Layout.preferredWidth: root.btnWidth
                text: "Select first"
                clButton: root.clButton
                onImageSelected: function (imageUrl) {
                    root.firstImageUrl = imageUrl
                }
            }

            FileDialogButton {
                Layout.preferredWidth: root.btnWidth
                text: "Select second"
                clButton: root.clButton
                onImageSelected: function (imageUrl) {
                    root.secondImageUrl = imageUrl
                }
            }

            Text {
                id: resultLabel
                Layout.topMargin: 34
                Layout.bottomMargin: 12
                color: root.clText
                font.pointSize: 18
                text: "Result:"
            }

            Button {
                Layout.preferredWidth: root.btnWidth
                text: "Compare"
                highlighted: true
                enabled: root.firstImageUrl !== "" && root.secondImageUrl !== ""
                Material.elevation: 5
                Material.background: root.clButton
                onClicked: {
                    bridge.compareImages(firstImageUrl, secondImageUrl)
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ColumnLayout {
            Layout.leftMargin: 64
            Layout.topMargin: 32

            Text {
                id: imageslabel
                Layout.bottomMargin: 12
                color: root.clText
                font.pointSize: 18
                text: "Images:"
            }
            
            RowLayout {
                id: imagesLayout
                spacing: 16

                Loader {
                    id: firstImageLoader
                    sourceComponent: root.firstImageUrl !== "" ? compFirstImage : compFirstImageStub

                    Component {
                        id: compFirstImage

                        Image {
                            id: firstImage
                            width: 400
                            height: 400
                            fillMode: Image.PreserveAspectFit
                            source: root.firstImageUrl
                        }
                    }

                    Component {
                        id: compFirstImageStub
                        
                        ImageStub {
                            borderColor: root.clButton
                            onImageDropped: function (imageUrl) {
                                root.firstImageUrl = imageUrl
                            }
                        }
                    }
                }

                Loader {
                    id: secondImageLoader
                    sourceComponent: root.secondImageUrl !== "" ? compSecondImage : compSecondImageStub

                    Component {
                        id: compSecondImage

                        Image {
                            id: secondImage
                            width: 400
                            height: 400
                            fillMode: Image.PreserveAspectFit
                            source: root.secondImageUrl
                        }
                    }

                    Component {
                        id: compSecondImageStub
                        
                        ImageStub {
                            borderColor: root.clButton
                            onImageDropped: function (imageUrl) {
                                root.secondImageUrl = imageUrl
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
