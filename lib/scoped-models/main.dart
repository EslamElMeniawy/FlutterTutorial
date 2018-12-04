import 'package:scoped_model/scoped_model.dart';

import './connected_product.dart';
import './products.dart';
import './user.dart';

// ignore: mixin_inherits_from_not_object
class MainModel extends Model with ConnectedProduct, ProductsModel, UserModel {}
