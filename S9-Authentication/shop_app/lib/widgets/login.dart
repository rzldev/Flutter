import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';
import '../screens/home_screen.dart';
import '../widgets/error_snackbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailNode = new FocusNode();
  final FocusNode _passNode = new FocusNode();

  Map<String, String> _loginForm = {
    'email': '',
    'password': '',
  };

  bool _isLoading = false;

  InputDecoration _formDecoration(String text, FocusNode node) =>
      new InputDecoration(
          labelText: text,
          labelStyle: new TextStyle(
              color: node.hasFocus ? Colors.pink : Colors.black54),
          border: const OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.pink,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.pink,
            ),
          ));

  void _requestFocus(FocusNode node) {
    setState(() => FocusScope.of(context).requestFocus(node));
  }

  Future _login() async {
    setState(() => _isLoading = true);

    _formKey.currentState.save();

    try {
      await Provider.of<Auth>(context, listen: false).login(
        email: _loginForm['email'],
        password: _loginForm['password'],
      );

      setState(() => _isLoading = false);

      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } on HttpException catch (error) {
      setState(() => _isLoading = false);

      String errorMessage = 'Login failed';

      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }

      return Scaffold.of(context).showSnackBar(
          ErrorSnackbar(context).showErrorSnackBar(errorText: errorMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new Column(
        children: [
          new TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailNode,
            decoration: _formDecoration('Email', _emailNode),
            onTap: () => _requestFocus(_emailNode),
            onFieldSubmitted: (_) => _requestFocus(_passNode),
            onSaved: (value) {
              _loginForm = {
                'email': value,
                'password': _loginForm['password'],
              };
            },
          ),
          const SizedBox(
            height: 16,
          ),
          new TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _passNode,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: _formDecoration('Password', _passNode),
            onTap: () => _requestFocus(_passNode),
            onFieldSubmitted: (_) {
              _login();
            },
            onSaved: (value) {
              _loginForm = {
                'email': _loginForm['email'],
                'password': value,
              };
            },
          ),
          const SizedBox(
            height: 16,
          ),
          _isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 5,
                )
              : new Container(
                  width: double.infinity,
                  child: new RaisedButton(
                    color: Colors.pink,
                    padding: new EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8)),
                    child: const Text(
                      'LOGIN',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: _login,
                  )),
        ],
      ),
    );
  }
}
