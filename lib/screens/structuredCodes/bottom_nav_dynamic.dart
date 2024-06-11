import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/my_categories.dart';
import 'package:projectchair/screens/my_home.dart';
import 'package:projectchair/screens/my_profile.dart';

class DynamicBottomNavigation extends StatefulWidget {
  final int currentIndex;

  const DynamicBottomNavigation({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<DynamicBottomNavigation> createState() =>
      _DynamicBottomNavigationState();
}

class _DynamicBottomNavigationState extends State<DynamicBottomNavigation> {
  void _onItemTapped(BuildContext context, int index) {
    Widget destinationScreen;

    switch (index) {
      case 0:
        destinationScreen =
            MyCategories(categoryListNotifier: categoryListNotifier);
        break;
      case 1:
        destinationScreen = const MyHome();
        break;
      case 2:
        destinationScreen = const MyProfile();
        break;
      default:
        destinationScreen = const MyHome(); // Fallback screen
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            destinationScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration:
            const Duration(milliseconds: 300), // Adjust to your preference
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: const Duration(milliseconds: 600),
      index: widget.currentIndex,
      backgroundColor: Colors.transparent,
      color: Colors.black, // Background color of the navigation bar
      buttonBackgroundColor:
          Colors.black, // Background color of the button when selected
      items: const <Widget>[
        Icon(Icons.category, size: 30, color: Colors.white),
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
