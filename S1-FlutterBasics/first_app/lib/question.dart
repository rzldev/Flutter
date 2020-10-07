import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String question;

  Question({@required this.question});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Text(
        question,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
