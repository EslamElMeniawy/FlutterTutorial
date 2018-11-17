import 'package:flutter/material.dart';

import './products_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Easy List'),
          centerTitle: true,
        ),
        body: ProductsManager(
          startingProduct: 'Food Tester',
        ),
      ),
    );
  }
}
