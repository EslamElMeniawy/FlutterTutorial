import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<Map<String, String>> products;
  final Function deleteProduct;

  Products(this.products, {this.deleteProduct});

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products[index]['image']),
          Text(products[index]['title']),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text('Details'),
                onPressed: () => Navigator.pushNamed<bool>(
                            context, '/product/' + index.toString())
                        .then((bool value) {
                      if (value) {
                        deleteProduct(index);
                      }
                    }),
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
