import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/product_providers.dart';

class GridViewProducts extends StatelessWidget {
  final bool isFavorite;
  const GridViewProducts({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final products =
        isFavorite == false ? productData.items : productData.favoriteProducts;
    return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 3 / 3,
        ),
        itemBuilder: (cntxt, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: const ProductItem(),
          );
        },
        itemCount: products.length);
  }
}
