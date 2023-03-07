import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = 'registration-screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToLoginScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (route) => false,
      arguments: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text('E-mail'),
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            // obscureText: true,
            decoration: const InputDecoration(
              label: Text('Password'),
              hintText: 'Password',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;
              if (email.length > 5 || password.length > 5) {
                debugPrint('Register ok---------');
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    debugPrint(
                        'This Password is weak-password, Enter Strong Password.');
                  } else if (e.code == 'email-already-in-use') {
                    debugPrint('Email Already in Use');
                  }
                  debugPrint(e.code);
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: _goToLoginScreen,
            child: const Text('Have an account? Login here!'),
          )
        ],
      ),
    );
  }
}
