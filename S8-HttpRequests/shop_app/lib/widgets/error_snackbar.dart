import 'package:flutter/material.dart';

class ErrorSnackbar {
  final BuildContext context;
  final String errorText;

  ErrorSnackbar(
      {@required this.context, this.errorText = 'Something went wrong'});

  SnackBar showSnackBar() => new SnackBar(
        content: new Text(errorText),
        duration: const Duration(seconds: 2),
        action: new SnackBarAction(
          label: 'Ok',
          textColor: Theme.of(context).errorColor,
          onPressed: () {},
        ),
      );
}
