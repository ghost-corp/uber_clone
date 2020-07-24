import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String from;
  final String message;
  final Timestamp timestamp;
  final bool person;

  const MessageWidget({this.timestamp, this.message, this.person, this.from});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment:
            person ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: person
                  ? BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12))
                  : BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
              color: person ? Colors.black : Colors.grey[200],
            ),
            padding: EdgeInsets.all(12),
            child: Text(
              message,
              style: TextStyle(color: person ? Colors.white : Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
