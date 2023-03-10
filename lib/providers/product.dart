import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String edition;
  final String author;
  final String description;
  final double price;
  final String imageUrl;
  final String image1;
  final String image2;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.edition,
    required this.author,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.image1,
    required this.image2,
    this.isFavorite = false,
  });

  void isFavoriteTogol() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
