import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handlerFunction;

  const AdaptiveFlatButton(this.text, this.handlerFunction);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: handlerFunction,
          )
        : FlatButton(
            onPressed: handlerFunction,
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          );
  }
}
