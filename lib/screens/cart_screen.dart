import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/cart.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routesName = 'cart-screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
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
                  OderButton(userId: userId, cart: cart, context: context),
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
    required this.userId,
    required this.cart,
    required this.context,
  });

  final BuildContext context;
  final String userId;
  final Cart cart;

  @override
  State<OderButton> createState() => _OderButtonState();
}

class _OderButtonState extends State<OderButton> {
  var isLoading = false;
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneNoController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNoController = TextEditingController();
    super.initState();
  }

  void _startTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SingleChildScrollView(
            child: Card(
              child: Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                width: 300,
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        label: Text('Receiver\'s Name'),
                        hintText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: _addressController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        label: Text('Address'),
                        hintText:
                            'District Name:\nThana: \nBlock:\nRoadNo:\nHouseNo:',
                      ),
                    ),
                    TextField(
                      controller: _phoneNoController,
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Phone Number'),
                        hintText: '01xxxxxxxxx',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String name = _nameController.text.trim();
                        String address = _addressController.text.trim();
                        String phone = _phoneNoController.text.trim();
                        if (name != '' || address != '' || phone != '') {
                          print(name + " " + address + " " + phone);
                          await Provider.of<Orders>(context, listen: false)
                              .addOrder(
                            widget.userId,
                            widget.cart.items.values.toList(),
                            widget.cart.totalAmount,
                            name,
                            address,
                            phone,
                          );
                          Future.delayed(Duration.zero).then((_) {
                            Navigator.of(context).pop();
                          });
                          setState(() {
                            isLoading = false;
                          });
                          widget.cart.clear();
                        }
                      },
                      child: const Text('Confirm Order'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || isLoading == true)
          ? null
          : () {
              setState(() {
                isLoading = true;
              });
              _startTransaction(widget.context);
            },
      child: isLoading == true
          ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(),
            )
          : const Text('Order Now'),
    );
  }
}
