import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routesName = 'cart-screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('${cart.totalAmount.toStringAsFixed(2)} Tk'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OderButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (contxt, index) {
                return MyCartItem(
                  id: cart.items.values.toList()[index].id,
                  productid: cart.items.keys.toList()[index],
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  title: cart.items.values.toList()[index].title,
                );
              },
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OderButton extends StatefulWidget {
  const OderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<OderButton> createState() => _OderButtonState();
}

class _OderButtonState extends State<OderButton> {
  var isLoad = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || isLoad == true)
          ? null
          : () async {
              setState(() {
                isLoad = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() {
                isLoad = false;
              });
              widget.cart.clear();
            },
      child: isLoad == true
          ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(),
            )
          : const Text('Order Now'),
    );
  }
}
