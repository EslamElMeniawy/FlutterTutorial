import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'contact',
              mini: true,
              onPressed: () async {
                final url = 'mailto:${widget.product.userEmail}';

                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Icon(
                Icons.mail,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'favorite',
              mini: true,
              onPressed: () {
                model.toggleProductFavoriteStatus();
              },
              child: Icon(
                model.selectedProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: 'options',
            onPressed: () {},
            child: Icon(Icons.more_vert),
          ),
        ],
      );
    });
  }
}