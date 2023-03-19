import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? user;

  static const String domain =
      'https://filesharingbd.pythonanywhere.com/bookapi/';

  void addUser(String name, String email, String uID) async {
    var uri = Uri.parse(domain + 'create-user/');
    var uploadData = json.encode({'userId': uID, 'name': name, 'email': email});

    try {
      final response = await http
          .post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: uploadData,
      )
          .then((value) {
        print(value.body);

        user = UserModel(email: email, uID: uID, name: name);
        notifyListeners();
      });
    } catch (error) {
      print(error);
    }
  }

  void fetchUser(String email) async {
    var uri = Uri.parse(domain + 'get-user/');

    try {
      var uploadData = json.encode({'email': email});
      final response = await http
          .post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: uploadData,
      )
          .then((value) {
        if (value.statusCode == 200) {
          var data = json.decode(value.body);
          user = UserModel(
              email: data['email'], uID: data['userId'], name: data['name']);
          notifyListeners();
        }
        print(value.body);
      });
    } catch (error) {
      print(error);
    }
  }

  UserModel getUser() {
    return user as UserModel;
  }
}
