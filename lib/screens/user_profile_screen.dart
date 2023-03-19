import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = 'user-profile';
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 50),
            ),
            SizedBox(
              height: 60,
              child: Card(
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: Card(
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
