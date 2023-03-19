import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  static const String domain =
      'https://filesharingbd.pythonanywhere.com/bookapi/';

  Future<void> fetchProducts() async {
    var url = Uri.parse(domain);

    try {
      final List<Product> tempProducts = [];
      var response = await http.get(url);
      final loardProducts = json.decode(response.body);
      loardProducts.forEach((productData) {
        tempProducts.add(Product(
          id: '${productData['id']}',
          title: productData['name'],
          edition: productData['edition'],
          author: productData['author'],
          description: productData['description'],
          imageUrl: productData['cover'],
          image1: productData['cover'],
          image2: productData['cover'],
          price: productData['price'] * 1.0,
        ));
      });
      _items = tempProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  List<Product> _items = [];

  // bool isFavorite = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteProducts {
    return _items.where((product) => product.isFavorite).toList();
  }

  set addItem(obj) {
    _items.add(obj);
    notifyListeners();
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
