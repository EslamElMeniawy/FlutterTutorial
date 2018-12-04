import 'package:scoped_model/scoped_model.dart';

import './products.dart';
import './user.dart';

// ignore: mixin_inherits_from_not_object
class MainModel extends Model with ProductsModel, UserModel {}
