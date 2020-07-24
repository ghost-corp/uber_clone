import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/chat/message_widget.dart';
import 'package:uber_clone/global/screen_size.dart';
import 'package:uber_clone/models/auth_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  ScrollController scroll = ScrollController();
  String driverId;

  @override
  Widget build(BuildContext context) {
    driverId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        height: height(context),
        width: width(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 40, top: 40, left: 5, right: 5),
              height: height(context) * 0.15,
              width: width(context),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    iconSize: 28,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.white,
                elevation: 30,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  width: width(context),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(globalUser.uid)
                        .collection('messages')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      List<DocumentSnapshot> docs = snapshot.data.documents;

                      List<Widget> chatMessages = docs
                          .map((e) => MessageWidget(
                                from: e.data['fromName'],
                                message: e.data['message'],
                                person: globalUser.uid == e.data['fromId'],
                              ))
                          .toList();

                      return ListView(
                        controller: scroll,
                        children: <Widget>[...chatMessages],
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        onTap: () {},
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(height: 1, fontSize: 16),
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: 'Enter a message',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(36.0)),
                            contentPadding: EdgeInsets.only(
                                left: 12, top: 12, bottom: 12, right: 12)),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      color: Colors.black,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        sendMessage();
                      },
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().length > 0) {
      String message = messageController.text.trim();
      messageController.clear();
      await Firestore.instance
          .collection("users")
          .document(globalUser.uid)
          .collection("messages")
          .add({
        'message': message,
        'fromId': globalUser.uid,
        'toId': driverId,
        'timestamp': Timestamp.now()
      });
      print('sent');
      scroll.animateTo(scroll.position.minScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
