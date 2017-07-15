import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    property var sit: true
    signal sendTextToC(string text)
    title: qsTr("Server")

    ListModel {
        id: messageModel
    }


    Label{
        id:logo
        text:"Waiting for Connection..."
        color: "#FF5722"
        font.pixelSize: 20
        x:parent.width/2 - 110
        y:parent.height/2 - 100
    }

    ColumnLayout {
        anchors { fill: parent; margins: 30 }
        spacing: 16

        ListView {
            id: listview
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: messageModel
            delegate: ItemDelegate
            {
                text: model.message
                font.family: "Comic Sans MS"
                font.pixelSize: 18
            }
        }
        RowLayout {
            spacing: 16
            y:200
            Layout.fillWidth: true; Layout.fillHeight: false
            x:300

            TextField {
                id: textField
                font.family: "Comic Sans MS"
                Layout.fillWidth: true; Layout.fillHeight: true
                placeholderText: "Write a message..."
                background: null
                focus: true
                renderType: Text.NativeRendering
                onTextEdited: {
                    if(text.length % 52  == 0){
                        console.log(textField.height)
//                        cursorPosition = 0
                        height += 50
                        textField.text += "\n\r"
                        console.log(text.length)
                        counter++
                    }

                }

               Keys.onPressed: {
                    if (event.key == Qt.Key_Enter && textField.text != "") {
                        logo.visible = false
                        messageModel.append({message: textField.text});
                        sendTextToC(textField.text)
                        textField.text = ""
                        listview.positionViewAtEnd()
                    }
                }
            }

            Button {
                id: send
                Material.foreground: "white"; Material.background: Material.DeepOrange
                Layout.fillHeight: true
                text: "Send"
                onClicked: {
                    if(textField.text != ""){
                        logo.visible = false
                        messageModel.append({message: textField.text});
                        sendTextToC(textField.text)
                        textField.text = ""
                        listview.positionViewAtEnd()
                    }
                }
            }
        }
    }

    property string textA : sentMessage.callMeFromQml()
    property string textB
    Timer {
        id:timer;interval: 1; running: true; repeat: true
        onTriggered: {
            if(textA != "" && textA.localeCompare(textB) != 0){
                messageModel.append({message:"Client: " + textA})
                textB = textA
                logo.visible = false
                listview.positionViewAtEnd()
            }
            else{
                textA = sentMessage.callMeFromQml()
            }
        }
    }

    Page1{}
}
