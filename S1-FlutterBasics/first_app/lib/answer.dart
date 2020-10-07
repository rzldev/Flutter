import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function answerQuestion;
  final String answer;

  Answer(this.answerQuestion, this.answer);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      child: RaisedButton(
        child: Text(answer),
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: answerQuestion,
      ),
    );
  }
}
