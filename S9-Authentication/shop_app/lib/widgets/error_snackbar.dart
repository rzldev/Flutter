import 'package:flutter/material.dart';

class ErrorSnackbar {
  final BuildContext context;

  ErrorSnackbar(this.context);

  SnackBar showErrorSnackBar({String errorText = 'Something went wrong'}) =>
      new SnackBar(
        content: new Text(errorText),
        duration: const Duration(seconds: 2),
        action: new SnackBarAction(
          label: 'Ok',
          textColor: Theme.of(context).errorColor,
          onPressed: () {},
        ),
      );
}
