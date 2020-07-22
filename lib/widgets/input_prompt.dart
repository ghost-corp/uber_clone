import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputPrompt extends StatefulWidget {
  final AsyncValueGetter<bool> onConfirmButtonPressed;
  final String title;
  final TextEditingController fieldController;
  final String successMessage;
  final String errorMessage;
  InputPrompt(
      {this.onConfirmButtonPressed,
      this.title,
      this.fieldController,
      this.errorMessage,
      this.successMessage});
  @override
  State createState() => InputPromptState();
}

class InputPromptState extends State<InputPrompt> {
  AsyncValueGetter<bool> onConfirmButtonPressed;
  String title;
  TextEditingController fieldController;
  bool executingFunction = false;
  bool success;
  String successMessage;
  String errorMessage;

  @override
  void initState() {
    onConfirmButtonPressed = widget.onConfirmButtonPressed;
    title = widget.title;
    fieldController = widget.fieldController;
    successMessage = widget.successMessage;
    errorMessage = widget.errorMessage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: fieldController,
              decoration: InputDecoration(border: UnderlineInputBorder()),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  success == null
                      ? Container()
                      : success == true
                          ? Text(
                              successMessage,
                              style: TextStyle(color: Colors.green),
                            )
                          : Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        executingFunction = true;
                      });
                      bool success = await onConfirmButtonPressed();
                      setState(() {
                        this.success = success;
                        executingFunction = false;
                      });
                    },
                    color: Colors.black,
                    child: executingFunction == true
                        ? Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          )
                        : Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
