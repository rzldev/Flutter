import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function _addTransaction;

  NewTransaction(this._addTransaction) {
    print('Constructor NewTransaction Widget');
  }

  @override
  _NewTransactionState createState() {
    print('createState NewTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  _NewTransactionState() {
    print('Constuctor NewTransaction State');
  }

  @override
  void initState() {
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  DateTime _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
              keyboardType: TextInputType.text,
              onSubmitted: (_) {
                widget._addTransaction(
                  _titleController.text,
                  double.parse(_amountController.text),
                );
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) {
                widget._addTransaction(
                  _titleController.text,
                  double.parse(_amountController.text),
                );
              },
            ),
            Container(
              height: 64,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date choosen!'
                          : DateFormat.yMd().format(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  AdaptiveFlatButton('Choose Date', _presentDatePicker)
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                widget._addTransaction(
                  _titleController.text,
                  double.parse(_amountController.text),
                  _selectedDate,
                );
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.blue,
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
