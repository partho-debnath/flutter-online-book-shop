import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_details_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context, listen: false);
    var cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              onPressed: () {
                print(product.id);
                product.isFavoriteTogol();
              },
              icon: Icon(
                product.isFavorite == false
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.yellow.shade500,
              ),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.yellow.shade500,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.nameRoute,
              arguments: {'productId': product.id},
            );
          },
          child: Image.network(
            product.imageUrl,
            scale: 1.5,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
