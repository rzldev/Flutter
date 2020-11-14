import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../widgets/error_snackbar.dart';

class SignUp extends StatefulWidget {
  final Function _refreshPage;

  const SignUp(this._refreshPage);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailNode = new FocusNode();
  final FocusNode _passNode = new FocusNode();
  final FocusNode _confirmPassNode = new FocusNode();

  Map<String, String> _signUpForm = {
    'email': '',
    'password': '',
    'confirm_password': '',
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

  Future _signUp() async {
    setState(() => _isLoading = true);

    _formKey.currentState.save();

    try {
      await Provider.of<Auth>(context, listen: false).signUp(
        email: _signUpForm['email'],
        password: _signUpForm['password'],
      );

      setState(() => _isLoading = false);
      Scaffold.of(context).showSnackBar(ErrorSnackbar(context)
          .showErrorSnackBar(errorText: 'Accound succesfully created'));

      widget._refreshPage();
    } on HttpException catch (error) {
      setState(() => _isLoading = false);

      String errorMessage = 'Sign up failed';

      if (error.toString().contains('EMAIL_EXIST')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }

      return Scaffold.of(context).showSnackBar(
          ErrorSnackbar(context).showErrorSnackBar(errorText: errorMessage));
    } catch (error) {
      setState(() => _isLoading = false);

      return Scaffold.of(context)
          .showSnackBar(ErrorSnackbar(context).showErrorSnackBar());
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
              _signUpForm = {
                'email': value,
                'password': _signUpForm['password'],
                'confirm_password': _signUpForm['confirm_password'],
              };
            },
          ),
          const SizedBox(
            height: 16,
          ),
          new TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            focusNode: _passNode,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: _formDecoration('Password', _passNode),
            onTap: () => _requestFocus(_passNode),
            onFieldSubmitted: (_) => _requestFocus(_confirmPassNode),
            onSaved: (value) {
              _signUpForm = {
                'email': _signUpForm['email'],
                'password': value,
                'confirm_password': _signUpForm['confirm_password'],
              };
            },
          ),
          const SizedBox(
            height: 16,
          ),
          new TextFormField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: _confirmPassNode,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: _formDecoration('Confirm Password', _confirmPassNode),
            onTap: () => _requestFocus(_confirmPassNode),
            onFieldSubmitted: (_) {
              _signUp();
            },
            onSaved: (value) {
              _signUpForm = {
                'email': _signUpForm['email'],
                'password': _signUpForm['password'],
                'confirm_password': value,
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8)),
                    child: const Text(
                      'SIGN UP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: _signUp,
                  )),
        ],
      ),
    );
  }
}
