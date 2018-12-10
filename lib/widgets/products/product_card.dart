import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import './address_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard(this.product);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TitleDefault(product.title),
          ),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(product.price.toString()),
          SizedBox(
            width: 8.0,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () {
              model.selectProduct(product.id);

              Navigator.pushNamed<bool>(
                context,
                '/product/' + product.id.toString(),
              ).then((_) => model.selectProduct(null));
            },
          ),
          IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.selectProduct(product.id);
              model.toggleProductFavoriteStatus();
              model.selectProduct(null);
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/food.jpg'),
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
          _buildTitlePriceRow(),
          SizedBox(
            height: 10.0,
          ),
          AddressTag('Mansoura, Egypt'),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
