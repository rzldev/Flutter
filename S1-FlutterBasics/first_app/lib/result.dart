import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetQuiz;

  const Result({this.resultScore, this.resetQuiz});

  String get resultText {
    if (resultScore > 20) {
      return 'You are awesome';
    } else if (resultScore > 10) {
      return 'You did good';
    } else {
      return 'The Quiz is over';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(8),
      child: Center(
        child: Column(
          children: [
            Text(
              resultText,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            FlatButton(
              onPressed: resetQuiz,
              child: Text(
                'Reset Quiz',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              textColor: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
