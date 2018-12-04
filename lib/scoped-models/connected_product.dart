import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selectedProductIndex;

  void addProduct(
      String title, String description, double price, String image) {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://keyassets-p2.timeincuk.net/wp/prod/wp-content/uploads/sites/53/2018/04/pick-and-mix-chocolate-and-sweet-cake-920x605.jpg',
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    http
        .post('https://auth-95faf.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response response) {
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
      notifyListeners();
    });
  }
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
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    if (_selectedProductIndex == null) {
      return null;
    }

    return _products[_selectedProductIndex];
  }

  bool get displayFavoriteOnly {
    return _showFavorite;
  }

  void updateProduct(
      String title, String description, double price, String image) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);

    _products[_selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    notifyListeners();
  }

  void fetchProducts() {
    http
        .get('https://auth-95faf.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];

      final Map<String, dynamic> productListData = json.decode(response.body);

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
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: !selectedProduct.isFavorite);

    _products[_selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;

    if (index != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'userid', email: email, password: password);
  }
}
