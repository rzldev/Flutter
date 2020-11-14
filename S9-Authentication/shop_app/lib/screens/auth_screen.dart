import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widgets/gradient_text.dart';
import '../widgets/login.dart';
import '../widgets/signup.dart';

enum FormMode { LoginMode, SignUpMode }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FormMode _openForm = FormMode.LoginMode;

  void _refreshPage() {
    setState(() => _openForm = FormMode.LoginMode);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          width: double.infinity,
          height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top),
          margin: MediaQuery.of(context).padding,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.pink,
                  Colors.pink.withOpacity(0.6),
                ]),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Column(
                children: [
                  const Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  new GradientText(
                      text: const Text('Simple Shop App',
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.pink.shade50,
                        ],
                      )),
                ],
              ),
              new Container(
                padding: const EdgeInsets.all(40),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(12),
                ),
                child: new Column(
                  children: [
                    _openForm == FormMode.LoginMode
                        ? new Login()
                        : new SignUp(_refreshPage),
                    const SizedBox(
                      height: 16,
                    ),
                    new RichText(
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                              text: _openForm == FormMode.SignUpMode
                                  ? 'Already have an account? '
                                  : 'Don\'t have any account yet? '),
                          new TextSpan(
                              text: _openForm == FormMode.SignUpMode
                                  ? 'Login'
                                  : 'SignUp',
                              style: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => setState(() =>
                                    _openForm == FormMode.SignUpMode
                                        ? _openForm = FormMode.LoginMode
                                        : _openForm = FormMode.SignUpMode)),
                        ],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
