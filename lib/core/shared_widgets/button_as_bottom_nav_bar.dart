import 'package:flutter/material.dart';

class ElevatedButtonAsButtonNavBar extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const ElevatedButtonAsButtonNavBar(
      {required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            offset: const Offset(0, -4),
            blurRadius: 8.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: ElevatedButton(
          style: ButtonStyle(
              fixedSize:
                  const WidgetStatePropertyAll(Size(double.infinity, 47)),
              shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)))),
          onPressed: onPressed,
          child: Text(text)),
    );
  }
}
