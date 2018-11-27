import 'package:flutter/material.dart';

import './product_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  Products(this.products);

  Widget _buildContent() {
    if (products.length > 0) {
      return _buildProductList();
    } else {
      return _buildNoProducts();
    }
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          ProductCard(products[index], index),
      itemCount: products.length,
    );
  }

  Widget _buildNoProducts() {
    return Center(
      child: Text('No products available, please add some.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}
