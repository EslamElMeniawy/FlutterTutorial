import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavorite = false;

  List<Product> get products {
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

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: !selectedProduct.isFavorite);

    updateProduct(updatedProduct);
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
