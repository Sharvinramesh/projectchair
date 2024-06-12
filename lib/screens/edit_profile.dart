// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';

// ignore: must_be_immutable
class MyEditProfile extends StatefulWidget {
  Userdatamodel data;
  MyEditProfile({super.key, required this.data});

  @override
  State<MyEditProfile> createState() => _MyEditprflState();
}

class _MyEditprflState extends State<MyEditProfile> {
  File? _image;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.data.username;
    _emailController.text = widget.data.email;
    _passwordController.text = widget.data.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.background,
        title: const Text('Edit profile'),
        centerTitle: true,
      ),
      backgroundColor: MyColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.black,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (widget.data.image != null
                          ? FileImage(File(widget.data.image!))
                          : null),
                  child: _image == null || widget.data.image == null
                      ? GestureDetector(
                          onTap: () {
                            addimg();
                          },
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                height: 55,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Name',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 55,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'e-mail',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 350,
                height: 55,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      Userdatamodel? updatedProfile = await saveprfl();
                      if (updatedProfile != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(
                            updatedProfile); // Pass updated data back to MyProfile
                      }
                    },
                    icon: const Icon(
                      Icons.save,
                      size: 45,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addimg() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {}
    } catch (e) {
      print('error picking image:$e');
    }
  }

  Future<Userdatamodel?> saveprfl() async {
    final image = _image?.path ?? widget.data.image ?? '';
    final name = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    if (name.isNotEmpty) {
      final profile = Userdatamodel(
        id: widget.data.id,
        image: image, // Updated image path
        username: name,
        email: email,
        password: password,
      );

      await updateprfl(
          widget.data.id!, profile); // Update profile data in database

      // Since updateprfl is a void function, return the updated profile directly
      return profile;
    }

    return null;
  }
}
