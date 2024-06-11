// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:projectchair/datas/db/db_functions.dart';

import 'package:projectchair/main.dart';
import 'package:projectchair/screens/my_home.dart';
import 'package:projectchair/screens/my_sign_up.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    super.initState();
    getAll();
  }

  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> Formkey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.background,
      ),
      backgroundColor: MyColors.background,
      body: SingleChildScrollView(
        child: Form(
          key: Formkey,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login Now',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address.';
                    }
                    // Check if the value contains any special characters other than '.', '_', '%', '+', and '-'
                    if (RegExp(r'[!#$%^&*(),?":{}|<>]').hasMatch(value)) {
                      return 'Special characters not allowed';
                    }
                    return null; // Return null if validation succeeds
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
                width: 360,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    if (Formkey.currentState!.validate()) {
                      bool isValidUser = userListNotifier.value.any((element) =>
                          element.email == email &&
                          element.password == password);

                      if (isValidUser) {
                        final sharedPrefs =
                            await SharedPreferences.getInstance();
                        await sharedPrefs.setBool(SAVE_KEY_NAME, true);

                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHome()));
                      } else {
                        // Handle invalid credentials
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid email or password')),
                        );
                      }
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Don't have an account?"),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                width: 360,
                child: ElevatedButton(
                  onPressed: () async {
                    final sharedPrefs = await SharedPreferences.getInstance();
                    await sharedPrefs.setBool(SAVE_KEY_NAME, true);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MySignUp()));
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
