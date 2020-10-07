import 'package:flutter/material.dart';
import 'quiz.dart';
import 'result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int _questionIndex = 0;
  int _totalScore = 0;

  final _questions = const [
    {
      'question': 'What\'s your favorite color?',
      'answers': [
        {'text': 'blue', 'score': 8},
        {'text': 'red', 'score': 10},
        {'text': 'green', 'score': 6},
        {'text': 'white', 'score': 4},
      ]
    },
    {
      'question': 'What\'s your favorite animal?',
      'answers': [
        {'text': 'parrot', 'score': 4},
        {'text': 'racoon', 'score': 6},
        {'text': 'cat', 'score': 8},
        {'text': 'dog', 'score': 10},
      ]
    },
    {
      'question': 'What\'s your favorite food?',
      'answers': [
        {'text': 'rendang', 'score': 10},
        {'text': 'sushi', 'score': 8},
        {'text': 'nasi goreng', 'score': 6},
        {'text': 'tom yam goong', 'score': 4},
      ]
    },
  ];

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
  }

  void resetQuiz() {
    setState(() {
      _totalScore = 0;
      _questionIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quiz App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                questions: _questions,
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
              )
            : Result(
                resultScore: _totalScore,
                resetQuiz: resetQuiz,
              ),
      ),
    );
  }
}
