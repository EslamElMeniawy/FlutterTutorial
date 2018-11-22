import 'package:flutter/material.dart';

import '../products_manager.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easy List'),
        centerTitle: true,
      ),
      body: ProductsManager(),
    );
  }
}
