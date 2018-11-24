import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: Text('LOGIN'),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
    );
  }
}
