import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:math';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount} Tk'),
            subtitle: Text(
              DateFormat('dd-MM-yyy-hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                  expanded == true ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: min(widget.order.products.length * 20.0 + 30, 180.0),
              child: ListView(
                children: widget.order.products
                    .map((item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item.title),
                            Text('${item.quantity}x Tk ${item.price}'),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
