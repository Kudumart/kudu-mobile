import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
        return const Scaffold(
        body: Center(
            child: Text("Categories screen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))));

  }
}