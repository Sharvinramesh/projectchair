// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/add_new_categories.dart';
import 'package:projectchair/screens/bills.dart';
import 'package:projectchair/screens/edit_profile.dart';
import 'package:projectchair/screens/my_login.dart';
import 'package:projectchair/screens/my_privacy_policy.dart';
import 'package:projectchair/screens/structuredCodes/bottom_nav_dynamic.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';
import 'package:projectchair/screens/terms_of_use.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  String? _profileImagePath;
  late Userdatamodel _userData;

  @override
  void initState() {
    super.initState();
    getAll();
    loadProfileImagePath(); // Load profile image path from SharedPreferences
  }

  Future<void> loadProfileImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.primary,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.background,
      body: ValueListenableBuilder(
        valueListenable: userListNotifier,
        builder:
            (BuildContext ctx, List<Userdatamodel> studentList, Widget? child) {
          if (studentList.isEmpty) {
            return const Center(child: LinearProgressIndicator());
          }
          _userData = studentList.last;
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: const Color(0XFFF2B875),
                      height: 200,
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: _profileImagePath != null
                                        ? FileImage(File(_profileImagePath!))
                                        : null,
                                    radius: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(_userData.username,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      Text(_userData.email,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final updatedData = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MyEditProfile(data: _userData),
                                        ),
                                      );
                                      if (updatedData != null) {
                                        setState(() {
                                          _profileImagePath = updatedData.image;
                                        });
                                        saveProfileImagePath(updatedData
                                            .image); // Save updated image path
                                      }
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.black,
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: const Color(0xFFF2E8CD),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person_add_alt_1_sharp),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SellProducts(),
                                          ),
                                        );
                                      },
                                      child: const Text('Add Bills'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.category_outlined),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MyAddnewcatgrs(
                                              categoryListNotifier:
                                                  categoryListNotifier,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Add new categories'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.privacy_tip_sharp),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyPrivacypolicy(),
                                          ),
                                        );
                                      },
                                      child: const Text('Privacy policy'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.receipt),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsOfUseScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text('Terms of Use'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Version 1.0')],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      color: const Color(0xFFF2E8CD),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content:
                                    const Text('Are you sure want to Logout'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await _logout();
                                    },
                                    child: const Text('Logout'),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.black,
                          ),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const DynamicBottomNavigation(currentIndex: 2),
    );
  }

  Future<void> saveProfileImagePath(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', imagePath);
  }

  Future<void> _logout() async {
    final SharedPreferences sharedprefs = await SharedPreferences.getInstance();
    await sharedprefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyLogin()));
  }
}
