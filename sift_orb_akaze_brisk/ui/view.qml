import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1

import io.qt.textproperties 1.0

ApplicationWindow {
    id: root
    width: 1240
    height: 668
    visible: true
    Material.theme: Material.Dark
    Material.accent: Material.Blue

    readonly property real btnWidth:    160
    readonly property color clText:     "#FF90CAF9"
    readonly property color clButton:   "#FF607D8B"
    property string firstImageUrl:      ""
    property string secondImageUrl:     ""
    property bool isResultReady:        false

    Bridge {
        id: bridge
    }

    RowLayout {
        id: mainRowLayout
        anchors.fill: parent

        ColumnLayout {
            id: detectorsLayout
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
                Layout.topMargin: 40
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
                Layout.topMargin: 40
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

            Button {
                Layout.preferredWidth: root.btnWidth
                text: "Clear"
                highlighted: true
                enabled: root.firstImageUrl !== "" || root.secondImageUrl !== ""
                Material.elevation: 5
                Material.background: root.clButton
                onClicked: {
                    root.firstImageUrl = root.secondImageUrl = ""
                    isResultReady = false
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }

        ColumnLayout {
            Layout.leftMargin: 64
            Layout.topMargin: 32
            spacing: 0

            Text {
                id: imageslabel
                Layout.bottomMargin: 16
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

            Rectangle {
                Layout.topMargin: 16
                Layout.preferredWidth: imagesLayout.width
                Layout.preferredHeight: 160
                border.width: 2
                border.color: "#FF009688"
                color: "#00000000"
                radius: 2
                visible: root.isResultReady

                GridLayout {
                    id: resultLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    rowSpacing: 8
                    columnSpacing: 10
                    rows: 4
                    columns: 2

                    Text {
                        id: selectedFilePathsLabel
                        Layout.alignment: Qt.AlignTop
                        color: root.clText
                        font.pointSize: 12
                        text: "File paths of selected images: "
                    }

                    ColumnLayout {
                        spacing: 3

                        Text {
                            id: firstImagePathLabel
                            color: "#FF2196F3"
                            font.pointSize: 12
                        }

                        Text {
                            id: secondImagePathLabel
                            color: "#FFFFC107"
                            font.pointSize: 12
                        }
                    }

                    Text {
                        id: featuresFoundLabel
                        Layout.alignment: Qt.AlignTop
                        color: root.clText
                        font.pointSize: 12
                        text: "Features found: "
                    }

                    ColumnLayout {
                        spacing: 3

                        Text {
                            id: firstImageFeaturesLabel
                            color: "#FF2196F3"
                            font.pointSize: 12
                        }

                        Text {
                            id: secondImageFeaturesLabel
                            color: "#FFFFC107"
                            font.pointSize: 12
                        }
                    }
                    
                    Text {
                        color: root.clText
                        font.pointSize: 12
                        text: "Inliers / Matched: "
                    }

                    Text {
                        id: inliersWithMatchedLabel
                        color: "#FF4CAF50"
                        font.pointSize: 12
                    }

                    Text {
                        color: root.clText
                        font.pointSize: 12
                        text: "Similarity: "
                    }

                    Text {
                        id: similarityLabel
                        color: "#FFF44336"
                        font.pointSize: 12
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Connections {
        target: bridge
        function onShowResult(firstImagePath, secondImagePath, compareResult) {
            firstImagePathLabel.text = firstImagePath
            secondImagePathLabel.text = secondImagePath
            firstImageFeaturesLabel.text = compareResult[0]
            secondImageFeaturesLabel.text = compareResult[1]
            inliersWithMatchedLabel.text = compareResult[2] + " / " + compareResult[3]
            similarityLabel.text = compareResult[4]
            root.isResultReady = true
        }
    }
}
