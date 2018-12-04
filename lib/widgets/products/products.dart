import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {
  Widget _buildContent(List<Product> products) {
    if (products.length > 0) {
      return _buildProductList(products);
    } else {
      return _buildNoProducts();
    }
  }

  Widget _buildProductList(List<Product> products) {
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildContent(model.displayedProducts);
      },
    );
  }
}
