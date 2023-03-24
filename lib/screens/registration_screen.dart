import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

import './login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = 'registration-screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _emailAlreadyExist = false;
  bool _isNameEmpty = false;
  bool _isPasswordHide = true;
  bool _isConfirmPasswordHide = true;
  bool _passwordNotMatch = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
    var user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  label: const Text('Full Name'),
                  hintText: 'Full Name',
                  errorText:
                      _isNameEmpty == true ? 'Name can\'t be Empty.' : null,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: const Text('E-mail'),
                  hintText: 'Email',
                  errorText: _emailAlreadyExist == false
                      ? null
                      : 'This Email already used',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordHide,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  hintText: 'Password',
                  errorText: _passwordNotMatch == false
                      ? null
                      : 'Password did not Match.',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordHide = !_isPasswordHide;
                      });
                    },
                    icon: Icon(_isPasswordHide == false
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _isConfirmPasswordHide,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordHide == false
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordHide = !_isConfirmPasswordHide;
                      });
                    },
                  ),
                  label: const Text('Confirm Password'),
                  hintText: 'Confirm Password',
                  errorText: _passwordNotMatch == false
                      ? null
                      : 'Password did not Match.',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  final confirmPassword = _confirmPasswordController.text;
                  if (name.length <= 3) {
                    setState(() {
                      _isNameEmpty = true;
                    });
                  }
                  if (password != confirmPassword) {
                    setState(() {
                      _passwordNotMatch = true;
                    });
                    return;
                  }
                  if (email.length > 5 && password.length > 5) {
                    debugPrint('Register ok---------');
                    try {
                      var userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      user.addUser(name, email, userCredential.user!.uid);
                      setState(() {
                        _emailAlreadyExist = false;
                        _passwordNotMatch = false;
                      });
                      Future.delayed(const Duration(seconds: 0));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Registration Complete, Now you can Login.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        debugPrint(
                            'This Password is weak-password, Enter Strong Password.');
                      } else if (e.code == 'email-already-in-use') {
                        debugPrint('Email Already in Use');
                        setState(() {
                          _emailAlreadyExist = true;
                        });
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
        ),
      ),
    );
  }
}
