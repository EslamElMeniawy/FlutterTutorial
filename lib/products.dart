import 'package:flutter/material.dart';

import './pages/product.dart';

class Products extends StatelessWidget {
  final List<String> products;

  Products([this.products = const []]);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/food.jpg'),
          Text(products[index]),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductPage(),
                      ),
                    ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (products.length > 0) {
      return _buildProductList();
    } else {
      return _buildNoProducts();
    }
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemBuilder: _buildProductItem,
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
