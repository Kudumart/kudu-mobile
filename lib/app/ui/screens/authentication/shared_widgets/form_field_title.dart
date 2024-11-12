import 'package:flutter/material.dart';

class FormFieldTitle extends StatelessWidget {
  final String title;
  const FormFieldTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
