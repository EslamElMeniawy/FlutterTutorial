import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_edit.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.cleatProductsList();
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        ).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final Product product = model.allProducts[index];

                  return Dismissible(
                    key: Key(product.title),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        model.selectProduct(product.id);
                        model.deleteProduct().then((success) {
                          if (!success) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Something went wrong'),
                                  content: Text('Please try again!'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        model.fetchProducts();
                                      },
                                      child: Text('Okay'),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        });
                      }
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(product.image),
                          ),
                          title: Text(product.title),
                          subtitle: Text('\$${product.price.toString()}'),
                          trailing: _buildEditButton(context, index, model),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
                itemCount: model.allProducts.length,
              );
      },
    );
  }
}
