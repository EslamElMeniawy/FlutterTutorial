import 'package:scoped_model/scoped_model.dart';

import './connected_product.dart';

// ignore: mixin_inherits_from_not_object
class MainModel extends Model with ConnectedProductModel, ProductsModel, UserModel {}
