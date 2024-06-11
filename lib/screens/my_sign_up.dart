// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/my_login.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({super.key});

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> Formkey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
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
                      'SignUp Now',
                      style: TextStyle(fontSize: 30),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your username';
                      }
                      if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
                        return null;
                      } else {
                        return 'Username not valid';
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address.';
                      }
                      if (RegExp(r'[!#$%^&*(),?":{}|<>]').hasMatch(value)) {
                        return 'Special characters not allowed';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your password';
                      }
                      if (value.length < 6) {
                        return 'enter min 6 cahracters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  width: 360,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Formkey.currentState!.validate()) {
                        onclick();
                      } else {
                        return;
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
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
      ),
    );
  }

  Future<void> onclick() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final data =
        Userdatamodel(username: username, email: email, password: password);
    addSignUp(data);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyLogin()));
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyLogin()));
    return Future.value(false);
  }
}
