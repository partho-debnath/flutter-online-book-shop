import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product_providers.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String nameRoute = "product-details";
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);

    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final productId = args['productId'] as String;
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final selectedProduct = productProvider.getProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedProduct.imageUrl,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Text(
                selectedProduct.title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 23),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                text: 'Author: ',
                style: const TextStyle(color: Colors.black, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: selectedProduct.author,
                    style: TextStyle(color: Colors.indigo.shade800),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(
                'Edition: ${selectedProduct.edition}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Chip(
              label: Text(
                'Price: ${selectedProduct.price} Tk',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton(
                      onPressed: () {
                        cart.addItem(selectedProduct.id, selectedProduct.title,
                            selectedProduct.price);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Text(
                selectedProduct.description,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
