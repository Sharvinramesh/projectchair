// ignore_for_file: file_names

import 'package:flutter/material.dart';

//Textformfield for keyboard type text

class BuildTextFormField1 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;

  const BuildTextFormField1({
    required this.controller,
    required this.labelText,
    this.isMultiline = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 340,
        child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

//Textformfield for numkeyboard
class BuildTextFormField2 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;

  const BuildTextFormField2(
      {super.key,
      required this.controller,
      required this.labelText,
      this.isMultiline = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 340,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
