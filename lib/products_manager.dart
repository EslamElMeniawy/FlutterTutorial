import 'package:flutter/material.dart';

import './products.dart';

class ProductsManager extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  ProductsManager(this.products);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Products(products)),
      ],
    );
  }
}
