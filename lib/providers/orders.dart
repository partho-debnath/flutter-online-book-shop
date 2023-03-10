import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  static const String domain =
      'https://filesharingbd.pythonanywhere.com/bookapi/orders/';
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders(String userId) async {
    String ul = domain + '$userId/';

    var url = Uri.parse(ul);
    final List<OrderItem> loadOrders = [];

    try {
      final response = await http.get(url);
      final loadData = json.decode(response.body) as List<dynamic>;

      if (loadData == null) {
        return;
      }

      loadData.forEach((item) {
        loadOrders.add(
          OrderItem(
            id: item['oid']['dateTime'],
            amount: item['amount'],
            dateTime: DateTime.parse(item['oid']['dateTime']),
            products: (item['products'] as List<dynamic>).map((product) {
              return CartItem(
                id: '${product['productId']['id']}',
                title: product['productId']['name'],
                price: product['productId']['price'] * 1.0,
                quantity: product['quantity'],
              );
            }).toList(),
          ),
        );
      });

      // loadData.forEach((orderId, orderData) {
      //   loadOrders.add(
      //     OrderItem(
      //       id: orderId,
      //       amount: orderData['amount'],
      //       dateTime: DateTime.parse(orderData['dateTime']),
      //       products: (orderData['products'] as List<dynamic>).map((item) {
      //         return CartItem(
      //           id: item['id'],
      //           title: item['title'],
      //           quantity: item['quantity'],
      //           price: item['price'],
      //         );
      //       }).toList(),
      //     ),
      //   );
      // });

      // print(loadData);
      _orders = loadOrders;
      notifyListeners();
    } catch (error) {
      print(error);
    }

    //-----------------------

    // try {
    //   final response = await http.get(url);

    //   final loadData = json.decode(response.body) as Map<String, dynamic>;
    //   if (loadData == null) {
    //     return;
    //   }
    //   loadData.forEach((orderId, orderData) {
    //     loadOrders.add(
    //       OrderItem(
    //         id: orderId,
    //         amount: orderData['amount'],
    //         dateTime: DateTime.parse(orderData['dateTime']),
    //         products: (orderData['products'] as List<dynamic>).map((item) {
    //           return CartItem(
    //             id: item['id'],
    //             title: item['title'],
    //             quantity: item['quantity'],
    //             price: item['price'],
    //           );
    //         }).toList(),
    //       ),
    //     );
    //   });

    //   _orders = loadOrders;
    //   notifyListeners();
    // } catch (error) {
    //   print(error);
    // }
  }

  Future<void> addOrder(String userId, List<CartItem> cartProducts,
      double total, String name, String address, String phoneNumber) async {
    final timestamp = DateTime.now();

    try {
      String ul = domain + '$userId/';
      var url = Uri.parse(ul);

      var uploadData = json.encode({
        'userName': name,
        'address': address,
        'phoneNo': phoneNumber,
        'userId': userId,
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      });

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: uploadData,
      );

      print('Data---');
      print(response.body);
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['orderId'],
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
    } catch (error) {
      print('error: $error');
    }
    notifyListeners();
  }
}
