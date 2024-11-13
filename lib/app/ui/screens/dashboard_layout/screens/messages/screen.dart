import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
        return const Scaffold(
        body: Center(
            child: Text("Messages screen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))));

  }
}