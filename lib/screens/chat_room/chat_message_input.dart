// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tennis_match_app/utils/constants.dart';

// ignore: must_be_immutable
class ChatMessageInput extends StatelessWidget {
  final Function onPressed;

  ChatMessageInput({Key key, this.onPressed}) : super(key: key);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Введите сообщение',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: Constants.border,
                disabledBorder: Constants.border,
                border: Constants.border,
                errorBorder: Constants.border,
                focusedBorder: Constants.border,
                focusedErrorBorder: Constants.border,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GiftsMarket()));*/
            },
            padding: EdgeInsets.zero,
            shape: CircleBorder(),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xffffae88), Color(0xff8f93ea)])),
              child: Icon(
                Icons.card_giftcard,
                color: Colors.white,
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              onPressed(_controller.text);
              _controller.clear();
            },
            padding: EdgeInsets.zero,
            shape: CircleBorder(),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xffffae88), Color(0xff8f93ea)])),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
