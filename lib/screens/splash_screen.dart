import 'package:flutter/material.dart';
import 'package:projectchair/main.dart';
import 'package:projectchair/screens/my_home.dart';

import 'package:projectchair/screens/my_login.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
    checkUserLoggedIn();
  }

  @override
  void didChangeDependencies() => super.didChangeDependencies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 131, 7),
    
      body: SingleChildScrollView(
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    'lib/assets/splashimages/WhatsApp Image 2024-03-15 at 11.01.16_37a0fa48.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  child: Image.asset(
                    'lib/assets/splashimages/b2978d0ef8d7b6606bbb22e6bfa9a612.jpg',
                    width: 700,
                    height: 700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  Future<void> gotLogin() async {
    await Future.delayed(const Duration(seconds: 3));

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyLogin()));
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedPrefs.getBool(SAVE_KEY_NAME);
    if (userLoggedIn == null || userLoggedIn == false) {
      gotLogin();
    } else {
      await Future.delayed(const Duration(seconds: 3));

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHome()));
    }
  }
}
