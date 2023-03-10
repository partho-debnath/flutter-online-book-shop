import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './registration_screen.dart';
import 'product_overview_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _userNotFound = false;

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

  void _goToRegistrationScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RegistrationScreen.routeName,
      (route) => false,
      arguments: {},
    );
  }

  Future<void> showErrorDialog(BuildContext context, String text) {
    return showDialog<void>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          title: const Text('An error occured'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
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
            decoration: InputDecoration(
              label: const Text('Password'),
              hintText: 'Password',
              errorText: _userNotFound == false
                  ? null
                  : 'Email or Password Incorrect.',
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
                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  debugPrint('Login ok---------');
                  debugPrint('User:-----: ${userCredential.user}');
                  await Future.delayed(const Duration(seconds: 0));
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      NotesScreen.routeName,
                      (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(
                      context,
                      'User not found!',
                    ); // for testing
                    debugPrint('User Not Found');
                    setState(() {
                      _userNotFound = true;
                    });
                  } else if (e.code == 'wrong-password') {
                    debugPrint('User Password is Wrong.');
                    await showErrorDialog(
                      context,
                      'Wrong credentials!',
                    ); // for testing
                    setState(() {
                      _userNotFound = true;
                    });
                  } else {
                    debugPrint('Something is wrong with FirebaseAuth');
                    await showErrorDialog(
                      context,
                      'Error: ${e.code}',
                    ); // for testing
                    debugPrint(e.code);
                  }
                } catch (e) {
                  debugPrint(
                      '${e.runtimeType}'); // whics exception occurs , where "FirebaseAuthException"
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: _goToRegistrationScreen,
            child: const Text('Not register yet? Registrer here!'),
          )
        ],
      ),
    );
  }
}
