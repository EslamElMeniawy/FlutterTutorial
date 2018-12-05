import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ConnectedProductModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProductId;
  bool _isLoading = false;
}

class ProductsModel extends ConnectedProductModel {
  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorite) {
      return List.from(
          _products.where((Product product) => product.isFavorite).toList());
    }

    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selectedProductId;
    });
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  Product get selectedProduct {
    if (_selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((Product product) {
      return product.id == _selectedProductId;
    });
  }

  bool get displayFavoriteOnly {
    return _showFavorite;
  }

  Future<bool> addProduct(
      String title, String description, double price, String image) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://keyassets-p2.timeincuk.net/wp/prod/wp-content/uploads/sites/53/2018/04/pick-and-mix-chocolate-and-sweet-cake-920x605.jpg',
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post(
          'https://auth-95faf.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);

      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://keyassets-p2.timeincuk.net/wp/prod/wp-content/uploads/sites/53/2018/04/pick-and-mix-chocolate-and-sweet-cake-920x605.jpg',
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    return http
        .put(
            'https://auth-95faf.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updatedData))
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      _products[selectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;

    _products.removeAt(selectedProductIndex);
    _selectedProductId = null;
    notifyListeners();

    return http
        .delete(
            'https://auth-95faf.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();

    return http
        .get(
            'https://auth-95faf.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];

      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);

        fetchedProductList.add(product);
      });

      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selectedProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() {
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: !selectedProduct.isFavorite);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selectedProductId = productId;

    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductModel {
  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    String postUrl;

    if (mode == AuthMode.Login) {
      postUrl =
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBe74nyu2lz-9o1H0_CnHmHd0kCOczd_nw';
    } else {
      postUrl =
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBe74nyu2lz-9o1H0_CnHmHd0kCOczd_nw';
    }

    try {
      final http.Response response = await http.post(
        postUrl,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      bool success = true;
      String message = 'Authentication succeeded.';

      if (responseData.containsKey('error')) {
        success = false;

        if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
          message = 'This email was not found.';
        } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
          message = 'The password is invalid.';
        } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
          message = 'This email already exsists.';
        } else {
          message = 'Something went wrong.';
        }
      } else {
        _authenticatedUser = User(
          id: responseData['localId'],
          email: responseData['email'],
          token: responseData['idToken'],
        );
      }

      _isLoading = false;
      notifyListeners();
      return {'success': success, 'message': message};
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}

class UtilityModel extends ConnectedProductModel {
  bool get isLoading {
    return _isLoading;
  }
}
