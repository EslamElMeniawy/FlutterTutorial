import 'package:flutter/material.dart';

import './products.dart';
import './product_control.dart';

class ProductsManager extends StatefulWidget {
  final String startingProduct;

  ProductsManager({this.startingProduct = 'Sweet Tester'});

  @override
  State<StatefulWidget> createState() {
    return _ProductsManagerState();
  }
}

class _ProductsManagerState extends State<ProductsManager> {
  List<String> _products = [];

  @override
  void initState() {
    super.initState();
    _products.add(widget.startingProduct);
  }

  void _addProduct(String product) {
    setState(() {
      _products.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(_addProduct),
        ),
        Expanded(child: Products(_products)),
      ],
    );
  }
}
