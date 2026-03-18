import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    visible: true
    width: 1000
    height: 600
    title: "Photo Reductor"

    property bool openingForMain: false

    ListModel {
        id: imageModel
    }

    function deleteImage(removedPath) {
        var realIndex = -1
        for (var i = 0; i < imageModel.count; i++) {
            if (imageModel.get(i).path === removedPath) {
                realIndex = i
                break
            }
        }
        if (realIndex === -1)
            return
        var wasCurrent = (img.source.toString() === removedPath.toString())
        imageModel.remove(realIndex)
        if (wasCurrent) {
            if (imageModel.count > 0) {
                img.source = imageModel.get(Math.min(realIndex, imageModel.count - 1)).path
            } else {
                img.source = ""
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Rectangle {
                width: 150
                color: "#2E2E2E"
                Layout.fillHeight: true

                Column {
                    anchors.fill: parent
                    spacing: 25
                    padding: 25

                    Button {
                        text: "Open Image"
                        implicitWidth: 100
                        implicitHeight: 40
                        onClicked: {
                            openingForMain = true
                            fileDialog.open()
                        }
                    }

                    Button { text: "Elements"; implicitWidth: 100; implicitHeight: 40 }
                    Button { text: "Filters";  implicitWidth: 100; implicitHeight: 40 }
                    Button { text: "Text";     implicitWidth: 100; implicitHeight: 40 }
                    Button { text: "Rotate";   implicitWidth: 100; implicitHeight: 40 }
                    Button { text: "Effect";   implicitWidth: 100; implicitHeight: 40 }
                    Button { text: "Stickers"; implicitWidth: 100; implicitHeight: 40 }
                }
            }

            Rectangle {
                color: "#1E1E1E"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Image {
                    id: img
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    width: parent.width
                    height: parent.height
                }
            }
        }

        Rectangle {
            id: bottomBar
            Layout.fillWidth: true
            height: 50
            color: "#2B2B2B"

            Row {
                anchors.centerIn: parent
                spacing: 15

                Button { text: "EXIF"; implicitWidth: 80; implicitHeight: 40 }

                Button {
                    text: "-"
                    implicitWidth: 80
                    implicitHeight: 40
                    onClicked: {
                        img.scale -= 0.1
                        if (img.scale < 0.1) img.scale = 0.1
                    }
                }

                Button {
                    text: "+"
                    implicitWidth: 80
                    implicitHeight: 40
                    onClicked: {
                        img.scale += 0.1
                        if (img.scale > 1.3) img.scale = 1.3
                    }
                }

                Text {
                    text: Math.round(img.scale * 100) + "%"
                    color: "white"
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                }

                Button { text: "Histogram"; implicitWidth: 80; implicitHeight: 40 }
                Button { text: "Compare"; implicitWidth: 80; implicitHeight: 40 }

                Button {
                    text: "Reset"
                    implicitWidth: 80
                    implicitHeight: 40
                    onClicked: img.scale = 1.0
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 150
            color: "#1A1A1A"

            Rectangle {
                id: addBtn
                width: 100
                height: parent.height
                color: "#2E2E2E"
                anchors.left: parent.left

                Column {
                    anchors.centerIn: parent
                    spacing: 4

                    Text {
                        text: "+"
                        color: "white"
                        font.pixelSize: 28
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text: "Add Image"
                        color: "#AAAAAA"
                        font.pixelSize: 11
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        openingForMain = false
                        fileDialog.open()
                    }

                    onEntered: addBtn.color = "#3E3E3E"
                    onExited: addBtn.color = "#2E2E2E"
                }
            }

            ScrollView {
                anchors.left: addBtn.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                Row {
                    spacing: 6
                    padding: 6
                    height: 150

                    Repeater {
                        model: imageModel

                        delegate: Rectangle {
                            width: 130
                            height: 138
                            color: "#2A2A2A"
                            radius: 4

                            Image {
                                anchors.fill: parent
                                anchors.margins: 4
                                source: model.path
                                fillMode: Image.PreserveAspectFit
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    img.source = model.path
                                }
                            }

                            Rectangle {
                                width: 20
                                height: 20
                                radius: 10
                                color: "#CC3333"
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 2

                                Text {
                                    anchors.centerIn: parent
                                    text: "×"
                                    color: "white"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.deleteImage(model.path)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select an Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg *.bmp *.gif *.webp)"]

        onAccepted: {
            var path = fileDialog.selectedFile || fileDialog.fileUrl

            if (path) {
                img.source = path

                imageModel.append({
                    path: path
                })
            }
        }
    }
}
