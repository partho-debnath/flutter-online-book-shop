import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  static const String domain =
      'https://fluttergedgetsstore-default-rtdb.firebaseio.com/products.json';

  ProductsProvider() {
    // addData();
  }

  Future<void> fetchProducts() async {
    var url = Uri.parse(domain);

    try {
      final List<Product> tempProducts = [];
      var response = await http.get(url);
      final loardProducts = json.decode(response.body) as Map<String, dynamic>;
      loardProducts.forEach((productId, productData) {
        print('$productId   ${productData['id']}');
        tempProducts.add(Product(
          id: productData['id'],
          title: productData['title'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          price: productData['price'],
        ));
      });
      _items = tempProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  void addData() async {
    var url = Uri.parse(domain);
    try {
      await http
          .post(
        url,
        body: json.encode({
          'title': 'A Pan',
          'id': 'p4',
          'imageUrl':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
          'price': 20.0,
          'description': 'A nice pair of trousers.'
        }),
      )
          .then((response) {
        print('Book Upload Done');
      });
    } catch (error) {
      print(error);
    }
  }

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'Shirt-2',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 30.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
  ];

  // bool isFavorite = false;

  List<Product> get items {
    // if (isFavorite == true) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }
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

  // void favourite() {
  //   isFavorite = true;
  //   notifyListeners();
  // }

  // void all() {
  //   isFavorite = false;
  //   notifyListeners();
  // }
}
